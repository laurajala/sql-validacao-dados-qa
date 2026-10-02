-- V05 - Pagamento anterior à aprovação
-- Regra: a data de pagamento não pode ser anterior à data de aprovação
--        do pedido.
-- Resultado esperado: nenhuma linha. Cada linha retornada é um defeito.

SELECT
    p.id  AS pedido_id,
    p.descricao,
    p.data_aprovacao,
    p.data_pagamento
FROM pedidos_pagamento p
WHERE p.data_pagamento < p.data_aprovacao;
