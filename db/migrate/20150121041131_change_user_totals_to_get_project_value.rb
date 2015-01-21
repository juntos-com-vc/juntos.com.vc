class ChangeUserTotalsToGetProjectValue < ActiveRecord::Migration
  def change
    execute <<-SQL
      CREATE OR REPLACE VIEW user_totals AS
        SELECT b.user_id AS id,
          b.user_id,
          count(DISTINCT b.project_id) AS total_contributed_projects,
          sum(b.project_value) AS sum,
          count(*) AS count,
          sum(CASE
                WHEN (((p.state)::text <> 'failed'::text) AND (NOT b.credits))
                  THEN (0)::numeric
                WHEN (((p.state)::text = 'failed'::text) AND b.credits)
                  THEN (0)::numeric
                WHEN (((p.state)::text = 'failed'::text) AND ((((b.state)::text = ANY ((ARRAY['requested_refund'::character varying, 'refunded'::character varying])::text[])) AND (NOT b.credits)) OR (b.credits AND (NOT ((b.state)::text = ANY ((ARRAY['requested_refund'::character varying, 'refunded'::character varying])::text[]))))))
                  THEN (0)::numeric
                WHEN ((((p.state)::text = 'failed'::text) AND (NOT b.credits)) AND ((b.state)::text = 'confirmed'::text))
                  THEN b.project_value
                ELSE (b.project_value * ((-1))::numeric) END)
            AS credits
          FROM (contributions b
          JOIN projects p ON ((b.project_id = p.id)))
            WHERE ((b.state)::text = ANY ((ARRAY['confirmed'::character varying, 'requested_refund'::character varying, 'refunded'::character varying])::text[]))
          GROUP BY b.user_id;
        SQL
  end
end
