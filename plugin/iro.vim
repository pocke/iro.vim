if !has('ruby')
  echoerr "iro.vim: This plugin does not work without has('ruby')"
  finish
endif

augroup iro
  autocmd!
  autocmd Filetype * call Iro_filetype()

  autocmd BufWinEnter,BufWinLeave,WinEnter,WinLeave,TabEnter,TabLeave * call iro#redraw()
  
augroup END

function! Iro_filetype() abort
  let groupname = 'iro_' . bufnr('%')
  execute 'augroup ' . groupname
    autocmd!
    call iro#redraw()
    autocmd InsertLeave,TextChanged <buffer> call iro#redraw()
  augroup END
endfunction
