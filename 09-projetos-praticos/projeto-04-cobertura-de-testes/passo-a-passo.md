# Passo a Passo — Cobertura de Testes com IA

---

## Passo 1 — Entender o que os testes existentes cobrem

```bash
npm test -- --coverage --coverageReporters=text
```

Saída esperada com os 2 testes existentes:

```
File                  | % Stmts | % Branch | % Funcs | % Lines
----------------------|---------|----------|---------|--------
paymentService.ts     |   28.57 |    18.75 |   33.33 |   28.57
```

---

## Passo 2 — Mapear os gaps com Copilot Chat

```
/explain #file:src/paymentService.ts

Agora analise #file:tests/paymentService.test.ts e liste os cenários
que NÃO estão cobertos, organizados por método:

processPayment():
- [ ] cartão de crédito aprovado
- [ ] cartão de crédito com parcelas válidas
- [ ] cartão > 12 parcelas
- [ ] parcela abaixo de R$10
- [ ] boleto abaixo de R$5
- [ ] pagamento rejeitado (múltiplo de 7)
- [ ] valor negativo

refund():
- [ ] estorno aprovado com sucesso
- [ ] estorno de pagamento não aprovado
- [ ] estorno de boleto

calculateInstallmentDetails():
- [ ] cálculo correto com 3 parcelas
- [ ] cálculo com parcelas > 12
```

---

## Passo 3 — Gerar testes com Claude Code

**Instrução:**
```
Estou aumentando a cobertura de tests/paymentService.test.ts.
Analise #file:src/paymentService.ts.

Gere testes Jest para os seguintes cenários ainda não cobertos:

1. processPayment com credit_card — 1 parcela (deve ser aprovado)
2. processPayment com credit_card — 3 parcelas (deve ser aprovado, valor/parcela correto)
3. processPayment com credit_card — 13 parcelas (deve lançar erro)
4. processPayment com credit_card — parcela abaixo de R$10 (deve lançar erro)
5. processPayment com boleto — R$3 (deve lançar erro)
6. processPayment com valor múltiplo de 7 (deve retornar status 'rejected')
7. processPayment com valor negativo (deve lançar erro)
8. refund de pagamento aprovado via pix (deve retornar status 'refunded')
9. refund de pagamento com status 'pending' (deve lançar erro)
10. refund de pagamento via boleto aprovado (deve lançar erro específico de boleto)
11. calculateInstallmentDetails com 3 parcelas de R$100 (valores exatos)
12. calculateInstallmentDetails com 0 parcelas (deve lançar erro)

Para cada teste:
- Use describe aninhado por método
- Nomeie com: "should [comportamento] when [condição]"
- Inclua asserções sobre o valor exato, não apenas que não lança erro
```

---

## Passo 4 — Revisar a qualidade dos testes gerados

Antes de aceitar, analise cada teste gerado:

### ✅ Teste de qualidade

```typescript
it('should apply 5% PIX discount on final amount', () => {
  const result = service.processPayment({
    amount: 200,
    method: 'pix',
    customerId: 'user-1',
  });
  // Asserção específica no valor calculado
  expect(result.amount).toBe(190); // 200 * 0.95
  expect(result.method).toBe('pix');
  expect(result.status).toBe('approved');
});
```

### ❌ Teste fraco — não detecta regressão

```typescript
it('should process credit card', () => {
  const result = service.processPayment({
    amount: 100,
    method: 'credit_card',
    customerId: 'user-1',
  });
  // Asserção trivial — não testa cálculo nem regras de negócio
  expect(result).toBeDefined();
});
```

---

## Passo 5 — Testar o caso do gateway

O método `simulateGateway` rejeita valores múltiplos de 7. Isso é um comportamento determinístico que deve ser explicitamente testado:

```typescript
it('should return rejected status when amount is multiple of 7', () => {
  // 49 é múltiplo de 7, logo será rejeitado
  // PIX desconta 5%: 49 * 0.95 = 46.55 — não é múltiplo de 7
  // Use um valor que após o desconto PIX ainda seja múltiplo de 7
  // OU teste com método boleto: 35 é múltiplo de 7 e >= 5
  const result = service.processPayment({
    amount: 35,
    method: 'boleto',
    customerId: 'user-1',
  });
  expect(result.status).toBe('rejected');
});
```

---

## Passo 6 — Validação final

```bash
npm test -- --coverage --coverageReporters=text
```

Resultado esperado após todos os testes:

```
File                  | % Stmts | % Branch | % Funcs | % Lines
----------------------|---------|----------|---------|--------
paymentService.ts     |   92.86 |    87.50 |  100.00 |   92.86
```

---

## Lição Principal

> Cobertura de código é uma métrica de risco, não de qualidade. Um teste que executa uma linha sem asserção significativa aumenta a cobertura mas não protege o código.

**A IA é eficiente para gerar o volume de testes, mas você é responsável por garantir que cada teste falha quando o comportamento é violado.**

Teste rápido para validar isso: mude a constante `PIX_DISCOUNT_RATE` de `0.05` para `0.10` e verifique se os testes falham. Se não falharem, os testes de desconto Pix são fracos.
