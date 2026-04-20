# Exemplos: Prompts de Code Review

> Prompts prontos para usar IA como primeiro revisor de código. O objetivo é identificar problemas reais antes da revisão humana — não substituí-la.

---

## 01 — Review Geral de Pull Request

**Situação:** Revisão completa de um PR antes de pedir revisão humana.

```markdown
Faça um code review deste diff como um desenvolvedor sênior rigoroso.

**Diff:**
```diff
[cole o diff do git aqui]
```

**Contexto do PR:**
- O que esta mudança faz: [descrição breve]
- Tickets relacionados: [link/id]
- Areas afetadas: [ex: autenticação, cálculo de preço, API pública]

**Foque em:**
1. **Correctude** — a lógica implementa corretamente o que foi pedido?
2. **Segurança** — há vetores de ataque introduzidos? (OWASP Top 10)
3. **Performance** — há N+1 queries, loops desnecessários, operações custosas?
4. **Manutenibilidade** — o código vai ser fácil de manter em 6 meses?
5. **Casos limite** — edge cases não tratados?

**Formato do output:**
Para cada problema:
- **[NÍVEL]** `arquivo.py:linha` — Descrição do problema
- Por que é um problema
- Sugestão de correção

Níveis: BLOQUEANTE / IMPORTANTE / SUGESTÃO

**Ignore:** Estilo, formatação, preferências pessoais — apenas problemas com impacto real.
```

---

## 02 — Review de Segurança

**Situação:** Código que lida com autenticação, dados sensíveis, ou input de usuário.

```markdown
Faça um security review deste código como um engenheiro de segurança.

**Código:**
```python
[cole o código]
```

**Contexto:**
- Este código lida com: [ex: autenticação, pagamentos, dados pessoais]
- Origem dos inputs: [ex: request HTTP de usuário não autenticado]
- Dados mais sensíveis: [ex: senhas, tokens, CPFs, dados de cartão]

**Analise especificamente:**
- [ ] Injection (SQL, Command, LDAP, XSS)
- [ ] Autenticação e gerenciamento de sessão
- [ ] Exposição de dados sensíveis (logging, respostas de erro, headers)
- [ ] Controle de acesso — autorização verificada antes de cada operação?
- [ ] Dependências com CVEs conhecidos
- [ ] Segredos hardcoded (chaves, senhas, tokens)
- [ ] Tratamento seguro de erros (sem stack traces para o usuário)

**Formato:**
| Vulnerabilidade | Severidade | Linha | Impacto | Correção |
|----------------|-----------|-------|---------|---------|

Use CVSS para severidade: CRÍTICO / ALTO / MÉDIO / BAIXO / INFORMATIVO
```

---

## 03 — Review de Performance

**Situação:** Código que vai rodar em produção com volume significativo de dados.

```markdown
Analise este código focando em performance e escalabilidade.

**Código:**
```python
[cole o código]
```

**Contexto de volume:**
- Chamadas esperadas: [ex: 1000 req/s no pico]
- Volume de dados: [ex: tabela com 5M de registros]
- Latência alvo: [ex: < 200ms p95]
- Infraestrutura: [ex: PostgreSQL, Redis, 4 vCPUs]

**Analise:**
1. Queries N+1 (um loop que faz query por iteração)
2. Falta de paginação em consultas que crescem com dados
3. Operações síncronas bloqueantes que deveriam ser async
4. Ausência de índices necessários
5. Dados carregados em memória desnecessariamente
6. Oportunidades de cache que não foram exploradas

**Formato:**
Para cada problema:
- **Localização:** `função:linha`
- **Problema:** descrição técnica
- **Impacto estimado:** [alto/médio/baixo] com justificativa
- **Solução:** código ou abordagem específica
- **Trade-off:** o que essa otimização custa (complexidade, consistência, etc.)
```

---

## 04 — Review de Arquitetura de Módulo

**Situação:** Revisão de um módulo ou feature inteira, não apenas um diff.

```markdown
Faça um architectural review deste módulo.

**Código do módulo:**
```
[cole os arquivos principais ou descreva a estrutura]
```

**Contexto arquitetural:**
- Padrão adotado no projeto: [ex: Clean Architecture, MVC, hexagonal]
- Módulos que este depende: [lista]
- Módulos que dependem deste: [lista]
- Requisitos não-funcionais: [performance, disponibilidade, etc.]

**Avalie:**
1. **Coesão** — as responsabilidades do módulo são relacionadas?
2. **Acoplamento** — o módulo expõe dependências desnecessariamente?
3. **Fronteiras** — as interfaces são claras e estáveis?
4. **Testabilidade** — o módulo pode ser testado isoladamente?
5. **Extensibilidade** — novos casos de uso podem ser adicionados sem modificar código existente?

**Output:**
- Pontos fortes (o que está bem)
- Riscos identificados (o que pode se tornar problema)
- Sugestões de melhoria (priorizadas)
- Questões abertas para discussão com o time
```

---

## 05 — Review de API Pública (Compatibilidade e Usabilidade)

**Situação:** Revisão de uma API que será consumida por outros times ou serviços externos.

```markdown
Revise este design de API pública antes do lançamento.

**Spec da API:**
```yaml
[cole o OpenAPI/swagger ou descreva os endpoints]
```

**Contexto:**
- Consumidores: [ex: app mobile, parceiros externos, outros serviços internos]
- Versão: [ex: v1, primeira versão pública]
- Expectativa de vida: [ex: manter compatibilidade por 2 anos]

**Avalie:**
1. **Nomenclatura** — nomes são intuitivos e consistentes?
2. **Semântica HTTP** — verbos e status codes usados corretamente?
3. **Backwards compatibility** — como breaking changes seriam introduzidos?
4. **Erros** — mensagens de erro são acionáveis para o consumidor?
5. **Paginação** — endpoints que retornam listas têm paginação?
6. **Segurança** — autenticação e autorização documentadas?
7. **Idempotência** — operações que precisam são idempotentes?
8. **Versionamento** — estratégia de versão clara?

**Output:** Lista de problemas que são difíceis de corrigir após o lançamento primeiro, depois melhorias desejáveis.
```

---

## 06 — Self-Review Antes de Abrir PR

**Situação:** Você quer um primeiro olhar no seu próprio código antes de pedir revisão do time.

```markdown
Estou prestes a abrir um PR. Faça um self-review deste código como se fosse meu revisor mais rigoroso.

**Código:**
```diff
[cole seu diff]
```

**Minha intenção:** [descreva o que você está tentando fazer e por quê]

**O que eu já verifiquei:**
- [ ] Os testes passam
- [ ] Não há secrets hardcoded
- [ ] [outras verificações que já fez]

**O que me preocupa:** [descreva suas dúvidas ou áreas que você mesmo acha fraca]

**Pergunta específica:** [se tiver uma dúvida técnica específica]

**Instrução:**
Seja honesto — aponte problemas mesmo que sejam sutis. Prefiro saber agora do que no PR review.
Organize por: BLOQUEANTE → IMPORTANTE → SUGESTÃO → ELOGIO (o que está bem)
```

---

## Notas de Uso

### Como usar IA em code review de forma responsável

1. **IA como primeiro revisor, não único** — use IA para pegar os problemas óbvios antes da revisão humana.
2. **Seja específico sobre o foco** — review de segurança, performance, ou arquitetura produze resultados melhores que "revise tudo".
3. **Cole o diff, não o arquivo inteiro** — o revisor humano vê o diff; a IA também deve focar no diff.
4. **Dê contexto** — "este código lida com pagamentos" ativa atenção diferente de "este código lida com preferências de UI".

### O que a IA é boa em revisar

- ✅ SQL injection, XSS e outros padrões de vulnerabilidade comuns
- ✅ Queries N+1 óbvias
- ✅ Inconsistências com padrões que você descreve
- ✅ Casos limite não tratados (quando você lista os esperados)

### O que a IA não é confiável em revisar

- ❌ Lógica de negócio complexa e específica do domínio
- ❌ Impacto de mudança no sistema completo (sem ver o sistema completo)
- ❌ Decisões que dependem de contexto organizacional ou histórico do projeto
