if g:iro#enabled_filetypes['yaml']
  let b:current_syntax = 'yaml'

  syn region yamlComment start="\#" end="$"
  hi link yamlComment Comment
endif
