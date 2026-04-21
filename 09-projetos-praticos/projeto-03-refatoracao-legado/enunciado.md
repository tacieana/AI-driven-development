# Enunciado — Refatoração de Código Legado

## Código Legado para Refatorar

Salve o arquivo abaixo como `src/orderProcessor.js` e **não o modifique ainda**:

```javascript
// orderProcessor.js — módulo de processamento de pedidos
// Escrito em 2018, nunca refatorado

var TAX = 0.1;
var DISC = { 'VIP': 0.2, 'GOLD': 0.15, 'BASIC': 0.05 };
var SHIP = { 'express': 25, 'standard': 10, 'pickup': 0 };

function proc(o) {
  var t = 0;
  for (var i = 0; i < o.items.length; i++) {
    var item = o.items[i];
    if (item.qty <= 0) { console.log('bad qty'); continue; }
    if (item.price <= 0) { console.log('bad price'); continue; }
    t = t + (item.price * item.qty);
  }

  var d = 0;
  if (o.customer && o.customer.type) {
    var ct = o.customer.type.toUpperCase();
    if (DISC[ct]) { d = t * DISC[ct]; }
  }
  if (o.coupon) {
    if (o.coupon == 'SAVE10') { d = d + (t * 0.1); }
    else if (o.coupon == 'SAVE20') { d = d + (t * 0.2); }
    else if (o.coupon == 'FREESHIP') { o._freeship = true; }
  }
  if (d > t * 0.35) { d = t * 0.35; } // max 35% desconto

  var tax = (t - d) * TAX;

  var ship = 0;
  if (!o._freeship) {
    var sm = o.shippingMethod || 'standard';
    ship = SHIP[sm] || 10;
    if (t - d > 200) { ship = ship * 0.5; } // frete com 50% off pra pedidos grandes
  }

  var total = (t - d) + tax + ship;

  return {
    subtotal: parseFloat(t.toFixed(2)),
    discount: parseFloat(d.toFixed(2)),
    tax: parseFloat(tax.toFixed(2)),
    shipping: parseFloat(ship.toFixed(2)),
    total: parseFloat(total.toFixed(2)),
    items_count: o.items.filter(function(i) { return i.qty > 0 && i.price > 0; }).length
  };
}

function batchProc(orders) {
  var results = [];
  var errs = 0;
  for (var i = 0; i < orders.length; i++) {
    try {
      if (!orders[i].items || orders[i].items.length == 0) {
        errs++;
        results.push({ error: 'no items', orderId: orders[i].id });
        continue;
      }
      var r = proc(orders[i]);
      r.orderId = orders[i].id;
      results.push(r);
    } catch(e) {
      errs++;
      results.push({ error: e.message, orderId: orders[i].id });
    }
  }
  return { results: results, errors: errs, processed: results.length - errs };
}

module.exports = { proc, batchProc };
```

---

## Problemas no Código Legado

Identifique (com ajuda do Copilot Chat) todos os problemas antes de refatorar:

| Categoria | Problemas |
|-----------|-----------|
| **Nomenclatura** | `proc`, `batchProc`, `t`, `d`, `sm`, `o`, `ct` — nomes crípticos |
| **Responsabilidades** | `proc` faz cálculo de subtotal, desconto, imposto e frete — 4 responsabilidades |
| **Mutação de estado** | `o._freeship = true` — mutação do objeto de entrada |
| **Sem tipos** | JavaScript puro, sem validação de tipos |
| **Sem testes** | Nenhum teste unitário |
| **`console.log`** | Usado para erros em vez de tratamento adequado |
| **Lógica duplicada** | `filter` refeito em `items_count` em vez de reusar |
| **Comentários óbvios** | "frete com 50% off pra pedidos grandes" — deveria ser código legível |

---

## Objetivo da Refatoração

Transforme o código em um módulo TypeScript moderno com:

```typescript
// Resultado esperado da refatoração

interface OrderItem { price: number; quantity: number; }
interface Customer { type: 'VIP' | 'GOLD' | 'BASIC' }
interface Order { id: string; items: OrderItem[]; customer?: Customer; coupon?: string; shippingMethod?: 'express' | 'standard' | 'pickup'; }
interface OrderSummary { subtotal: number; discount: number; tax: number; shipping: number; total: number; itemCount: number; }

function processOrder(order: Order): OrderSummary
function processBatch(orders: Order[]): BatchResult
```

**Regra de ouro:** O comportamento dos testes de caracterização deve continuar passando após a refatoração.

---

## Critérios de Aceite

- [ ] Testes de caracterização escritos **antes** da refatoração — cobrindo todos os cenários do `proc` original
- [ ] Módulo refatorado em TypeScript com tipos explícitos
- [ ] `processOrder` e `processBatch` como funções puras (sem mutação de input)
- [ ] Responsabilidades separadas: cálculo de subtotal, desconto, imposto e frete em funções distintas
- [ ] Nomes descritivos em todos os identificadores
- [ ] Sem `console.log` — erros tratados adequadamente
- [ ] Todos os testes de caracterização passando após a refatoração
- [ ] Cobertura ≥ 90%
