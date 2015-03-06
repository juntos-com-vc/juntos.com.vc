/* Import online projects */
INSERT INTO contributions (
  project_id,
  user_id,
  value,
  project_value,
  platform_value,
  payment_id,
  state,
  created_at,
  confirmed_at,
  anonymous,
  credits,
  payment_token
) SELECT DISTINCT
  projects.id,
  users.id,
  CASE
    WHEN old_contributions."valorPlataforma"::numeric > 0
      THEN (old_contributions.valor::numeric + old_contributions."valorPlataforma"::numeric)
    ELSE old_contributions.valor::numeric END,
  old_contributions.valor::numeric,
  old_contributions."valorPlataforma"::numeric,
  moip.codigo,
  'confirmed',
  old_contributions.data,
  old_contributions.data,
  old_contributions.anonimo::boolean,
  false,
  old_contributions."projetodoacaoId"
FROM "old_db"."juntoscomvc_projeto_doacao" as old_contributions
JOIN users
  ON users.email = (SELECT email FROM old_db.juntoscomvc_cliente WHERE old_db.juntoscomvc_cliente."clienteId" = old_contributions."clienteId")
JOIN projects
  ON projects.uuid = old_contributions."projetoId"
JOIN (select * from old_db.juntoscomvc_projeto_doacao_moip as a
      INNER JOIN
        (select max(data) as data, id_transacao as id_2
        from old_db.juntoscomvc_projeto_doacao_moip
        group by id_transacao) as b
      ON a.data = b.data AND a.id_transacao = b.id_2
    ) as moip
  ON moip.id_transacao = old_contributions.codigo
WHERE ativo = 'true'
  AND moip.status_pagamento in ('1', '4')
  AND old_contributions.valor::numeric > 0;

/* Import garupa contributions */
INSERT INTO contributions (
  project_id,
  user_id,
  value,
  project_value,
  platform_value,
  payment_id,
  state,
  created_at,
  confirmed_at,
  anonymous,
  credits,
  payment_token
) SELECT DISTINCT
  projects.id,
  users.id,
  CASE
    WHEN old_contributions."valorPlataforma"::numeric > 0
      THEN (old_contributions.valor::numeric + old_contributions."valorPlataforma"::numeric)
    ELSE old_contributions.valor::numeric END,
  old_contributions.valor::numeric,
  old_contributions."valorPlataforma"::numeric,
  moip.codigo,
  'confirmed',
  old_contributions.data,
  old_contributions.data,
  old_contributions.anonimo::boolean,
  false,
  old_contributions."projetodoacaoId"
FROM "old_db"."garupa_projeto_doacao" as old_contributions
JOIN users
  ON users.email = (SELECT email FROM old_db.garupa_cliente WHERE old_db.garupa_cliente."clienteId" = old_contributions."clienteId")
JOIN projects
  ON projects.uuid = old_contributions."projetoId"
JOIN (select * from old_db.garupa_projeto_doacao_moip as a
      INNER JOIN
        (select max(data) as data, id_transacao as id_2
        from old_db.garupa_projeto_doacao_moip
        group by id_transacao) as b
      ON a.data = b.data AND a.id_transacao = b.id_2
    ) as moip
  ON moip.id_transacao = old_contributions.codigo
WHERE ativo = 'true'
  AND moip.status_pagamento in ('1', '4')
  AND old_contributions.valor::numeric > 0;
