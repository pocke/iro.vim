let s:self_path=expand("<sfile>")
execute 'ruby require "' . s:self_path . '.rb"'

function! iro#ruby#tokens() abort
  execute 'ruby IroVim::Ruby.parse(' . bufnr('%') . ')'
  let result = s:result
  unlet s:result
  return result
endfunction
