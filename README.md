# Validação de Dados com SQL aplicada a QA

[![SQL Validations](https://github.com/laurajala/sql-validacao-dados-qa/actions/workflows/pipeline.yml/badge.svg)](https://github.com/laurajala/sql-validacao-dados-qa/actions/workflows/pipeline.yml)

Projeto que demonstra o uso de **SQL como ferramenta de Quality Assurance**: consultas baseadas em regras de negócio para identificar inconsistências em uma base de homologação de um **sistema fictício de pagamentos e conciliação bancária**, executadas automaticamente em pipeline com **SQL Server** e **GitHub Actions**.

> Todos os dados são fictícios e foram criados exclusivamente para este projeto.

---

## Contexto

Em sistemas financeiros, muitos defeitos não aparecem na interface: estão nos dados. Um pedido pode estar marcado como pago sem ter saído do banco, um valor líquido pode ter sido calculado errado ou um pagamento pode ter sido feito em duplicidade.

Neste projeto, a base de homologação contém **inconsistências intencionais**, e cada consulta de validação verifica uma regra de negócio. **Resultado esperado de cada validação: nenhuma linha.** Cada linha retornada representa um defeito.

---

## Modelo de dados

```text
fornecedores ──< pedidos_pagamento ──< retencoes
                        │
                        └──< conciliacoes >── lancamentos_bancarios
```

| Tabela | Descrição |
| --- | --- |
| `fornecedores` | Fornecedores que recebem os pagamentos |
| `pedidos_pagamento` | Pedidos com valor bruto, valor líquido, status e datas do fluxo |
| `retencoes` | Tributos retidos em cada pedido (IRRF, INSS, ISSQN) |
| `lancamentos_bancarios` | Lançamentos do extrato bancário |
| `conciliacoes` | Vínculo entre o pedido pago e o lançamento do extrato |

---

## Validações

| ID | Regra de negócio | Técnica SQL |
| --- | --- | --- |
| V01 | Todo pedido pago deve estar conciliado | `LEFT JOIN` + `IS NULL` |
| V02 | Valor conciliado deve ser igual ao do extrato | `INNER JOIN` entre 3 tabelas + `ABS()` |
| V03 | Não pode haver pagamento em duplicidade | `GROUP BY` + `HAVING COUNT(*) > 1` |
| V04 | Valor líquido = bruto − retenções | `LEFT JOIN` + `SUM` + `COALESCE` |
| V05 | Pagamento não pode ser anterior à aprovação | Comparação de datas |
| V06 | Status PAGO exige data de pagamento | `IS NULL` |
| V07 | Não pagar fornecedores inativos | `JOIN` com filtro em tabela relacionada |

Os defeitos encontrados estão documentados no [Relatório de Defeitos](docs/relatorio_de_defeitos.md), com resultado esperado, resultado obtido, impacto e severidade.

---

## Integração contínua

A cada alteração, a pipeline do GitHub Actions:

```text
Sobe um SQL Server 2022 em container
      ↓
Cria a estrutura do banco
      ↓
Carrega a massa de dados de homologação
      ↓
Executa as 7 validações
      ↓
Publica o relatório no resumo da execução
```

O resultado de cada validação fica disponível no **Summary** da execução, na aba [Actions](https://github.com/laurajala/sql-validacao-dados-qa/actions), como evidência.

A pipeline é aprovada quando todos os scripts executam sem erro. Os defeitos encontrados são esperados, pois fazem parte da massa de homologação, e são apresentados no relatório da execução.

---

## Estrutura do projeto

```text
sql-validacao-dados-qa/
├── .github/workflows/pipeline.yml
├── database/
│   ├── 01_schema.sql
│   └── 02_massa_de_dados.sql
├── validacoes/
│   ├── V01_pedido_pago_sem_conciliacao.sql
│   ├── V02_conciliacao_valor_divergente.sql
│   ├── V03_pagamento_em_duplicidade.sql
│   ├── V04_valor_liquido_incorreto.sql
│   ├── V05_pagamento_antes_da_aprovacao.sql
│   ├── V06_status_pago_sem_data.sql
│   └── V07_pagamento_fornecedor_inativo.sql
├── docs/
│   └── relatorio_de_defeitos.md
└── README.md
```

---

## Como executar localmente

1. Tenha acesso a uma instância do **SQL Server** (por exemplo, SQL Server Developer/Express ou um container Docker).
2. Em uma ferramenta como o **SQL Server Management Studio (SSMS)** ou o **VS Code com a extensão MSSQL**, execute na ordem:
   - `database/01_schema.sql`
   - `database/02_massa_de_dados.sql`
3. Execute as consultas da pasta `validacoes/` no banco `PagamentosQA` e analise os registros retornados.

---

## Tecnologias

- **SQL Server 2022** (T-SQL)
- **GitHub Actions** com SQL Server em container
- **Git e GitHub**

---

## Autora

**Laura Ajala** — Quality Engineer

[LinkedIn](https://www.linkedin.com/in/laura-ajala/) · [GitHub](https://github.com/laurajala)
