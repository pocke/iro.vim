if g:iro#enabled_filetypes['ruby']
  if !exists("ruby_no_identifiers")
    hi def link rubyIdentifier Identifier
  else
    hi def link rubyIdentifier NONE
  endif

  hi def link rubyLocalVariable rubyIdentifier
  let b:current_syntax = 'ruby'
endif
