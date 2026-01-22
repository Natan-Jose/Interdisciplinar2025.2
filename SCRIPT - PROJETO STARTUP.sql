CREATE DATABASE plataforma_servicos_db;

USE plataforma_servicos_db;

CREATE TABLE IF NOT EXISTS usuario_contratante (
   cod_usuario_contratante BIGINT NOT NULL AUTO_INCREMENT,
   nome VARCHAR(100) DEFAULT NULL,
   email VARCHAR(255) NOT NULL,
   senha VARCHAR(255) NOT NULL,
   reset_token VARCHAR(255) DEFAULT NULL,
   data_cadastro DATE NOT NULL, 
   status BOOLEAN DEFAULT 1 COMMENT 'Ativo (1) ou Inativo (0)',
  
  UNIQUE (nome),
  UNIQUE (email),
  CONSTRAINT chk_usuario_contratante_status CHECK (status IN (1, 0)),
  PRIMARY KEY (cod_usuario_contratante)
) COMMENT = 'Armazena os dados de login e perfil dos usuários contratantes.';

CREATE TABLE IF NOT EXISTS contratante (
   cod_contratante BIGINT NOT NULL AUTO_INCREMENT,
   foto_perfil TEXT NOT NULL,
   nome_contratante VARCHAR(150) NOT NULL,
   cpf VARCHAR(14) NOT NULL COMMENT 'CPF sem pontos ou traços, exatamente 11 dígitos numéricos',
   data_nascimento DATE NOT NULL,
   sexo CHAR(1) NOT NULL COMMENT 'M = Masculino, F = Feminino',
   telefone VARCHAR(15) NOT NULL COMMENT 'Telefone celular sem formatação, 11 dígitos: DDD + número',
   data_cadastro DATE NOT NULL,
   cod_usuario_contratante BIGINT NOT NULL,
   status BOOLEAN DEFAULT 1 COMMENT 'Ativo (1) ou Inativo (0)',
  
  UNIQUE (cpf),
  UNIQUE (telefone),
  CONSTRAINT chk_contratante_cpf CHECK (cpf REGEXP '^[0-9]{11}$'),
  CONSTRAINT chk_contratante_sexo CHECK (sexo IN ('M','F')),
  CONSTRAINT chk_contratante_telefone CHECK (telefone REGEXP '^[0-9]{11}$'),
  CONSTRAINT chk_contratante_status CHECK (status IN (1, 0)),
  PRIMARY KEY (cod_contratante)
) COMMENT = 'Registra dados pessoais dos contratantes, vinculados ao usuário.';

CREATE TABLE IF NOT EXISTS endereco_contratante (
   cod_endereco_contratante BIGINT NOT NULL AUTO_INCREMENT,
   cep VARCHAR(15) NOT NULL COMMENT 'CEP sem traços ou pontos, exatamente 8 dígitos numéricos',
   rua VARCHAR(150) NOT NULL,
   numero INT DEFAULT NULL,
   bairro VARCHAR(100) NOT NULL,
   cidade VARCHAR(150) NOT NULL,
   estado VARCHAR(50) NOT NULL,
   cod_contratante BIGINT NOT NULL,
   status BOOLEAN DEFAULT 1 COMMENT 'Ativo (1) ou Inativo (0)',
   
  CONSTRAINT chk_endereco_contratante_cep CHECK (cep REGEXP '^[0-9]{8}$'),
  CONSTRAINT chk_endereco_contratante_status CHECK (status IN (1, 0)),
  PRIMARY KEY (cod_endereco_contratante)
) COMMENT = 'Armazena os endereços residenciais dos contratantes.';

CREATE TABLE IF NOT EXISTS servico (
   cod_servico BIGINT NOT NULL AUTO_INCREMENT,
   nome_servico VARCHAR(100) NOT NULL,
   status BOOLEAN DEFAULT 1 COMMENT 'Ativo (1) ou Inativo (0)',
  
  UNIQUE (nome_servico),
  CONSTRAINT chk_servico_status CHECK (status IN (1, 0)),
  PRIMARY KEY (cod_servico)
) COMMENT = 'Armazena os serviços disponíveis na plataforma.';

CREATE TABLE IF NOT EXISTS usuario_prestador (
   cod_usuario_prestador BIGINT NOT NULL AUTO_INCREMENT,
   nome VARCHAR(100) DEFAULT NULL,
   email VARCHAR(255) NOT NULL,
   senha VARCHAR(255) NOT NULL,
   reset_token VARCHAR(255) DEFAULT NULL,
   data_cadastro DATE NOT NULL,
   status BOOLEAN DEFAULT 1 COMMENT 'Ativo (1) ou Inativo (0)',

  UNIQUE (nome),
  UNIQUE (email),
  CONSTRAINT chk_usuario_prestador_status CHECK (status IN (1, 0)),
  PRIMARY KEY (cod_usuario_prestador)
) COMMENT = 'Armazena os dados de login e perfil dos usuários prestadores.';

CREATE TABLE IF NOT EXISTS prestador (
   cod_prestador BIGINT NOT NULL AUTO_INCREMENT,
   foto_perfil TEXT NOT NULL,
   nome_prestador VARCHAR(150) NOT NULL,
   cpf VARCHAR(14) NOT NULL COMMENT 'CPF sem pontos ou traços, exatamente 11 dígitos numéricos',
   data_nascimento DATE NOT NULL,
   sexo CHAR(1) NOT NULL COMMENT 'M = Masculino, F = Feminino',
   telefone VARCHAR(15) NOT NULL COMMENT 'Telefone celular sem formatação, 11 dígitos: DDD + número',
   descricao_perfil TEXT NOT NULL,
   curriculo TEXT DEFAULT NULL,
   coordenadas POINT DEFAULT NULL,
   disponibilidade CHAR(1) DEFAULT 'I' COMMENT 'D = Disponível, I = Indisponível',
   data_cadastro DATE NOT NULL,
   cod_usuario_prestador BIGINT NOT NULL,
   status BOOLEAN DEFAULT 1 COMMENT 'Ativo (1) ou Inativo (0)',

  UNIQUE (cpf),
  UNIQUE (telefone),
  CONSTRAINT chk_prestador_cpf CHECK (cpf REGEXP '^[0-9]{11}$'),
  CONSTRAINT chk_prestador_sexo CHECK (sexo IN ('M','F')),
  CONSTRAINT chk_prestador_telefone CHECK (telefone REGEXP '^[0-9]{11}$'),
  CONSTRAINT chk_prestador_descricao_perfil CHECK (CHAR_LENGTH(descricao_perfil) <= 200),
  CONSTRAINT chk_prestador_disponibilidade CHECK (disponibilidade IN ('D','I')),
  CONSTRAINT chk_prestador_status CHECK (status IN (1, 0)),
  PRIMARY KEY (cod_prestador)
) COMMENT = 'Registra dados pessoais e profissionais dos prestadores de serviços.';

CREATE TABLE IF NOT EXISTS endereco_prestador (
   cod_endereco_prestador BIGINT NOT NULL AUTO_INCREMENT,
   cep VARCHAR(15) NOT NULL COMMENT 'CEP sem traços ou pontos, exatamente 8 dígitos numéricos',
   rua VARCHAR(150) NOT NULL,
   numero INT DEFAULT NULL,
   bairro VARCHAR(100) NOT NULL,
   cidade VARCHAR(150) NOT NULL,
   estado VARCHAR(50) NOT NULL,
   cod_prestador BIGINT NOT NULL,
   status BOOLEAN DEFAULT 1 COMMENT 'Ativo (1) ou Inativo (0)',
   
  CONSTRAINT chk_endereco_prestador_cep CHECK (cep REGEXP '^[0-9]{8}$'),
  CONSTRAINT chk_endereco_prestador_status CHECK (status IN (1, 0)),
  PRIMARY KEY (cod_endereco_prestador)
) COMMENT = 'Armazena os endereços residenciais dos prestadores.';

CREATE TABLE IF NOT EXISTS certificado (
   cod_certificado BIGINT NOT NULL AUTO_INCREMENT,
   caminho_arquivo TEXT NOT NULL,
   cod_prestador BIGINT NOT NULL,
   status BOOLEAN DEFAULT 1 COMMENT 'Ativo (1) ou Inativo (0)',

  CONSTRAINT chk_certificado_status CHECK (status IN (1, 0)),
  PRIMARY KEY (cod_certificado)
) COMMENT = 'Armazena os certificados associados a cada prestador.';

CREATE TABLE IF NOT EXISTS habilidade (
   cod_habilidade BIGINT NOT NULL AUTO_INCREMENT,
   nome_habilidade VARCHAR(100) NOT NULL,
   status BOOLEAN DEFAULT 1 COMMENT 'Ativo (1) ou Inativo (0)',
   
  UNIQUE (nome_habilidade),
  CONSTRAINT chk_habilidade_status CHECK (status IN (1, 0)),
  PRIMARY KEY (cod_habilidade)
) COMMENT = 'Lista as habilidades disponíveis para prestadores.';

 CREATE TABLE IF NOT EXISTS habilidade_profissional (
   cod_habilidade_profissional BIGINT NOT NULL AUTO_INCREMENT,
   cod_prestador BIGINT NOT NULL,
   cod_habilidade BIGINT NOT NULL,
   status BOOLEAN DEFAULT 1 COMMENT 'Ativo (1) ou Inativo (0)',

  UNIQUE (cod_prestador, cod_habilidade),
  CONSTRAINT chk_habilidade_profissional_status CHECK (status IN (1, 0)),
  PRIMARY KEY (cod_habilidade_profissional)
) COMMENT = 'Associa habilidades aos prestadores, registrando suas competências.';

CREATE TABLE IF NOT EXISTS solicitacao (
   cod_solicitacao BIGINT NOT NULL AUTO_INCREMENT,
   descricao_solicitacao TEXT NOT NULL,
   localizacao VARCHAR(500) NOT NULL,
   coordenadas POINT NOT NULL,
   urgencia VARCHAR(20) NOT NULL,
   data_preferencial DATE NOT NULL,
   horario TIME NOT NULL,
   status_solicitacao VARCHAR(20) DEFAULT 'PENDENTE',
   data_cadastro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   data_finalizacao TIMESTAMP DEFAULT NULL COMMENT 'Registra o momento em que a solicitação foi concluída ou cancelada',
   cod_servico BIGINT NOT NULL,
   cod_motivo_cancelamento BIGINT DEFAULT NULL COMMENT 'Preenchido apenas se a solicitação for CANCELADO',
   cod_contratante BIGINT NOT NULL,
  
  CONSTRAINT chk_solicitacao_descricao_solicitacao CHECK (CHAR_LENGTH(descricao_solicitacao) <= 200),
  CONSTRAINT chk_solicitacao_urgencia CHECK (urgencia IN ('BAIXA', 'MEDIA', 'ALTA')),
  CONSTRAINT chk_solicitacao_status CHECK (status_solicitacao IN ('PENDENTE','EM ANDAMENTO', 'CONCLUIDO', 'CANCELADO')),

  CONSTRAINT chk_motivo_cancelamento_obrigatorio 
    CHECK (
        (status_solicitacao = 'CANCELADO' AND cod_motivo_cancelamento IS NOT NULL)
        OR
        (status_solicitacao <> 'CANCELADO')
    ),

  PRIMARY KEY (cod_solicitacao)
) COMMENT = 'Registra as solicitações de serviços feitas pelos contratantes.';

CREATE TABLE IF NOT EXISTS motivo_cancelamento (
   cod_motivo_cancelamento BIGINT NOT NULL AUTO_INCREMENT,
   motivo_cancelamento VARCHAR(200) NOT NULL,
   status BOOLEAN DEFAULT 1 COMMENT 'Ativo (1) ou Inativo (0)',
  
  CONSTRAINT chk_motivo_cancelamento_status CHECK (status IN (1, 0)),
  PRIMARY KEY (cod_motivo_cancelamento)
) COMMENT = 'Armazena todos os motivos de cancelamento utilizados no sistema.';

CREATE TABLE IF NOT EXISTS atendimento (
   cod_atendimento BIGINT NOT NULL AUTO_INCREMENT,
   cod_solicitacao BIGINT NOT NULL,
   cod_prestador BIGINT NOT NULL,
   data_atendimento TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (cod_atendimento)
) COMMENT = 'Registra os atendimentos realizados por prestadores para solicitações.';

/*CREATE TABLE IF NOT EXISTS mensagem (
    cod_mensagem BIGINT NOT NULL AUTO_INCREMENT,
    remetente VARCHAR(80) NOT NULL CHECK (remetente IN ('CONTRATANTE', 'PRESTADOR')),
    mensagem TEXT NOT NULL,
    data_envio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cod_atendimento BIGINT NOT NULL,
  PRIMARY KEY (cod_mensagem)
) COMMENT = 'Registra as mensagens enviadas entre contratantes e prestadores durante um atendimento.';*/
  
CREATE TABLE IF NOT EXISTS faturamento (
   cod_faturamento BIGINT NOT NULL AUTO_INCREMENT,
   valor_final DECIMAL(10,2) NOT NULL,
   forma_pagamento VARCHAR(50) NOT NULL,
   cod_atendimento BIGINT NOT NULL,
   status BOOLEAN DEFAULT 1 COMMENT 'Ativo (1) ou Inativo (0)',
   
  CONSTRAINT chk_faturamento_valor_final CHECK (valor_final > 0),
  CONSTRAINT chk_faturamento_forma_pagamento CHECK (forma_pagamento IN ('DINHEIRO', 'PIX', 'CARTAO')),
  CONSTRAINT chk_faturamento_status CHECK (status IN (1, 0)),
  PRIMARY KEY (cod_faturamento)
) COMMENT = 'Armazena os dados de cobrança e pagamento por atendimento.';

/*CREATE TABLE IF NOT EXISTS avaliacao_contratante (
   cod_avaliacao_contratante BIGINT NOT NULL AUTO_INCREMENT,
   nota TINYINT NOT NULL COMMENT 'Nota de avaliação de 1 a 5',
   comentario TEXT DEFAULT NULL,
   data_avaliacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   cod_solicitacao BIGINT NOT NULL,
  
  CONSTRAINT chk_avaliacao_contratante_nota CHECK (nota BETWEEN 1 AND 5), 
  CONSTRAINT chk_avaliacao_contratante_comentario CHECK (CHAR_LENGTH(comentario) <= 50),
  PRIMARY KEY (cod_avaliacao_contratante) 
) COMMENT = 'Armazena as avaliações dadas ao contratante após uma solicitação';

CREATE TABLE IF NOT EXISTS avaliacao_prestador (
   cod_avaliacao_prestador BIGINT NOT NULL AUTO_INCREMENT,
   nota TINYINT NOT NULL COMMENT 'Nota de avaliação de 1 a 5',
   comentario TEXT DEFAULT NULL,
   data_avaliacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   cod_atendimento BIGINT NOT NULL,
   
  CONSTRAINT chk_avaliacao_prestador_nota CHECK (nota BETWEEN 1 AND 5), 
  CONSTRAINT chk_avaliacao_prestador_comentario CHECK (CHAR_LENGTH(comentario) <= 50),
  PRIMARY KEY (cod_avaliacao_prestador)
) COMMENT = 'Armazena as avaliações dadas ao prestador após um atendimento.';*/

CREATE TABLE IF NOT EXISTS role (
   cod_role BIGINT NOT NULL AUTO_INCREMENT,
   nome_role VARCHAR(100) NOT NULL,
   status BOOLEAN DEFAULT 1 COMMENT 'Ativo (1) ou Inativo (0)',
  
  UNIQUE (nome_role),
  CONSTRAINT chk_role_status CHECK (status IN (1, 0)),
  PRIMARY KEY (cod_role)
) COMMENT = 'Define os perfis de acesso (roles) disponíveis na plataforma.';

CREATE TABLE IF NOT EXISTS role_contratante (
	cod_role_contratante BIGINT NOT NULL AUTO_INCREMENT,
    cod_usuario_contratante BIGINT NOT NULL,
    cod_role BIGINT NOT NULL,
    status BOOLEAN DEFAULT 1 COMMENT 'Ativo (1) ou Inativo (0)',
    
  CONSTRAINT chk_role_contratante_status CHECK (status IN (1, 0)),
  PRIMARY KEY (cod_role_contratante)
) COMMENT = 'Associa roles a usuários contratantes.';

CREATE TABLE IF NOT EXISTS role_prestador (
    cod_role_prestador BIGINT NOT NULL AUTO_INCREMENT,
    cod_usuario_prestador BIGINT NOT NULL,
    cod_role BIGINT NOT NULL,
    status BOOLEAN DEFAULT 1 COMMENT 'Ativo (1) ou Inativo (0)',
    
  CONSTRAINT chk_role_prestador_status CHECK (status IN (1, 0)),
  PRIMARY KEY (cod_role_prestador)
) COMMENT = 'Associa roles a usuários prestadores.';

# ===========================================
#               FOREIGN KEY
# ===========================================

# tabela - contratante
ALTER TABLE contratante
ADD CONSTRAINT fk_contratante_usuario_contratante
FOREIGN KEY (cod_usuario_contratante) 
REFERENCES usuario_contratante(cod_usuario_contratante)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

# tabela - endereco_contratante
ALTER TABLE endereco_contratante
ADD CONSTRAINT fk_endereco_contratante_contratante
FOREIGN KEY (cod_contratante) 
REFERENCES contratante(cod_contratante)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

# tabela - prestador
ALTER TABLE prestador
ADD CONSTRAINT fk_prestador_usuario_prestador
FOREIGN KEY (cod_usuario_prestador) 
REFERENCES usuario_prestador(cod_usuario_prestador)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

# tabela - endereco_prestador
ALTER TABLE endereco_prestador
ADD CONSTRAINT fk_endereco_prestador_prestador
FOREIGN KEY (cod_prestador) 
REFERENCES prestador(cod_prestador)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

# tabela - certificado
ALTER TABLE certificado
ADD CONSTRAINT fk_certificado_prestador
FOREIGN KEY (cod_prestador) 
REFERENCES prestador(cod_prestador)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

# tabela - habilidade_profissional
ALTER TABLE habilidade_profissional
ADD CONSTRAINT fk_habilidade_profissional_prestador
FOREIGN KEY (cod_prestador) 
REFERENCES prestador(cod_prestador)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE habilidade_profissional
ADD CONSTRAINT fk_habilidade_profissional_habilidade
FOREIGN KEY (cod_habilidade) 
REFERENCES habilidade(cod_habilidade)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

# tabela - solicitacao
ALTER TABLE solicitacao
ADD CONSTRAINT fk_solicitacao_servico
FOREIGN KEY (cod_servico) 
REFERENCES servico(cod_servico)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE solicitacao
ADD CONSTRAINT fk_solicitacao_motivo_cancelamento
FOREIGN KEY (cod_motivo_cancelamento) 
REFERENCES motivo_cancelamento(cod_motivo_cancelamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE solicitacao
ADD CONSTRAINT fk_solicitacao_contratante
FOREIGN KEY (cod_contratante) 
REFERENCES contratante(cod_contratante)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

# tabela - atendimento
ALTER TABLE atendimento
ADD CONSTRAINT fk_atendimento_solicitacao
FOREIGN KEY (cod_solicitacao) 
REFERENCES solicitacao(cod_solicitacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE atendimento
ADD CONSTRAINT fk_atendimento_prestador
FOREIGN KEY (cod_prestador) 
REFERENCES prestador(cod_prestador)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

# tabela - mensagem
/*ALTER TABLE mensagem
ADD CONSTRAINT fk_mensagem_atendimento
FOREIGN KEY (cod_atendimento) 
REFERENCES atendimento(cod_atendimento)
ON DELETE NO ACTION
ON UPDATE NO ACTION; */   
    
# tabela - faturamento
ALTER TABLE faturamento
ADD CONSTRAINT fk_faturamento_atendimento
FOREIGN KEY (cod_atendimento) 
REFERENCES atendimento(cod_atendimento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

# tabela - avaliacao_contratante
/*ALTER TABLE avaliacao_contratante
ADD CONSTRAINT fk_avaliacao_contratante_solicitacao
FOREIGN KEY (cod_solicitacao) 
REFERENCES solicitacao(cod_solicitacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

# tabela - avaliacao_prestador
ALTER TABLE avaliacao_prestador
ADD CONSTRAINT fk_avaliacao_prestador_atendimento
FOREIGN KEY (cod_atendimento) 
REFERENCES atendimento(cod_atendimento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;*/

# tabela - role_contratante
ALTER TABLE role_contratante
ADD CONSTRAINT fk_role_contratante_usuario_contratante
FOREIGN KEY (cod_usuario_contratante) 
REFERENCES usuario_contratante(cod_usuario_contratante)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE role_contratante
ADD CONSTRAINT fk_role_contratante_role
FOREIGN KEY (cod_role) 
REFERENCES role(cod_role)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

# tabela - role_prestador
ALTER TABLE role_prestador
ADD CONSTRAINT fk_role_prestador_usuario_prestador
FOREIGN KEY (cod_usuario_prestador) 
REFERENCES usuario_prestador(cod_usuario_prestador)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE role_prestador
ADD CONSTRAINT fk_role_prestador_role
FOREIGN KEY (cod_role) 
REFERENCES role(cod_role)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

# ================================================================
# == TRIGGERS DE PADRONIZAÇÃO DE DADOS
# ================================================================

# =============================================================
# POLÍTICA DE PADRONIZAÇÃO DE TEXTO (UPPERCASE)
# =============================================================
# Estas triggers são responsáveis por garantir a consistência dos dados
# automaticamente, convertendo colunas específicas para MAIÚSCULO (UPPERCASE)
# antes de cada inserção ou atualização.
#
# A padronização é aplicada a:
# - Chaves de pesquisa (emails, CPFs, nomes de serviço/habilidade).
# - Códigos e Status de valor fixo ('A', 'I', 'M', 'F', 'BAIXA', etc.).
# - Endereços estruturados (rua, bairro, cidade, estado).
#
# NOTA: Campos de texto livre (descrições longas, comentários, e mensagens)
# são intencionalmente MANTIDOS em seu formato original para preservar a
# legibilidade e usabilidade do usuário.
# =============================================================

DELIMITER //

-- TRIGGERS PARA usuario_contratante
CREATE TRIGGER tg_usuario_contratante_insert_upper
BEFORE INSERT ON usuario_contratante
FOR EACH ROW
BEGIN
  SET NEW.nome = UPPER(NEW.nome);
  SET NEW.email = UPPER(NEW.email);
  SET NEW.status = UPPER(NEW.status);
END //

CREATE TRIGGER tg_usuario_contratante_update_upper
BEFORE UPDATE ON usuario_contratante
FOR EACH ROW
BEGIN
  SET NEW.nome = UPPER(NEW.nome);
  SET NEW.email = UPPER(NEW.email);
  SET NEW.status = UPPER(NEW.status);
END //

-- TRIGGERS PARA contratante
CREATE TRIGGER tg_contratante_insert_upper
BEFORE INSERT ON contratante
FOR EACH ROW
BEGIN
  SET NEW.nome_contratante = UPPER(NEW.nome_contratante);
  SET NEW.sexo = UPPER(NEW.sexo);
  SET NEW.status = UPPER(NEW.status);
END //

CREATE TRIGGER tg_contratante_update_upper
BEFORE UPDATE ON contratante
FOR EACH ROW
BEGIN
  SET NEW.nome_contratante = UPPER(NEW.nome_contratante);
  SET NEW.sexo = UPPER(NEW.sexo);
  SET NEW.status = UPPER(NEW.status);
END //

-- TRIGGERS PARA endereco_contratante
CREATE TRIGGER tg_endereco_contratante_insert_upper
BEFORE INSERT ON endereco_contratante
FOR EACH ROW
BEGIN
  SET NEW.rua = UPPER(NEW.rua);
  SET NEW.bairro = UPPER(NEW.bairro);
  SET NEW.cidade = UPPER(NEW.cidade);
  SET NEW.estado = UPPER(NEW.estado);
  SET NEW.status = UPPER(NEW.status);
END //

CREATE TRIGGER tg_endereco_contratante_update_upper
BEFORE UPDATE ON endereco_contratante
FOR EACH ROW
BEGIN
  SET NEW.rua = UPPER(NEW.rua);
  SET NEW.bairro = UPPER(NEW.bairro);
  SET NEW.cidade = UPPER(NEW.cidade);
  SET NEW.estado = UPPER(NEW.estado);
  SET NEW.status = UPPER(NEW.status);
END //

-- TRIGGERS PARA servico
CREATE TRIGGER tg_servico_insert_upper
BEFORE INSERT ON servico
FOR EACH ROW
BEGIN
  SET NEW.nome_servico = UPPER(NEW.nome_servico);
  SET NEW.status = UPPER(NEW.status);
END //

CREATE TRIGGER tg_servico_update_upper
BEFORE UPDATE ON servico
FOR EACH ROW
BEGIN
  SET NEW.nome_servico = UPPER(NEW.nome_servico);
  SET NEW.status = UPPER(NEW.status);
END //

-- TRIGGERS PARA usuario_prestador
CREATE TRIGGER tg_usuario_prestador_insert_upper
BEFORE INSERT ON usuario_prestador
FOR EACH ROW
BEGIN
  SET NEW.nome = UPPER(NEW.nome);
  SET NEW.email = UPPER(NEW.email);
  SET NEW.status = UPPER(NEW.status);
END //

CREATE TRIGGER tg_usuario_prestador_update_upper
BEFORE UPDATE ON usuario_prestador
FOR EACH ROW
BEGIN
  SET NEW.nome = UPPER(NEW.nome);
  SET NEW.email = UPPER(NEW.email);
  SET NEW.status = UPPER(NEW.status);
END //

-- TRIGGERS PARA prestador
CREATE TRIGGER tg_prestador_insert_upper
BEFORE INSERT ON prestador
FOR EACH ROW
BEGIN
  SET NEW.nome_prestador = UPPER(NEW.nome_prestador);
  SET NEW.sexo = UPPER(NEW.sexo);
# SET NEW.descricao_perfil = UPPER(NEW.descricao_perfil);
  SET NEW.disponibilidade = UPPER(NEW.disponibilidade);
  SET NEW.status = UPPER(NEW.status);
END //

CREATE TRIGGER tg_prestador_update_upper
BEFORE UPDATE ON prestador
FOR EACH ROW
BEGIN
  SET NEW.nome_prestador = UPPER(NEW.nome_prestador);
  SET NEW.sexo = UPPER(NEW.sexo);
# SET NEW.descricao_perfil = UPPER(NEW.descricao_perfil);
  SET NEW.disponibilidade = UPPER(NEW.disponibilidade);
  SET NEW.status = UPPER(NEW.status);
END //

-- TRIGGERS PARA endereco_prestador
CREATE TRIGGER tg_endereco_prestador_insert_upper
BEFORE INSERT ON endereco_prestador
FOR EACH ROW
BEGIN
  SET NEW.rua = UPPER(NEW.rua);
  SET NEW.bairro = UPPER(NEW.bairro);
  SET NEW.cidade = UPPER(NEW.cidade);
  SET NEW.estado = UPPER(NEW.estado);
  SET NEW.status = UPPER(NEW.status);
END //

CREATE TRIGGER tg_endereco_prestador_update_upper
BEFORE UPDATE ON endereco_prestador
FOR EACH ROW
BEGIN
  SET NEW.rua = UPPER(NEW.rua);
  SET NEW.bairro = UPPER(NEW.bairro);
  SET NEW.cidade = UPPER(NEW.cidade);
  SET NEW.estado = UPPER(NEW.estado);
  SET NEW.status = UPPER(NEW.status);
END //

-- TRIGGERS PARA certificado
CREATE TRIGGER tg_certificado_insert_upper
BEFORE INSERT ON certificado
FOR EACH ROW
BEGIN
  SET NEW.status = UPPER(NEW.status);
END //

CREATE TRIGGER tg_certificado_update_upper
BEFORE UPDATE ON certificado
FOR EACH ROW
BEGIN
  SET NEW.status = UPPER(NEW.status);
END //

-- TRIGGERS PARA habilidade
CREATE TRIGGER tg_habilidade_insert_upper
BEFORE INSERT ON habilidade
FOR EACH ROW
BEGIN
  SET NEW.nome_habilidade = UPPER(NEW.nome_habilidade);
  SET NEW.status = UPPER(NEW.status);
END //

CREATE TRIGGER tg_habilidade_update_upper
BEFORE UPDATE ON habilidade
FOR EACH ROW
BEGIN
  SET NEW.nome_habilidade = UPPER(NEW.nome_habilidade);
  SET NEW.status = UPPER(NEW.status);
END //

-- TRIGGERS PARA habilidade_profissional
CREATE TRIGGER tg_habilidade_profissional_insert_upper
BEFORE INSERT ON habilidade_profissional
FOR EACH ROW
BEGIN
  SET NEW.status = UPPER(NEW.status);
END //

CREATE TRIGGER tg_habilidade_profissional_update_upper
BEFORE UPDATE ON habilidade_profissional
FOR EACH ROW
BEGIN
  SET NEW.status = UPPER(NEW.status);
END //

-- TRIGGERS PARA solicitacao
CREATE TRIGGER tg_solicitacao_insert_upper
BEFORE INSERT ON solicitacao
FOR EACH ROW
BEGIN
# SET NEW.descricao_solicitacao = UPPER(NEW.descricao_solicitacao);
# SET NEW.localizacao = UPPER(NEW.localizacao);
  SET NEW.urgencia = UPPER(NEW.urgencia);
  SET NEW.status_solicitacao = UPPER(NEW.status_solicitacao);
END //

CREATE TRIGGER tg_solicitacao_update_upper
BEFORE UPDATE ON solicitacao
FOR EACH ROW
BEGIN
# SET NEW.descricao_solicitacao = UPPER(NEW.descricao_solicitacao);
# SET NEW.localizacao = UPPER(NEW.localizacao);
  SET NEW.urgencia = UPPER(NEW.urgencia);
  SET NEW.status_solicitacao = UPPER(NEW.status_solicitacao);
END //

-- TRIGGERS PARA faturamento
CREATE TRIGGER tg_faturamento_insert_upper
BEFORE INSERT ON faturamento
FOR EACH ROW
BEGIN
  SET NEW.forma_pagamento = UPPER(NEW.forma_pagamento);
  SET NEW.status = UPPER(NEW.status);
END //

CREATE TRIGGER tg_faturamento_update_upper
BEFORE UPDATE ON faturamento
FOR EACH ROW
BEGIN
  SET NEW.forma_pagamento = UPPER(NEW.forma_pagamento);
  SET NEW.status = UPPER(NEW.status);
END //

-- TRIGGERS PARA role
CREATE TRIGGER tg_role_insert_upper
BEFORE INSERT ON role
FOR EACH ROW
BEGIN
  SET NEW.status = UPPER(NEW.status);
END //

CREATE TRIGGER tg_role_update_upper
BEFORE UPDATE ON role
FOR EACH ROW
BEGIN
  SET NEW.status = UPPER(NEW.status);
END //

-- TRIGGERS PARA role_contratante
CREATE TRIGGER tg_role_contratante_insert_upper
BEFORE INSERT ON role_contratante
FOR EACH ROW
BEGIN
  SET NEW.status = UPPER(NEW.status);
END //

CREATE TRIGGER tg_role_contratante_update_upper
BEFORE UPDATE ON role_contratante
FOR EACH ROW
BEGIN
  SET NEW.status = UPPER(NEW.status);
END //

-- TRIGGERS PARA role_prestador
CREATE TRIGGER tg_role_prestador_insert_upper
BEFORE INSERT ON role_prestador
FOR EACH ROW
BEGIN
  SET NEW.status = UPPER(NEW.status);
END //

CREATE TRIGGER tg_role_prestador_update_upper
BEFORE UPDATE ON role_prestador
FOR EACH ROW
BEGIN
  SET NEW.status = UPPER(NEW.status);
END //

/* ============================================================
   SERVIÇOS OFERECIDOS NA PLATAFORMA
   OBS: Lista de serviços usada apenas para TESTES.
        -> Ainda não confirmada oficialmente.
   ============================================================ */

INSERT INTO servico (nome_servico) VALUES ('BARBEIRO'                       );
INSERT INTO servico (nome_servico) VALUES ('CABELEIREIRO'                   );
INSERT INTO servico (nome_servico) VALUES ('CARPINTEIRO'                    );
INSERT INTO servico (nome_servico) VALUES ('CHAVEIRO'                       );  
INSERT INTO servico (nome_servico) VALUES ('DIARISTA'                       ); 
INSERT INTO servico (nome_servico) VALUES ('ELETRICISTA'                    );
INSERT INTO servico (nome_servico) VALUES ('ENCANADOR'                      );
INSERT INTO servico (nome_servico) VALUES ('GESSEIRO'                       );
INSERT INTO servico (nome_servico) VALUES ('INSTALADOR DE ELETRÔNICOS'      );
INSERT INTO servico (nome_servico) VALUES ('JARDINEIRO'                     );
INSERT INTO servico (nome_servico) VALUES ('LAVAJATO'                       );   
INSERT INTO servico (nome_servico) VALUES ('MANICURE'                       );
INSERT INTO servico (nome_servico) VALUES ('MARCENEIRO'                     );
INSERT INTO servico (nome_servico) VALUES ('MASSAGISTA'                     );
INSERT INTO servico (nome_servico) VALUES ('MUNDANÇAS'                      );
INSERT INTO servico (nome_servico) VALUES ('MONTADOR'                       );
INSERT INTO servico (nome_servico) VALUES ('PEDREIRO'                       );
INSERT INTO servico (nome_servico) VALUES ('PINTOR'                         );
INSERT INTO servico (nome_servico) VALUES ('PASSEADOR DE CÃES'              );
INSERT INTO servico (nome_servico) VALUES ('PISCINEIRO'                     );
INSERT INTO servico (nome_servico) VALUES ('TECNOLOGIA DA INFORMAÇÃO'       );    
INSERT INTO servico (nome_servico) VALUES ('TÉCNICO DE AR CONDICIONADO'     );   

/* ============================================================
   HABILIDADES DOS PRESTADORES
   OBS: Lista de habilidades usada apenas para TESTES.
        -> Ainda não confirmada oficialmente.
   ============================================================ */

INSERT INTO habilidade (nome_habilidade) VALUES
-- GRUPO: PROFISSIONAIS DE SAÚDE E CUIDADOS
('CUIDADOR DE IDOSOS'),
('ENFERMAGEM DOMICILIAR'),
('FISIOTERAPIA'),
('MASSOTERAPIA'),
('ACOMPANHANTE HOSPITALAR'),
('TERAPIA OCUPACIONAL'),
('PSICOLOGIA CLÍNICA'),
('NUTRIÇÃO CLÍNICA'),
('ODONTOLOGIA DOMICILIAR'),
('AUXILIAR DE ENFERMAGEM'),
('FONOAUDIOLOGIA'),
('ACUPUNTURA'),
('CUIDADOR DE PESSOAS COM DEFICIÊNCIA'),
('EDUCAÇÃO FÍSICA TERAPÊUTICA'),
('ENFERMAGEM GERAL');

INSERT INTO motivo_cancelamento
(motivo_cancelamento)
VALUES
('valor não acordado');


