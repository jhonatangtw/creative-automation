# Manual do time — Automação de criativo H&W

Como instalar e como usar. Escrito para quem vai **operar**, não para quem construiu.

---

## O que a automação faz

Duas frentes, escolhidas pelo tipo de material que você tem na mão:

| Você tem | Use | O que sai |
|---|---|---|
| Body de avatar falando, plano fixo | `editor-broll` | Criativo editado com inserts, punch-in e legenda |
| Só a locução (VSL cantada, storytelling longo) | `broll-narrativo-pixar` | O criativo inteiro em imagem, do 0 ao fim |

A segunda é a nova. Validada no **AD04 Crowned** — 10:54 de VO cantada viraram 151 planos gerados,
animados e montados, cobrindo 100% da timeline.

---

## Instalação

### 1. Requisitos

| Item | Como conferir | Se faltar |
|---|---|---|
| **git** | `git --version` | macOS `xcode-select --install` · Windows `winget install Git.Git` e **reabra o VS Code** |
| **ffmpeg** | `ffmpeg -version` | macOS `brew install ffmpeg` · Windows `winget install Gyan.FFmpeg` |
| **Python 3** | `python3 --version` | macOS já vem · Windows `winget install Python.Python.3.12` |
| **Premiere Pro** | aberto com o projeto | — |
| **Painel Tools PRO** | aberto dentro do Premiere | pedir ao Jhon |
| **CLI Higgsfield** | `higgsfield account status` | `npm i -g @higgsfield/cli && higgsfield auth login` |

Só para gerar imagem/vídeo: CLI do Higgsfield.
**Marcar a timeline é 100% local** — não precisa de Higgsfield nem de chave de API.

### 2. Instalar o plugin

Dentro do Claude Code:

```
/plugin marketplace add jhonatangtw/creative-automation
/plugin install editor-broll@hw-creative
```

### 3. Conferir

```
bash diagnostico.sh
```

E dentro do Claude Code, confirme que o Premiere responde:

```
Confere se o Tools PRO está on e qual projeto está aberto
```

---

## Comandos

### `/marcar-vsl <sequência> [link da copy]`

Marca a timeline a partir da locução. **Não gera imagem** — é a etapa barata e a que mais evita
retrabalho.

```
/marcar-vsl "body AD04" https://docs.google.com/document/d/...
```

Saem marcadores de trecho, numerados em ordem, cobrindo a janela real da fala:

| Cor | Tipo | O que é |
|---|---|---|
| 🔴 vermelho | `B-ROLL` | imagem a criar — sem buraco na timeline |
| 🔵 azul | `LETTERING` | texto/cartela na tela |
| 🟣 roxo | `COPY` | precisa da sua decisão |

**Os roxos são o valor da marcação.** Eles apontam conflito entre hook e corpo da copy, nome real
citado (risco de imagem), claim sensível e trecho que a copy tem mas não foi gravado.

> ⚠️ **O nome da sequência tem que ser exato.** Foi o que já custou 17 marcadores perdidos num job
> real. Copie da aba do Premiere.

### `/broll-narrativo <sequência>`

A pipeline inteira. Ela **para em dois portões** e espera seu OK:

1. **Marcadores** — você confere a marcação e resolve os roxos.
2. **Bíblia de elenco** — você aprova quem são os personagens, os cenários e o arco visual antes de
   qualquer imagem ser gerada.

Só depois ela gera, confere, anima e monta. Ela te diz o custo estimado antes de disparar.

### `/fechar-lacunas <sequência>`

Preenche os buracos de cobertura. Gera **só o que falta** — não refaz o que já está bom.

### `/conferir-broll <pasta ou sequência>`

QC do que foi gerado: colagem de painéis, rotação, letterbox, continuidade de elenco e do arco
visual, texto queimado, e conferência técnica com ffprobe.

---

## Como pedir bem

Três coisas mudam mais o resultado do que qualquer outra:

**1. Diga o nome exato da sequência.** Sem isso a automação marca a sequência errada ou não acha
nada.

**2. Mande a copy.** Ela corrige erro de transcrição e revela o que foi escrito mas não gravado.
Em VO cantada isso é decisivo — a transcrição perde trechos sob a música.

**3. Descreva o elenco uma vez, com detalhe.** Idade, rosto, roupa e um adereço fixo (anel, brinco,
cardigã). É o adereço que faz o espectador reconhecer o personagem entre planos distantes.

Exemplo de pedido bom:

> Marca a sequência "body AD04". A copy tá no doc [link]. A protagonista é uma avó de 59 anos,
> cabelo branco ralo com entradas no começo e cheio no fim. Tem o neto de 6 anos, a filha de 32,
> o marido e a irmã. Referência visual é Pixar 3D.

---

## Quanto custa

| Item | Créditos |
|---|---|
| Imagem (Nano Banana Pro, 2k, 9:16) | 2 |
| Vídeo (Seedance 2.0, 720p, 5s) | 22,5 |

Um criativo de 11 minutos com cobertura total ≈ **151 planos ≈ 3.700 créditos**.

**Marcar não custa nada** — é local.

> ⚠️ A conta do Higgsfield é compartilhada. Para medir o gasto de um job, anote o saldo antes e
> depois **e confira o extrato**: outra pessoa pode estar gerando ao mesmo tempo.

---

## Quando algo trava

**"O host não respondeu em 120s"** — **não é erro.** É o Premiere ainda trabalhando. Espere e peça
para ler o estado. **Nunca mande repetir**: retentativa empilha trabalho, trava o Premiere e pode
desfazer o que já foi feito.

**Premiere a 100% de CPU depois de importar muito arquivo** — está conformando. Espere. O projeto
em disco já está salvo, não se perde montagem.

**Vídeo aparece pequeno com borda** — é escala. Vídeo 720×1280 numa sequência 1080×1920 precisa de
150%. Peça para "aplicar a escala e ler de volta", ou resolva na mão: seleciona tudo na V1 → botão
direito → *Definir tamanho do quadro*.

**Higgsfield devolvendo 401** — o conector MCP expirou. O **CLI** tem login próprio e continua
valendo; peça para usar o CLI.

**O personagem mudou de cara no meio** — a bíblia de elenco não foi colada literal em algum plano.
Peça para regerar aquele plano com a âncora exata.

**O plano não mostra o defeito que a copy narra** — o gerador embeleza. Peça **ângulo alto sobre a
região**; retrato frontal não carrega essa informação.

---

## Onde ficam as coisas

```
skills/broll-narrativo-pixar/
├── SKILL.md                      o fluxo e os portões
├── references/
│   ├── armadilhas.md             tudo que já deu errado, e o porquê
│   ├── elenco-e-ancoras.md       o modelo da bíblia de elenco
│   ├── marcacao.md               formato, cores e cobertura
│   ├── geracao-imagem.md         modelos, travas e regra do ângulo
│   └── premiere.md               limites e leitura de volta
└── scripts/
    ├── transcrever.py            VO → tempo de timeline
    ├── qc_colagem.py             detector de colagem/rotação
    ├── animar_seedance.py        imagem → vídeo
    ├── montar_broll.py           importar, posicionar, escalar, conferir
    └── cep.py                    ExtendScript no Premiere
```

---

## Uma regra que vale para tudo

**Retorno de sucesso não prova resultado.** Toda etapa termina lendo o estado de volta: quantos
marcadores, quantos clipes, qual cobertura, qual escala, quantos offline.

Foi lendo de volta que se descobriu que o `setScaleToFrameSize()` retornava OK sem alterar nada, e
que 60 clipes tinham voltado para 100% depois de já terem sido ajustados.
