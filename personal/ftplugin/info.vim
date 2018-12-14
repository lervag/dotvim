nmap <buffer> gk <plug>(InfoUp)
nmap <buffer> gl <plug>(InfoNext)
nmap <buffer> gh <plug>(InfoPrev)
nmap <buffer> gm <plug>(InfoMenu)
nmap <buffer> gf <plug>(InfoFollow)

nmap <buffer> <cr> K

nnoremap <silent><buffer> q :quitall<cr>

noremap <silent><buffer> <tab>   :call InfoNextLink()<cr>
noremap <silent><buffer> <s-tab> :call InfoPrevLink()<cr>

function! InfoNextLink() abort " {{{1
  call search('\v\*(\s+.{-}::|\s+.{-}:\s\+.{-}\.|Note)')
endfunction

" }}}1
function! InfoPrevLink() abort " {{{1
  call search('\v\*(\s+.{-}::|\s+.{-}:\s\+.{-}\.|Note)', 'b')
endfunction

" }}}1
