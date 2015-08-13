function! s:man(...)
  source $VIMRUNTIME/ftplugin/man.vim

  while line('$') == 1
    redraw
    if get(l:, 'arg')
      echo 'Man page not found, please try again'
    endif
    let l:arg = a:0 > 0 ? join(a:000, ' ')
          \ : input('Man page: ', '', 'customlist,ManComplete')
    silent! execute 'Man' l:arg
  endwhile

  only
  setlocal readonly
  setlocal nomodifiable
  setlocal noexpandtab
  setlocal nolist
  setlocal tabstop=8
  setlocal softtabstop=8
  setlocal shiftwidth=8
  setlocal colorcolumn=
  setlocal iskeyword+=\.,-

  noremap <buffer>         q       :q<cr>
  noremap <buffer>         o       :ManWrapper 
  noremap <buffer>         <cr>    :ManWrapper <c-r><c-w><cr>
  noremap <buffer><silent> <bs>    <c-o><c-o>
  noremap <buffer><silent> <tab>   /\w\+(\d)<cr>
  noremap <buffer><silent> <s-tab> ?\w\+(\d)<cr>
endfunction

function! ManComplete(A, L, P)
  return uniq(filter(map(systemlist('man -k ' . a:A),
        \ 'split(v:val, '' '')[0]'),
        \ 'v:val =~# ''^'' . a:A'))
endfunction

command! -complete=customlist,ManComplete -nargs=*
      \ ManWrapper call s:man(<f-args>)
