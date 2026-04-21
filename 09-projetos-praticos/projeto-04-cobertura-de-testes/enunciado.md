# Enunciado — Cobertura de Testes com IA

## O Módulo

Salve os arquivos abaixo. Eles representam um serviço de pagamentos com testes insuficientes.

### `src/paymentService.ts`

```typescript
export type PaymentMethod = 'credit_card' | 'pix' | 'boleto';
export type PaymentStatus = 'pending' | 'approved' | 'rejected' | 'refunded';

export interface Payment {
  id: string;
  amount: number;
  method: PaymentMethod;
  status: PaymentStatus;
  installments?: number;
  createdAt: Date;
}

export interface ProcessPaymentInput {
  amount: number;
  method: PaymentMethod;
  installments?: number;
  customerId: string;
}

export class PaymentService {
  private readonly MAX_INSTALLMENTS = 12;
  private readonly MIN_INSTALLMENT_AMOUNT = 10;
  private readonly PIX_DISCOUNT_RATE = 0.05;

  processPayment(input: ProcessPaymentInput): Payment {
    this.validateInput(input);

    const amount = this.calculateFinalAmount(input);
    const payment: Payment = {
      id: crypto.randomUUID(),
      amount,
      method: input.method,
      status: 'pending',
      installments: input.installments,
      createdAt: new Date(),
    };

    return this.simulateGateway(payment);
  }

  private validateInput(input: ProcessPaymentInput): void {
    if (input.amount <= 0) {
      throw new Error('Valor deve ser maior que zero');
    }
    if (input.method === 'credit_card') {
      const installments = input.installments ?? 1;
      if (installments < 1 || installments > this.MAX_INSTALLMENTS) {
        throw new Error(`Parcelas devem ser entre 1 e ${this.MAX_INSTALLMENTS}`);
      }
      const installmentAmount = input.amount / installments;
      if (installmentAmount < this.MIN_INSTALLMENT_AMOUNT) {
        throw new Error(`Valor mínimo por parcela é R$ ${this.MIN_INSTALLMENT_AMOUNT}`);
      }
    }
    if (input.method === 'boleto' && input.amount < 5) {
      throw new Error('Valor mínimo para boleto é R$ 5,00');
    }
  }

  private calculateFinalAmount(input: ProcessPaymentInput): number {
    if (input.method === 'pix') {
      return parseFloat((input.amount * (1 - this.PIX_DISCOUNT_RATE)).toFixed(2));
    }
    return input.amount;
  }

  private simulateGateway(payment: Payment): Payment {
    // Simula gateway: valores múltiplos de 7 são rejeitados (para testes)
    if (payment.amount % 7 === 0) {
      return { ...payment, status: 'rejected' };
    }
    return { ...payment, status: 'approved' };
  }

  refund(payment: Payment): Payment {
    if (payment.status !== 'approved') {
      throw new Error('Apenas pagamentos aprovados podem ser estornados');
    }
    if (payment.method === 'boleto') {
      throw new Error('Estorno de boleto deve ser processado manualmente');
    }
    return { ...payment, status: 'refunded' };
  }

  calculateInstallmentDetails(amount: number, installments: number) {
    if (installments < 1 || installments > this.MAX_INSTALLMENTS) {
      throw new Error('Número de parcelas inválido');
    }
    const installmentAmount = parseFloat((amount / installments).toFixed(2));
    const total = parseFloat((installmentAmount * installments).toFixed(2));
    const difference = parseFloat((total - amount).toFixed(2));
    return { installmentAmount, total, difference, installments };
  }
}
```

### `tests/paymentService.test.ts` (testes existentes — apenas 28% de cobertura)

```typescript
import { PaymentService } from '../src/paymentService';

describe('PaymentService', () => {
  const service = new PaymentService();

  it('should process a pix payment', () => {
    const result = service.processPayment({
      amount: 100,
      method: 'pix',
      customerId: 'user-1',
    });
    expect(result.status).toBe('approved');
    expect(result.amount).toBe(95); // 5% de desconto
  });

  it('should throw when amount is zero', () => {
    expect(() =>
      service.processPayment({ amount: 0, method: 'pix', customerId: 'user-1' })
    ).toThrow('Valor deve ser maior que zero');
  });
});
```

---

## Objetivo

Atingir **80% de cobertura de linhas** em `paymentService.ts` com testes que realmente validam comportamento — não apenas executam linhas.

---

## Critérios de Aceite

- [ ] Cobertura de linhas ≥ 80% em `paymentService.ts`
- [ ] Todos os casos de erro de `validateInput` estão cobertos
- [ ] Desconto Pix está testado com asserção no valor exato
- [ ] Rejeição do gateway (múltiplos de 7) está coberta
- [ ] `refund` está coberto: sucesso, pagamento não aprovado, boleto
- [ ] `calculateInstallmentDetails` está coberto: casos válidos e inválidos
- [ ] Nenhum teste passa trivialmente sem asserção significativa

---

## Passo a Passo

### 1 — Gerar o relatório de cobertura atual

```bash
npm test -- --coverage --coverageReporters=text
```

Anote quais linhas não estão cobertas.

### 2 — Usar IA para identificar os gaps

**No Copilot Chat:**
```
Analise #file:src/paymentService.ts e #file:tests/paymentService.test.ts.

Liste todos os cenários de teste que estão faltando, organizados por método.
Para cada cenário, indique:
- Qual comportamento está sendo validado
- Qual linha do código está descoberta
```

### 3 — Gerar testes com Claude Code ou `@test-expert`

```
Gere os testes faltantes para src/paymentService.ts com base nesta lista de gaps:
[cole a lista gerada no passo anterior]

Use a estrutura Jest com describe/it e Arrange-Act-Assert.
Não gere testes triviais — cada it() deve ter pelo menos uma asserção significativa.
```

### 4 — Revisar criticamente cada teste gerado

Para cada teste gerado, verifique:
- A asserção está testando o comportamento certo ou só executando código?
- O nome do teste descreve claramente o que está sendo testado?
- O teste falharia se o comportamento fosse alterado?

### 5 — Validação final

```bash
npm test -- --coverage
# Linha "All files | statements" deve mostrar ≥ 80%
```
