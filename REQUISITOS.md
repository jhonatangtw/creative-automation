# Requisitos da máquina

Sem isso a skill instala mas falha ao rodar. Leva ~20 minutos na primeira vez.

---

## 0. Git — instale ANTES de tudo

O `/plugin marketplace add` **clona um repositório**. Sem git, a instalação para no primeiro passo com esta mensagem:

```
Failed to add marketplace: Failed to clone marketplace repository:
Command 'git' not found or is in an unsafe location
```

| | |
|---|---|
| Conferir | `git --version` |
| macOS | `xcode-select --install` |
| Windows | `winget install Git.Git` — ou https://git-scm.com |

**No Windows, feche e reabra o VS Code depois de instalar.** O PATH só é lido em processo novo, então o Claude Code continua sem enxergar o git até reiniciar.

---

## 1. Programas

| Item | Conferir com | Instalar |
|---|---|---|
| **Git** | `git --version` | ver seção 0 acima |
| **Claude Code** | `claude --version` | https://claude.com/claude-code |
| **Extensão do VS Code** | ícone do Claude na barra lateral | busque "Claude Code" nas extensões |
| **ffmpeg / ffprobe** | `ffmpeg -version` | mac: `brew install ffmpeg`<br>win: `winget install ffmpeg` |
| **Python 3** | `python3 --version` | mac já vem<br>win: https://python.org |
| **Pillow** | `python3 -c "import PIL"` | `pip3 install Pillow` |
| **Whisper** | `whisper --help` | `pip3 install openai-whisper` |

### Baixe o modelo do Whisper antes do primeiro job

O `large-v3` tem **~3 GB** e baixa na primeira execução. Se rodar o primeiro criativo já com prazo, vai parecer que travou.

```bash
whisper --model large-v3 --help
```

---

## 2. Contas e conectores

### Higgsfield — obrigatório

É quem gera o B-roll. Conectar no **claude.ai → Settings → Connectors**, **com a conta e os créditos do próprio editor**.

Custo real medido: ~2 créditos por imagem, ~10 por clipe de 5 s em 1080p. **Um criativo completo sai por ~60 créditos.**

### Um caminho até o Premiere — OBRIGATÓRIO para timeline e marcadores

Sem isto, a automação **não coloca insert e não escreve marcador**. Ela só consegue gerar B-roll, legenda e o MP4 final por ffmpeg.

Há **dois** caminhos, e o mais simples é o novo:

**Tools PRO (recomendado)** — Editor Black Belt Tools PRO **1.2.0+**. Painel → **Conectar IA** → **Ligar** → colar o comando no terminal. Sem login, sem OAuth, roda em `127.0.0.1`. Ele **opera** a timeline: marcadores em lote, importar mídia, montar, punch-in.

**Higgsfield** — as mesmas operações, pela nuvem. Precisa do conector no claude.ai **e** do painel com Connect pressionado no Premiere. Mais lento e cai sozinho às vezes.

> Ter os dois é o ideal, porque **o B-roll só é gerado pelo Higgsfield**. O arranjo usual é gerar nele e montar no Tools PRO.

**Como confirmar:** peça *"lê o projeto do Premiere"*. Deve voltar o nome do projeto e da sequência ativa.

Sintomas de que está faltando:

- *"Não tenho uma ferramenta de controle ao vivo do Premiere nesta sessão"*
- O Claude tenta ler ou editar o `.prproj` diretamente, ou oferecer CSV de marcadores

> **Nunca deixe editar o `.prproj` com o projeto aberto no Premiere.** O Premiere sobrescreve o arquivo ao salvar e o trabalho é perdido.

> **A conexão cai sozinha.** Já caiu duas vezes numa sessão. Se a automação reclamar que o Premiere não responde no meio do trabalho, é só reconectar pelo painel — nada se perde.

> **Deixe apenas UM projeto aberto.** Com dois, o plugin escreve no projeto errado — bins e clipes vão parar em outro job.

### HeyGen e ElevenLabs — só para gerar o bruto do zero

Se o body já existe, não precisa. Se for gerar do zero (copy → áudio → lipsync), criar:

```bash
mkdir -p ~/.config/hw-creative
cat > ~/.config/hw-creative/.env <<'EOF'
ELEVENLABS_API_KEY=
HEYGEN_API_KEY=
EOF
chmod 600 ~/.config/hw-creative/.env
```

Abrir o arquivo, colar os valores depois do `=`, sem aspas e sem espaço.

> **Nunca cole chave de API no chat.** Fica gravada no histórico da conversa. Se acontecer, rotacione a chave.

---

## 3. Fonte

Os scripts de legenda e lettering procuram uma fonte bold automaticamente, nesta ordem:

- **macOS:** Arial Rounded Bold, Arial Bold, Arial Black
- **Windows:** `ARLRDBD.TTF`, `arialbd.ttf`, `ariblk.ttf`
- **Linux:** DejaVu Sans Bold, Liberation Sans Bold

Se nenhuma existir, dá para passar o caminho de uma `.ttf` com `--font`.

---

## 4. Checagem rápida

Cole no terminal — mostra o que falta:

```bash
for c in claude ffmpeg ffprobe python3 whisper; do
  command -v $c >/dev/null && echo "ok    $c" || echo "FALTA $c"
done
python3 -c "import PIL" 2>/dev/null && echo "ok    Pillow" || echo "FALTA Pillow"
```
