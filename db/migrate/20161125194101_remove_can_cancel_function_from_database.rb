class RemoveCanCancelFunctionFromDatabase < ActiveRecord::Migration
  def up
    execute "DROP FUNCTION can_cancel(contributions);"
  end

  def down
    execute "
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
