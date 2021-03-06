/*
 Importing regular Users

clienteId     | uuid
empresa       | name
empresa       | full_name
email         | email
dataCadastro  | created_at
dataAlteracao | updated_at
cnpj          | cpf
endereco      | address_street
numero        | address_number
complemento   | address_complement
cep           | address_zip_code
bairro        | address_neighbourhood
cidade        | address_city
estado        | address_state
telefone      | phone_number
celular       | mobile_phone
nome          | responsible_name
cpf           | responsible_cpf
senha         | uncrypted_password
1             | access_type

*/

/* Discovering duplicated emails */
DROP TABLE IF EXISTS duplicated_emails;
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
WHERE "clienteId" in (SELECT DISTINCT ON (old.email) "clienteId"
                      FROM old_db.juntoscomvc_cliente old
                      JOIN duplicated_emails dup ON old.email = dup.email);

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
  mobile_phone,
  responsible_name,
  responsible_cpf,
  uncrypted_password,
  access_type
) SELECT
  "clienteId",
  empresa,
  empresa,
  email,
  "dataCadastro",
  "dataAlteracao",
  cnpj,
  endereco,
  numero,
  complemento,
  cep,
  bairro,
  cidade,
  estado,
  telefone,
  celular,
  nome,
  cpf,
  senha,
  1
FROM "old_db"."juntoscomvc_cliente"
WHERE
  tipo = 'OG'
  AND ativo = 'true'
  AND "email" NOT IN (SELECT email FROM users WHERE uuid is not null);

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
  mobile_phone,
  responsible_name,
  responsible_cpf,
  uncrypted_password,
  access_type
) SELECT
  "clienteId",
  empresa,
  empresa,
  email,
  "dataCadastro",
  "dataAlteracao",
  cnpj,
  endereco,
  numero,
  complemento,
  cep,
  bairro,
  cidade,
  estado,
  telefone,
  celular,
  nome,
  cpf,
  senha,
  1
FROM "old_db"."garupa_cliente"
WHERE
  tipo = 'OG'
  AND ativo = 'true'
  AND "email" NOT IN (SELECT email FROM users WHERE uuid is not null);
