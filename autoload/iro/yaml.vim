let s:self_path=expand("<sfile>")
execute "ruby require '" . s:self_path . ".rb'"

function! iro#yaml#tokens() abort
  execute 'ruby IroVim::YAML.tokens(' . bufnr('%') . ')'
  let result = s:result
  unlet s:result
  return result
endfunction
