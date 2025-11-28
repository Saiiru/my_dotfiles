# 🦇 Batman Stack — Workstation DRAGON-OPS

Ambiente de desenvolvimento + jogos para Arch/Wayland, focado em produtividade (DEV/QA/DevOps) com estética Batcave + Night City.

> Diretório raiz: `~/workstation`  
> Nada aqui mexe no NixOS (pasta `nixos/` é ignorada).

---

## Visão Geral

| Módulo          | Caminho                            | Função                                                                           |
|-----------------|------------------------------------|----------------------------------------------------------------------------------|
| **mise**        | `config/mise/mise.toml`            | Toolchain global (Node, Python, Go, Java 11, Maven/Gradle, Rust) + tasks QA/dev. |
| **Zsh**         | `config/zsh/…`                     | Shell modular (env/options/completion/keybinds/plugins/prompt).                  |
| **Prompt**      | `config/zsh/prompt/bat_hud.zsh`    | HUD 2 linhas: user/host, path, git, stack detectada (Java/Node/Go/Rust/Python…). |
| **Templates**   | `templates/java-batman-api`        | Template Spring Boot 3 + Java 11 + Maven + healthcheck + compose opcional.       |
| **Templates**   | `templates/java-batman-api`, `templates/java-svc` | Template Maven local e overlay Batman (docker/env/ops) para Spring Boot.          |
| **Scaffolding** | `bin/bat-new-project`, `bin/bat_init_stack`, `bin/bat_init_java` | Gera projetos (template local) e Initializr de console (Java/Node + Postgres).   |
| **Binários**    | `bin/`                             | Scripts auxiliares (ex.: `bat-new-project`, `bat_init_stack`, `bat_init_java`).   |
| **Ignore**      | `.gitignore`                       | Ignora caches, node_modules, target, venv, e também `nixos/`.                    |

---

## Requisitos Rápidos

* Arch/Wayland (Kitty + Zsh + tmux recomendados).
* `mise` instalado (antigo `rtx`).
* `tmux`, `git`, `curl`, `unzip` (para scaffolding Java).
* Docker + docker-compose para subir Postgres nos templates.

---

## Toolchain (mise)

Principais linguagens/ferramentas (definidas em `config/mise/mise.toml`):

| Linguagem/Tool | Versão          |
|----------------|-----------------|
| Node.js        | LTS             |
| Python         | 3.12            |
| Go             | latest          |
| Java           | 11              |
| Maven / Gradle | latest          |
| Rust           | stable          |

Tasks úteis:

| Task                  | Comando                    | Descrição                                             |
|-----------------------|----------------------------|-------------------------------------------------------|
| bootstrap             | `mise run bootstrap`       | Instala/atualiza toda a toolchain.                    |
| update-tools          | `mise run update-tools`    | Atualiza para versões novas compatíveis.              |
| dev-shell             | `mise run dev-shell`       | Abre tmux `dev` com Zsh + mise.                       |
| qa-check              | `mise run qa-check`        | Git status, Docker info, pre-commit (se houver).      |
| {java,node,go,python,rust}-env | `mise run <lang>-env` | Mostra infos básicas do ambiente.                     |

---

## Zsh (HUD do Batman)

Arquitetura modular em `config/zsh/`:

| Arquivo/dir                  | Papel                                               |
|------------------------------|-----------------------------------------------------|
| `config.d/10-env.zsh`        | XDG, PATH, locale, histórico em XDG.                |
| `config.d/20-options.zsh`    | Opções seguras (nonomatch, no_beep, notify, hist).  |
| `config.d/30-completions.zsh`| compinit cacheado, matcher case-insensitive.        |
| `config.d/40-keybinds.zsh`   | Emacs + navegação por palavra, fzf em Ctrl+T.       |
| `aliases.zsh`                | Git/Docker/K8s/linguagens; `bdev` => `bat_dev`.     |
| `functions.zsh`              | `bat_dev`, `bat_project_root`, checks de env, `groot`. |
| `plugins.zsh`                | autosuggestions, syntax highlighting, completions, history-substring-search, fzf. |
| `prompt/bat_hud.zsh`         | Prompt 2 linhas: user/host, path, git, stack; RPROMPT = hora. |

Prompt atual (exemplo em repo git):
```
┌──(sairu 󰭟 batcomputer)-[~/workstation] -[ main! ?] -[ Java]
└─λ
```
Stack só aparece se detectar manifest (pom.xml, package.json, go.mod, Cargo.toml, pyproject/req/.venv, Dockerfile/compose, SQL, C/CPP via CMake/meson).

---

## Scaffolding de Projetos

### Script
`bin/bat-new-project`
* Stack suportada: `java-api` (Spring Boot 3 + Java 11 + Maven).
* Uso:
```bash
bat-new-project java-api gotham-api --group com.sairu.gotham
```
* Faz:
  - Copia template `templates/java-batman-api`.
  - Substitui groupId/artifactId/package.
  - Ajusta packages Java e README.
  - Informa próximos passos.

### Template Java
`templates/java-batman-api`
* Spring Boot 3.3.4, Java 11, Maven.
* Healthcheck `/api/v1/health`.
* `.mise.toml` por projeto (java/maven + tasks build/test/run/dev/init).
* Compose opcional: crie seu próprio `docker-compose.yml` se quiser DB (já há `db/init.sql` placeholder no template base).

### Próximos passos pós-scaffold
```bash
cd gotham-api
mise install
mise run init
mise run dev   # sobe em http://localhost:8080/api/v1/health
```

### Initializr de Terminal (Java/Node + Postgres)
`bin/bat_init_stack` e `bin/bat_init_java`
* Stacks: Java Spring Boot (via start.spring.io) ou Node Express.
* Cria projeto já com `db/init.sql` e `docker-compose.yml` (Postgres).
* Uso:
```bash
bat_init_stack my-service          # interativo: escolhe stack e deps
STACK=java-spring bat_init_stack gotham-api
STACK=node-express bat_init_stack nightwatch-api
bat_init_java                      # opção focada em Spring, com overlay Batman (docker/env/ops)
```
* Requisitos extras: `curl`, `unzip` (Java), `npm`, `jq`, `docker`/`compose` para subir o DB.

---

## Estrutura do Repo

```
workstation/
  bin/
    bat-new-project       # scaffold de projetos
    ...                   # outros scripts globais
  config/
    mise/mise.toml        # toolchain global
    zsh/                  # shell modular + prompt Bat HUD
    ...                   # kitty, niri, quickshell, etc.
  templates/
    java-batman-api/      # template Spring Boot
  scratch/                # área livre (gitignore)
  icons/ themes/ wallpapers/ scripts/
  nixos/                  # ignorado (não versionar)
```

---

## Como começar (checklist)

1) Instalar toolchain global:
```bash
cd ~/workstation
mise run bootstrap
```
2) Abrir shell dev:
```bash
mise run dev-shell   # tmux + zsh + mise
```
3) Criar novo backend Java:
```bash
bat-new-project java-api gotham-api --group com.sairu.gotham
cd gotham-api
mise install
mise run init
mise run dev
```
Ou usar o Initializr:
```bash
bat_init_stack gotham-api   # escolhe stack (Java/Node) e deps; cria compose + init.sql
```
4) Prompt/HUD:
```bash
source ~/workstation/config/zsh/prompt/bat_hud.zsh
```
5) tmux:
   - `prefix + r`: reload do tmux.conf
   - `F11`: abre nova janela com `bat_init_stack`
   - `F12`: abre nova janela com `mise run dev-shell`

---

## Notas

* `nixos/` continua ignorado pelo git.
* Não mexemos em Neovim aqui.
* Para stacks extras (Node/Go/etc.) basta criar novos templates em `templates/` e expandir `bat-new-project`.
