class ChangeProjectTotalToGetPlatformValue < ActiveRecord::Migration
  def change
    execute <<-SQL
      CREATE OR REPLACE VIEW project_totals AS
        SELECT
          contributions.project_id,
          sum(contributions.project_value) AS pledged,
          ((sum(contributions.project_value) / projects.goal) * (100)::numeric) AS progress,
          sum(contributions.payment_service_fee) AS total_payment_service_fee,
          count(*) AS total_contributions,
          sum(contributions.platform_value) AS platform_fee
        FROM (contributions JOIN projects ON ((contributions.project_id = projects.id)))
        WHERE ((contributions.state)::text = ANY ((ARRAY['confirmed'::character varying, 'refunded'::character varying, 'requested_refund'::character varying])::text[]))
        GROUP BY contributions.project_id, projects.goal;
      SQL
  end
end
