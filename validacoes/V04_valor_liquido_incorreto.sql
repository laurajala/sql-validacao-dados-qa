-- V04 - Valor líquido incorreto
-- Regra: valor líquido = valor bruto - soma das retenções (IRRF, INSS, ISSQN).
-- Resultado esperado: nenhuma linha. Cada linha retornada é um defeito.

SELECT
    p.id                                         AS pedido_id,
    p.valor_bruto,
    COALESCE(SUM(r.valor), 0)                    AS total_retencoes,
    p.valor_bruto - COALESCE(SUM(r.valor), 0)    AS valor_liquido_esperado,
    p.valor_liquido                              AS valor_liquido_registrado
FROM pedidos_pagamento p
LEFT JOIN retencoes r ON r.pedido_id = p.id
GROUP BY p.id, p.valor_bruto, p.valor_liquido
HAVING p.valor_liquido <> p.valor_bruto - COALESCE(SUM(r.valor), 0);
