# Editor Automático de B-roll

Automação de edição de criativo UGC 9:16 da **H&W Publishing**. Roda no Claude Code dentro do VS Code e opera o Premiere Pro do editor.

Validada em produção nos criativos **AD01** e **AD05** do LeafTide.

📘 **[MANUAL-DO-TIME.md](MANUAL-DO-TIME.md)** — instalação, comandos e o que fazer quando trava.

**Comandos:** `/marcar-vsl` · `/broll-narrativo` · `/fechar-lacunas` · `/conferir-broll`

---

## O que ela resolve

Um body de avatar gerado por IA é um **plano fixo de 2 a 3 minutos**. Mesma pessoa, mesmo enquadramento, do primeiro ao último frame. Sem edição, a retenção cai nos primeiros 15 segundos.

O que segura o espectador é insert. E aí aparece o gargalo real: **o B-roll que esse criativo precisa não existe em banco de imagem.**

A avatar está numa cozinha que não existe — cenário gerado. Não há stock com "mãos dosando matchá naquela mesa, com aquele chasen e aquele cartão de receita". O editor tem três saídas: gravar (impossível, o set é fictício), usar stock genérico que não casa, ou não colocar insert.

**A automação gera o B-roll sob medida para aquele cenário.**

---

## Instalação

### 1. Instalar o plugin

> **Precisa de git.** O comando abaixo clona um repositório — sem git ele falha com
> `Command 'git' not found`. Confira com `git --version`; se faltar:
> macOS `xcode-select --install` · Windows `winget install Git.Git` (e reabra o VS Code).

Dentro do Claude Code:

```
/plugin marketplace add jhonatangtw/creative-automation
/plugin install editor-broll@hw-creative
```

> Repositório privado: o editor precisa ter acesso de leitura no GitHub e estar autenticado (`gh auth login`).

Confira com `/skills` — `editor-automatico-de-broll` deve aparecer.

### 2. Preparar a máquina

Ver **[REQUISITOS.md](REQUISITOS.md)**. Sem isso a skill instala mas falha ao rodar.

### 2b. Conectar o Premiere

Ver **[SETUP-MCP.md](SETUP-MCP.md)**.

São **dois** servidores, e eles somam. O **Tools PRO** roda dentro do painel do Editor Black Belt, em `127.0.0.1`, sem login — é quem opera a timeline, e leva 2 minutos para ligar. O **Higgsfield** é nuvem, precisa de conector no claude.ai, e é o único que **gera** imagem e vídeo.

Comece pelo Tools PRO: é o que não trava. O `invalid_request: redirect_uri` é exclusivo do Higgsfield — o Tools PRO não tem OAuth.

Para diagnosticar: `bash diagnostico.sh`

### 3. Usar

Ver **[COMO-USAR.md](COMO-USAR.md)**.

Para pedir marcações: **[como-pedir-marcacoes.md](skills/editor-automatico-de-broll/references/como-pedir-marcacoes.md)** — o prompt pronto, o que muda o resultado e o checklist de instalação.

---

## Atualizar

```
/plugin marketplace update hw-creative
```

Toda correção entra aqui e chega em todo mundo. As armadilhas descobertas em produção — Premiere em português quebrando a API, dois projetos abertos corrompendo a escrita, `blend` deixando o vídeo magenta — estão documentadas e versionadas.

---

## O que ela entrega

Um **projeto do Premiere editável**, não um MP4 fechado. O editor abre, ajusta, troca um insert, testa outro hook.

Números reais dos dois criativos já feitos:

| | AD01 | AD05 |
|---|---|---|
| Clipes de B-roll gerados | 7 | 4 |
| Punch-ins | 4 | 5 |
| Legenda | 122 blocos | 141 blocos |
| Lettering | 3 blocos | 3 blocos |
| Marcadores citando a copy | 12 | 15 |

**Tempo medido:** os 4 inserts do AD05 levaram **10 min 59 s**, do primeiro frame ao último clipe baixado. Somando transcrição, lettering, timeline e marcações: **~25 minutos**, boa parte em paralelo.

**Custo:** ~180 créditos Higgsfield entre os dois criativos.

---

## O que ela NÃO faz

- **Não gera semelhança de pessoa real.** Figura pública em anúncio é impersonação.
- **Não fabrica registro** — print de conversa, perfil de rede, depoimento de terceiro.
- **Não decide compliance.** Sinaliza os gatilhos conhecidos do Meta (antes/depois em emagrecimento, equivalência a medicamento, uso de figura pública), mas quem sobe decide.
- **Não escala para centenas de variações.** Para volume alto, ferramenta de prateleira resolve melhor.
- **Não tem retorno de performance.** Não sabe qual criativo converteu. É a maior lacuna atual.

---

## Regras de estilo já decididas

Vieram de teste comparativo, não de preferência:

- **Corte seco.** Sem transição, sem flash. Em UGC, transição denuncia produção.
- **Poucos inserts**, em casamento verbal-visual: o clipe entra no segundo em que a fala o descreve.
- **Roupa diferente em cada B-roll.** Lê como dias diferentes — é o que dá cheiro de UGC real.
- **Legenda no caso da copy**, não em caixa alta.
- **Punch-in com escalas variadas** (110–116%). Escala igual em todas vira tique visível.
- Transição e música de fundo são finalização humana no Premiere.

---

## Roadmap — um formato, uma skill

A operação trabalha com cinco formatos. Cada um vira uma skill separada neste repo, não uma skill gigante que tenta fazer tudo.

| Formato | Estado |
|---|---|
| **Criativos** | ✅ `editor-automatico-de-broll` — validada em AD01 e AD05 |
| **Troca de potes** | ⬜ próximo candidato — provavelmente o mais automatizável, por ser substituição mecânica |
| **Microleads** | ⬜ |
| **Lead** | ⬜ |
| **VSL** | ⬜ existem skills de *análise* de VSL, mas nenhuma de edição |

Para adicionar um formato: criar a pasta em `skills/`, listar em `.claude-plugin/marketplace.json`, bumpar a versão em `plugin.json` e registrar no `CHANGELOG.md`.

**Como um formato novo é aprendido:** mostrando um job **já feito** — material de entrada, saída final e o `.prproj` se existir. O processo é deduzido do material, não de explicação escrita. Foi assim que a skill de criativo pegou o padrão de legenda, o ritmo de insert e o estilo de corte.

## Estrutura do repositório

```
.claude-plugin/     metadados do plugin e do marketplace
skills/
  editor-automatico-de-broll/
    SKILL.md              o fluxo em 8 passos
    references/           armadilhas, prompts, estilo, config, lipsync
    scripts/              legendas, lettering, montagem, conferência
  photorealism-prompts/   gramática de prompt usada na geração
```
