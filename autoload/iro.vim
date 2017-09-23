let g:iro_ruby = get(g:, 'iro_ruby', [
\   ['tstring_content', 'String'],
\   ['comment', 'Comment'],
\ ])

let s:self_path=expand("<sfile>")
execute 'rubyfile ' . s:self_path . '.rb'

function! iro#highlight() abort
  execute 'ruby Iro.highlight(' . bufnr('%') . ')'
endfunction
