if $IRO_DISABLED
  let g:iro#enabled_filetypes = {'ruby': 0, 'python': 0, 'yaml': 0}
endif

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

function! s:iro_clean() abort
  let filetypes = iro#available_filetypes()
  if len(filetypes) == 0
    execute printf('ruby IroVim.clean(%d)', winnr())
  endif
endfunction
