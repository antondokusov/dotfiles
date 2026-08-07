export SHELL=/bin/zsh
export EDITOR=nvim
export VISUAL=nvim

export JAVA_HOME=/opt/homebrew/opt/openjdk@17
export ANDROID_HOME="$HOME/android_sdk"
export FZF_DEFAULT_OPTS_FILE="$HOME/.config/fzf/fzfrc"

typeset -U path PATH
path=(
  "$HOME/.local/bin"
  "$HOME/.local/share/mise/shims"
  "$ANDROID_HOME/emulator"
  "$ANDROID_HOME/platform-tools"
  "$ANDROID_HOME/cmdline-tools/latest/bin"
  "$HOME/.pub-cache/bin"
  /opt/homebrew/bin
  $path
)
export PATH

if [[ -r "$ZDOTDIR/secrets.zsh" ]]; then
  source "$ZDOTDIR/secrets.zsh"
fi
