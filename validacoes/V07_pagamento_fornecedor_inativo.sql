-- V07 - Pagamento para fornecedor inativo
-- Regra: não devem ser realizados pagamentos para fornecedores inativos.
-- Resultado esperado: nenhuma linha. Cada linha retornada é um defeito.

SELECT
    p.id            AS pedido_id,
    f.id            AS fornecedor_id,
    f.razao_social,
    p.valor_liquido,
    p.data_pagamento
FROM pedidos_pagamento p
INNER JOIN fornecedores f ON f.id = p.fornecedor_id
WHERE p.status = 'PAGO'
  AND f.ativo = 0;
