unsetopt BEEP
bindkey -e

HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

autoload -Uz compinit
# Homebrew's completion tree is user-owned but group-writable on this machine.
# Trust it explicitly so fresh shells never block on compaudit's prompt.
compinit -u
zmodload zsh/complist

# Match the previous completion palette and keep file-type colors neutral.
export LS_COLORS=''
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-colors \
  'no=38;2;32;32;32' \
  'fi=38;2;32;32;32' \
  'di=38;2;32;32;32' \
  'ln=38;2;32;32;32' \
  'pi=38;2;32;32;32' \
  'so=38;2;32;32;32' \
  'bd=38;2;32;32;32' \
  'cd=38;2;32;32;32' \
  'ex=38;2;32;32;32' \
  'ma=38;2;32;32;32;48;2;208;208;208'
zstyle ':completion:*:descriptions' format '%F{#888888}%d%f'
zstyle ':completion:*:warnings' format '%F{#b0b0b0}%d%f'

# The palette lives in the stowed fzfrc; discard the legacy rose-pine override.
unset FZF_DEFAULT_OPTS
if [[ -t 0 && -t 1 ]] && (( $+commands[fzf] )); then
  source <(fzf --zsh)
fi

if (( $+commands[wt] )); then
  eval "$(command wt config shell init zsh)"
fi

if (( $+commands[mise] )); then
  eval "$(command mise activate zsh)"
fi

lg() {
  command lazygit
}

autoload -Uz add-zsh-hook
_ascetic_prompt_precmd() {
  emulate -L zsh

  local directory=${PWD:t}
  [[ -n $directory ]] || directory=/
  directory=${directory//\%/%%}

  local branch
  branch=$(command git branch --show-current 2>/dev/null)
  branch=${branch//$'\n'/}
  branch=${branch//\%/%%}

  PROMPT="%F{#888888}${directory}${branch:+ (${branch})} > %f"
  RPROMPT='%F{#888888}%D{%H:%M:%S}%f'
}
add-zsh-hook precmd _ascetic_prompt_precmd

# zoxide recommends initialization at the end of the interactive config.
if (( $+commands[zoxide] )); then
  eval "$(command zoxide init zsh)"
fi
