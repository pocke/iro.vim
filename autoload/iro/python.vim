let g:iro#python#definitions = get(g:, 'iro#python#definitions', [
\   ['COMMENT', 'Comment'],
\   ['STRING', 'String'],
\   ['NUMBER', 'Number'],
\ ])

let s:self_path=expand("<sfile>")
execute 'py3file ' . s:self_path . '.py'

function! iro#python#tokens() abort
  execute 'python3 tokens(' . bufnr('%') . ')'
  let result = s:result
  unlet s:result
  return result
endfunction
