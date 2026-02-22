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

$env.PROMPT_COMMAND = {|| $"(ansi { fg: '#888888' })(pwd | path basename)(ansi reset)" }
$env.PROMPT_INDICATOR = {|| $"(ansi { fg: '#888888' }) > (ansi reset)" }
$env.PROMPT_COMMAND_RIGHT = {|| $"(ansi { fg: '#888888' })(date now | format date '%H:%M:%S')(ansi reset)" }

$env.config.color_config = {
    shape_block: { fg: '#202020' }
    shape_bool: { fg: '#202020' }
    shape_custom: { fg: '#202020' }
    shape_external: { fg: '#202020' }
    shape_externalarg: { fg: '#202020' }
    shape_filepath: { fg: '#202020' }
    shape_flag: { fg: '#202020' }
    shape_float: { fg: '#202020' }
    shape_globpattern: { fg: '#202020' }
    shape_int: { fg: '#202020' }
    shape_internalcall: { fg: '#202020' }
    shape_list: { fg: '#202020' }
    shape_literal: { fg: '#202020' }
    shape_nothing: { fg: '#202020' }
    shape_operator: { fg: '#202020' }
    shape_pipe: { fg: '#202020' }
    shape_range: { fg: '#202020' }
    shape_record: { fg: '#202020' }
    shape_signature: { fg: '#202020' }
    shape_string: { fg: '#202020' }
    shape_table: { fg: '#202020' }
    shape_variable: { fg: '#202020' }
    shape_garbage: { fg: white bg: red attr: b }
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
