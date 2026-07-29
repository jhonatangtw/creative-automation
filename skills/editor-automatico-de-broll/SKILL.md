---
name: editor-automatico-de-broll
description: >-
  Edita um criativo UGC 9:16 a partir do BRUTO de um avatar falante (VSL/UGC/depoimento) em plano
  fixo — gera B-ROLL da MESMA pessoa em roupas diferentes no Higgsfield, encaixa os inserts nos
  pontos exatos da fala, aplica punch-ins pra quebrar o plano parado, e entrega legenda sincronizada
  + MP4 final + timeline no Premiere. Use SEMPRE que o usuário mandar um vídeo de avatar/talking head
  pronto e pedir "edita esse criativo", "coloca b-roll", "deixa dinâmico", "monta o AD", "edita o
  body", "faz a edição do criativo", "insere os inserts", "pega os brutos e deixa pronto", ou apontar
  uma pasta de demanda com body + avatar + copy. Aciona também para regerar um B-roll específico,
  mudar ponto de insert, corrigir legenda contra a copy, ou refazer o corte com mais/menos inserts.
  NÃO é para conferir criativos prontos (use conferir-ads-por-frame), nem para cortar silêncio de
  aula (use cortar-aula), nem para gerar prompts sem editar (use skill-black-belt).
---

# Editor Automático de B-roll

Recebe o **bruto** de um criativo (body de avatar falante em plano único) e devolve o criativo **editado**: B-roll gerado, inserts encaixados na fala, punch-ins, legenda e MP4 final.

**Princípio que rege tudo:** a alavanca é o **B-ROLL**, não o efeito. Um body de avatar é um plano travado de 2 minutos — o que segura retenção é ver a pessoa em outro lugar, com outra roupa, fazendo o que ela está narrando. Transição e efeito são enfeite e costumam denunciar a produção. **Corte seco é o padrão.**

---

## Entradas esperadas

| Item | Onde costuma estar | Obrigatório |
|---|---|---|
| Body (avatar falando) | `VIDEO DO BODY.mp4` na pasta da demanda | sim |
| Imagem do avatar | `ARQUIVOS BRUTO/*AVATAR*.jpeg` | sim (identidade do B-roll) |
| Vídeo de referência | `EXEMPLO*.mp4` | recomendado (define o estilo) |
| Copy | Google Docs / .docx | recomendado (corrige a legenda) |

Se faltar a referência, seguir o padrão UGC descrito em `references/estilo-ugc.md`.

---

## Fluxo

### 0. PERGUNTAR qual MCP usar — sempre, antes de qualquer coisa

Dois servidores falam com o Adobe. **Nunca escolher sozinho: perguntar ao usuário.**

Antes de perguntar, descobrir quais estão vivos — assim a pergunta vem com informação, não no escuro:

```
pr_midia_info      →  Tools PRO respondeu?
get_host_status    →  Higgsfield respondeu, com ppro: true?
```

Então perguntar, dizendo o que está no ar:

> **Qual MCP eu uso para operar o Premiere?**
> - **Tools PRO** — local, ~3 ms, sem login. Marcadores em lote, importar e montar timeline.
> - **Higgsfield** — nuvem, com login. Mais lento e já caiu no meio do trabalho, mas é o único que **gera** imagem e vídeo.

Ponto que precisa ficar claro na pergunta: **o B-roll é gerado no Higgsfield de qualquer jeito.** A escolha é só sobre quem *opera* a timeline. Dá para gerar no Higgsfield e montar no Tools PRO — costuma ser o melhor arranjo.

Se nenhum dos dois responder, **avisar e parar.** Nunca editar o `.prproj` direto — ver `armadilhas.md`.

Detalhes, ferramentas e travas em `references/mcp-premiere.md`. **Ler antes de escrever no Premiere.**

### 1. Ler o material antes de decidir qualquer coisa
```bash
ffprobe -v error -select_streams v:0 -show_entries stream=width,height,r_frame_rate \
  -show_entries format=duration -of default=noprint_wrappers=1 "<arquivo>"
# mosaico de frames do vídeo de REFERÊNCIA — é dele que sai a receita de estilo
ffmpeg -v error -i "<ref>.mp4" -vf "fps=1/5,scale=270:-1,tile=6x6" -frames:v 1 mosaico.jpg
```
Olhar o mosaico **de verdade**. Extrair: quanto tempo fica no talking head, quantos inserts, estilo/posição da legenda, se usa split screen, o que acontece no CTA.

Olhar também a imagem do avatar — ela define cenário, guarda-roupa e props que o B-roll precisa repetir.

### 2. Transcrever — **sem forçar idioma**
```bash
ffmpeg -v error -i body.mp4 -vn -ac 1 -ar 16000 -c:a pcm_s16le body.wav
whisper body.wav --model large-v3 --word_timestamps True --output_format json --output_dir ./
```
O body pode estar **em inglês mesmo com copy PT-BR no doc**. Forçar `--language pt` num áudio inglês produz lixo. A legenda segue o **ÁUDIO**, nunca a coluna do documento.

### 3. Mapear os inserts pela fala
Ler a transcrição e escolher **poucos** pontos (4–5 em ~2min). Critério único que importa: **casamento verbal-visual** — o insert entra no segundo em que a fala o descreve.

> "tive que trocar o guarda-roupa" → ela aparece **de outra roupa**
> "três colheres misturadas com..." → a receita sendo feita

Body de TTS não tem silêncio pra cortar (gaps de ~0,3s). **Não existe corte de tempo morto aqui** — não perder tempo procurando.

### 4. Gerar o B-roll (Higgsfield)
Detalhes e templates de prompt em `references/prompts-broll.md`.

```
media_upload → media_confirm  (imagem do avatar)
generate_image  model=nano_banana_pro, medias=[{role:image, value:<media_id>}], aspect_ratio=9:16
generate_video  model=kling3_0_turbo, medias=[{role:start_image, value:<job_id>}], 1080p
```
Custo: ~2 créditos/imagem, ~10/clipe de 5s. Preflight com `get_cost:true`.

**Roupas diferentes em cada B-roll** — lê como dias diferentes, que é o cheiro de UGC real. Manter cenário/props da imagem original em pelo menos um insert, pra ancorar a continuidade.

**Baixar e conferir frame a frame antes de montar.** Clipe de IA quebra no meio:
```bash
ffmpeg -v error -i clip.mp4 -vf "fps=1,scale=200:-1,tile=8x1" -frames:v 1 qa.jpg
```

### 5. Legenda
```bash
python3 scripts/legendas.py --json body.json --out AD01_legendas.srt \
        --overlay AD01_LEGENDAS.mov --dur <duracao>
```
Gera SRT em frases de 3–4 palavras + overlay ProRes 4444 com alpha (pílula branca, texto preto).

**Obrigatório antes de renderizar:** diffar o texto contra a copy do doc e corrigir nome de marca/produto. O Whisper acerta timing e erra nome próprio.
```bash
python3 scripts/conferir_legenda.py --srt AD01_legendas.srt --copy copy.txt
```

### 5b. Lettering animado (só quando pedido)
```bash
python3 scripts/lettering.py --config lettering.json --out LETTERING.mov --dur <duracao>
```
Tipografia grande com glow, pop-in com overshoot, em 2–3 falas de maior peso. Posição padrão `y=0.55` — acima da legenda (0.73) e abaixo do rosto, que num selfie 9:16 ocupa o terço superior.

**Regra que não pode ser esquecida:** suprimir a legenda nas janelas de lettering, senão o **mesmo texto aparece duas vezes na tela** (o lettering em cima e a legenda logo abaixo). Naquele beat o lettering *é* a legenda.
```bash
python3 scripts/legendas.py --srt legendas.srt --overlay LEGENDAS.mov --dur <dur> \
        --mute "5.90-8.10" --mute "70.30-72.30"
```

### 6. Montar e exportar
```bash
python3 scripts/montar.py --config edicao.json > build.sh && bash build.sh
```
O `montar.py` gera o ffmpeg com punch-ins, inserts e legenda. Formato do `edicao.json` em `references/config.md`.

Punch-ins com escalas **variadas** (110/112/114/116%) — escala igual em todas vira tique visível.

### 7. Conferir o resultado — sempre
```bash
for t in 3 11 26 47 68 84 120 130; do
  ffmpeg -v error -ss $t -i final.mp4 -frames:v 1 -vf scale=230:-1 f_$t.png -y; done
ffmpeg -v error -i f_3.png -i f_11.png ... -filter_complex hstack=8 -frames:v 1 qa.jpg
```
**Olhar a imagem.** Não reportar como pronto sem ter visto. Nesta skill já apareceram: vídeo inteiro magenta, efeito vazando pra todos os frames, legenda duplicada — todos invisíveis nos retornos de sucesso das ferramentas.

### 8. Montar no Premiere

Com o Tools PRO ligado, isto deixou de ser opcional: dá para entregar o projeto **editável**, que é melhor que um MP4 fechado — o editor troca um insert, testa outro hook.

**Sempre ler o estado imediatamente antes de escrever.** A sequência ativa muda quando o usuário clica noutra aba, e o estado de minutos atrás não vale.

```
pr_midia_info        →  confere projeto e sequência ativa
pr_midia_importar    →  {"arquivos":[...], "bin":"BROLL"}
pr_midia_listar      →  pega o nome EXATO de cada item
pr_timeline_colocar  →  {"sequencia":"<nome>", "clipes":[...]}   ← em lote
```

`pr_timeline_colocar` resolve **todos** os clipes antes de colocar qualquer um: se um nome estiver errado, nada entra. Timeline pela metade é pior que nada feito.

**Marcações** — `pr_marcadores_criar` aceita a lista inteira numa chamada. Vermelho = B-roll, azul = lettering, roxo = decisão humana. Marcador de **trecho** (com `duracao`), cobrindo a janela da fala.

**Punch-in** — `pr_zoom_aplicar` age sobre a **seleção**, então peça ao usuário para selecionar os clipes. Escalas variadas (110–116%).

**Tire o áudio do B-roll.** `pr_timeline_colocar` traz o áudio nativo junto, e ele briga com a voz do avatar:
```
pr_timeline_remover  →  {"sequencia":"<nome>", "tipo":"audio", "trilha":<n>}
```

**Confira lendo de volta — sempre.** `pr_timeline_listar` mostra o que existe em cada trilha. Não reportar como pronto sem ter lido: retorno de sucesso diz que a chamada não deu erro, não que o resultado está certo. Foi exatamente assim que o áudio de b-roll passou despercebido.

**Antes de qualquer coisa destrutiva**, rode com `simular: true` e mostre o número ao usuário. Não há desfazer pelo MCP.

> **Não rode `pr_autoclip` numa sequência anotada** — ele corta em todos os marcadores, inclusive nos de sugestão. Use `ignorarCores: [1,2,6]`.

---

## Decisões que já estão tomadas (não perguntar de novo)

- **Corte seco por padrão.** Não propor transição/flash/glitch. Se o usuário pedir, ver `references/armadilhas.md`.
- **Poucos inserts**, em ponto estratégico, não espalhados.
- Punch-in é de graça e resolve plano parado — usar em vez de gerar mais B-roll.
- O usuário finaliza transição e música de fundo no Premiere. Não fazer isso por ele.

---

## Se o bruto ainda não existe

A skill começa no body pronto. Para gerar o bruto a partir da copy (copy → áudio → lipsync), ver `references/heygen-lipsync.md`: HeyGen v3 com Avatar V, clone de voz no ElevenLabs, e o caminho alternativo pelo Higgsfield quando o HeyGen recusa a persona.

## Referências
- `references/mcp-premiere.md` — conectar e operar Premiere/AE, as travas e a convenção de cor. **Ler antes de escrever no Premiere.**
- `references/armadilhas.md` — falhas silenciosas do Premiere/ffmpeg/Whisper. **Ler antes de montar.**
- `references/heygen-lipsync.md` — gerar o bruto: TTS, clone de voz, lipsync e motores
- `references/prompts-broll.md` — templates de prompt de B-roll e modelos do Higgsfield
- `references/estilo-ugc.md` — o padrão visual UGC extraído da referência aprovada
- `references/config.md` — formato do `edicao.json`
