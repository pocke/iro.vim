let g:iro#ruby#definitions = get(g:, 'iro#ruby#definitions', [
\   ['tstring_content', 'String'],
\   ['CHAR', 'Character'],
\   ['int', 'Number'],
\   ['float', 'Float'],
\
\   ['kw', 'Keyword'],
\   ['comment', 'Comment'],
\   ['embdoc', 'Comment'],
\   ['embdoc_beg', 'Comment'],
\   ['embdoc_end', 'Comment'],
\   ['const', 'Type'],
\
\   ['regexp_beg', 'Delimiter'],
\   ['regexp_end', 'Delimiter'],
\   ['heredoc_beg', 'Delimiter'],
\   ['heredoc_end', 'Delimiter'],
\   ['tstring_beg', 'Delimiter'],
\   ['tstring_end', 'Delimiter'],
\   ['embexpr_beg', 'Delimiter'],
\   ['embexpr_end', 'Delimiter'],
\ ])

let s:self_path=expand("<sfile>")
execute 'ruby require "' . s:self_path . '.rb"'

function! iro#ruby#tokens() abort
  execute 'ruby Iro::Ruby.tokens(' . bufnr('%') . ')'
  let result = s:result
  unlet s:result
  return result
endfunction
