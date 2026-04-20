# 📝 Exercícios — Capítulo 01: Prompt Engineering

> Exercícios práticos para desenvolver intuição real sobre prompt engineering. Cada exercício tem um critério claro de sucesso.

---

## Exercício 01 — Reescrever Prompts Vagos

**Objetivo:** Praticar a transformação de prompts ruins em prompts eficazes.

**Tarefa:** Reescreva cada prompt abaixo aplicando os 5 princípios (Clareza, Especificidade, Contexto, Formato, Restrições). Depois teste em Claude ou Copilot e compare os resultados.

**Prompts para reescrever:**

```
1. "Melhora minha função de login"

2. "Cria um endpoint de usuários"

3. "Adiciona tratamento de erro aqui"

4. "Refatora isso pra ficar melhor"

5. "Faz um teste pra essa função"
```

**Critério de sucesso:** Seu prompt reescrito deve ser específico o suficiente para que duas pessoas diferentes cheguem ao mesmo entendimento do que deve ser produzido.

**Template de reescrita:**
```markdown
Original: [prompt vago]

Reescrito:
[Contexto]: ...
[Tarefa]: ...
[Restrições]: ...
[Formato de output]: ...
```

---

## Exercício 02 — Construindo um Prompt com PCTFR

**Objetivo:** Praticar a montagem estruturada de um prompt completo.

**Cenário:** Você precisa adicionar rate limiting a um endpoint existente da sua API. O endpoint é `POST /api/comments` e recebe um userId no JWT. O limite é de 10 comentários por hora por usuário. Você usa FastAPI e Redis.

**Tarefa:** Construa um prompt completo com todos os 5 componentes:

```markdown
## Meu Prompt Estruturado

**Papel:**
[Que especialista a IA deve ser?]

**Contexto:**
[Qual é a situação técnica atual?]

**Tarefa:**
[O que exatamente deve ser feito?]

**Formato de saída:**
[Como o resultado deve ser apresentado?]

**Restrições:**
[O que não deve ser feito ou alterado?]
```

**Critério de sucesso:** Envie o prompt para Claude e avalie: o resultado pode ser utilizado diretamente sem iterações adicionais?

---

## Exercício 03 — Aplicando Chain-of-Thought

**Objetivo:** Identificar quando CoT ajuda e como ativá-lo corretamente.

**Parte A — Classificação:**

Para cada tarefa abaixo, decida: CoT ajuda? Por quê?

| Tarefa | CoT Ajuda? | Justificativa |
|--------|:----------:|---------------|
| Gerar uma docstring para uma função simples | | |
| Analisar a complexidade de tempo de um algoritmo recursivo | | |
| Renomear variáveis para seguir snake_case | | |
| Avaliar se vale a pena migrar de REST para GraphQL neste projeto | | |
| Converter um loop for em list comprehension | | |
| Investigar por que um teste intermitente falha sob carga | | |

**Parte B — Prática:**

Pegue a tarefa "Avaliar se vale a pena migrar de REST para GraphQL" e escreva dois prompts:
1. Sem CoT — direto ao ponto
2. Com CoT — forçando raciocínio estruturado

Teste ambos e compare a qualidade das respostas.

---

## Exercício 04 — Criando Exemplos Few-Shot

**Objetivo:** Construir um conjunto de exemplos few-shot para um problema real.

**Cenário:** Sua equipe precisa padronizar as mensagens de erro que a API retorna. O formato atual é inconsistente. Você quer usar IA para converter mensagens informais no formato padrão.

**Formato desejado:**
```json
{
  "code": "ERROR_CODE_SNAKE_CASE",
  "message": "Mensagem clara para o usuário (sem detalhes técnicos)",
  "field": "campo_afetado (se aplicável, senão null)"
}
```

**Tarefa:** Crie 4 exemplos few-shot que cubram casos variados (erro de validação, recurso não encontrado, erro de permissão, erro de servidor).

**Template:**
```markdown
[Exemplo 1 — Validação]
Input: "email inválido no campo de cadastro"
Output: {
  "code": "...",
  "message": "...",
  "field": "..."
}

[Exemplo 2 — Not Found]
Input: ...
Output: ...

[Exemplo 3 — Permissão]
...

[Exemplo 4 — Servidor]
...
```

**Critério de sucesso:** Teste o prompt com 3 inputs novos. O output deve seguir o formato sem desvios.

---

## Exercício 05 — Identificando Anti-Patterns

**Objetivo:** Reconhecer anti-patterns em prompts reais.

**Tarefa:** Para cada prompt abaixo, identifique o(s) anti-pattern(s) e reescreva-o:

**Prompt A:**
```
"Olha esse código aqui, tem uns problemas de segurança, de performance,
e a arquitetura tá errada. Também quero que você adicione testes e 
atualize a documentação. Ah, e muda o nome das variáveis pra seguir
o padrão da empresa"
```
Anti-pattern(s): ___________
Reescrita: ___________

---

**Prompt B:**
```
"Refatora isso aqui:
[codebase inteiro com 3000 linhas coladas]

Quero que fique mais limpo"
```
Anti-pattern(s): ___________
Reescrita: ___________

---

**Prompt C:**
```
"Não usa recursão, não usa list comprehension, não usa lambda,
não usa classes, não usa decorators"
```
Anti-pattern(s): ___________
Reescrita: ___________

---

**Prompt D:**
```
"Como faço pra esse código funcionar?"
[sem colar o código, sem descrever o erro]
```
Anti-pattern(s): ___________
Reescrita: ___________

---

## Exercício 06 — Prompt de Debug Completo

**Objetivo:** Construir um prompt de debugging com todas as evidências necessárias.

**Cenário:** Você tem este erro em produção:
```
KeyError: 'user_id'
  File "src/middleware/auth.py", line 34, in authenticate
    user_id = token_data['user_id']
```

O código na linha 34:
```python
async def authenticate(request: Request, token: str = Depends(oauth2_scheme)):
    try:
        token_data = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
        user_id = token_data['user_id']
        request.state.user_id = user_id
    except JWTError:
        raise HTTPException(status_code=401)
```

O erro acontece apenas para alguns usuários — tokens gerados antes de uma mudança que você fez ontem.

**Tarefa:** Escreva o prompt de debug completo com todas as informações que um desenvolvedor precisaria para diagnosticar e corrigir:

```markdown
[Seu prompt aqui — inclua: código, erro, contexto da mudança recente,
comportamento esperado, o que você já investigou]
```

**Critério de sucesso:** Seu prompt deve conter evidências suficientes para que a IA diagnostique o problema sem fazer perguntas adicionais.

---

## Exercício 07 — Prompt de Testes com Casos Explícitos

**Objetivo:** Praticar a especificação completa de casos de teste.

**Função a testar:**
```python
def calculate_discount(subtotal: float, coupon_code: str | None, user_tier: str) -> float:
    """
    Calcula o desconto total aplicável.
    
    user_tier: "regular", "premium", "vip"
    cupons: "FIRST10" (10% primeira compra), "SAVE20" (20% acima de R$500)
    Desconto máximo: 30%
    """
    discount = 0.0
    
    if user_tier == "premium":
        discount += 0.05
    elif user_tier == "vip":
        discount += 0.10
    
    if coupon_code == "FIRST10":
        discount += 0.10
    elif coupon_code == "SAVE20" and subtotal > 500:
        discount += 0.20
    
    return min(discount, 0.30)
```

**Tarefa:** Escreva um prompt que peça testes para esta função, listando TODOS os casos que devem ser cobertos (não deixe a IA decidir).

Dica: Mapeie todos os caminhos possíveis — quantas combinações de tier × cupom × valor existem?

---

## Exercício 08 — Desafio Integrador

**Objetivo:** Aplicar todas as técnicas aprendidas em um único prompt complexo.

**Cenário real:** Você precisa refatorar uma função legada de processamento de pedidos. O código existe (imagine que você tem acesso), tem bugs conhecidos, sem testes, e vai para produção amanhã.

**Sua missão:** Escreva um único prompt que:
1. Defina claramente o papel da IA
2. Forneça contexto suficiente (stack, restrições, o que não pode mudar)
3. Decomponha a tarefa em etapas gerenciáveis
4. Defina critérios de sucesso para cada etapa
5. Especifique o formato do output
6. Use CoT para a análise inicial

**Critério de sucesso:** Mostre o prompt para um colega. Ele deve conseguir entender o que precisa ser feito sem precisar ler código ou perguntar nada adicional.

---

## ✅ Auto-Avaliação do Capítulo

Antes de seguir para o próximo capítulo, confirme:

- [ ] Consigo reescrever um prompt vago em um prompt específico em menos de 5 minutos
- [ ] Sei quando usar cada um dos 5 componentes do PCTFR
- [ ] Consigo identificar quando Chain-of-Thought vai melhorar o resultado
- [ ] Sei construir um conjunto de exemplos few-shot que cubram variação suficiente
- [ ] Consigo reconhecer os 10 anti-patterns descritos no capítulo
- [ ] Meus prompts de debug incluem código, stack trace, contexto e o que já testei
- [ ] Meus prompts de testes listam os casos explicitamente, não delegam à IA

---

## 🔗 Próximo Capítulo

Se você completou os exercícios e se sente confortável:

👉 [Capítulo 02 — Fluxos de Trabalho](../02-fluxos-de-trabalho/01-ai-no-ciclo-de-desenvolvimento.md)
