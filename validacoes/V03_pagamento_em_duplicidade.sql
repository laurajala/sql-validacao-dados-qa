-- V03 - Pagamento em duplicidade
-- Regra: não deve haver mais de um pedido pago para o mesmo fornecedor,
--        com o mesmo valor bruto e na mesma data de pagamento.
-- Resultado esperado: nenhuma linha. Cada linha retornada é um defeito.

SELECT
    p.fornecedor_id,
    f.razao_social,
    p.valor_bruto,
    p.data_pagamento,
    COUNT(*)  AS quantidade_pedidos
FROM pedidos_pagamento p
INNER JOIN fornecedores f ON f.id = p.fornecedor_id
WHERE p.status = 'PAGO'
GROUP BY p.fornecedor_id, f.razao_social, p.valor_bruto, p.data_pagamento
HAVING COUNT(*) > 1;
