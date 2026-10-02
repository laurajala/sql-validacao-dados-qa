-- V02 - Conciliação com valor divergente do extrato
-- Regra: o valor conciliado deve ser igual ao valor debitado no extrato
--        e ao valor líquido do pedido.
-- Resultado esperado: nenhuma linha. Cada linha retornada é um defeito.

SELECT
    c.id               AS conciliacao_id,
    p.id               AS pedido_id,
    p.valor_liquido,
    c.valor_conciliado,
    ABS(l.valor)       AS valor_extrato
FROM conciliacoes c
INNER JOIN pedidos_pagamento p      ON p.id = c.pedido_id
INNER JOIN lancamentos_bancarios l  ON l.id = c.lancamento_id
WHERE c.valor_conciliado <> ABS(l.valor)
   OR c.valor_conciliado <> p.valor_liquido;
