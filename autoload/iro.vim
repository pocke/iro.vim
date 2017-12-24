let s:self_path=expand("<sfile>")
execute 'ruby require "' . s:self_path . '.rb"'

" TODO: merge
let g:iro#enabled_filetypes = get(g:, 'iro#enabled_filetypes', {
\   'ruby': 1,
\   'yaml': 1,
\   'python': 0,
\ })

function! iro#redraw() abort
  " See https://github.com/todesking/ruby_hl_lvar.vim/blob/fd52ba13f1b5fee2a4413de9704ef91ea3ffdfc4/autoload/ruby_hl_lvar.vim#L138
  if mode() =~# "^[vV\<C-v>]"
    return
  endif

  if empty(iro#available_filetypes())
    return
  endif

  let cur_wn = winnr()
  let prev_wn = winnr('#')
  let lastwn = winnr('$')

  for wn in range(1, lastwn)
    execute wn . 'wincmd w'

    execute printf('ruby Iro.clean(%d)', wn)

    for ft in iro#available_filetypes()
      execute printf('ruby Iro.draw(%d, "%s")', wn, ft)
    endfor
  endfor

  if prev_wn > 0
    execute prev_wn . "wincmd w"
  endif
  execute cur_wn . "wincmd w"
endfunction

function! iro#available_filetypes() abort
  return filter(split(&filetype, '\.'), {_, ft -> get(g:iro#enabled_filetypes, ft, 0)})
endfunction
