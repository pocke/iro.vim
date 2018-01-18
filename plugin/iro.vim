if !has('ruby')
  echoerr "iro.vim: This plugin does not work without has('ruby')"
  finish
endif

augroup iro
  autocmd!
  autocmd Filetype * call Iro_filetype()

  autocmd BufWinEnter,BufWinLeave,WinEnter,WinLeave,TabEnter,TabLeave * call iro#redraw()
  autocmd BufEnter * call s:iro_clean()

augroup END

function! Iro_filetype() abort
  let groupname = 'iro_' . bufnr('%')
  execute 'augroup ' . groupname
    autocmd!
    call iro#redraw()
    autocmd TextChangedi,TextChanged <buffer> call iro#redraw()
  augroup END
endfunction

function! s:iro_clean()
  let filetypes = keys(g:iro#enabled_filetypes)
  if !count(filetypes, &filetype)
    execute printf('ruby Iro.clean(%d)', winnr())
  endif
endfunction
