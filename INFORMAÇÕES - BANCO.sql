-- =============================================
-- VIEW: vw_tabelas_comentarios
-- DESCRIÇÃO: Lista todas as tabelas do banco atual
--             com seus respectivos comentários.
-- UTILIDADE: Permite visualizar rapidamente o propósito
--             de cada tabela do banco de dados.
-- =============================================

CREATE OR REPLACE VIEW vw_tabelas_comentarios AS
SELECT 
    TABLE_NAME AS tabela,
    TABLE_COMMENT AS comentario
FROM 
    information_schema.TABLES
WHERE 
    TABLE_SCHEMA = DATABASE();

SELECT * FROM vw_tabelas_comentarios;

-- =============================================
-- VIEW: vw_colunas_comentarios
-- DESCRIÇÃO: Lista todas as colunas do banco atual
--             que possuem comentários, **exceto**
--             colunas relacionadas a status.
-- UTILIDADE: Permite visualizar rapidamente o propósito
--             de cada coluna sem incluir colunas de status.
-- =============================================

CREATE OR REPLACE VIEW vw_colunas_comentarios AS
SELECT 
    TABLE_NAME AS tabela,
    COLUMN_NAME AS coluna,
    COLUMN_COMMENT AS comentario
FROM 
    information_schema.COLUMNS
WHERE 
    TABLE_SCHEMA = DATABASE()
    AND COLUMN_COMMENT <> ''
    AND COLUMN_COMMENT NOT LIKE '%Ativo%'  -- exclui colunas de status
ORDER BY 
    TABLE_NAME;

-- Para consultar a view:
SELECT * FROM vw_colunas_comentarios;

-- =============================================
-- VIEW: vw_colunas_status
-- DESCRIÇÃO: Lista todas as tabelas do banco atual
--             que possuem colunas com comentários
--             contendo "Ativo", agrupando as colunas
--             e seus comentários em uma única linha por tabela.
-- UTILIDADE: Permite visualizar rapidamente quais
--             colunas representam status em cada tabela.
-- =============================================

CREATE OR REPLACE VIEW vw_colunas_status AS
SELECT 
    TABLE_NAME AS tabela,
    GROUP_CONCAT(CONCAT(COLUMN_NAME, ': ', COLUMN_COMMENT) 
                 ORDER BY COLUMN_NAME SEPARATOR '; ') AS colunas_status
FROM 
    information_schema.COLUMNS
WHERE 
    TABLE_SCHEMA = DATABASE()
    AND COLUMN_COMMENT LIKE '%Ativo%'
GROUP BY 
    TABLE_NAME
ORDER BY 
    TABLE_NAME;

-- Para consultar a view:
SELECT * FROM vw_colunas_status;


-- =============================================
-- VIEW: vw_constraints_principal
-- DESCRIÇÃO: Lista todas as constraints principais do banco atual,
--             incluindo PRIMARY KEY (PK), FOREIGN KEY (FK) e CHECK.
-- UTILIDADE: Permite identificar rapidamente as regras de integridade
--             definidas no banco, organizadas em grupos: PK primeiro,
--             depois FK e por último CHECK, facilitando a leitura.
-- =============================================

CREATE OR REPLACE VIEW vw_constraints_principal AS
SELECT 
    TABLE_NAME AS tabela,
    CONSTRAINT_NAME AS constraint_nome,
    CONSTRAINT_TYPE AS tipo
FROM 
    information_schema.TABLE_CONSTRAINTS
WHERE 
    TABLE_SCHEMA = DATABASE()
    AND CONSTRAINT_TYPE IN ('PRIMARY KEY', 'FOREIGN KEY', 'CHECK')
ORDER BY 
    CASE CONSTRAINT_TYPE
        WHEN 'PRIMARY KEY' THEN 1
        WHEN 'FOREIGN KEY' THEN 2
        WHEN 'CHECK' THEN 3
    END,
    TABLE_NAME,
    CONSTRAINT_NAME;

-- Para ver as constraints do tipo CHECK:
SELECT * FROM vw_constraints_principal;

-- =============================================
-- VIEW: vw_constraints_unique
-- DESCRIÇÃO: Lista todas as constraints do tipo UNIQUE
--             de todas as tabelas do banco atual,
--             mostrando o nome da constraint e a coluna correspondente.
-- UTILIDADE: Permite identificar rapidamente quais colunas
--             têm valores únicos e quais nomes o MySQL atribuiu
--             às constraints UNIQUE.
-- =============================================

CREATE OR REPLACE VIEW vw_constraints_unique AS
SELECT 
    TABLE_NAME AS tabela,
    CONSTRAINT_NAME AS constraint_nome,
    COLUMN_NAME AS coluna
FROM 
    information_schema.KEY_COLUMN_USAGE
WHERE 
    TABLE_SCHEMA = DATABASE()
    AND CONSTRAINT_NAME IN (
        SELECT CONSTRAINT_NAME
        FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = DATABASE()
          AND CONSTRAINT_TYPE = 'UNIQUE'
    )
ORDER BY TABLE_NAME, CONSTRAINT_NAME;

-- Para ver todas as UNIQUE constraints:
SELECT * FROM vw_constraints_unique;


