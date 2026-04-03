# ascetic theme — monochrome, minimal

$env.PROMPT_COMMAND = {||
  let dir = $"(ansi { fg: '#888888' })(pwd | path basename)(ansi reset)"
  let branch = (do { git branch --show-current } | complete | if $in.exit_code == 0 { $in.stdout | str trim } else { "" })
  if ($branch | is-empty) {
    $dir
  } else {
    $"($dir)(ansi { fg: '#888888' }) \(($branch)\)(ansi reset)"
  }
}
$env.PROMPT_INDICATOR = {|| $"(ansi { fg: '#888888' }) > (ansi reset)" }
$env.PROMPT_COMMAND_RIGHT = {|| $"(ansi { fg: '#888888' })(date now | format date '%H:%M:%S')(ansi reset)" }

# neutralise LS_COLORS so file-type colours don't bleed into completions
$env.LS_COLORS = ""

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

    filesize: { fg: '#888888' }
    duration: { fg: '#888888' }
    date: { fg: '#888888' }
    header: { fg: '#888888' attr: b }
    row_index: { fg: '#888888' }
    separator: { fg: '#444444' }
    hints: { fg: '#b0b0b0' }
}

$env.config.menus = [
    {
        name: completion_menu
        only_buffer_difference: false
        marker: " > "
        type: {
            layout: columnar
            columns: 4
            col_padding: 2
        }
        style: {
            text: '#202020'
            selected_text: { fg: '#202020' bg: '#d0d0d0' }
            description_text: '#888888'
            match_text: { fg: '#202020' attr: u }
            selected_match_text: { fg: '#202020' bg: '#d0d0d0' attr: u }
        }
    }
    {
        name: history_menu
        only_buffer_difference: true
        marker: " > "
        type: {
            layout: list
            page_size: 10
        }
        style: {
            text: '#202020'
            selected_text: { fg: '#202020' bg: '#d0d0d0' }
            description_text: '#888888'
            match_text: { fg: '#202020' attr: u }
            selected_match_text: { fg: '#202020' bg: '#d0d0d0' attr: u }
        }
    }
]
