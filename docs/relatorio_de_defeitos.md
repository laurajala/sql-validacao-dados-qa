# Relatório de Defeitos — Base de Homologação

Defeitos identificados pelas consultas de validação na massa de dados do sistema fictício de pagamentos.

**Ambiente:** Homologação (base fictícia) · **Banco:** SQL Server 2022 · **Execução:** pipeline do GitHub Actions

## Resumo

| ID | Validação | Registro afetado | Severidade |
| --- | --- | --- | --- |
| DEF-01 | V01 — Pedido pago sem conciliação | Pedido 1004 | Alta |
| DEF-02 | V02 — Conciliação com valor divergente | Conciliação 9005 / Pedido 1006 | Alta |
| DEF-03 | V03 — Pagamento em duplicidade | Pedidos 1007 e 1008 | Crítica |
| DEF-04 | V04 — Valor líquido incorreto | Pedido 1009 | Alta |
| DEF-05 | V05 — Pagamento anterior à aprovação | Pedido 1010 | Alta |
| DEF-06 | V06 — Status PAGO sem data de pagamento | Pedido 1011 | Média |
| DEF-07 | V07 — Pagamento para fornecedor inativo | Pedido 1012 | Alta |

---

## DEF-01 — Pedido pago sem conciliação bancária

- **Regra:** todo pedido com status PAGO deve estar conciliado com um lançamento do extrato.
- **Resultado esperado:** pedido pago com conciliação registrada.
- **Resultado obtido:** o pedido **1004** (Manutenção do ar-condicionado, R$ 2.955,00) está com status PAGO e data de pagamento 06/02/2026, mas não possui conciliação.
- **Impacto:** o sistema indica um pagamento que não pode ser confirmado no extrato bancário.
- **Evidência:** `validacoes/V01_pedido_pago_sem_conciliacao.sql`

## DEF-02 — Conciliação com valor divergente do extrato

- **Regra:** o valor conciliado deve ser igual ao valor debitado no extrato.
- **Resultado esperado:** valor conciliado igual ao valor do extrato.
- **Resultado obtido:** a conciliação **9005** registra R$ 2.000,00 para o pedido **1006**, mas o lançamento no extrato é de R$ 2.100,00.
- **Impacto:** diferença de R$ 100,00 conciliada indevidamente, mascarando uma divergência financeira.
- **Evidência:** `validacoes/V02_conciliacao_valor_divergente.sql`

## DEF-03 — Pagamento em duplicidade

- **Regra:** não deve haver mais de um pagamento para o mesmo fornecedor, com o mesmo valor e na mesma data.
- **Resultado esperado:** um único pagamento.
- **Resultado obtido:** os pedidos **1007** e **1008** (Beta Consultoria em TI, R$ 4.000,00 cada) foram pagos em 20/02/2026, com dois débitos no extrato.
- **Impacto:** saída de recursos em duplicidade (R$ 3.940,00 líquidos pagos a mais).
- **Evidência:** `validacoes/V03_pagamento_em_duplicidade.sql`

## DEF-04 — Valor líquido incorreto

- **Regra:** valor líquido = valor bruto − soma das retenções.
- **Resultado esperado:** R$ 10.000,00 − R$ 650,00 (IRRF R$ 150,00 + ISSQN R$ 500,00) = **R$ 9.350,00**.
- **Resultado obtido:** o pedido **1009** registra valor líquido de **R$ 9.500,00**.
- **Impacto:** pagamento de R$ 150,00 a mais ao fornecedor e divergência no recolhimento dos tributos.
- **Evidência:** `validacoes/V04_valor_liquido_incorreto.sql`

## DEF-05 — Pagamento anterior à aprovação

- **Regra:** a data de pagamento não pode ser anterior à data de aprovação.
- **Resultado esperado:** pagamento em data igual ou posterior à aprovação.
- **Resultado obtido:** o pedido **1010** foi aprovado em 12/03/2026 e pago em 10/03/2026.
- **Impacto:** indica falha no fluxo de aprovação, permitindo pagamento sem autorização prévia.
- **Evidência:** `validacoes/V05_pagamento_antes_da_aprovacao.sql`

## DEF-06 — Status PAGO sem data de pagamento

- **Regra:** pedidos com status PAGO devem ter a data de pagamento preenchida.
- **Resultado esperado:** data de pagamento informada.
- **Resultado obtido:** o pedido **1011** está com status PAGO e data de pagamento nula, embora possua conciliação.
- **Impacto:** inconsistência cadastral que afeta relatórios e consultas por período.
- **Evidência:** `validacoes/V06_status_pago_sem_data.sql`

## DEF-07 — Pagamento para fornecedor inativo

- **Regra:** não devem ser realizados pagamentos para fornecedores inativos.
- **Resultado esperado:** nenhum pagamento para fornecedores inativos.
- **Resultado obtido:** o pedido **1012** (R$ 2.500,00) foi pago à **Sigma Transportes**, fornecedor marcado como inativo.
- **Impacto:** falha de controle no cadastro de fornecedores, com risco de pagamento indevido.
- **Evidência:** `validacoes/V07_pagamento_fornecedor_inativo.sql`
