# Conectar o Premiere ao Claude Code

Existem **dois** servidores que falam com o Adobe. Eles fazem coisas diferentes, e o ideal é ter os dois.

| | **Tools PRO** | **Higgsfield** |
|---|---|---|
| Onde roda | dentro do painel, na sua máquina | nuvem |
| Login | **nenhum** | conector no claude.ai |
| Velocidade | ~3 ms | centenas de ms; cai sozinho às vezes |
| Opera a timeline | ✅ marcadores, importar, montar, punch-in | ✅ |
| **Gera** imagem e vídeo | ❌ | ✅ **só ele** |

**Comece pelo Tools PRO.** É o que não trava. O Higgsfield entra depois, e só é necessário para gerar B-roll.

---

## Tools PRO — 2 minutos, sem login

**1.** Instale o Editor Black Belt Tools PRO (versão **1.1.0** ou superior) e abra o Premiere.

**2.** Abra o painel: *Janela → Extensões → Editor Black Belt Tools PRO*.

**3.** No rodapé, clique em **Conectar IA** → **Ligar**. A bolinha fica verde.

**4.** Clique em **Copiar comando** e cole no terminal:

```
claude mcp add --transport http toolspro-pr http://127.0.0.1:7842/mcp --header "Authorization: Bearer <seu token>"
```

**5.** Reinicie o Claude Code. Servidores MCP carregam no início da sessão.

**6.** Confirme pedindo: *"lê o projeto do Premiere"*. Deve voltar o nome do projeto e da sequência ativa.

Pronto. **O comando é uma vez só** — o token não vence e sobrevive a fechar o Premiere. O servidor volta sozinho quando você reabre o app.

### After Effects

Mesma coisa, com o painel aberto no AE. Ele usa a porta **7843** e o nome `toolspro-ae` — o próprio painel monta o comando certo. São dois registros separados de propósito: assim um pedido para o AE vai para o AE.

### Se der errado

| Sintoma | O que é |
|---|---|
| O botão não aparece no rodapé | Versão anterior à 1.1.0. Atualize pelo botão dourado no topo do painel |
| Clicou em Ligar e não ficou verde | A porta 7842 está ocupada. Feche outras instâncias do Premiere |
| O comando colou mas o Claude não vê as ferramentas | Falta reiniciar o Claude Code |
| Funcionava e parou | Confira se o painel continua aberto — o servidor mora dentro dele |

---

## Higgsfield — necessário para gerar B-roll

Aqui existem dois caminhos, e **só um funciona**.

| | Conector no claude.ai | `claude mcp add` |
|---|---|---|
| Onde autentica | domínio da Anthropic | **em `localhost:<porta>`** |
| Funciona? | ✅ **sim** | ❌ **não** |

### Por que o caminho local falha

O `claude mcp add` sobe um servidor local (`localhost:4204`, a porta muda a cada tentativa) e pede ao Higgsfield que redirecione o login para lá. O cliente OAuth deles **não tem endereços de localhost cadastrados**:

```
invalid_request: redirect_uri
```

**Trocar de porta não resolve. Repetir não resolve.** Falha em qualquer máquina.

> Esse erro é **exclusivo do Higgsfield**. O Tools PRO não tem OAuth — não há para onde redirecionar.

### O caminho que funciona

**1.** Se já tentou o caminho local, remova: `claude mcp remove higgsfield`

**2.** No Premiere, abra o painel **Higgsfield**, em "How to connect" clique em **Copy**. A URL é:

```
https://bridge.higgsfield.ai/mcp
```

> Existe outra parecida (`mcp.higgsfield.ai`). **Não é essa.**

**3.** `claude.ai` → **Settings** → **Connectors** → **Add custom connector** → colar → autenticar.

**4.** No Premiere: painel Higgsfield → **Connect**. Tem que ficar **Live**, bolinha verde.

**5.** Confirme com `get_host_status` → `{"ppro": true}`.

---

## O arranjo recomendado

**Gerar no Higgsfield, montar no Tools PRO.** O Higgsfield faz o que só ele faz — imagem e vídeo. O Tools PRO monta a timeline sem latência e sem cair no meio.

Se o Higgsfield cair durante o trabalho, o que já foi montado continua lá.

> A automação **sempre pergunta** qual usar antes de começar. Se você não tem preferência, responda "Tools PRO para montar, Higgsfield para gerar".

---

## Nunca

**Não deixe o Claude editar o `.prproj` com o projeto aberto no Premiere.** O Premiere sobrescreve o arquivo ao salvar e o trabalho é perdido. É a saída que ele oferece quando não tem conexão, e é destrutiva.

Se nenhum servidor estiver ligado, a saída certa é ligar um — não improvisar.

---

## Diagnóstico

```bash
bash diagnostico.sh
```

Reporta versões, dependências e servidores MCP, sem expor nenhuma chave. Mande a saída junto com um print do painel.
