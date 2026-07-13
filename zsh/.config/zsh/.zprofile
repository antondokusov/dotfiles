if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Restore the canonical path order after Homebrew adds its own entries.
source "$ZDOTDIR/.zshenv"

if (( $+commands[mise] )); then
  eval "$(command mise activate zsh --shims)"
fi
