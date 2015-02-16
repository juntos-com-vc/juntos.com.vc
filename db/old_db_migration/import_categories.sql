/*
 Importing Categories

categoriaprojetoId  | uuid
nome                | name_pt
corEscura           | color
dataCadastro        | created_at
dataAlteracao       | updated_at
ativo

*/



/* Import the active categories */

INSERT INTO categories (
  uuid,
  name_pt,
  color,
  created_at,
  updated_at
) SELECT DISTINCT
  "categoriaprojetoId",
  nome,
  concat('#', "corEscura"),
  "dataCadastro",
  "dataAlteracao"
FROM "old_db"."juntoscomvc_categoriaprojeto"
WHERE
  ativo = 'true'
