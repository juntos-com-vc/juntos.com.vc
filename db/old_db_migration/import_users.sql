/*
 Importing regular Users

clienteId     | uid
nome          | name
nome          | full_name
email         | email
dataCadastro  | created_at
dataAlteracao | created_at
cpf           | cpf
endereco      | address_street
numero        | address_number
complemento   | address_complement
cep           | address_zip_code
bairro        | address_neighbourhood
cidade        | address_city
estado        | address_state
celular       | phone_number
nascimento    | birth_date
sexo          | gender (0 - male; 1 - female)
administrador | admin
senha         | uncrypted_password
0             | access_type

*/

/* Discovering duplicated emails */
CREATE TEMP TABLE duplicated_emails AS
WITH emails AS (
  SELECT email
  FROM old_db.juntoscomvc_cliente
  GROUP BY email
  HAVING count(email) > 1
)
SELECT
  emails.email
FROM
  emails;

DELETE FROM old_db.juntoscomvc_cliente
WHERE "clienteId" in (SELECT "clienteId"
                      FROM old_db.juntoscomvc_cliente old_users,
                           (SELECT min("dataCadastro") created_at, email
                            FROM old_db.juntoscomvc_cliente
                            WHERE email IN (SELECT email FROM duplicated_emails)
                            GROUP BY email) to_delete
                      WHERE
                        old_users.email = to_delete.email
                        AND old_users."dataCadastro" != to_delete.created_at);

INSERT INTO users (
  uuid,
  name,
  full_name,
  email,
  created_at,
  updated_at,
  cpf,
  address_street,
  address_number,
  address_complement,
  address_zip_code,
  address_neighbourhood,
  address_city,
  address_state,
  phone_number,
  birth_date,
  gender,
  admin,
  uncrypted_password,
  access_type
) SELECT
  "clienteId",
  nome,
  nome,
  email,
  "dataCadastro",
  "dataAlteracao",
  cpf,
  endereco,
  numero,
  complemento,
  cep,
  bairro,
  cidade,
  estado,
  celular,
  nascimento::date,
  CASE WHEN sexo = 'F' THEN 1 ELSE 0 END,
  CASE WHEN administrador = 'true' THEN true ELSE false END,
  senha,
  0
FROM "old_db"."juntoscomvc_cliente"
WHERE
  tipo = 'AP'
  AND ativo = 'true'
  AND url not like '%-1';

/* Import the users from Garupa who aren't on database yet. */

INSERT INTO users (
  uuid,
  name,
  full_name,
  email,
  created_at,
  updated_at,
  cpf,
  address_street,
  address_number,
  address_complement,
  address_zip_code,
  address_neighbourhood,
  address_city,
  address_state,
  phone_number,
  birth_date,
  gender,
  admin,
  uncrypted_password,
  access_type
) SELECT
  "clienteId",
  nome,
  nome,
  email,
  "dataCadastro",
  "dataAlteracao",
  cpf,
  endereco,
  numero,
  complemento,
  cep,
  bairro,
  cidade,
  estado,
  celular,
  nascimento::date,
  CASE WHEN sexo = 'F' THEN 1 ELSE 0 END,
  CASE WHEN administrador = 'true' THEN true ELSE false END,
  senha,
  0
FROM "old_db"."garupa_cliente"
WHERE
  tipo = 'AP'
  AND ativo = 'true'
  AND url not like '%-1'
  AND "email" NOT IN (SELECT email FROM users WHERE uuid is not null);
