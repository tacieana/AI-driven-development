---
name: nome-da-skill
description: Uma frase descrevendo o que esta skill faz — aparece no /help
---

# Título da Skill

> Instrução de contexto breve: quem é o Claude nesta skill, qual o objetivo.

---

## Contexto

[Informações sobre o projeto que são relevantes especificamente para esta skill.
Pode referenciar o CLAUDE.md para não duplicar.]

---

## Tarefa

[Descrição clara e específica do que deve ser feito.
Use listas numeradas para passos sequenciais.
Use bullets para itens não-ordenados.]

### Passo 1 — [Nome do passo]

[O que fazer. Inclua comandos quando aplicável:]

```bash
[comando a executar]
```

### Passo 2 — [Nome do passo]

[Continuação]

---

## Argumentos

Se esta skill recebe argumentos, documente aqui:

- `$ARGUMENTS` — [o que o argumento representa e como é usado]
- Exemplo: `/nome-da-skill src/meu-arquivo.py`

Se não há argumentos, remova esta seção.

---

## Formato de Saída

[Descreva o formato esperado da resposta. Exemplo:]

Para cada [item], retorne:
- **Campo 1:** [descrição]
- **Campo 2:** [descrição]

Termine com um resumo: [N itens encontrados / N ações executadas / etc.]

---

## Critério de Conclusão

[Como o Claude sabe que terminou? O que define "feito" para esta skill?]

- [ ] [Critério 1]
- [ ] [Critério 2]

---

## Exemplos de Uso

```bash
# Sem argumentos
/nome-da-skill

# Com argumento
/nome-da-skill src/payments/handler.py

# Com múltiplos argumentos (se aplicável)
/nome-da-skill src/ tests/
```
