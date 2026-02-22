$env.EDITOR = 'nvim'
$env.config.show_banner = false

$env.JAVA_HOME = '/opt/homebrew/opt/openjdk@17'

source ~/.config/nushell/secrets.nu

def lg [] {
  lazygit
}

def ana [] {
  rm pubspec.lock
  fvm flutter pub get
  fvm dart run build_runner build --delete-conflicting-outputs
  ./scripts/generate_localisation_keys.sh
  ./scripts/format.sh
  fvm flutter analyze
  # let result = fvm flutter analyze
  # osascript -e 'display notification "$result"'
}

def anatest [] {
  try { fvm flutter analyze }
  osascript -e 'display notification "Analysis complete"'
}

$env.config.keybindings = [
  {
      name: "fuzzy file search"
      modifier: control
      keycode: char_t
      mode: "emacs"
      event: [
        {
          send: "ExecuteHostCommand"
          # cmd: "commandline edit --insert (ls **/* | input list --fuzzy -d name | $in.name)"
          cmd: "commandline edit --insert (tv files)"
        }
      ]
  },
  {
      name: "history search"
      modifier: control
      keycode: char_r
      mode: "emacs"
      event: [
        {
          send: "ExecuteHostCommand"
          cmd: "commandline edit --insert (tv nu-history)"
        }
      ]
  }
]

zoxide init nushell | save -f ~/.zoxide.nu
source ~/.zoxide.nu
