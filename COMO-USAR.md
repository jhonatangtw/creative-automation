# Como usar, dentro do VS Code

---

## 1. Montar a pasta do job

A automação espera esta estrutura. Ela cria as pastas se você pedir.

```
[DATA][OT] NN_XX [Produto] [Squad]/
├── 01_BRUTOS/
│   ├── AVATAR/        a imagem da persona
│   ├── AUDIO/         hook1, hook2, hook3, body  (se for gerar o lipsync)
│   ├── COPY/          a copy aprovada  ← NÃO É OPCIONAL
│   └── REFERENCIA/    vídeo de exemplo do estilo (opcional, ajuda muito)
├── 02_GERADO/
│   ├── LIPSYNC/       saída do HeyGen
│   ├── BROLL/         inserts gerados
│   └── OVERLAYS/      legenda e lettering .mov
├── 03_PROJETO/        .prproj, edicao.json, .srt
└── 04_ENTREGA/        MP4 finais
```

**A regra:** o que entra fica em `01`, o que a IA produz fica em `02`, o que sai fica em `04`. Dá para apagar o `02` inteiro e regerar sem perder nada insubstituível.

### Por que a COPY não é opcional

É ela que permite conferir a legenda palavra por palavra. Sem ela, sai a transcrição crua do Whisper — que erra justamente as palavras que mais importam.

Erros reais já pegos por essa conferência: **"MANJARO"** onde a copy diz *Mounjaro*, **"macho"** onde diz *matchá*, e a palavra *Mounjaro* sumindo por completo de um bloco.

---

## 2. Abrir o projeto do Premiere

**Você cria e abre o projeto**, dentro de `03_PROJETO/`. A automação não cria projeto — e é assim de propósito: só quando o projeto é do job ela pode salvar sem risco de escrever no arquivo de outro trabalho.

> **Deixe apenas UM projeto aberto.** Com dois, o plugin passa a escrever no projeto errado — bins e clipes vão parar em outro job. É a falha mais cara do fluxo.

---

## 3. Pedir

No VS Code, abra o Claude Code e aponte a pasta:

```
edita o criativo dessa pasta: /caminho/para/[DATA][OT] NN_XX [Produto] [Squad]
```

Não precisa de comando especial. A skill é acionada pelo pedido.

Outras formas que funcionam:

- *"coloca b-roll nesse body e deixa dinâmico"*
- *"faz as marcações desse criativo conforme a copy"*
- *"legenda o AD03 e deixa cru que eu estilizo"*
- *"gera os hooks com lipsync a partir desses áudios"*

---

## 4. O que vai acontecer

1. Lê os vídeos e extrai mosaico de frames da referência para deduzir o estilo
2. Transcreve o áudio com timestamp por palavra
3. **Mostra o mapa de inserts antes de executar** — é aqui que você aprova ou ajusta
4. Gera o B-roll (pergunta antes de gastar crédito)
5. Monta a timeline: inserts, punch-ins, overlays
6. Legenda conferindo contra a copy
7. Marca a timeline com o que a copy exige em cada trecho
8. Confere frame a frame antes de dizer que terminou

---

## 5. Ler as marcações

Abra o marcador na timeline: ele traz **a fala literal** e **a instrução do brief**.

```
COPY EXIGE — mostrar a amiga
Fala: "A close friend of mine was one of the first to try this recipe
AND JUST LOOK AT HOW SHE LOOKS TODAY". A copy manda MOSTRAR.
Sem imagem aqui a frase fica órfã.
```

Prefixos:

| Prefixo | O que é |
|---|---|
| `OK` | Já montado |
| `COPY EXIGE` | A copy pede imagem aqui |
| `SUGESTÃO B-ROLL` | Oportunidade não coberta |
| `SUGESTÃO LETTERING` | Frase forte sem reforço |
| `CTA` | Fecho |
| `ATENÇÃO` | Precisa de conferência humana |

> Os marcadores aparecem comprimidos se a timeline estiver com zoom aberto. Tecle `\` para enquadrar.

---

## 6. Quando alguma coisa der errado

| Sintoma | O que fazer |
|---|---|
| *"Não tenho ferramenta de controle ao vivo do Premiere"* | Falta o conector. Ver [REQUISITOS.md](REQUISITOS.md) — precisa do conector Higgsfield no claude.ai **e** do painel conectado no Premiere. Conferir com `get_host_status` → `ppro: true` |
| Claude oferece editar o `.prproj` ou gerar CSV de marcadores | Mesmo problema acima. **Recuse a edição direta do `.prproj`** com o projeto aberto — o Premiere sobrescreve ao salvar |
| "Premiere não está conectado" | Abrir o painel do Higgsfield no Premiere e clicar em Connect |
| Clipe entrou na timeline errada | Fechar todos os projetos menos um e refazer |
| Legenda com nome de marca errado | Colocar a copy em `01_BRUTOS/COPY/` e pedir a conferência |
| Whisper parece travado | Está baixando o modelo de 3 GB, só na primeira vez |
| Geração recusada | Se for figura pública, é bloqueio de propósito |

---

## 7. O que revisar antes de subir

A automação sinaliza, mas não decide:

- **Antes/depois** em criativo de emagrecimento — o Meta proíbe
- **Equivalência a medicamento** ("como Mounjaro", "efeito de cirurgia bariátrica")
- **Figura pública** sem autorização
- **Imagem contradizendo a fala** — já apareceu hook dizendo *"estou de pijama"* com a avatar de camisa social
- **Áudio divergindo da copy aprovada** — já apareceu frase inteira trocada no material gravado
