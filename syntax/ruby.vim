if g:iro#enabled_filetypes['ruby']
  hi def link rubyIdentifier Identifier
  hi def link rubyDefine Define
  hi def link rubyLocalVariable rubyIdentifier
  hi def link rubyFunction Function
  hi def link rubySymbol Constant
  hi def link rubySymbolDelimiter rubySymbol

  let b:current_syntax = 'ruby'
endif
