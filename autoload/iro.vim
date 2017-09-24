let s:self_path=expand("<sfile>")
execute 'rubyfile ' . s:self_path . '.rb'

let g:iro#enabled_filetypes = {
\   'ruby': 1,
\   'python': 1,
\ }

function! iro#redraw() abort
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
