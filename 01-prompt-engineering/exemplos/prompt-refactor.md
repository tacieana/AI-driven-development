# Exemplos: Prompts de Refatoração

> Prompts prontos para situações comuns de refatoração. Adapte o contexto técnico para seu projeto.

---

## 01 — Extrair Responsabilidades de Classe God Object

**Situação:** Uma classe cresceu demais e acumula responsabilidades que não são dela.

```markdown
Analise a classe abaixo e refatore-a para separar responsabilidades.

**Código:**
```python
[cole a classe aqui]
```

**O que fazer:**
1. Identifique as responsabilidades distintas (liste-as antes de implementar)
2. Extraia cada responsabilidade em uma classe dedicada
3. Mantenha a classe original como orquestradora ou facade se necessário

**O que NÃO alterar:**
- A interface pública usada externamente (métodos públicos e suas assinaturas)
- O comportamento observável para qualquer input atual

**Restrições:**
- Máximo de 15 linhas por método
- Cada nova classe tem uma única responsabilidade clara
- Sem novas dependências externas

**Output:** Liste as classes identificadas, depois implemente a refatoração completa.
```

---

## 02 — Eliminar Duplicação (DRY)

**Situação:** Você identificou lógica repetida em múltiplos lugares.

```markdown
Elimine a duplicação no código abaixo sem alterar o comportamento.

**Código com duplicação:**
```python
[cole o código com duplicação]
```

**Contexto:**
- A lógica duplicada é: [descreva o que está repetido]
- Aparece em: [liste onde aparece]

**Abordagem esperada:**
- Extraia a lógica comum em uma função/método privado
- Renomeie para deixar a intenção clara
- Mantenha os callers funcionando sem mudanças na interface

**Restrição:** Não use herança para eliminar a duplicação — prefira composição ou funções auxiliares.

**Output:** A função extraída + os trechos originais modificados para usá-la.
```

---

## 03 — Reduzir Complexidade Ciclomática

**Situação:** Uma função tem muitos `if/else` aninhados e está difícil de testar.

```markdown
Refatore a função abaixo para reduzir complexidade ciclomática.
A complexidade atual é [N] — o objetivo é ≤ 5.

**Código:**
```python
[cole a função]
```

**Técnicas permitidas (use a mais adequada):**
- Early return / guard clauses
- Extração em funções menores
- Tabela de decisão / dicionário
- Polimorfismo se os ifs tratam de tipos diferentes

**O que NÃO fazer:**
- Não inverta a lógica apenas para esconder a complexidade
- Não use truques que dificultem a leitura

**Critério de sucesso:** Cada caminho lógico deve ser testável de forma independente.

**Output:** Código refatorado + análise de qual técnica foi usada e por quê.
```

---

## 04 — Converter Callbacks para Async/Await

**Situação:** Código legado usa callbacks ou Promises encadeadas que precisam ser modernizadas.

```markdown
Converta o código abaixo de [callbacks / Promises encadeadas] para async/await.

**Código legado:**
```javascript
[cole o código]
```

**Contexto:**
- Runtime: Node.js [versão] / Browser moderno
- As funções [lista] já suportam Promises nativamente
- [outra API] ainda usa callbacks — use util.promisify se necessário

**O que manter:**
- O comportamento de erro deve ser idêntico
- Os tipos de retorno devem ser equivalentes

**Restrições:**
- Não use .then()/.catch() — apenas async/await com try/catch
- Mantenha nomes de variáveis quando fizer sentido

**Output:** Código convertido. Anote qualquer comportamento que mudou sutilmente.
```

---

## 05 — Tornar Código Testável (Dependency Injection)

**Situação:** Uma função depende de globals, singletons ou I/O direto, impossibilitando testes unitários.

```markdown
Refatore o código abaixo para ser testável unitariamente via injeção de dependência.

**Código atual:**
```python
[cole o código com dependências hardcoded]
```

**Problema:** [descreva por que não é testável — ex: "chama db diretamente", "usa datetime.now()"]

**Abordagem:**
- Extraia as dependências como parâmetros com valores padrão
- Use Protocol/ABC para tipar as dependências se Python
- Não mude o comportamento para callers que não passam as dependências

**Exemplo de como deve ficar testável:**
```python
# Antes:
def create_user(email: str):
    db.save(User(email=email, created_at=datetime.now()))

# Depois (testável):
def create_user(email: str, db=default_db, clock=datetime.now):
    db.save(User(email=email, created_at=clock()))
```

**Output:** Código refatorado + um exemplo de como escrever o teste unitário com mocks.
```

---

## 06 — Refatoração Segura com Testes Existentes

**Situação:** Você tem testes e quer refatorar garantindo que nada quebra.

```markdown
Refatore o código abaixo para [objetivo: melhorar legibilidade / performance / estrutura].
Temos testes existentes — sua refatoração não pode fazê-los falhar.

**Código atual:**
```python
[cole o código]
```

**Testes existentes (referência):**
```python
[cole os testes principais]
```

**Objetivo da refatoração:** [descreva claramente o que deve melhorar]

**Processo esperado:**
1. Identifique o que pode mudar sem impactar os testes
2. Implemente em incrementos — cada passo deve manter os testes verdes
3. Liste as mudanças feitas por etapa

**Restrição:** Se alguma mudança exigir atualizar um teste, aponte qual e por quê — não mude os testes sem explicar.
```

---

## Notas de Uso

- **Sempre cole o código** — nunca descreva o código em texto. O modelo precisa ver o código real.
- **Defina "o que não mudar"** — é o elemento mais crítico em prompts de refatoração.
- **Peça o raciocínio antes** para refatorações complexas: "Liste os problemas que você vê antes de propor a solução."
- **Verifique equivalência** — rode os testes após aceitar o código refatorado.
