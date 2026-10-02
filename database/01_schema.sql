-- =====================================================================
-- Projeto: Validação de Dados com SQL aplicada a QA
-- Arquivo: 01_schema.sql
-- Objetivo: criar a estrutura do banco de um sistema FICTÍCIO de
--           pedidos de pagamento e conciliação bancária.
-- =====================================================================

IF DB_ID('PagamentosQA') IS NULL
    CREATE DATABASE PagamentosQA;
GO

USE PagamentosQA;
GO

-- Fornecedores que recebem os pagamentos
CREATE TABLE fornecedores (
    id            INT           NOT NULL PRIMARY KEY,
    razao_social  VARCHAR(150)  NOT NULL,
    cnpj          VARCHAR(14)   NOT NULL,
    ativo         BIT           NOT NULL DEFAULT 1
);

-- Pedidos de pagamento solicitados no sistema
CREATE TABLE pedidos_pagamento (
    id              INT            NOT NULL PRIMARY KEY,
    fornecedor_id   INT            NOT NULL REFERENCES fornecedores(id),
    descricao       VARCHAR(200)   NOT NULL,
    valor_bruto     DECIMAL(12,2)  NOT NULL,
    valor_liquido   DECIMAL(12,2)  NOT NULL,
    status          VARCHAR(20)    NOT NULL
                    CHECK (status IN ('PENDENTE', 'APROVADO', 'PAGO', 'CANCELADO')),
    data_criacao    DATE           NOT NULL,
    data_aprovacao  DATE           NULL,
    data_pagamento  DATE           NULL
);

-- Tributos retidos em cada pedido (IRRF, INSS, ISSQN)
CREATE TABLE retencoes (
    id         INT            NOT NULL PRIMARY KEY,
    pedido_id  INT            NOT NULL REFERENCES pedidos_pagamento(id),
    tributo    VARCHAR(10)    NOT NULL
               CHECK (tributo IN ('IRRF', 'INSS', 'ISSQN')),
    valor      DECIMAL(12,2)  NOT NULL
);

-- Lançamentos do extrato bancário
CREATE TABLE lancamentos_bancarios (
    id               INT            NOT NULL PRIMARY KEY,
    data_lancamento  DATE           NOT NULL,
    valor            DECIMAL(12,2)  NOT NULL,
    historico        VARCHAR(200)   NOT NULL
);

-- Vínculo entre o pedido pago e o lançamento do extrato
CREATE TABLE conciliacoes (
    id                INT            NOT NULL PRIMARY KEY,
    pedido_id         INT            NOT NULL REFERENCES pedidos_pagamento(id),
    lancamento_id     INT            NOT NULL REFERENCES lancamentos_bancarios(id),
    valor_conciliado  DECIMAL(12,2)  NOT NULL,
    data_conciliacao  DATE           NOT NULL
);
GO
