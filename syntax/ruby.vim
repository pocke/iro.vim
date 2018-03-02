if g:iro#enabled_filetypes['ruby']
  hi def link rubyIdentifier Identifier
  hi def link rubyDefine Define
  hi def link rubyLocalVariable rubyIdentifier

  let b:current_syntax = 'ruby'
endif
