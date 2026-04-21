# Passo a Passo — Refatoração de Código Legado

---

## Passo 1 — Entender o código com Copilot Chat

**Não modifique o código ainda.** Use o Copilot Chat para mapear o comportamento:

```
/explain #file:src/orderProcessor.js

Liste todas as regras de negócio implementadas na função proc():
- Como o subtotal é calculado?
- Quais tipos de cliente existem e quais descontos recebem?
- Quais cupons são aceitos e qual o efeito de cada um?
- Qual é o desconto máximo permitido?
- Como o frete é calculado e em que casos é gratuito ou reduzido?
```

Documente as respostas em `docs/regras-de-negocio.md` — esse é o "contrato" que a refatoração deve preservar.

---

## Passo 2 — Escrever testes de caracterização

Os testes de caracterização documentam o comportamento **atual** — mesmo que ele seja "errado" do ponto de vista do negócio. Eles travam o comportamento existente.

**Instrução para o Claude Code:**
```
Analise src/orderProcessor.js e escreva testes de caracterização em
tests/characterization/orderProcessor.test.js usando Jest.

Cubra todos os cenários:
1. Pedido simples (sem desconto, sem cupom, frete standard)
2. Cliente VIP com desconto de 20%
3. Cliente GOLD com desconto de 15%
4. Cupom SAVE10 combinado com desconto de cliente
5. Cupom SAVE20 combinado com desconto de cliente
6. Cupom FREESHIP — frete zero
7. Desconto máximo de 35% (quando a combinação excede)
8. Pedido > R$200 — frete com 50% de desconto
9. Item com qty <= 0 — deve ser ignorado
10. Item com price <= 0 — deve ser ignorado
11. batchProc com pedidos mistos (sucesso e erro)
12. batchProc com pedido sem items

Use valores concretos que você calculou manualmente para cada caso.
```

Rode os testes e confirme que todos passam **antes de qualquer refatoração**.

---

## Passo 3 — Planejar a refatoração

**Instrução para o Claude Code:**
```
Analise src/orderProcessor.js e docs/regras-de-negocio.md.
Crie um plano de refatoração para TypeScript que:
1. Lista os arquivos a criar e suas responsabilidades
2. Propõe os tipos/interfaces necessários
3. Identifica as funções puras que emergem das responsabilidades separadas
4. Define a ordem de implementação (o que fazer primeiro)

NÃO implemente ainda — apenas o plano.
```

---

## Passo 4 — Refatorar incrementalmente

Refatore em pequenos passos, rodando os testes após cada um.

### 4a — Criar tipos e interfaces

```
Crie src/types.ts com as interfaces Order, OrderItem, Customer,
OrderSummary e BatchResult conforme o plano aprovado.
```

### 4b — Extrair cálculo de subtotal

```
Crie src/calculators/subtotal.ts com a função:
calculateSubtotal(items: OrderItem[]): { subtotal: number; validItemCount: number }

A função deve:
- Ignorar itens com qty <= 0 ou price <= 0 (sem console.log)
- Retornar subtotal e count dos itens válidos

Atualize os testes de caracterização para importar do novo local se necessário.
Rode os testes — todos devem passar.
```

### 4c — Extrair cálculo de desconto

```
Crie src/calculators/discount.ts com:
calculateDiscount(subtotal: number, customer?: Customer, coupon?: string):
  { discount: number; freeShipping: boolean }

Implemente as regras de desconto de cliente, cupom e cap de 35%.
Rode os testes.
```

### 4d — Extrair cálculo de frete

```
Crie src/calculators/shipping.ts com:
calculateShipping(subtotalAfterDiscount: number, method: ShippingMethod, freeShipping: boolean): number

Implemente as regras de frete por método, gratuidade e desconto de 50%.
Rode os testes.
```

### 4e — Compor a função principal

```
Crie src/orderProcessor.ts com processOrder() e processBatch()
que compõem as funções de calculators/.

Exporte os tipos de src/types.ts.
Rode os testes de caracterização apontando para o novo módulo.
Todos devem passar.
```

---

## Passo 5 — Adicionar testes de unidade das funções extraídas

```
Agora que as responsabilidades estão separadas, adicione testes unitários
para cada função em tests/unit/:
- subtotal.test.ts
- discount.test.ts
- shipping.test.ts

Esses testes são mais granulares que os de caracterização e facilitam
o diagnóstico quando algo quebra no futuro.
```

---

## Passo 6 — Verificação final

```bash
npm test -- --coverage
# Deve mostrar ≥ 90% de cobertura

npm run type-check
# Zero erros TypeScript

npm run lint
```

Confirme que o comportamento é idêntico ao original comparando os outputs do `proc` antigo e do `processOrder` novo com os mesmos inputs.

---

## Reflexão: O que mudou com IA no fluxo de refatoração?

- **Antes da IA:** Entender código legado levava horas de leitura manual
- **Com Copilot Chat:** `/explain` mapeia as regras em minutos
- **Com Claude Code:** O plano de refatoração e a extração de funções são muito mais rápidos
- **O que a IA não substitui:** O julgamento de quais testes de caracterização são suficientes e a revisão de que a refatoração preserva o comportamento correto
