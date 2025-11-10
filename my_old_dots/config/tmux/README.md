# tmux · Red Hood Neon

Status minimalista integrado ao visual do Kitty (tabs preferenciais). Ícones curtos, sem relógio ou bateria, com bloco opcional mostrando as tabs atuais do Kitty via remote control.

## Requisitos
- tmux 3.x com truecolor: `set -as terminal-overrides ",*:RGB"`.
- Nerd Font monoespaçada (GeistMono Nerd Font ou JetBrainsMono Nerd Font).
- Kitty com `allow_remote_control yes` e `listen_on unix:/tmp/kitty` (já definido no `kitty.conf`).
- `jq` instalado para o script de sincronização.

## Arquivos
| Caminho | Função |
|--------|--------|
| `~/.config/tmux/tmux.conf` | Theme principal (status, bordas, mensagens). |
| `bin/redhood-kitty-tabs`   | Script que consulta `kitty @ ls` e devolve `KIT NN título`. |
| `~/.config/tmux/variants/compact.conf` *(opcional)* | Variante sem o bloco esquerdo estendido. |
| `~/.config/tmux/variants/contrast.conf` *(opcional)* | Variante com fundo #000 e acentos neon mais fortes. |

## Como usar
1. Garante que `~/dotfiles/bin` esteja no `PATH`.
2. No Kitty, abre tmux e recarrega: `tmux source-file ~/.config/tmux/tmux.conf`.
3. Para alternar estilos: `tmux source-file ~/.config/tmux/variants/compact.conf` etc.

## Atalhos úteis
- `<prefix> r` — recarrega o tema e mostra toast.
- `s` / `w` — escolhem sessões/janelas nas interfaces padrão do tmux (sem FZF).

## Solução de problemas
- **Segmento “KIT” não aparece** → verifique `kitty @ ls` (Kitty precisa estar rodando e permitir remote control). Sem Kitty, o segmento some automaticamente.
- **Tofu nos ícones** → confirme a Nerd Font escolhida no terminal.
- **Truecolor sem efeito** → confirme `tmux info | grep RGB`.

## Inspiração visual
- Batcomputer / Batcave HUDs (Arkham Knight, BvS).
- Neon outline do logo (ver `config/kitty/backgrounds/user_neon_filled.svg`).
