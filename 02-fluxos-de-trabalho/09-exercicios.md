# 📝 Exercícios — Capítulo 02: Fluxos de Trabalho

> Exercícios práticos para consolidar os fluxos de desenvolvimento com IA. Cada exercício simula uma situação real.

---

## Exercício 01 — Mapeando IA no Ciclo do Seu Projeto

**Objetivo:** Identificar onde a IA pode entrar no seu fluxo atual de trabalho.

**Tarefa:** Preencha a tabela com base no seu contexto real:

| Fase | Você usa IA hoje? | Poderia usar mais? | Maior barreira |
|------|:-----------------:|:-----------------:|----------------|
| Refinamento de requisitos | Sim / Não | Sim / Não | |
| Design e arquitetura | Sim / Não | Sim / Não | |
| Implementação | Sim / Não | Sim / Não | |
| Testes | Sim / Não | Sim / Não | |
| Code review | Sim / Não | Sim / Não | |
| Deploy e operações | Sim / Não | Sim / Não | |
| Debugging | Sim / Não | Sim / Não | |

**Reflexão:**
1. Qual fase tem o maior gap entre uso atual e uso potencial?
2. O que está impedindo o uso nessa fase? (ferramenta, conhecimento, política, conforto)
3. Qual seria o ganho mais impactante de adotar IA nessa fase?

---

## Exercício 02 — TDD com IA: Ciclo Completo

**Objetivo:** Praticar o ciclo Red-Green-Refactor completo com IA.

**Cenário:** Implemente a função `calculate_shipping(weight_kg, distance_km, is_express)`:
- Frete padrão: R$ 5,00 base + R$ 0,10/km + R$ 2,00/kg
- Frete expresso: 2x o valor do padrão
- Peso máximo aceito: 30kg — lança `WeightExceededError`
- Distância máxima: 500km — lança `DistanceExceededError`
- Valores negativos lançam `InvalidInputError`

**Tarefas:**

1. **RED:** Escreva você mesmo os 3 primeiros testes (não use IA ainda). Confirme que falham.

2. **Peça à IA os casos restantes:**
```markdown
"Dado este conjunto inicial de testes para calculate_shipping,
identifique os edge cases que ainda não estão cobertos e escreva os testes.
Não implemente a função."
[seus 3 testes]
```

3. **GREEN:** Peça à IA para implementar o mínimo necessário para fazer os testes passarem.

4. **REFACTOR:** Com todos os testes verdes, peça à IA para refatorar a função.

5. **Validação:** Execute todos os testes e confirme que estão verdes.

**Critério de sucesso:** O ciclo completo executado sem pular nenhuma fase. Pelo menos 8 testes no total.

---

## Exercício 03 — Pre-Review de Código

**Objetivo:** Criar um processo de pre-review com IA para seu projeto.

**Parte A — Escrevendo o Prompt de Review:**

Escreva um prompt de pre-review personalizado para o seu projeto, incluindo:
- A stack técnica específica
- As categorias de problemas mais relevantes para o seu contexto
- O formato de output que você quer
- O que a IA deve IGNORAR (estilo, preferências pessoais)

**Parte B — Testando o Processo:**

Pegue um diff recente do seu projeto (ou use o exemplo abaixo) e execute seu prompt:

```python
# Diff de exemplo para testar
async def delete_user(user_id: str, admin_token: str):
    if admin_token == "secret123":
        await db.execute(f"DELETE FROM users WHERE id='{user_id}'")
        print(f"Deleted user {user_id} with all data")
        return True
    return False
```

**Reflexão:** Que problemas a IA identificou? Você os teria pego em uma revisão manual?

---

## Exercício 04 — Refatoração Incremental

**Objetivo:** Praticar refatoração em passos atômicos com testes verdes em cada passo.

**Código para refatorar:**
```python
def process_invoice(invoice_data):
    # Valida
    if not invoice_data.get('customer_id'):
        raise ValueError("customer_id required")
    if not invoice_data.get('items') or len(invoice_data['items']) == 0:
        raise ValueError("items required")
    for item in invoice_data['items']:
        if item['quantity'] <= 0:
            raise ValueError("quantity must be positive")
        if item['price'] <= 0:
            raise ValueError("price must be positive")
    
    # Calcula
    subtotal = 0
    for item in invoice_data['items']:
        subtotal += item['quantity'] * item['price']
    tax = subtotal * 0.12
    total = subtotal + tax
    if invoice_data.get('discount_pct'):
        discount = total * invoice_data['discount_pct']
        total = total - discount
    
    # Salva
    invoice = {'customer_id': invoice_data['customer_id'],
               'subtotal': subtotal, 'tax': tax, 'total': total,
               'status': 'pending', 'created_at': datetime.now().isoformat()}
    db.invoices.insert(invoice)
    
    # Notifica
    customer = db.customers.find_one({'id': invoice_data['customer_id']})
    send_email(customer['email'], f"Invoice created: R${total:.2f}")
    
    return invoice
```

**Tarefas:**
1. Peça à IA para identificar as responsabilidades — não implemente ainda
2. Decida a ordem de extração (qual responsabilidade extrair primeiro?)
3. Execute um passo por vez, rodando testes entre cada passo
4. Faça pelo menos 3 passos de refatoração atômicos

**Critério de sucesso:** 3 commits distintos, cada um com testes verdes.

---

## Exercício 05 — Geração de Documentação

**Objetivo:** Criar documentação útil para um módulo existente usando IA.

**Tarefas:**

1. **Docstrings:** Pegue um arquivo do seu projeto sem docstrings e peça à IA para gerá-las. Revise a precisão — a IA descreveu corretamente o que o código faz?

2. **Diagrama Mermaid:** Escolha um fluxo do seu sistema (autenticação, checkout, cadastro) e peça à IA para gerar um diagrama de sequência. Adicione ao README.

3. **Changelog de PR:** Pegue um PR recente e peça à IA para gerar uma entrada de changelog no formato Keep a Changelog.

**Reflexão:** Em qual dos três a IA foi mais precisa? Onde você precisou corrigir mais?

---

## Exercício 06 — Debugging Estruturado

**Objetivo:** Aplicar o processo estruturado de debugging com IA.

**Cenário:** Este código tem um bug. Sem ler a solução abaixo, use o processo da aula para diagnosticar:

```python
def calculate_average(numbers: list[float]) -> float:
    total = 0
    for n in numbers:
        total = total + n
    return total / len(numbers)

# Testes que falham misteriosamente:
# calculate_average([1, 2, 3]) == 2.0  ✅
# calculate_average([])  → ZeroDivisionError (comportamento não especificado)
# calculate_average([1.5, 2.5]) == 2.0  ✅
# calculate_average([0.1, 0.2]) == 0.30000000000000004  ❌ (esperado 0.3)
```

**Tarefas:**
1. Escreva o prompt de debugging com todos os 4 elementos (código, evidências, esperado, investigado)
2. Envie para a IA e avalie as hipóteses geradas
3. Implemente a correção sugerida
4. Escreva 2 testes que garantem o comportamento correto

---

## Exercício 07 — Mapeamento de Testes para Função Complexa

**Objetivo:** Praticar o mapeamento de caminhos antes de gerar testes.

**Função:**
```python
def apply_membership_benefits(user_id: str, cart: Cart) -> Cart:
    user = get_user(user_id)
    
    if not user.is_member:
        return cart
    
    membership = get_membership(user_id)
    
    if membership.is_expired:
        notify_expired_membership(user_id)
        return cart
    
    if membership.tier == "silver":
        cart.apply_discount(0.05)
    elif membership.tier == "gold":
        cart.apply_discount(0.10)
        if cart.subtotal > 500:
            cart.add_free_shipping()
    elif membership.tier == "platinum":
        cart.apply_discount(0.15)
        cart.add_free_shipping()
        if user.birthday_this_month:
            cart.apply_discount(0.05)  # desconto extra aniversário
    
    return cart
```

**Tarefas:**
1. Mapeie **todos** os caminhos de execução possíveis (sem usar a IA)
2. Conte: quantos caminhos existem?
3. Peça à IA para mapear os caminhos e compare com o seu mapeamento — a IA encontrou algo que você perdeu?
4. Peça à IA para gerar os testes com base no mapeamento combinado

---

## Exercício 08 — Desafio Integrador: Fluxo Completo

**Objetivo:** Executar um fluxo completo de desenvolvimento para uma feature simples.

**Feature:** Adicionar um endpoint `GET /users/{id}/activity-summary` que retorna:
```json
{
  "user_id": "uuid",
  "total_orders": 15,
  "total_spent": 2340.50,
  "last_order_date": "2025-04-10",
  "average_order_value": 156.03,
  "member_since_days": 365
}
```

**Execute em sequência:**
1. **Requisitos:** Peça à IA para identificar ambiguidades e critérios de aceitação faltantes
2. **TDD:** Escreva os testes antes de implementar (com ajuda da IA para os casos)
3. **Implementação:** Peça à IA para implementar o endpoint para fazer os testes passarem
4. **Pre-review:** Faça o review do código gerado antes de "commitar"
5. **Documentação:** Gere a docstring do endpoint e a spec OpenAPI

**Critério de sucesso:** Você completou todas as 5 fases com resultado utilizável em cada uma.

---

## ✅ Auto-Avaliação do Capítulo

- [ ] Sei identificar em qual fase do ciclo a IA agrega mais valor no meu contexto
- [ ] Consigo executar o ciclo TDD com IA sem pular o RED
- [ ] Tenho um processo de pre-review com IA personalizado para o meu projeto
- [ ] Sei refatorar incrementalmente, com commit a cada passo e testes verdes
- [ ] Sei gerar diagramas Mermaid a partir de descrições de fluxo
- [ ] Consigo formular um prompt de debugging com os 4 elementos obrigatórios
- [ ] Sei mapear caminhos de execução antes de pedir testes à IA

---

## 🔗 Próximo Capítulo

👉 [Capítulo 03 — Context Engineering](../03-context-engineering/01-o-que-e-context-engineering.md)
