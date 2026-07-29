#!/usr/bin/env bash
# Diagnostico de instalacao — Editor Automatico de B-roll
# Roda: bash diagnostico.sh
# NAO imprime valor de nenhuma chave de API. Pode colar a saida em qualquer lugar.
set -u

ok=0; falta=0
linha() { printf '%s\n' "------------------------------------------------------------"; }
check() {
  if command -v "$1" >/dev/null 2>&1; then
    printf "  ok     %-12s %s\n" "$1" "$( $2 2>&1 | head -1 | cut -c1-48 )"; ok=$((ok+1))
  else
    printf "  FALTA  %-12s -> %s\n" "$1" "$3"; falta=$((falta+1))
  fi
}

echo "============================================================"
echo " DIAGNOSTICO — Editor Automatico de B-roll"
echo " $(date '+%Y-%m-%d %H:%M')"
echo "============================================================"

echo; echo "SISTEMA"; linha
printf "  SO           %s\n" "$(uname -s) $(uname -r)"
printf "  arquitetura  %s\n" "$(uname -m)"

echo; echo "PROGRAMAS"; linha
check claude   "claude --version"    "https://claude.com/claude-code"
check ffmpeg   "ffmpeg -version"     "mac: brew install ffmpeg | win: winget install ffmpeg"
check ffprobe  "ffprobe -version"    "vem junto com o ffmpeg"
check python3  "python3 --version"   "https://python.org"
check whisper  "whisper --help"      "pip3 install openai-whisper"
check git      "git --version"       "https://git-scm.com"

if python3 -c "import PIL" 2>/dev/null; then
  printf "  ok     %-12s %s\n" "Pillow" "$(python3 -c 'import PIL;print(PIL.__version__)')"; ok=$((ok+1))
else
  printf "  FALTA  %-12s -> %s\n" "Pillow" "pip3 install Pillow"; falta=$((falta+1))
fi

echo; echo "MODELO DO WHISPER"; linha
if [ -d "$HOME/.cache/whisper" ] && [ -n "$(ls -A "$HOME/.cache/whisper" 2>/dev/null)" ]; then
  ls -1sh "$HOME/.cache/whisper" 2>/dev/null | tail -n +2 | sed 's/^/  /'
else
  echo "  NENHUM modelo baixado."
  echo "  Baixe ANTES do primeiro job (large-v3 tem ~3 GB):"
  echo "     whisper --model large-v3 --help"
fi

echo; echo "FONTE PARA LEGENDA E LETTERING"; linha
python3 - <<'PY' 2>/dev/null || echo "  nao consegui checar (python3 ausente)"
import os
c=["/System/Library/Fonts/Supplemental/Arial Rounded Bold.ttf",
   "/System/Library/Fonts/Supplemental/Arial Black.ttf",
   "/System/Library/Fonts/Supplemental/Arial Bold.ttf",
   "C:/Windows/Fonts/ARLRDBD.TTF","C:/Windows/Fonts/ariblk.ttf","C:/Windows/Fonts/arialbd.ttf",
   "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
   "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf"]
achadas=[p for p in c if os.path.exists(p)]
if achadas:
    for p in achadas: print("  ok    ", p)
else:
    print("  NENHUMA fonte bold encontrada — passe --font com o caminho de uma .ttf")
PY

echo; echo "SERVIDORES MCP LOCAIS"; linha
echo "  ESPERADO: toolspro-pr (e toolspro-ae, se usa After Effects)."
echo "  O Higgsfield NAO deve aparecer aqui — ele e conector do claude.ai."
echo "  Ver SETUP-MCP.md"
if command -v claude >/dev/null 2>&1; then
  claude mcp list 2>/dev/null | sed 's/^/  /' || echo "  (nao consegui listar)"
else
  echo "  (claude nao instalado)"
fi

echo; echo "SKILLS INSTALADAS"; linha
D="$HOME/.claude/skills"
if [ -d "$D" ]; then
  ls -1 "$D" 2>/dev/null | sed 's/^/  /'
  [ -d "$D/editor-automatico-de-broll" ] \
    && echo "  --> editor-automatico-de-broll PRESENTE" \
    || echo "  --> editor-automatico-de-broll AUSENTE"
else
  echo "  pasta $D nao existe"
fi

echo; echo "PLUGINS"; linha
P="$HOME/.claude/plugins/installed_plugins.json"
[ -f "$P" ] && python3 -c "
import json
d=json.load(open('$P')).get('plugins',{})
print('\n'.join('  '+k+'  '+(v[0].get('version','?') if isinstance(v,list) and v else '?') for k,v in d.items()) or '  nenhum')
" 2>/dev/null || echo "  nenhum plugin instalado"

echo; echo "CHAVES DE API (só presença, nunca o valor)"; linha
E="$HOME/.config/hw-creative/.env"
if [ -f "$E" ]; then
  awk -F= '/^[A-Z]/{printf "  %-22s %s\n", $1, (length($2)>0 ? "preenchida" : "VAZIA")}' "$E"
  printf "  permissao do arquivo: %s (deve ser 600)\n" "$(ls -l "$E" | awk '{print $1}')"
else
  echo "  $E nao existe"
  echo "  So e necessario para gerar o bruto do zero (HeyGen/ElevenLabs)"
fi

echo; linha
printf " RESUMO: %d ok, %d faltando\n" "$ok" "$falta"
if [ "$falta" -gt 0 ]; then
  echo " Instale o que esta como FALTA antes de rodar a automacao."
fi
echo
echo " Falta ainda, fora deste script:"
echo "   1. Tools PRO: painel no Premiere -> Conectar IA -> Ligar -> colar o comando"
echo "   2. Higgsfield (so pra GERAR b-roll): conector no claude.ai, NAO via 'claude mcp add'"
echo "   3. Reiniciar o Claude Code depois de registrar"
echo " Ver SETUP-MCP.md"
linha
