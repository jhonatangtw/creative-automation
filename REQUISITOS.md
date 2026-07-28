# Requisitos da máquina

Sem isso a skill instala mas falha ao rodar. Leva ~20 minutos na primeira vez.

---

## 1. Programas

| Item | Conferir com | Instalar |
|---|---|---|
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

### Premiere Pro + plugin Higgsfield — opcional

Só é necessário para montar a timeline. O MP4 final é gerado por ffmpeg e **não depende do Premiere**.

No Premiere: abrir o painel do **Higgsfield** e clicar em **Connect** em "Supercomputer Connection".

> **Atenção:** a conexão cai sozinha de vez em quando. Se a automação reclamar que o Premiere não responde, é só reconectar pelo painel.

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
