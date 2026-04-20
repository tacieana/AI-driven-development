# 07 — Anti-Patterns de Prompt Engineering

> **Objetivo:** Reconhecer e corrigir os erros mais comuns que degradam a qualidade dos outputs — os "anti-patterns" que todo desenvolvedor comete antes de desenvolver boas intuições.

---

## O que é um Anti-Pattern?

Um **anti-pattern de prompt** é uma abordagem que parece razoável mas sistematicamente produz outputs piores. Diferente de um erro óbvio, o anti-pattern é frequentemente a "primeira tentativa natural" de quem ainda não desenvolveu intuição sobre como modelos respondem.

---

## Anti-Pattern 1: O Prompt Vago

**Sintoma:** Você descreve o objetivo geral mas não a tarefa específica.

```
❌ Vago:
"Melhore este código"
"Deixe mais eficiente"
"Refatore isso"
"Corrija os problemas"
```

**Por que é um problema:** O modelo vai adivinhar o que "melhorar" significa para ele — que pode ser diferente do que significa para você. Você vai receber um output que parece ter melhorado mas não resolve o problema real.

```
✅ Específico:
"Reduza a complexidade ciclomática da função processOrder — ela está com CC=12.
Extraia os blocos de validação em funções privadas nomeadas.
Não mude o comportamento externo."
```

**Diagnóstico:** Se você não consegue escrever um critério de aceitação para "o que é um bom output", seu prompt está vago demais.

---

## Anti-Pattern 2: Contexto Insuficiente

**Sintoma:** Você pede o código mas não fornece o ambiente onde ele vai rodar.

```
❌ Sem contexto:
"Crie uma função de autenticação"

Resultado: O modelo cria autenticação genérica com bcrypt, JWT arbitrário,
e uma arquitetura que pode não ser compatível com seu projeto.
```

**Por que é um problema:** O modelo usa o padrão mais comum do seu treinamento, que pode não ser o seu padrão.

```
✅ Com contexto:
"Crie a função authenticate_user para nossa API FastAPI 0.111.
- Já temos: User model (SQLAlchemy), AuthenticationError exception, redis_client global
- Autenticação: email + password, retorna JWT assinado com HS256
- Token expira em 1h
- Lib JWT: python-jose, já importada
- Não crie novas models ou exceptions"
```

**Diagnóstico:** Se você precisaria explicar mais coisas a um colega novo para ele implementar corretamente, seu prompt está faltando contexto.

---

## Anti-Pattern 3: Contexto Excessivo (Context Stuffing)

**Sintoma:** Você cola todo o codebase achando que mais contexto = resultado melhor.

```
❌ Excessivo:
[5000 linhas de código de 20 arquivos diferentes]
"Agora adicione validação de email"
```

**Por que é um problema:**
- O modelo fica "perdido no meio" — pesquisa mostra atenção degradada em contextos muito longos
- Aumenta custo de tokens sem proporcional melhoria
- O modelo pode usar partes do contexto que não são relevantes e gerar código confuso

```
✅ Contexto cirúrgico:
"Aqui está o arquivo onde a mudança deve acontecer (src/validators.py):
[apenas esse arquivo]

E aqui está o modelo User para referência:
[apenas a classe User]

Adicione a função validate_email seguindo o padrão das outras funções do arquivo."
```

**Diagnóstico:** Inclua apenas o código que o modelo precisa **ler** para completar a tarefa, não tudo que existe no repositório.

---

## Anti-Pattern 4: Pedir Tudo de Uma Vez

**Sintoma:** Uma única mensagem com múltiplas tarefas não relacionadas.

```
❌ Tudo de uma vez:
"Refatore o UserService para separar responsabilidades,
adicione testes para todas as novas classes,
atualize o README com a nova arquitetura,
e também corrija o bug no endpoint de login que mencionei ontem"
```

**Por que é um problema:**
- O modelo vai tentar satisfazer todos os pedidos simultaneamente
- Qualidade fica distribuída — cada parte recebe menos atenção
- Fica difícil dar feedback específico
- Erros numa parte afetam as outras

```
✅ Uma tarefa por vez:
Sessão 1: "Refatore o UserService para separar responsabilidades"
→ revise e confirme

Sessão 2: "Adicione testes para as classes extraídas na sessão anterior"
→ revise e confirme

Sessão 3: "Atualize o README refletindo a nova arquitetura"
```

**Diagnóstico:** Se sua tarefa tem mais de dois verbos de ação distintos, divida em múltiplas mensagens.

---

## Anti-Pattern 5: Instruções Negativas sem Alternativa

**Sintoma:** Você diz o que não fazer mas não diz o que fazer.

```
❌ Apenas negação:
"Não use recursão"
"Não use list comprehensions"
"Não crie classes desnecessárias"
```

**Por que é um problema:** O modelo sabe o que evitar mas não o que fazer no lugar. Pode simplesmente substituir por algo igualmente problemático.

```
✅ Negação + alternativa:
"Não use recursão — use iteração com um stack explícito"
"Não use list comprehensions com mais de uma condição — use for loops explícitos"
"Não crie classes — mantenha como funções modulares no mesmo arquivo"
```

---

## Anti-Pattern 6: Copiar e Colar Erro sem Diagnóstico

**Sintoma:** Você cola uma stack trace e pede "como corrijo isso?"

```
❌ Dump de erro:
"TypeError: 'NoneType' object is not subscriptable
  File '/app/service.py', line 47, in process
    result = data['key']
Como corrijo?"
```

**Por que é um problema:** Sem o código e o contexto, o modelo vai adivinhar o que `data` deveria ser. Você vai receber uma "correção" que pode não funcionar na sua situação real.

```
✅ Erro com contexto:
"Estou recebendo este erro:
TypeError: 'NoneType' object is not subscriptable na linha 47.

O código em questão:
```python
async def process(user_id: str) -> dict:
    data = await get_user_data(user_id)  # linha 45
    result = data['profile']              # linha 47 — erro aqui
    return result
```

A função `get_user_data` retorna None quando o usuário não tem dados de perfil.
O comportamento esperado: retornar um dict vazio `{}` nesse caso.

Corrija com o mínimo de mudança possível."
```

---

## Anti-Pattern 7: Aceitar o Primeiro Output Sem Iteração

**Sintoma:** Você aceita e commita o primeiro output sem dar feedback.

**Por que é um problema:**
- O primeiro output raramente é o melhor possível
- Mesmo quando funciona, pode ter problemas sutis que uma segunda passagem revela
- Você perde a oportunidade de calibrar o modelo para seu contexto específico

```
✅ Ciclo de refinamento:
1. Output inicial → "Funciona, mas a função ficou longa demais. Quebre em helpers"
2. Output refinado → "Melhor. O nome 'helper1' não é descritivo. Renomeie para..."
3. Output final → aceito e commitado
```

**Diagnóstico:** Trate o primeiro output como um rascunho. Dê pelo menos um ciclo de feedback antes de aceitar.

---

## Anti-Pattern 8: Prompt sem Critério de Sucesso

**Sintoma:** Você não define como vai saber se o output está correto.

```
❌ Sem critério:
"Refatore esta função para ser mais eficiente"
→ Como saber se ficou mais eficiente?

❌ Sem critério:
"Escreva testes para esta classe"
→ Quantos? Que cenários? O que constitui cobertura suficiente?
```

```
✅ Com critério:
"Refatore esta função para reduzir de O(n²) para O(n log n) ou melhor.
Confirme a complexidade final com uma análise explícita."

"Escreva testes cobrindo: happy path, 3 edge cases (lista vazia, item único, duplicatas)
e 2 casos de erro (input inválido, permissão negada).
Total de 6 testes, todos devem passar com pytest sem modificar o código."
```

---

## Anti-Pattern 9: Ignorar Alucinações

**Sintoma:** Você aceita chamadas de API sem verificar se existem.

```
❌ Não verificado:
# Output do modelo:
response = openai.ChatCompletion.create(
    model="gpt-4",
    messages=messages,
    response_format={"type": "json_object"},  # ← existe esse parâmetro?
    seed=42                                    # ← existe seed na API?
)
# Você commita sem checar a documentação
```

**Como mitigar:**
- Sempre verifique parâmetros de API em documentação oficial
- Cole a documentação relevante no prompt: "use apenas os parâmetros desta spec: [spec]"
- Execute o código antes de aceitar

---

## Anti-Pattern 10: System Prompt Genérico

**Sintoma:** Você usa o mesmo system prompt para tudo, sem especializá-lo para o projeto.

```
❌ Genérico:
"Você é um assistente útil de programação."

✅ Especializado:
"Você é um desenvolvedor sênior Python trabalhando no projeto X.
- Stack: Python 3.12, FastAPI, SQLAlchemy async, PostgreSQL
- Padrão de código: Clean Architecture, sem comentários inline, type hints obrigatórios
- Convenções: snake_case, classes em PascalCase, módulos em lowercase
- Nunca adicione dependências além das já listadas no pyproject.toml
- Nunca use eval(), exec() ou subprocess sem aprovação explícita
- Ao refatorar, sempre preserve a interface pública"
```

---

## Resumo: Diagnóstico Rápido

| Sintoma no output | Anti-pattern provável |
|------------------|-----------------------|
| Output genérico demais | Falta de contexto (AP 2) |
| Output inconsistente com o projeto | System prompt genérico (AP 10) |
| Múltiplas coisas mudadas sem pedir | Pedir tudo de uma vez (AP 4) |
| Código com API que não existe | Alucinação não verificada (AP 9) |
| Output que satisfaz mas não resolve | Prompt vago (AP 1) |
| Modelo usa biblioteca errada | Falta de contexto técnico (AP 2) |
| Código bom mas com problemas sutis | Não iterou (AP 7) |

---

## ✅ Pontos-chave do Capítulo

- **Vaguidão** é o anti-pattern mais comum — se não tem critério de aceitação, o prompt está vago.
- **Contexto insuficiente** produz output genérico; **contexto excessivo** degrada a atenção do modelo.
- **Tarefas múltiplas** em um único prompt dividem a qualidade — uma tarefa por sessão.
- **Sempre itere** — o primeiro output é um rascunho.
- **Verifique APIs** antes de aceitar código que usa bibliotecas externas.

---

## 🔗 Próxima Seção

👉 [Exemplos Práticos](./exemplos/) — Prompts prontos e comentados para refatoração, debugging, testes e code review.

👉 [Exercícios do Capítulo 01](./08-exercicios.md)
