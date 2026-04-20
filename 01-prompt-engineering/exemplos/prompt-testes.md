# Exemplos: Prompts de Geração de Testes

> Prompts prontos para geração de testes unitários, de integração e de contrato. O elemento crítico é sempre listar explicitamente os casos que devem ser cobertos.

---

## 01 — Testes Unitários para Função Pura

**Situação:** Função sem dependências externas, input/output determinístico.

```markdown
Escreva testes unitários para a função abaixo usando [pytest / jest / vitest].

**Função:**
```python
[cole a função]
```

**Cobertura obrigatória:**
- Happy path: [descreva o comportamento normal]
- Edge cases:
  - [ ] Input vazio: `[]` / `""` / `None`
  - [ ] Input mínimo: um único elemento
  - [ ] Input máximo: [limite se houver]
  - [ ] [outros edge cases específicos do domínio]
- Erros esperados:
  - [ ] [tipo de exceção] para [condição]
  - [ ] [tipo de exceção] para [condição]

**Convenções:**
- Naming: `test_[função]_[cenário]_[resultado esperado]`
- Organização: agrupe por comportamento com classes TestClass ou marcadores
- Sem fixtures complexas — use valores literais

**Restrições:**
- Sem mocks — a função é pura
- Sem testes de implementação interna — apenas comportamento observável
- Cada teste deve ter exatamente um assert que valida o comportamento central

**Output:** Testes organizados por grupo de comportamento.
```

---

## 02 — Testes com Mocks para Dependências Externas

**Situação:** Função que chama banco de dados, API externa, sistema de arquivos, etc.

```markdown
Escreva testes unitários para a função abaixo. Use mocks para as dependências externas.

**Função:**
```python
[cole a função]
```

**Dependências a mockar:**
| Dependência | O que simular |
|------------|---------------|
| `db.get(User, id)` | Retornar um User fixture ou None |
| `send_email()` | Capturar chamada, não enviar |
| `redis_client.get()` | Retornar valor ou None |

**Framework de mock:** [pytest-mock / unittest.mock / vi.mock / jest.mock]

**Cenários obrigatórios:**
1. [Dependência] retorna resultado esperado → função faz X
2. [Dependência] retorna None → função faz Y
3. [Dependência] lança exceção → função faz Z
4. [Dependência] é chamada com os parâmetros corretos (assert_called_with)

**Output:** Testes com setup de mocks explícito. Mostre o que cada mock simula e por quê.
```

---

## 03 — Testes de Integração para API REST

**Situação:** Testar endpoints HTTP com banco de dados real (test database).

```markdown
Escreva testes de integração para o endpoint abaixo usando [pytest + httpx / supertest].

**Endpoint:**
```python
[cole o router/controller]
```

**Setup esperado:**
- Database: PostgreSQL de teste com migrations aplicadas
- Fixtures: user_factory, client (cliente HTTP configurado)
- Cleanup: rollback por teste (usar transaction fixture)

**Cenários a testar:**
- [ ] Request válido com autenticação → status 200 + body esperado
- [ ] Sem autenticação → 401
- [ ] Sem permissão → 403
- [ ] Body inválido → 422 com errors específicos
- [ ] Recurso não encontrado → 404
- [ ] [regra de negócio específica] → [status + body]

**Assertions:**
Para cada cenário, valide:
- Status code
- Schema do response body (campos obrigatórios presentes)
- Estado do banco após a operação (se é mutation)

**Restrições:**
- Sem mocks de banco — use database de teste real
- Cada teste deve ser independente (sem dependência de ordem de execução)

**Output:** Testes com fixtures documentadas. Inclua o conftest.py se precisar criar fixtures.
```

---

## 04 — Aumentar Cobertura em Módulo Existente

**Situação:** Você tem código existente com cobertura baixa e precisa aumentar.

```markdown
Analise o código abaixo e identifique os caminhos não cobertos pelos testes existentes.

**Código:**
```python
[cole o código]
```

**Testes existentes:**
```python
[cole os testes atuais]
```

**Cobertura atual:** [ex: 45% — medida com pytest-cov]

**Meta:** Atingir [80%+] sem testar implementação interna.

**Instrução:**
1. Mapeie todos os caminhos de execução possíveis (branches, exceções)
2. Identifique quais caminhos os testes existentes NÃO cobrem
3. Gere testes apenas para os caminhos faltantes
4. Não duplique testes que já existem

**Output:**
- Lista dos caminhos não cobertos
- Testes para cobri-los
- Estimativa de cobertura após adicionar os novos testes
```

---

## 05 — Testes de Contrato para API

**Situação:** Você precisa garantir que uma API mantém seu contrato ao evoluir.

```markdown
Escreva testes de contrato para a API abaixo.

**Contrato atual (schema):**
```json
{
  "endpoint": "POST /users",
  "request": {
    "email": "string, required",
    "name": "string, required",
    "role": "string, enum: [admin, user, viewer]"
  },
  "response": {
    "id": "string, uuid",
    "email": "string",
    "created_at": "string, ISO8601"
  }
}
```

**O que os testes de contrato devem garantir:**
- Campos obrigatórios ausentes → 422
- Tipos incorretos → 422
- Enum com valor inválido → 422
- Request válido → response com todos os campos do contrato
- Campos extras no request → ignorados (não causam erro)
- Response NÃO expõe campos sensíveis (password_hash, internal_id)

**Restrições:**
- Use schema validation no assert (jsonschema / pydantic / zod)
- Testes devem passar mesmo se a implementação interna mudar
- Um teste por regra de contrato — não agrupe múltiplas regras

**Output:** Testes com validação de schema explícita.
```

---

## 06 — Property-Based Testing

**Situação:** Função com espaço de inputs muito grande — testes baseados em exemplos são insuficientes.

```markdown
Escreva testes property-based para a função abaixo usando [Hypothesis / fast-check].

**Função:**
```python
[cole a função]
```

**Propriedades que devem ser sempre verdadeiras:**
1. [Propriedade de simetria]: ex: "se f(a, b) = x, então f(b, a) = x"
2. [Propriedade de identidade]: ex: "f(empty) = empty"
3. [Invariante de domínio]: ex: "o resultado tem sempre o mesmo tipo do input"
4. [Propriedade de idempotência]: ex: "f(f(x)) = f(x)"

**Estratégias de geração:**
- Input válido: [como gerar — ex: st.text() com min_size=1]
- Input de borda: [ex: strings muito longas, Unicode, caracteres especiais]

**Output:** Testes de propriedade com estratégias de geração explícitas e comentário explicando cada propriedade.
```

---

## Notas de Uso

### O que define um bom teste (gerado ou não)

- **Testa comportamento, não implementação** — se você pode refatorar sem mudar o teste, ele está bom.
- **Um assert central por teste** — testes com 10 asserts testam 10 coisas e falham por qualquer uma.
- **Nome descritivo** — `test_login_with_wrong_password_returns_401` é melhor que `test_login_fail`.
- **Independente de ordem** — cada teste deve funcionar isoladamente.

### Quando a IA gera testes ruins

- Testa métodos privados → rejeite, peça apenas comportamento observável
- Todos os testes passam mas não testam nada útil → adicione mais edge cases explicitamente
- Usa mocks quando não deveria (ou não usa quando deveria) → especifique explicitamente
