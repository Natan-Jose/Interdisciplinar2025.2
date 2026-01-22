SELECT cod_solicitacao,
       status_solicitacao,
       data_finalizacao,
       GREATEST(0, 10 - TIMESTAMPDIFF(MINUTE, data_finalizacao, NOW())) AS minutos_restantes
FROM solicitacao
WHERE status_solicitacao IN ('CONCLUIDO', 'CANCELADO');

SELECT a.cod_atendimento,
       s.cod_solicitacao,
       s.status_solicitacao,
       s.data_finalizacao,
       GREATEST(0, 10 - TIMESTAMPDIFF(MINUTE, s.data_finalizacao, NOW())) AS minutos_restantes
FROM atendimento a
JOIN solicitacao s ON a.cod_solicitacao = s.cod_solicitacao
WHERE s.status_solicitacao = 'CONCLUIDO';

SELECT f.cod_faturamento,
       a.cod_atendimento,
       s.cod_solicitacao,
       s.status_solicitacao,
       s.data_finalizacao,
       GREATEST(0, 10 - TIMESTAMPDIFF(MINUTE, s.data_finalizacao, NOW())) AS minutos_restantes
FROM faturamento f
JOIN atendimento a ON f.cod_atendimento = a.cod_atendimento
JOIN solicitacao s ON a.cod_solicitacao = s.cod_solicitacao
WHERE s.status_solicitacao = 'CONCLUIDO';

