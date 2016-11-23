class ChangeCanCancelFunctionTo4DaysForSlip < ActiveRecord::Migration
  def up
    execute "
      CREATE OR REPLACE FUNCTION to_current_timezone(TIMESTAMP) RETURNS TIMESTAMP WITH TIME ZONE AS
      $$
          SELECT $1 AT TIME ZONE COALESCE((SELECT value FROM settings WHERE name = 'timezone'), 'America/Sao_Paulo')
      $$
      LANGUAGE sql;

      CREATE OR REPLACE FUNCTION contribution_total_days(DATE) RETURNS INT AS
      $$
          SELECT COUNT(1)::INT as total_of_days
          FROM generate_series($1, to_current_timezone(current_timestamp::TIMESTAMP)::DATE, '1 day') day
          WHERE extract(DOW FROM day) NOT IN (0,1)
      $$
      LANGUAGE sql;

      CREATE OR REPLACE FUNCTION public.can_cancel(contributions) RETURNS BOOLEAN AS
      $$
          SELECT $1.state = 'waiting_confirmation' AND contribution_total_days($1.created_at::DATE) > 8
      $$
      LANGUAGE sql;
    "
  end

  def down
    execute "
      DROP FUNCTION can_cancel(contributions);
      DROP FUNCTION contribution_total_days(DATE);
      DROP FUNCTION to_current_timezone(TIMESTAMP);

      CREATE FUNCTION public.can_cancel(contributions) RETURNS BOOLEAN AS
        $$
            SELECT $1.state = 'waiting_confirmation' AND
              (
                ((
                  SELECT COUNT(1) AS total_of_days
                  FROM generate_series($1.created_at::DATE, (current_timestamp AT TIME ZONE COALESCE((SELECT value FROM settings WHERE name = 'timezone'), 'America/Sao_Paulo'))::DATE, '1 day') day
                  WHERE extract(DOW FROM day) NOT IN (0,1)
                )  > 4)
                OR
                (
                  LOWER($1.payment_choice) = LOWER('DebitoBancario')
                  AND
                    (
                      SELECT COUNT(1) as total_of_days
                      from generate_series($1.created_at::DATE, (current_timestamp AT TIME ZONE coalesce((SELECT value FROM settings WHERE name = 'timezone'), 'America/Sao_Paulo'))::DATE, '1 day') day
                      WHERE extract(dow from day) NOT IN (0,1)
                    )  > 1)
              )
        $$
        LANGUAGE sql;
      "
  end
end
