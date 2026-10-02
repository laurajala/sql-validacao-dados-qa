-- V06 - Pedido com status PAGO sem data de pagamento
-- Regra: todo pedido com status PAGO deve ter a data de pagamento preenchida.
-- Resultado esperado: nenhuma linha. Cada linha retornada é um defeito.

SELECT
    p.id  AS pedido_id,
    p.descricao,
    p.status,
    p.data_pagamento
FROM pedidos_pagamento p
WHERE p.status = 'PAGO'
  AND p.data_pagamento IS NULL;
