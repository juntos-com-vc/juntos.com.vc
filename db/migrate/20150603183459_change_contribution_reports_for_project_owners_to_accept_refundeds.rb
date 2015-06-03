class ChangeContributionReportsForProjectOwnersToAcceptRefundeds < ActiveRecord::Migration
  def up
    drop_view :contribution_reports_for_project_owners

    execute <<-SQL
      CREATE OR REPLACE VIEW contribution_reports_for_project_owners AS
      SELECT b.project_id, COALESCE(r.id, 0) AS reward_id,
        p.user_id AS project_owner_id,
        r.description AS reward_description,
        to_char(r.deliver_at, 'DD/MM/YYYY'::text) AS reward_deliver_at,
        (b.confirmed_at)::date AS confirmed_at,
        b.value AS contribution_value,
        (b.value * (SELECT (settings.value)::numeric AS value FROM settings WHERE (settings.name = 'catarse_fee'::text))) AS service_fee,
        u.email AS user_email,
        COALESCE(u.full_name, u.name) AS user_name,
        b.payer_email,
        b.payment_method,
        b.anonymous,
        b.state,
        COALESCE(u.address_street, b.address_street) AS street,
        COALESCE(u.address_complement, b.address_complement) AS complement,
        COALESCE(u.address_number, b.address_number) AS address_number,
        COALESCE(u.address_neighbourhood, b.address_neighbourhood) AS neighbourhood,
        COALESCE(u.address_city, b.address_city) AS city,
        COALESCE(u.address_state, b.address_state) AS address_state,
        COALESCE(u.address_zip_code, b.address_zip_code) AS zip_code,
        b.project_value as project_value
          FROM (((contributions b JOIN users u ON ((u.id = b.user_id))) JOIN projects p ON ((b.project_id = p.id))) LEFT JOIN rewards r ON ((r.id = b.reward_id))) WHERE ((b.state)::text = ANY (ARRAY[('confirmed'::character varying)::text, ('waiting_confirmation'::character varying)::text, ('refunded'::character varying)::text]));
    SQL
  end

  def down
    drop_view :contribution_reports_for_project_owners

    execute <<-SQL
      CREATE OR REPLACE VIEW contribution_reports_for_project_owners AS
      SELECT b.project_id, COALESCE(r.id, 0) AS reward_id,
        p.user_id AS project_owner_id,
        r.description AS reward_description,
        to_char(r.deliver_at, 'DD/MM/YYYY'::text) AS reward_deliver_at,
        (b.confirmed_at)::date AS confirmed_at,
        b.value AS contribution_value,
        (b.value * (SELECT (settings.value)::numeric AS value FROM settings WHERE (settings.name = 'catarse_fee'::text))) AS service_fee,
        u.email AS user_email,
        COALESCE(u.full_name, u.name) AS user_name,
        b.payer_email,
        b.payment_method,
        b.anonymous,
        b.state,
        COALESCE(u.address_street, b.address_street) AS street,
        COALESCE(u.address_complement, b.address_complement) AS complement,
        COALESCE(u.address_number, b.address_number) AS address_number,
        COALESCE(u.address_neighbourhood, b.address_neighbourhood) AS neighbourhood,
        COALESCE(u.address_city, b.address_city) AS city,
        COALESCE(u.address_state, b.address_state) AS address_state,
        COALESCE(u.address_zip_code, b.address_zip_code) AS zip_code,
        b.project_value as project_value
          FROM (((contributions b JOIN users u ON ((u.id = b.user_id))) JOIN projects p ON ((b.project_id = p.id))) LEFT JOIN rewards r ON ((r.id = b.reward_id))) WHERE ((b.state)::text = ANY (ARRAY[('confirmed'::character varying)::text, ('waiting_confirmation'::character varying)::text]));
    SQL
  end
end
