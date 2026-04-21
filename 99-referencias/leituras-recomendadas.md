# 📚 Leituras Recomendadas

> Livros, papers, posts e repositórios para aprofundar os temas do curso. Organizados por nível e tema.

---

## Livros

### Fundamentos de IA para Desenvolvedores

**"A Practical Guide to Building Ethical AI"**
Aborda tomada de decisão responsável no desenvolvimento de sistemas com IA. Complementa o capítulo 00 sobre ética.

**"The Alignment Problem" — Brian Christian (2020)**
Explora os desafios de alinhar sistemas de IA com intenções humanas. Essencial para entender por que limitações e revisão humana importam.

**"Working Effectively with Legacy Code" — Michael Feathers (2004)**
O livro que originou a técnica de testes de caracterização usada no Projeto 03. Técnicas atemporais para lidar com código sem testes — ainda mais relevante com IA acelerando a geração de código.

**"The Pragmatic Programmer" — Hunt & Thomas (20th Anniversary Edition)**
Fundamentos de craft de software que se tornam ainda mais importantes quando IA gera código: nomenclatura, responsabilidade única, testes, automação.

### Agentes e Sistemas de IA

**"Designing Machine Learning Systems" — Chip Huyen (2022)**
Cobre o ciclo de vida de sistemas de ML em produção. Relevante para o capítulo 04 sobre agentes e o capítulo 10 sobre governança organizacional.

---

## Papers Acadêmicos

### Produtividade de Desenvolvedores com IA

**"The Impact of AI on Developer Productivity: Evidence from GitHub Copilot" (Peng et al., 2023)**
Estudo controlado mostrando 55,8% de aceleração em tarefas de código com Copilot. Primeira evidência empírica sólida de impacto em produtividade.
> arxiv.org/abs/2302.06590

**"Communicating with Incompletely Specified Agents" (Perez et al., 2022)**
Sobre os desafios de comunicação entre humanos e agentes de IA com objetivos parcialmente definidos. Contexto teórico para o capítulo de context engineering.

### Segurança em Agentes de IA

**"Not What You've Signed Up For: Compromising Real-World LLM-Integrated Applications with Indirect Prompt Injection" (Greshake et al., 2023)**
Demonstração prática de ataques de prompt injection em sistemas reais. Leitura obrigatória para o capítulo de segurança.
> arxiv.org/abs/2302.12173

**"ReAct: Synergizing Reasoning and Acting in Language Models" (Yao et al., 2022)**
O paper original do padrão ReAct que fundamenta a maioria dos frameworks de agentes modernos.
> arxiv.org/abs/2210.03629

---

## Posts e Artigos

### Context Engineering

**"Context Engineering for AI Agents" — Anthropic (2025)**
Visão detalhada da Anthropic sobre context engineering — o que é, como difere de prompt engineering e por que importa.
> anthropic.com/research

**"What is Context Engineering?" — Lilian Weng (2024)**
Análise técnica profunda de context engineering, incluindo RAG, memory management e tool use.
> lilianweng.github.io

### Agentes e Automação

**"Building Effective Agents" — Anthropic (2024)**
Guia prático da Anthropic sobre como construir agentes confiáveis — padrões de design, quando usar agentes, quando não usar.
> anthropic.com/research/building-effective-agents

**"Agents" — Chip Huyen (2025)**
Visão abrangente sobre agentes de IA em produção: arquiteturas, ferramentas, desafios de confiabilidade.
> huyenchip.com

### Prompting

**"Prompt Engineering Guide" — DAIR.AI**
Guia comunitário com técnicas de prompting, exemplos e pesquisa recente. Atualizado regularmente.
> promptingguide.ai

---

## Repositórios e Recursos Online

### MCP

| Repositório | Descrição |
|------------|-----------|
| `modelcontextprotocol/servers` | Coleção oficial de servidores MCP prontos para uso |
| `modelcontextprotocol/typescript-sdk` | SDK oficial TypeScript para criar servidores MCP |
| `modelcontextprotocol/python-sdk` | SDK oficial Python para criar servidores MCP |

### Exemplos e Referências de Código

| Repositório | Descrição |
|------------|-----------|
| `anthropics/anthropic-cookbook` | Exemplos práticos de uso da API Anthropic com casos reais |
| `github/gh-copilot` | Código-fonte da extensão Copilot CLI |
| `awesome-mcp-servers` | Lista curada de servidores MCP da comunidade |

---

## Cursos e Treinamentos Complementares

**"Prompt Engineering for Developers" — DeepLearning.AI + OpenAI**
Curso gratuito e técnico sobre prompt engineering para devs. Bom complemento prático ao capítulo 01.
> deeplearning.ai

**"Building Systems with the ChatGPT API" — DeepLearning.AI**
Apesar do nome, cobre conceitos aplicáveis a qualquer LLM: chains, agentes, avaliação. Complementa o capítulo 04.
> deeplearning.ai

**"LangChain for LLM Application Development" — DeepLearning.AI**
Introdução a frameworks de agentes. Útil para quem quer ir além das ferramentas cobertas neste curso.
> deeplearning.ai

---

## Podcasts

**"The TWIML AI Podcast" (This Week in Machine Learning)**
Entrevistas semanais com pesquisadores e praticantes de IA. Bom para manter-se atualizado.

**"Latent Space" — swyx & Alessio**
Foco em builders de produtos de IA. Cobre ferramentas, arquiteturas e tendências. Especialmente relevante para desenvolvedores.

**"Practical AI" — Changelog Media**
Aplicações práticas de IA — menos teoria, mais como as coisas funcionam no mundo real.

---

## Comunidades

| Comunidade | Onde | Foco |
|-----------|------|------|
| Anthropic Discord | discord.gg/anthropic | Claude, Claude Code, MCP |
| GitHub Community | github.community | Copilot, Actions, Discussions |
| r/LocalLLaMA | reddit.com/r/LocalLLaMA | Modelos open source e self-hosted |
| AI Engineer Foundation | aieng.community | IA para engenheiros de software |

---

## Para se Manter Atualizado

O campo de IA para desenvolvimento evolui muito rapidamente. Acompanhe:

```
📰 Changelogs e release notes:
- docs.anthropic.com/en/release-notes
- github.blog (Copilot updates)
- modelcontextprotocol.io (MCP spec updates)

🔔 Newsletters:
- The Batch (deeplearning.ai) — semanal, técnico e acessível
- TLDR AI — resumo diário de notícias de IA
- Latent Space Newsletter — foco em builders de produto

📺 YouTube:
- Anthropic (canal oficial) — demos e tutoriais
- GitHub (canal oficial) — Copilot updates e tutoriais
```
