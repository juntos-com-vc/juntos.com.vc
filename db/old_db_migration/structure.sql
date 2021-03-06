CREATE SCHEMA old_db;
SET search_path TO old_db,public;

CREATE TABLE IF NOT EXISTS "old_db"."juntoscomvc_categoriaprojeto" (
  "categoriaprojetoId" TEXT,
  "nome" TEXT,
  "ordem" TEXT,
  "corClara" TEXT,
  "corEscura" TEXT,
  "corTexto" TEXT,
  "corCirculo" TEXT,
  "url" TEXT,
  "dataCadastro" TIMESTAMP,
  "dataAlteracao" TIMESTAMP,
  "ativo" TEXT,
  "gamification_doacoesporcategoria_id" TEXT,
  "gamification_doacoesporcategoria_medalha" TEXT,
  "gamification_doacoesporcategoria_trofeu" TEXT
);

CREATE TABLE IF NOT EXISTS "old_db"."juntoscomvc_cliente" (
  "clienteId" TEXT,
  "codigo" TEXT,
  "tipo" TEXT,
  "empresa" TEXT,
  "nome" TEXT,
  "cnpj" TEXT,
  "email" TEXT,
  "telefone" TEXT,
  "celular" TEXT,
  "cpf" TEXT,
  "nascimento" TEXT,
  "sexo" TEXT,
  "endereco" TEXT,
  "numero" TEXT,
  "complemento" TEXT,
  "cep" TEXT,
  "bairro" TEXT,
  "cidade" TEXT,
  "estado" TEXT,
  "senha" TEXT,
  "ativo" TEXT,
  "dataCadastro" TIMESTAMP,
  "dataAlteracao" TIMESTAMP,
  "facebookId" TEXT DEFAULT ''::character,
  "facebookLink" TEXT,
  "facebookUsuario" TEXT,
  "googlemaisId" TEXT,
  "googlemaisLink" TEXT,
  "url" TEXT,
  "administrador" TEXT
);
CREATE TABLE IF NOT EXISTS "old_db"."juntoscomvc_cliente_credito" (
  "creditoId" TEXT,
  "projetoId" TEXT,
  "clienteId" TEXT,
  "doacaoId" TEXT,
  "valor" TEXT,
  "data" TIMESTAMP
);
CREATE TABLE IF NOT EXISTS "old_db"."juntoscomvc_parceiro" (
  "parceiroId" TEXT,
  "categoria" TEXT,
  "ordem" TEXT,
  "nome" TEXT,
  "cnpj" TEXT,
  "razaoSocial" TEXT,
  "inscricaoEstadual" TEXT,
  "contato" TEXT,
  "email" TEXT,
  "endereco" TEXT,
  "numero" TEXT,
  "complemento" TEXT,
  "cep" TEXT,
  "bairro" TEXT,
  "cidade" TEXT,
  "estado" TEXT,
  "site" TEXT,
  "dataCadastro" TIMESTAMP,
  "dataAlteracao" TIMESTAMP,
  "ativo" TEXT
);
CREATE TABLE IF NOT EXISTS "old_db"."juntoscomvc_patrocinador" (
  "patrocinadorId" TEXT,
  "nome" TEXT,
  "cnpj" TEXT,
  "razaoSocial" TEXT,
  "inscricaoEstadual" TEXT,
  "contato" TEXT,
  "email" TEXT,
  "site" TEXT,
  "dataCadastro" TIMESTAMP,
  "dataAlteracao" TIMESTAMP,
  "ativo" TEXT
);
CREATE TABLE IF NOT EXISTS "old_db"."juntoscomvc_projeto" (
  "clienteId" TEXT,
  "categoriaprojetoId" TEXT,
  "projetoId" TEXT,
  "codigo" TEXT,
  "nome" TEXT,
  "descricao" TEXT,
  "metaValor" TEXT,
  "metaData" TIMESTAMP,
  "empresa" TEXT,
  "cnpj" TEXT,
  "cpf" TEXT,
  "responsavel" TEXT,
  "email" TEXT,
  "telefone" TEXT,
  "endereco" TEXT,
  "numero" TEXT,
  "complemento" TEXT,
  "cep" TEXT,
  "bairro" TEXT,
  "cidade" TEXT,
  "estado" TEXT,
  "site" TEXT,
  "facebook" TEXT,
  "twitter" TEXT,
  "googlemais" TEXT,
  "moip" TEXT,
  "url" TEXT,
  "tempo" TEXT,
  "descricaoCompleta" TEXT,
  "video" TEXT,
  "agradecimento" TEXT,
  "ativo" TEXT,
  "dataCadastro" TIMESTAMP,
  "dataAlteracao" TIMESTAMP,
  "dataAtivacao" TIMESTAMP,
  "dataPasso1" TIMESTAMP,
  "dataPasso2" TIMESTAMP,
  "dataPasso3" TIMESTAMP,
  "dataAvaliacaoPasso1" TIMESTAMP,
  "dataAvaliacaoPasso2" TIMESTAMP,
  "dataAvaliacaoPasso3" TIMESTAMP,
  "avaliacaoPasso1" TEXT,
  "avaliacaoPasso2" TEXT,
  "avaliacaoPasso3" TEXT,
  "reprovacao" TEXT,
  "creditado" TEXT,
  "visualizacoes" TEXT
);

CREATE TABLE IF NOT EXISTS "old_db"."juntoscomvc_projeto_doacao" (
  "projetodoacaoId" TEXT,
  "codigo" TEXT,
  "projetoId" TEXT,
  "clienteId" TEXT,
  "recompensaId" TEXT,
  "recompensaValor" TEXT,
  "recompensaNome" TEXT,
  "cartaodoacaoId" TEXT,
  "valor" TEXT,
  "valorCredito" TEXT,
  "valorPlataforma" TEXT,
  "codigoMoip" TEXT,
  "formaPagamento" TEXT,
  "cartaoCofre" TEXT,
  "cartaoBandeira" TEXT,
  "cartaoNome" TEXT,
  "cartaoNumero" TEXT,
  "cartaoSeguranca" TEXT,
  "cartaoValidade" TEXT,
  "debitoInstituicao" TEXT,
  "data" TIMESTAMP,
  "ativo" TEXT,
  "anonimo" TEXT,
  "credito" TEXT,
  "token" TEXT
);
CREATE TABLE IF NOT EXISTS "old_db"."juntoscomvc_projeto_doacao_importacao" (
  "codigo" TEXT,
  "usuario" TEXT,
  "projeto" TEXT,
  "recompensa" TEXT,
  "nomeProjeto" TEXT,
  "valor" TEXT,
  "recompensaNome" TEXT,
  "exibicaoPlataforma" TEXT,
  "avisoEmailOferta" TEXT,
  "data" TIMESTAMP,
  "credito" TEXT,
  "valorPlataforma" TEXT,
  "valorCredito" TEXT
);
CREATE TABLE IF NOT EXISTS "old_db"."juntoscomvc_projeto_doacao_moip" (
  "moipId" TEXT,
  "codigo" TEXT,
  "id_transacao" TEXT,
  "valor" TEXT,
  "status_pagamento" TEXT,
  "cod_moip" TEXT,
  "forma_pagamento" TEXT,
  "tipo_pagamento" TEXT,
  "parcelas" TEXT,
  "email_consumidor" TEXT,
  "cartao_bin" TEXT,
  "cartao_final" TEXT,
  "cartao_bandeira" TEXT,
  "cofre" TEXT,
  "data" TIMESTAMP
);
CREATE TABLE IF NOT EXISTS "old_db"."juntoscomvc_projeto_novidade" (
  "projetoId" TEXT,
  "projetonovidadeId" TEXT,
  "data" TIMESTAMP,
  "nome" TEXT,
  "descricao" TEXT,
  "ativo" TEXT,
  "dataCadastro" TIMESTAMP,
  "dataAlteracao" TIMESTAMP,
  "codigo" TEXT
);
CREATE TABLE IF NOT EXISTS "old_db"."juntoscomvc_projeto_patrocinador" (
  "projetoPatrocinadorId" TEXT,
  "projetoId" TEXT,
  "patrocinadorId" TEXT,
  "ordem" TEXT
);
CREATE TABLE IF NOT EXISTS "old_db"."juntoscomvc_projeto_recompensa" (
  "recompensaId" TEXT,
  "codigo" TEXT,
  "projetoId" TEXT,
  "valor" TEXT,
  "nome" TEXT,
  "quantidade" TEXT,
  "ordem" TEXT
);
CREATE TABLE IF NOT EXISTS "old_db"."garupa_categoriaprojeto" (
  "categoriaprojetoId" TEXT,
  "nome" TEXT,
  "ordem" TEXT,
  "corClara" TEXT,
  "corEscura" TEXT,
  "corTexto" TEXT,
  "corCirculo" TEXT,
  "url" TEXT,
  "dataCadastro" TIMESTAMP,
  "dataAlteracao" TIMESTAMP,
  "ativo" TEXT
);

CREATE TABLE IF NOT EXISTS "old_db"."garupa_cliente" (
  "clienteId" TEXT,
  "codigo" TEXT,
  "tipo" TEXT,
  "empresa" TEXT,
  "nome" TEXT,
  "cnpj" TEXT,
  "email" TEXT,
  "telefone" TEXT,
  "celular" TEXT,
  "cpf" TEXT,
  "nascimento" TEXT,
  "sexo" TEXT,
  "endereco" TEXT,
  "numero" TEXT,
  "complemento" TEXT,
  "cep" TEXT,
  "bairro" TEXT,
  "cidade" TEXT,
  "estado" TEXT,
  "senha" TEXT,
  "ativo" TEXT,
  "dataCadastro" TIMESTAMP,
  "dataAlteracao" TIMESTAMP,
  "facebookId" TEXT,
  "facebookLink" TEXT,
  "facebookUsuario" TEXT,
  "googlemaisId" TEXT,
  "googlemaisLink" TEXT,
  "url" TEXT,
  "administrador" TEXT
);
CREATE TABLE IF NOT EXISTS "old_db"."garupa_cliente_credito" (
  "creditoId" TEXT,
  "projetoId" TEXT,
  "clienteId" TEXT,
  "doacaoId" TEXT,
  "valor" TEXT,
  "data" TIMESTAMP
);
CREATE TABLE IF NOT EXISTS "old_db"."garupa_parceiro" (
  "parceiroId" TEXT,
  "categoria" TEXT,
  "ordem" TEXT,
  "nome" TEXT,
  "cnpj" TEXT,
  "razaoSocial" TEXT,
  "inscricaoEstadual" TEXT,
  "contato" TEXT,
  "email" TEXT,
  "endereco" TEXT,
  "numero" TEXT,
  "complemento" TEXT,
  "cep" TEXT,
  "bairro" TEXT,
  "cidade" TEXT,
  "estado" TEXT,
  "site" TEXT,
  "dataCadastro" TIMESTAMP,
  "dataAlteracao" TIMESTAMP,
  "ativo" TEXT
);
CREATE TABLE IF NOT EXISTS "old_db"."garupa_patrocinador" (
  "patrocinadorId" TEXT,
  "nome" TEXT,
  "cnpj" TEXT,
  "razaoSocial" TEXT,
  "inscricaoEstadual" TEXT,
  "contato" TEXT,
  "email" TEXT,
  "site" TEXT,
  "dataCadastro" TIMESTAMP,
  "dataAlteracao" TIMESTAMP,
  "ativo" TEXT
);
CREATE TABLE IF NOT EXISTS "old_db"."garupa_projeto" (
  "clienteId" TEXT,
  "categoriaprojetoId" TEXT,
  "projetoId" TEXT,
  "codigo" TEXT,
  "nome" TEXT,
  "descricao" TEXT,
  "metaValor" TEXT,
  "metaData" TIMESTAMP,
  "empresa" TEXT,
  "cnpj" TEXT,
  "cpf" TEXT,
  "responsavel" TEXT,
  "email" TEXT,
  "telefone" TEXT,
  "endereco" TEXT,
  "numero" TEXT,
  "complemento" TEXT,
  "cep" TEXT,
  "bairro" TEXT,
  "cidade" TEXT,
  "estado" TEXT,
  "site" TEXT,
  "facebook" TEXT,
  "twitter" TEXT,
  "googlemais" TEXT,
  "moip" TEXT,
  "url" TEXT,
  "tempo" TEXT,
  "descricaoCompleta" TEXT,
  "video" TEXT,
  "agradecimento" TEXT,
  "ativo" TEXT,
  "dataCadastro" TIMESTAMP,
  "dataAlteracao" TIMESTAMP,
  "dataAtivacao" TIMESTAMP,
  "dataPasso1" TIMESTAMP,
  "dataPasso2" TIMESTAMP,
  "dataPasso3" TIMESTAMP,
  "dataAvaliacaoPasso1" TIMESTAMP,
  "dataAvaliacaoPasso2" TIMESTAMP,
  "dataAvaliacaoPasso3" TIMESTAMP,
  "avaliacaoPasso1" TEXT,
  "avaliacaoPasso2" TEXT,
  "avaliacaoPasso3" TEXT,
  "reprovacao" TEXT,
  "creditado" TEXT,
  "visualizacoes" TEXT
);

CREATE TABLE IF NOT EXISTS "old_db"."garupa_projeto_doacao" (
  "projetodoacaoId" TEXT,
  "codigo" TEXT,
  "projetoId" TEXT,
  "clienteId" TEXT,
  "recompensaId" TEXT,
  "recompensaValor" TEXT,
  "recompensaNome" TEXT,
  "cartaodoacaoId" TEXT,
  "valor" TEXT,
  "valorCredito" TEXT,
  "valorPlataforma" TEXT,
  "codigoMoip" TEXT,
  "formaPagamento" TEXT,
  "cartaoCofre" TEXT,
  "cartaoBandeira" TEXT,
  "cartaoNome" TEXT,
  "cartaoNumero" TEXT,
  "cartaoSeguranca" TEXT,
  "cartaoValidade" TEXT,
  "debitoInstituicao" TEXT,
  "data" TIMESTAMP,
  "ativo" TEXT,
  "anonimo" TEXT,
  "credito" TEXT,
  "token" TEXT
);
CREATE TABLE IF NOT EXISTS "old_db"."garupa_projeto_doacao_importacao" (
  "codigo" TEXT,
  "usuario" TEXT,
  "projeto" TEXT,
  "recompensa" TEXT,
  "nomeProjeto" TEXT,
  "valor" TEXT,
  "recompensaNome" TEXT,
  "exibicaoPlataforma" TEXT,
  "avisoEmailOferta" TEXT,
  "data" TIMESTAMP,
  "credito" TEXT,
  "valorPlataforma" TEXT,
  "valorCredito" TEXT
);
CREATE TABLE IF NOT EXISTS "old_db"."garupa_projeto_doacao_moip" (
  "moipId" TEXT,
  "codigo" TEXT,
  "id_transacao" TEXT,
  "valor" TEXT,
  "status_pagamento" TEXT,
  "cod_moip" TEXT,
  "forma_pagamento" TEXT,
  "tipo_pagamento" TEXT,
  "parcelas" TEXT,
  "email_consumidor" TEXT,
  "cartao_bin" TEXT,
  "cartao_final" TEXT,
  "cartao_bandeira" TEXT,
  "cofre" TEXT,
  "data" TIMESTAMP
);
CREATE TABLE IF NOT EXISTS "old_db"."garupa_projeto_novidade" (
  "projetoId" TEXT,
  "projetonovidadeId" TEXT,
  "data" TIMESTAMP,
  "nome" TEXT,
  "descricao" TEXT,
  "ativo" TEXT,
  "dataCadastro" TIMESTAMP,
  "dataAlteracao" TIMESTAMP,
  "codigo" TEXT
);
CREATE TABLE IF NOT EXISTS "old_db"."garupa_projeto_patrocinador" (
  "projetoPatrocinadorId" TEXT,
  "projetoId" TEXT,
  "patrocinadorId" TEXT,
  "ordem" TEXT
);
CREATE TABLE IF NOT EXISTS "old_db"."garupa_projeto_recompensa" (
  "recompensaId" TEXT,
  "codigo" TEXT,
  "projetoId" TEXT,
  "valor" TEXT,
  "nome" TEXT,
  "quantidade" TEXT,
  "ordem" TEXT
);
