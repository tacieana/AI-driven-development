# 📝 Exercícios — Capítulo 00: Fundamentos

> Consolide os conceitos aprendidos com exercícios práticos e reflexivos. Não há respostas únicas corretas — o objetivo é desenvolver seu raciocínio crítico sobre o uso de IA.

---

## 🧠 Exercício 01 — Mapeando sua Posição Atual

**Objetivo:** Identificar onde você está hoje no espectro AI-Assisted → AI-Driven.

**Tarefa:**

Reflita sobre sua semana de trabalho mais recente. Para cada situação, marque como você utilizou IA (se utilizou):

| Situação de desenvolvimento | Não usei IA | AI-Assisted (consulta pontual) | AI-Driven (ciclo contínuo) |
|-----------------------------|:-----------:|:------------------------------:|:--------------------------:|
| Escrever nova funcionalidade | | | |
| Debugar um erro | | | |
| Escrever testes | | | |
| Fazer code review | | | |
| Escrever documentação | | | |
| Refatorar código existente | | | |
| Aprender nova tecnologia | | | |

**Reflexão:**
1. Em quais áreas você já usa IA de forma mais avançada?
2. Em quais áreas você usa menos do que poderia?
3. O que está impedindo uso mais amplo? (conforto, política, ferramenta, etc.)

---

## 🤝 Exercício 02 — Calibrando o Mental Model de Pair Programmer

**Objetivo:** Praticar a calibração de nível de detalhe no prompt.

**Tarefa:** Escreva dois prompts para a mesma tarefa — um "junior" e um "senior". Depois, se possível, teste ambos em Claude ou Copilot e compare os resultados.

**Tarefa a prompar:** *"Criar uma função que valida um endereço de email"*

**Prompt Junior (antes):**
```
[Escreva seu prompt "junior" aqui]
```

**Prompt Senior (depois):**
```
[Escreva seu prompt "senior" aqui — inclua:
 - Linguagem/runtime específico
 - Comportamento esperado para entradas inválidas
 - Se deve validar apenas o formato ou também o domínio
 - Tipo de retorno esperado
 - Restrições de dependências]
```

**Reflexão após testar:**
- O segundo prompt produziu resultado melhor de primeira?
- Quantas iterações cada um precisou?
- O que você incluiria da próxima vez que não incluiu agora?

---

## 🔤 Exercício 03 — Calculando Tokens

**Objetivo:** Desenvolver intuição sobre uso de tokens.

**Tarefa:** Estime o número de tokens (aproximação) e depois verifique usando o tokenizador da Anthropic (platform.anthropic.com/tokenizer) ou OpenAI.

| Texto | Sua Estimativa | Resultado Real |
|-------|----------------|----------------|
| `print("Hello, World!")` | | |
| `def authenticate_user(email: str, password: str) -> Optional[User]:` | | |
| Um arquivo Python de 100 linhas de código típico | | |
| Um README.md de 500 palavras | | |
| Este exercício inteiro | | |

**Reflexão:**
- Você superestimou ou subestimou?
- Para um modelo com 200k tokens de contexto, quantos arquivos de código médio cabem?

---

## 🎭 Exercício 04 — Detectando Alucinações

**Objetivo:** Desenvolver o olho crítico para identificar outputs incorretos.

**Parte A — Teste Controlado:**

Faça os seguintes prompts para um LLM e avalie a resposta:

```
1. "Qual é o método Python para remover o primeiro elemento de uma lista 
   mantendo os outros — além de pop(0)?"
   
   [Verifique: existe tal método? A IA pode sugerir algo que não existe]
```

```
2. "Qual é a sintaxe para fazer um LEFT JOIN em SQL e retornar apenas 
   as linhas onde a tabela direita é NULL?"
   
   [Verifique a sintaxe gerada — é correta? Funciona?]
```

```
3. "Gere código Python para fazer requisições HTTP usando a biblioteca 'httpx', 
   usando o método client.get() com timeout de 30 segundos"
   
   [Verifique na documentação oficial do httpx se os parâmetros estão corretos]
```

**Parte B — Reflexão:**
- Em quantos casos a IA produziu algo incorreto?
- O código incorreto parecia plausível?
- Como você detectou o erro?

---

## ⚖️ Exercício 05 — Calibrando Nível de Autonomia

**Objetivo:** Praticar a classificação de tarefas pelo nível de autonomia adequado.

**Tarefa:** Para cada tarefa abaixo, defina:
- **Nível de autonomia:** Alta / Supervisionada / Controle Humano
- **Justificativa:** Por quê?

| Tarefa | Autonomia | Justificativa |
|--------|-----------|---------------|
| Gerar docstrings para funções existentes | | |
| Criar migration SQL que adiciona coluna em tabela com 10M de registros | | |
| Refatorar nomes de variáveis em um arquivo de utilitários | | |
| Implementar lógica de cálculo de impostos | | |
| Gerar arquivo de configuração Docker para ambiente de dev | | |
| Criar query que deleta registros duplicados | | |
| Gerar testes unitários para uma função pura | | |
| Implementar OAuth2 do zero | | |
| Renomear um diretório de assets estáticos | | |
| Alterar lógica de desconto em sistema de e-commerce | | |

---

## 🔒 Exercício 06 — Avaliação Ética de Cenário

**Objetivo:** Aplicar o framework de ética e responsabilidade em cenários reais.

**Cenário:** Você está desenvolvendo uma feature de cadastro de usuários. Usa o Copilot para gerar a função de validação e inserção no banco. O código gerado funciona nos seus testes. Você está prestes a fazer o commit.

**Perguntas:**

1. **Sobre segurança:** Liste 3 verificações de segurança específicas que você faria antes do commit.

2. **Sobre dados pessoais:** O formulário coleta nome, CPF e data de nascimento. O código gerado loga esses dados em caso de erro. O que você faria?

3. **Sobre propriedade intelectual:** O código gerado parece muito semelhante a um trecho de um projeto open source famoso que você conhece. Como você investigaria? O que faria se confirmado?

4. **Sobre responsabilidade:** Um bug nesta feature causa cadastros duplicados e o cliente reclama. Quem é responsável: você, a empresa, ou a ferramenta de IA?

---

## 🗺️ Exercício 07 — Plano de Adoção Pessoal

**Objetivo:** Criar um plano concreto de como você vai mudar sua prática.

**Tarefa:** Complete o template abaixo:

```markdown
## Meu Plano de Adoção de AI-Driven Development

### Minha situação atual:
- Ferramentas que já uso: [liste]
- Nível de uso atual: [AI-Assisted / Iniciando AI-Driven]
- Principal bloqueio: [conhecimento / ferramenta / política / conforto]

### 3 mudanças que vou implementar nos próximos 30 dias:
1. [Mudança específica e mensurável]
2. [Mudança específica e mensurável]  
3. [Mudança específica e mensurável]

### Métricas de sucesso:
- Como vou saber que estou progredindo?

### Riscos e mitigações:
- Risco 1: [ex: aceitar código sem revisar] → Mitigação: [checklist de revisão]
- Risco 2: [...]
```

---

## ✅ Auto-Avaliação do Capítulo

Antes de seguir para o próximo capítulo, confirme que você consegue:

- [ ] Explicar a diferença entre AI-Assisted e AI-Driven em suas próprias palavras
- [ ] Identificar qual mental model aplicar para diferentes tipos de tarefa
- [ ] Calcular aproximadamente quantos tokens um arquivo de código usa
- [ ] Listar 3 tipos de alucinação e como detectá-los
- [ ] Classificar tarefas por nível de autonomia adequado
- [ ] Identificar pelo menos 3 tipos de dados que nunca devem ser enviados para ferramentas de IA
- [ ] Descrever o processo de revisão mínimo que você aplicaria a código gerado por IA

---

## 🔗 Próximo Capítulo

Se você completou os exercícios e se sente confortável com os conceitos:

👉 [Capítulo 01 — Prompt Engineering](../01-prompt-engineering/01-principios-fundamentais.md)
