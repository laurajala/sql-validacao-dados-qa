-- V01 - Pedido pago sem conciliação bancária
-- Regra: todo pedido com status PAGO deve estar conciliado com um
--        lançamento do extrato bancário.
-- Resultado esperado: nenhuma linha. Cada linha retornada é um defeito.

SELECT
    p.id            AS pedido_id,
    p.descricao,
    p.valor_liquido,
    p.data_pagamento
FROM pedidos_pagamento p
LEFT JOIN conciliacoes c ON c.pedido_id = p.id
WHERE p.status = 'PAGO'
  AND c.id IS NULL;
