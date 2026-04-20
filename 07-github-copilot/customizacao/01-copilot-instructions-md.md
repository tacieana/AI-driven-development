# 01 — copilot-instructions.md

> **Objetivo:** Criar e estruturar o arquivo `.github/copilot-instructions.md` para calibrar o comportamento do Copilot em todo o repositório.

---

## O que é o `copilot-instructions.md`

O arquivo `.github/copilot-instructions.md` é o principal mecanismo de personalização do GitHub Copilot em nível de repositório. Seu conteúdo é automaticamente incluído como contexto em:

- Todas as sessões de Copilot Chat no repositório
- Todas as execuções do Cloud Agent atribuídas a issues do repositório
- Sessões do Agent Mode no IDE quando o repositório está aberto

> 📌 **Referência:** docs.github.com/en/copilot/customizing-copilot/adding-repository-instructions-for-github-copilot

---

## Escopo das Instruções

| Nível | Arquivo | Abrangência |
|-------|---------|------------|
| **Repositório** | `.github/copilot-instructions.md` | Todos os usuários do repo |
| **Organização** | Configurado nas org settings | Todos os repos da organização |
| **Pessoal** | `~/.config/github-copilot/instructions.md` | Apenas o seu usuário |
| **Enterprise** | Configurado no admin panel | Todos os repos da empresa |

Para repositórios de time, o nível **repositório** é o mais comum e recomendado.

> 📌 **Referência:** docs.github.com/en/copilot/customizing-copilot/adding-repository-instructions-for-github-copilot#about-copilot-instructions

---

## Estrutura Recomendada

```markdown
# GitHub Copilot Instructions

Breve descrição do projeto para o Copilot entender o domínio.

## Stack técnica
[Linguagens, frameworks, versões]

## Estrutura do projeto
[Organização de diretórios e responsabilidades]

## Padrões de código
[Convenções que o Copilot deve seguir]

## Padrões de teste
[Frameworks, organização e o que deve ser testado]

## Padrões de erro
[Como erros devem ser tratados e lançados]

## O que NÃO fazer
[Anti-patterns específicos do projeto]
```

---

## Escopo por Subdiretório

Você pode criar arquivos de instruções específicos para subdiretórios:

```
.github/copilot-instructions.md        ← instruções gerais do repo
src/frontend/
  .github/copilot-instructions.md      ← específico para o frontend
src/backend/
  .github/copilot-instructions.md      ← específico para o backend
```

O Copilot combina as instruções do nível mais específico com as do nível mais geral.

---

## Boas Práticas de Conteúdo

### ✅ Seja específico e verificável

```markdown
# ❌ Genérico — sem impacto real
Escreva código de qualidade com boas práticas.

# ✅ Específico — Copilot pode seguir
Use ESLint com a configuração em .eslintrc.json.
Nunca desabilite regras com // eslint-disable sem comentário explicando o motivo.
```

### ✅ Forneça exemplos negativos e positivos

```markdown
## Tratamento de erros

❌ Não faça:
try {
  await db.query(sql);
} catch (e) {
  console.log(e);
}

✅ Faça:
try {
  await db.query(sql);
} catch (error) {
  logger.error('Database query failed', { sql, error });
  throw new DatabaseError('Falha ao executar query', { cause: error });
}
```

### ✅ Documente decisões de arquitetura

```markdown
## Arquitetura
Usamos o padrão Repository para isolar o acesso a dados.
Services NUNCA importam Prisma diretamente — sempre via Repository.

Controllers → Services → Repositories → Prisma
```

### ❌ Evite informações desatualizadas

```markdown
# ❌ Problemático — vai envelhecer e confundir
Usamos a versão 2.0 do nosso pacote interno @company/auth.
A versão 3.0 está planejada para março.

# ✅ Melhor — referencia a fonte canônica
Importe e use o pacote @company/auth. Consulte sua documentação
em ./docs/auth.md para a versão correta e exemplos de uso.
```

---

## Limitações

| Limitação | Detalhe |
|-----------|---------|
| Tamanho máximo | O arquivo muito longo pode exceder a janela de contexto |
| Não é obrigatoriamente seguido | O Copilot usa como contexto, não como regra rígida |
| Não substitui code review | Humanos ainda devem revisar o output |
| Não afeta completions inline | Apenas Chat, Cloud Agent e Agent Mode |

---

## Verificar se as Instruções Estão Ativas

No Copilot Chat do VS Code:

```
1. Abra o Chat (Ctrl+Alt+I)
2. No canto superior direito do chat, clique no ícone de contexto (📎)
3. Verifique se "copilot-instructions.md" aparece nos documentos de contexto
```

---

## ✅ Pontos-chave do Capítulo

- `.github/copilot-instructions.md` é incluído automaticamente em todas as interações de Chat e Agent no repositório
- O arquivo pode existir em diferentes escopos: repositório, organização, usuário pessoal e enterprise
- Instruções específicas para subdiretórios se combinam com as instruções gerais do repo
- Seja específico e verificável — instruções vagas não mudam o comportamento do Copilot
- Exemplos negativos (❌) e positivos (✅) no arquivo são mais eficazes do que regras em prosa
- O arquivo não afeta completions inline — apenas Chat e Agent Mode

---

## 🔗 Próxima Aula

👉 [02 — Custom Agents com .agent.md](./02-custom-agents-agent-md.md)
