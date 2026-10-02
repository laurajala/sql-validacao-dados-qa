-- =====================================================================
-- Projeto: Validação de Dados com SQL aplicada a QA
-- Arquivo: 02_massa_de_dados.sql
-- Objetivo: popular o banco com dados FICTÍCIOS de um ambiente de
--           homologação. A massa contém inconsistências intencionais,
--           que devem ser encontradas pelas consultas de validação.
-- =====================================================================

USE PagamentosQA;
GO

INSERT INTO fornecedores (id, razao_social, cnpj, ativo) VALUES
(1, 'Alfa Serviços de Limpeza Ltda',      '11222333000181', 1),
(2, 'Beta Consultoria em TI Ltda',        '22333444000172', 1),
(3, 'Gama Eventos e Turismo Ltda',        '33444555000163', 1),
(4, 'Delta Materiais de Escritório Ltda', '44555666000154', 1),
(5, 'Ômega Manutenção Predial Ltda',      '55666777000145', 1),
(6, 'Sigma Transportes Ltda',             '66777888000136', 0);

INSERT INTO pedidos_pagamento
    (id, fornecedor_id, descricao, valor_bruto, valor_liquido, status, data_criacao, data_aprovacao, data_pagamento)
VALUES
(1001, 1, 'Serviço de limpeza - janeiro',     5000.00, 4725.00, 'PAGO',      '2026-01-05', '2026-01-07', '2026-01-10'),
(1002, 2, 'Consultoria em TI - janeiro',      8000.00, 7880.00, 'PAGO',      '2026-01-08', '2026-01-09', '2026-01-15'),
(1003, 4, 'Material de escritório',           1200.00, 1200.00, 'PAGO',      '2026-01-12', '2026-01-13', '2026-01-16'),
(1004, 5, 'Manutenção do ar-condicionado',    3000.00, 2955.00, 'PAGO',      '2026-02-02', '2026-02-03', '2026-02-06'),
(1005, 3, 'Locação de espaço para evento',    6000.00, 6000.00, 'PAGO',      '2026-02-05', '2026-02-06', '2026-02-10'),
(1006, 4, 'Mobiliário para sala de reunião',  2000.00, 2000.00, 'PAGO',      '2026-02-09', '2026-02-10', '2026-02-12'),
(1007, 2, 'Consultoria em TI - fevereiro',    4000.00, 3940.00, 'PAGO',      '2026-02-10', '2026-02-11', '2026-02-20'),
(1008, 2, 'Consultoria em TI - fevereiro',    4000.00, 3940.00, 'PAGO',      '2026-02-12', '2026-02-13', '2026-02-20'),
(1009, 5, 'Reforma da recepção',             10000.00, 9500.00, 'PAGO',      '2026-03-02', '2026-03-04', '2026-03-09'),
(1010, 3, 'Coffee break - seminário',         1500.00, 1500.00, 'PAGO',      '2026-03-05', '2026-03-12', '2026-03-10'),
(1011, 4, 'Toners para impressoras',           900.00,  900.00, 'PAGO',      '2026-03-10', '2026-03-11', NULL),
(1012, 6, 'Frete de mobiliário',              2500.00, 2500.00, 'PAGO',      '2026-03-15', '2026-03-16', '2026-03-18'),
(1013, 1, 'Serviço de limpeza - março',       5000.00, 4725.00, 'PENDENTE',  '2026-03-20', NULL,         NULL),
(1014, 2, 'Consultoria em TI - março',        8000.00, 7880.00, 'APROVADO',  '2026-03-22', '2026-03-24', NULL),
(1015, 3, 'Evento cancelado',                 3000.00, 3000.00, 'CANCELADO', '2026-03-25', NULL,         NULL);

INSERT INTO retencoes (id, pedido_id, tributo, valor) VALUES
(1, 1001, 'IRRF',   75.00),
(2, 1001, 'ISSQN', 200.00),
(3, 1002, 'IRRF',  120.00),
(4, 1004, 'IRRF',   45.00),
(5, 1007, 'IRRF',   60.00),
(6, 1008, 'IRRF',   60.00),
(7, 1009, 'IRRF',  150.00),
(8, 1009, 'ISSQN', 500.00),
(9, 1013, 'IRRF',   75.00),
(10, 1013, 'ISSQN', 200.00),
(11, 1014, 'IRRF', 120.00);

-- Débitos no extrato são registrados com valor negativo
INSERT INTO lancamentos_bancarios (id, data_lancamento, valor, historico) VALUES
(5001, '2026-01-10', -4725.00, 'PAG FORNECEDOR ALFA SERVICOS'),
(5002, '2026-01-15', -7880.00, 'PAG FORNECEDOR BETA CONSULTORIA'),
(5003, '2026-01-16', -1200.00, 'PAG FORNECEDOR DELTA MATERIAIS'),
(5004, '2026-02-10', -6000.00, 'PAG FORNECEDOR GAMA EVENTOS'),
(5005, '2026-02-12', -2100.00, 'PAG FORNECEDOR DELTA MATERIAIS'),
(5006, '2026-02-20', -3940.00, 'PAG FORNECEDOR BETA CONSULTORIA'),
(5007, '2026-02-20', -3940.00, 'PAG FORNECEDOR BETA CONSULTORIA'),
(5008, '2026-03-09', -9500.00, 'PAG FORNECEDOR OMEGA MANUTENCAO'),
(5009, '2026-03-10', -1500.00, 'PAG FORNECEDOR GAMA EVENTOS'),
(5010, '2026-03-11',  -900.00, 'PAG FORNECEDOR DELTA MATERIAIS'),
(5011, '2026-03-18', -2500.00, 'PAG FORNECEDOR SIGMA TRANSPORTES');

INSERT INTO conciliacoes (id, pedido_id, lancamento_id, valor_conciliado, data_conciliacao) VALUES
(9001, 1001, 5001, 4725.00, '2026-01-11'),
(9002, 1002, 5002, 7880.00, '2026-01-16'),
(9003, 1003, 5003, 1200.00, '2026-01-17'),
(9004, 1005, 5004, 6000.00, '2026-02-11'),
(9005, 1006, 5005, 2000.00, '2026-02-13'),
(9006, 1007, 5006, 3940.00, '2026-02-21'),
(9007, 1008, 5007, 3940.00, '2026-02-21'),
(9008, 1009, 5008, 9500.00, '2026-03-10'),
(9009, 1010, 5009, 1500.00, '2026-03-11'),
(9010, 1011, 5010,  900.00, '2026-03-12'),
(9011, 1012, 5011, 2500.00, '2026-03-19');
GO
