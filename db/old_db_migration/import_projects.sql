/*
 Importing regular Users

clienteId           | user_id
categoriaprojetoId  | category_id
projetoId           | uuid
nome                | name
descricao           | headline
metaValor           | goal
url                 | permalink
tempo               | online_days
descricaoCompleta   | about & about_html
video               | video_url
agradecimento       | thank_you
ativo               | state
dataCadastro        | created_at
dataAlteracao       | updated_at
dataAtivacao        | online_date

*/

/* Remove duplicated urls */
UPDATE old_db.juntoscomvc_projeto SET url = 'brincarumdireitodacrianca-2' WHERE "projetoId" = '10013FE5-5311-46FD-81C2-957DEDD4C733';
UPDATE old_db.juntoscomvc_projeto SET url = 'cartaelivro-2' WHERE "projetoId" = '58E96A45-B600-4D1C-A0A1-2C274000CE3B';

/* Import projects */
INSERT INTO projects (
  uuid,
  category_id,
  user_id,
  name,
  headline,
  goal,
  permalink,
  online_days,
  about,
  about_html,
  video_url,
  thank_you,
  created_at,
  updated_at,
  online_date,
  state
) SELECT
  "projetoId",
  categories.id,
  users.id,
  nome,
  substr(descricao, 0, 140),
  ("metaValor"::float::integer),
  url,
  tempo::integer,
  "descricao",
  "descricao",
  video,
  agradecimento,
  "dataCadastro",
  "dataAlteracao",
  "dataAtivacao",
  'online'
FROM "old_db"."juntoscomvc_projeto" as old_projects
JOIN users
  ON users.uuid = old_projects."clienteId"
JOIN categories
  ON categories.uuid = old_projects."categoriaprojetoId"
WHERE ativo = 'true'
  AND "dataAtivacao" is not null;
