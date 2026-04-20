# Exemplos: Prompts de Debugging

> Prompts prontos para investigação e correção de bugs. O elemento mais crítico é sempre fornecer evidências concretas.

---

## 01 — Bug com Stack Trace

**Situação:** Você tem um erro com stack trace e precisa da causa raiz.

```markdown
Ajude a identificar a causa raiz deste erro.

**Stack trace:**
```
[cole o stack trace completo]
```

**Código relevante:**
```python
[cole o código das linhas citadas no stack trace + contexto ao redor]
```

**Input que reproduz o bug:**
```
[descreva ou cole o input que causa o erro]
```

**Comportamento esperado:** [o que deveria acontecer]

**O que já investiguei:** [suas hipóteses e o que você já descartou]

**Instrução:**
1. Trace a execução com o input problemático, passo a passo
2. Identifique a linha exata onde o comportamento diverge
3. Explique por que aquela linha se comporta assim
4. Proponha a correção mínima necessária — não refatore além do necessário
```

---

## 02 — Bug Intermitente (Race Condition / Timing)

**Situação:** O bug só ocorre às vezes, sob carga ou em condições específicas.

```markdown
Temos um bug intermitente. Ocorre aproximadamente [X% das vezes / sob alta carga / em horários específicos].

**Código suspeito:**
```python
[cole o código]
```

**Contexto de execução:**
- Ambiente: [ex: 4 workers Gunicorn, PostgreSQL com pool de 10 conexões]
- Ocorre mais quando: [padrão observado — ex: "quando múltiplos usuários fazem login simultaneamente"]
- Logs quando ocorre:
```
[cole logs relevantes]
```

**Hipótese atual:** [o que você acha que pode ser]

**Instrução:**
1. Identifique se há shared state mutável acessado concorrentemente
2. Trace dois fluxos de execução paralelos para encontrar a janela de race condition
3. Proponha a correção — pode ser lock, operação atômica, ou redesign de fluxo
4. Explique por que a correção elimina o problema
```

---

## 03 — Bug de Performance (Lentidão)

**Situação:** Uma operação que deveria ser rápida está lenta.

```markdown
Esta operação está demorando [tempo atual] para [N registros]. O esperado é [tempo alvo].

**Código:**
```python
[cole o código lento]
```

**Contexto de dados:**
- Volume atual: [ex: 50.000 registros na tabela users]
- Índices existentes: [ex: índice em email, criado_at]
- Query plan (se banco de dados):
```sql
-- EXPLAIN ANALYZE output
[cole o output]
```

**Instrução:**
1. Identifique o bottleneck — onde o tempo está sendo gasto?
2. Para cada problema encontrado, estime o impacto (alto/médio/baixo)
3. Proponha otimizações em ordem de impacto × facilidade de implementação
4. Para cada otimização, explique o ganho esperado e o tradeoff

**Restrição:** Não altere a interface da função. A mudança deve ser de implementação apenas.
```

---

## 04 — Bug Lógico (Output Incorreto sem Erro)

**Situação:** O código roda sem erros mas produz resultado errado.

```markdown
Este código roda sem erros mas produz output incorreto.

**Código:**
```python
[cole o código]
```

**Caso que demonstra o bug:**
- Input: `[valor de input]`
- Output atual: `[o que retorna]`
- Output esperado: `[o que deveria retornar]`

**Outros casos testados:**
| Input | Output atual | Output esperado | Correto? |
|-------|-------------|-----------------|----------|
| [ex1] | [saída]     | [esperado]      | ✅/❌    |
| [ex2] | [saída]     | [esperado]      | ✅/❌    |

**Instrução:**
1. Trace a execução do código com o input problemático, linha por linha
2. Identifique onde o valor diverge do esperado pela primeira vez
3. Explique a lógica incorreta
4. Proponha a correção e verifique mentalmente com os outros casos da tabela
```

---

## 05 — Debugging de Query SQL

**Situação:** Uma query SQL retorna resultados incorretos ou inesperados.

```markdown
Esta query está retornando resultados incorretos.

**Query:**
```sql
[cole a query]
```

**Schema das tabelas relevantes:**
```sql
[cole os CREATEs ou a descrição das tabelas]
```

**Dados de exemplo:**
```sql
-- Tabela A:
[dados de exemplo]

-- Tabela B:
[dados de exemplo]
```

**Resultado atual:**
```
[o que a query retorna]
```

**Resultado esperado:**
```
[o que deveria retornar]
```

**Instrução:**
1. Analise a query passo a passo — break down de cada JOIN e WHERE
2. Identifique onde a lógica diverge do esperado
3. Proponha a query corrigida
4. Explique a diferença entre a query original e a corrigida
```

---

## 06 — Investigação de Comportamento Inesperado em Produção

**Situação:** Você tem logs de produção e precisa reconstruir o que aconteceu.

```markdown
Algo inesperado aconteceu em produção. Preciso entender o que ocorreu.

**Logs do período:**
```
[cole os logs relevantes em ordem cronológica]
```

**O que era esperado acontecer:** [descrição do fluxo normal]

**O que realmente aconteceu:** [sintoma observado pelo usuário ou sistema]

**Código do fluxo afetado:**
```python
[cole o código do fluxo suspeito]
```

**Instrução:**
1. Analise os logs e reconstitua a sequência de eventos
2. Identifique o evento que iniciou o comportamento inesperado
3. Trace como aquele evento se propagou até o sintoma observado
4. Identifique o ponto de falha e sugira:
   a) A correção imediata (hotfix)
   b) A melhoria de longo prazo para prevenir recorrência
```

---

## Notas de Uso

### Princípios para bom debugging com IA

- **Cole sempre o código, não descreva** — "tenho uma função que faz X" é insuficiente.
- **Inclua evidências** — stack trace, logs, casos de teste que reproduzem.
- **Descreva o que já testou** — evita que a IA sugira o que você já descartou.
- **Peça raciocínio antes da solução** — "trace a execução antes de propor a correção".
- **Exija o mínimo de mudança** — bugfixes devem mudar o mínimo possível para reduzir o risco de regressão.

### Red flags no output de debugging

- IA propõe refatoração grande onde você pediu uma correção de bug → rejeite, peça mínimo.
- IA diz "pode ser X ou Y" sem determinar qual → peça que trace a execução para determinar.
- IA sugere testar algo você já testou → forneça mais evidências do que já descartou.
