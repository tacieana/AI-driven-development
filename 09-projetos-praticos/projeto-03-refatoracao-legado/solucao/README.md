# Solução de Referência — Refatoração de Código Legado

---

## Estrutura Final

```
src/
├── types.ts                      # Interfaces e tipos
├── calculators/
│   ├── subtotal.ts               # calculateSubtotal()
│   ├── discount.ts               # calculateDiscount()
│   └── shipping.ts               # calculateShipping()
└── orderProcessor.ts             # processOrder() e processBatch()

tests/
├── characterization/
│   └── orderProcessor.test.js    # Testes do comportamento original (JS puro)
└── unit/
    ├── subtotal.test.ts
    ├── discount.test.ts
    └── shipping.test.ts
```

---

## Exemplos de Testes de Caracterização Corretos

```javascript
// tests/characterization/orderProcessor.test.js
const { proc } = require('../../src/orderProcessor'); // módulo original

describe('proc — testes de caracterização', () => {
  it('pedido simples sem desconto', () => {
    const result = proc({
      items: [{ price: 100, qty: 2 }],
      shippingMethod: 'standard'
    });
    expect(result).toEqual({
      subtotal: 200,
      discount: 0,
      tax: 20,
      shipping: 10,
      total: 230,
      items_count: 1
    });
  });

  it('cliente VIP recebe 20% de desconto', () => {
    const result = proc({
      items: [{ price: 100, qty: 1 }],
      customer: { type: 'VIP' },
      shippingMethod: 'standard'
    });
    expect(result.discount).toBe(20);
    expect(result.total).toBe(100 - 20 + 8 + 10); // 98
  });

  it('cap de 35% é aplicado quando descontos combinados excedem', () => {
    // VIP (20%) + SAVE20 (20%) = 40% > cap de 35%
    const result = proc({
      items: [{ price: 100, qty: 1 }],
      customer: { type: 'VIP' },
      coupon: 'SAVE20',
    });
    expect(result.discount).toBe(35); // cap aplicado
  });
});
```

---

## Exemplo de Função Refatorada

```typescript
// src/calculators/discount.ts

const CUSTOMER_DISCOUNTS: Record<string, number> = {
  VIP: 0.20,
  GOLD: 0.15,
  BASIC: 0.05,
};

const MAX_DISCOUNT_RATE = 0.35;

interface DiscountResult {
  discount: number;
  freeShipping: boolean;
}

export function calculateDiscount(
  subtotal: number,
  customer?: { type: string },
  coupon?: string
): DiscountResult {
  let discountRate = 0;
  let freeShipping = false;

  if (customer?.type) {
    const rate = CUSTOMER_DISCOUNTS[customer.type.toUpperCase()];
    if (rate) discountRate += rate;
  }

  if (coupon === 'SAVE10') discountRate += 0.10;
  else if (coupon === 'SAVE20') discountRate += 0.20;
  else if (coupon === 'FREESHIP') freeShipping = true;

  const cappedRate = Math.min(discountRate, MAX_DISCOUNT_RATE);
  const discount = parseFloat((subtotal * cappedRate).toFixed(2));

  return { discount, freeShipping };
}
```

---

## O que torna esta refatoração bem-sucedida

- ✅ Testes de caracterização escritos antes de qualquer mudança de código
- ✅ Refatoração incremental — um passo de cada vez, testando entre cada passo
- ✅ Funções puras sem efeitos colaterais (sem `o._freeship = true`)
- ✅ Nomes descritivos que eliminam a necessidade de comentários
- ✅ Constantes nomeadas (`MAX_DISCOUNT_RATE`) em vez de magic numbers (`0.35`)
- ✅ Comportamento idêntico ao original verificado pelos testes de caracterização
