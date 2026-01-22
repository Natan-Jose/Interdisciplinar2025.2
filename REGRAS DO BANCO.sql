# ================================================================
# == CÓDIGOS DE ERRO
# ================================================================

# SQLSTATE 45000 --> Indica um erro genérico e definido pelo utilizador.
#                   usado para bloquear operações não permitidas nas triggers.

# ================================================================
# == TRIGGERS
# ================================================================

# =============================================
-- TRIGGER: tg_limite_habilidades

-- DESCRIÇÃO: Impede que um prestador tenha mais
--            de 3 habilidades principais.
# =============================================

DELIMITER //

CREATE TRIGGER tg_limite_habilidades
BEFORE INSERT ON habilidade_profissional
FOR EACH ROW
BEGIN
    DECLARE num_habilidades INT;

    -- Conta quantas habilidades o prestador já possui
    SELECT COUNT(*)
    INTO num_habilidades
    FROM habilidade_profissional
    WHERE cod_prestador = NEW.cod_prestador;

    -- Se já tiver 3 ou mais habilidades, impede a inserção
    IF num_habilidades >= 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O prestador já atingiu o limite máximo de 3 habilidades principais.';
    END IF;

END //

DELIMITER ;


# ===========================================================
-- TRIGGER: tg_mudar_status_solicitacao

-- DESCRIÇÃO: Atualiza automaticamente o status de uma solicitação
--             para 'EM ANDAMENTO' quando um atendimento é inserido.
# ===========================================================

DELIMITER //

CREATE TRIGGER tg_mudar_status_solicitacao
AFTER INSERT ON atendimento
FOR EACH ROW
BEGIN
    UPDATE solicitacao
    SET status_solicitacao = 'EM ANDAMENTO'
    WHERE cod_solicitacao = NEW.cod_solicitacao
      AND status_solicitacao = 'PENDENTE'; 
END //

DELIMITER ;


# ===========================================================
-- TRIGGER: tg_contratante_unico_servico

-- DESCRIÇÃO: Impede que o contratante crie uma nova solicitação
--            se já possuir uma solicitação com status 'EM ANDAMENTO'.
# ===========================================================

DELIMITER //

CREATE TRIGGER tg_contratante_unico_servico
BEFORE INSERT ON solicitacao
FOR EACH ROW
BEGIN
    DECLARE qtd_ativos INT;

    -- Conta quantas solicitações "EM ANDAMENTO" o contratante já possui
    SELECT COUNT(*)
    INTO qtd_ativos
    FROM solicitacao
    WHERE cod_contratante = NEW.cod_contratante
      AND status_solicitacao = 'EM ANDAMENTO';

    -- Se já existir algum serviço ativo "EM ANDAMENTO", impede a inserção
    IF qtd_ativos > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'O contratante já possui uma solicitação em andamento. Não é permitido criar outra.';
    END IF;
END //

DELIMITER ;

# ===========================================================
-- TRIGGER: tg_prestador_unico_servico

-- DESCRIÇÃO: Impede que o prestador aceite um novo serviço
--            se já possuir uma solicitação com status 'EM ANDAMENTO'
--            na tabela solicitacao.
# ===========================================================

DELIMITER //

CREATE TRIGGER tg_prestador_unico_servico
BEFORE INSERT ON atendimento
FOR EACH ROW
BEGIN
    DECLARE qtd_ativos INT;

    -- Conta quantos serviços "EM ANDAMENTO" o prestador já possui
    SELECT COUNT(*)
    INTO qtd_ativos
    FROM atendimento a
    JOIN solicitacao s ON a.cod_solicitacao = s.cod_solicitacao
    WHERE a.cod_prestador = NEW.cod_prestador
      AND s.status_solicitacao = 'EM ANDAMENTO';

    -- Se já existir algum serviço ativo "EM ANDAMENTO", impede a inserção
    IF qtd_ativos > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'O prestador já possui um serviço em andamento. Não é permitido aceitar outro.';
    END IF;
END //

DELIMITER ;

# ===========================================================
-- TRIGGER: tg_registra_finalizacao

-- DESCRIÇÃO: Registra automaticamente o momento em que uma solicitação
--             é finalizada, ou seja, quando seu status muda para 
--             'CONCLUIDO' ou 'CANCELADO'. A trigger define o campo 
--             `data_finalizacao` na própria tabela `solicitacao`, 
--             permitindo controlar quando a solicitação foi concluída.
# ===========================================================

DELIMITER //

CREATE TRIGGER tg_registra_finalizacao
BEFORE UPDATE ON solicitacao
FOR EACH ROW
BEGIN
    -- Só registra a data de finalização quando muda para CONCLUIDO ou CANCELADO
    IF (NEW.status_solicitacao IN ('CONCLUIDO', 'CANCELADO')) 
       AND (OLD.status_solicitacao NOT IN ('CONCLUIDO', 'CANCELADO')) THEN
       
        SET NEW.data_finalizacao = NOW();
    END IF;
END;
//

DELIMITER ;

# ===========================================================
-- TRIGGER: tg_proteger_solicitacao_finalizada

-- DESCRIÇÃO: Permite alterar apenas o campo 'status_solicitacao' 
--             em solicitações cujo status esteja 'CONCLUIDO' ou 'CANCELADO'. 
--             Todos os demais campos permanecem inalterados.
# ===========================================================

DELIMITER //

CREATE TRIGGER tg_proteger_solicitacao_finalizada
BEFORE UPDATE ON solicitacao
FOR EACH ROW
BEGIN
    DECLARE minutos_passados INT;

    -- Só aplica a regra se a solicitação está finalizada
    IF OLD.status_solicitacao IN ('CONCLUIDO', 'CANCELADO') THEN
        -- Calcula quantos minutos se passaram desde a finalização
        SET minutos_passados = TIMESTAMPDIFF(MINUTE, OLD.data_finalizacao, NOW());

        -- Bloqueia alterações se já passaram mais de 10 minutos
        IF minutos_passados > 10 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Não é permitido alterar a solicitação após 10 minutos da finalização';
        END IF;

        -- Bloqueia alteração de qualquer campo se NÃO for alteração do status
        IF NEW.status_solicitacao = OLD.status_solicitacao THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Após a finalização, apenas o status pode ser alterado';
        END IF;
    END IF;
END //

DELIMITER ;


# ===========================================================
-- TRIGGER: tg_proteger_atendimento_finalizado

-- DESCRIÇÃO: Bloqueia qualquer tentativa de atualização em atendimentos
--             cujo status da solicitação vinculada esteja 'CONCLUIDO' ou 'CANCELADO'.
# ===========================================================

DELIMITER //

CREATE TRIGGER tg_proteger_atendimento_finalizado
BEFORE UPDATE ON atendimento
FOR EACH ROW
BEGIN
    DECLARE status_solicitacao_atual VARCHAR(20);

    -- Obtém o status da solicitação associada
    SELECT s.status_solicitacao
    INTO status_solicitacao_atual
    FROM solicitacao s
    WHERE s.cod_solicitacao = OLD.cod_solicitacao;

    -- Bloqueia a atualização se a solicitação estiver CONCLUIDO ou CANCELADO
    IF status_solicitacao_atual IN ('CONCLUIDO', 'CANCELADO') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é permitido atualizar um atendimento vinculado a uma solicitação concluída ou cancelada';
    END IF;
END //

DELIMITER ;

# ===========================================================
-- TRIGGER: tg_proteger_faturamento_finalizado

-- DESCRIÇÃO: Impede qualquer alteração nos dados da tabela
--             faturamento se a solicitação associada estiver 'CONCLUIDO' ou 'CANCELADO'.
# ===========================================================

DELIMITER //

CREATE TRIGGER tg_proteger_faturamento_finalizado
BEFORE UPDATE ON faturamento
FOR EACH ROW
BEGIN
    DECLARE status_solicitacao_atual VARCHAR(20);

    -- Obtém o status da solicitação relacionada ao atendimento
    SELECT s.status_solicitacao
    INTO status_solicitacao_atual
    FROM atendimento a
    JOIN solicitacao s ON a.cod_solicitacao = s.cod_solicitacao
    WHERE a.cod_atendimento = OLD.cod_atendimento;

    -- Bloqueia qualquer atualização se a solicitação estiver CONCLUIDO ou CANCELADO
    IF status_solicitacao_atual IN ('CONCLUIDO', 'CANCELADO') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é permitido alterar nenhum dado de faturamento de solicitação concluída ou cancelada';
    END IF;
END;
//

DELIMITER ;


# ================================================================
# == EVENTS
# ================================================================

# ===========================================================
-- EVENT: ev_remover_solicitacoes_pendentes

-- DESCRIÇÃO: Remove automaticamente solicitações que permanecem
--             com status 'PENDENTE' por mais de 2 horas.

-- OBJETIVO: Garantir que solicitações sem aceite de prestadores
--            dentro do tempo limite sejam descartadas, evitando
--            acúmulo de registros obsoletos e melhorando o
--            desempenho e a integridade operacional do sistema.

-- AGENDAMENTO: Executado automaticamente a cada 10 minutos.

-- OBSERVAÇÃO: Requer que o campo 'data_criacao' exista na tabela
--             'solicitacao' e que o Event Scheduler esteja ativo.
# ===========================================================

SET GLOBAL event_scheduler = ON;

SHOW VARIABLES LIKE 'event_scheduler';

DELIMITER //

CREATE EVENT IF NOT EXISTS ev_remover_solicitacoes_pendentes
ON SCHEDULE EVERY 10 MINUTE
DO
BEGIN
    DELETE FROM solicitacao
    WHERE status_solicitacao = 'PENDENTE'
      AND TIMESTAMPDIFF(HOUR, data_cadastro, NOW()) >= 2;
END //

DELIMITER ;

# DROP EVENT IF EXISTS ev_remover_solicitacoes_pendentes;
SHOW EVENTS;

SELECT * FROM solicitacao;




