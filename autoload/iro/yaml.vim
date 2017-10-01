let s:self_path=expand("<sfile>")
execute 'rubyfile ' . s:self_path . '.rb'

function! iro#yaml#tokens() abort
  execute 'ruby Iro::YAML.tokens(' . bufnr('%') . ')'
  let result = s:result
  unlet s:result
  return result
endfunction
