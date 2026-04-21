# Aula 04 — LM Studio e Interfaces Gráficas

## Objetivo

Usar o LM Studio como alternativa com interface gráfica ao Ollama para quem prefere um ambiente visual, e conhecer outras opções de interface disponíveis para modelos locais.

---

## LM Studio

LM Studio é uma aplicação desktop com interface gráfica para rodar modelos de linguagem localmente. Ele integra download de modelos diretamente do Hugging Face, um chat interativo, playground de parâmetros e um servidor local compatível com a API OpenAI.

**Ideal para quem:**
- Prefere interface gráfica a linha de comando
- Quer explorar e comparar modelos visualmente
- Precisa ajustar parâmetros de inferência (temperature, top-p, context length) com feedback imediato
- Quer expor um servidor local para ferramentas externas sem configurar o Ollama

### Instalação

Baixe o instalador para macOS, Windows ou Linux em lmstudio.ai. Não requer configuração adicional — basta instalar e abrir.

> 📌 **Referência:** lmstudio.ai — site oficial com instaladores e documentação

### Download de Modelos

O LM Studio integra busca diretamente no Hugging Face. Na aba **Discover**, você pode pesquisar modelos por nome, filtrar por tamanho e ver qual quantização cabe no seu hardware:

1. Abra a aba **Discover**
2. Busque `qwen2.5-coder`
3. Selecione a quantização recomendada (LM Studio indica qual cabe na sua RAM/VRAM)
4. Clique em Download

### Funcionalidades Principais

| Funcionalidade | O que faz |
|---------------|-----------|
| **Chat** | Interface de conversa com histórico, similar ao ChatGPT |
| **Playground** | Modo prompt direto com controle de parâmetros em tempo real |
| **Parâmetros** | Sliders para temperature, top-p, context length, repeat penalty |
| **Multi-model chat** | Comparar respostas de dois modelos lado a lado |
| **Servidor local** | API OpenAI-compatible em localhost:1234 |
| **Logs** | Visualizar tokens gerados, velocidade e uso de memória |

---

## Configurar o Servidor Local

O LM Studio pode expor um servidor REST local compatível com a API OpenAI — o mesmo formato do Ollama, mas na porta `1234` por padrão.

**Para ativar:**

1. Carregue um modelo (aba **Chat** ou **Local Server**)
2. Abra a aba **Local Server**
3. Clique em **Start Server**
4. O servidor fica disponível em `http://localhost:1234`

```bash
# Testando o servidor do LM Studio
curl http://localhost:1234/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen2.5-coder-7b",
    "messages": [{"role": "user", "content": "Hello"}],
    "stream": false
  }'
```

Qualquer ferramenta configurada para apontar para `http://localhost:1234` funciona automaticamente — Continue, scripts Python/Node.js com SDK OpenAI, etc.

> 📌 **Referência:** lmstudio.ai/docs/local-server — documentação do servidor local

---

## Comparativo: LM Studio vs Ollama

| Aspecto | LM Studio | Ollama |
|---------|-----------|--------|
| **Interface** | GUI completa | Terminal / API |
| **Facilidade inicial** | ✅ Mais fácil para iniciantes | ⚠️ Requer familiaridade com CLI |
| **Controle de parâmetros** | ✅ Sliders visuais | ⚠️ Via Modelfile ou API |
| **Automação e scripts** | ⚠️ Menos prático | ✅ Ideal para automação |
| **Uso em CI/CD** | ❌ Não adequado | ✅ Headless, scriptável |
| **Velocidade de setup** | ✅ Instalação e uso imediato | ✅ Também rápido |
| **Descoberta de modelos** | ✅ Busca integrada no HuggingFace | ✅ Ollama Library |
| **Modelfiles (customização)** | ❌ Não suporta | ✅ Suporte completo |
| **Uso em servidor remoto** | ❌ App desktop | ✅ Pode rodar headless em servidor |
| **Múltiplos modelos simultâneos** | ⚠️ Um por vez | ✅ `ollama ps` mostra carregados |

**Quando usar LM Studio:** exploração, comparação visual de modelos, uso pessoal interativo.
**Quando usar Ollama:** automação, integração com ferramentas, servidores, CI/CD.

---

## Outras Opções de Interface

### Jan.ai

Interface desktop open source similar ao LM Studio, com foco em privacidade e extensibilidade. Suporta plugins e modelos customizados.

| Aspecto | Jan.ai |
|---------|--------|
| Backend | Nitro (baseado em llama.cpp) |
| Plataformas | macOS, Windows, Linux |
| Diferencial | Open source completo, extensível via plugins |
| Ideal para | Quem quer LM Studio mas prefere código aberto |

> 📌 **Referência:** github.com/janhq/jan

### GPT4All

Foco em execução totalmente local e privada. Interface simples, sem recursos avançados, mas muito leve.

| Aspecto | GPT4All |
|---------|---------|
| Backend | llama.cpp, nomic-gpt4all |
| Diferencial | Extremamente leve, focado em privacidade |
| Ideal para | Hardware muito limitado ou uso ocasional |

> 📌 **Referência:** gpt4all.io

### Open WebUI

Interface web que serve como frontend para o Ollama. Permite que toda uma equipe acesse o mesmo servidor Ollama com uma UI similar ao ChatGPT, via navegador.

| Aspecto | Open WebUI |
|---------|-----------|
| Tipo | Web app (Docker) |
| Backend | Ollama (ou OpenAI-compatible) |
| Acesso | Multi-usuário via navegador |
| Diferencial | Ideal para times — um servidor, muitos usuários |

> 📌 **Referência:** github.com/open-webui/open-webui

---

## Open WebUI + Ollama: Stack para Times

Combinação popular para equipes pequenas que querem um modelo compartilhado sem cada dev precisar rodar localmente:

```yaml
# docker-compose.yml
services:
  ollama:
    image: ollama/ollama
    volumes:
      - ollama_data:/root/.ollama
    ports:
      - "11434:11434"
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]

  open-webui:
    image: ghcr.io/open-webui/open-webui:main
    environment:
      - OLLAMA_BASE_URL=http://ollama:11434
    ports:
      - "3000:8080"
    volumes:
      - webui_data:/app/backend/data

volumes:
  ollama_data:
  webui_data:
```

```bash
# Subir a stack
docker compose up -d

# Baixar o modelo no servidor
docker exec ollama ollama pull qwen2.5-coder:7b

# Acessar a UI
# http://localhost:3000
```

**Vantagens para times:**
- Um servidor GPU compartilhado em vez de cada dev precisar de hardware potente
- Interface familiar para quem vem do ChatGPT
- Histórico de conversas por usuário
- Administração centralizada de quais modelos estão disponíveis

> 📌 **Referência:** github.com/open-webui/open-webui — documentação completa de configuração

---

## Pontos-Chave

- **LM Studio** é o melhor ponto de entrada para quem prefere interface gráfica — download, chat e servidor local em um só lugar
- **Ollama é mais versátil para automação** — scriptável, headless, ideal para CI/CD e integração com ferramentas
- **Open WebUI + Ollama** é a stack recomendada para times que querem um servidor compartilhado
- O servidor local de ambas (LM Studio em `:1234`, Ollama em `:11434`) usa o mesmo formato de API OpenAI — as ferramentas são intercambiáveis

---

## Próxima Aula

👉 [Aula 05 — Integrando com o Fluxo de Desenvolvimento](./05-integrando-com-o-fluxo-de-desenvolvimento.md)
