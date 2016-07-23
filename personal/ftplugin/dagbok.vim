setl nohlsearch
setl foldmethod=expr
setl foldexpr=DagbokFold(v:lnum)
setl fo-=n

nnoremap <buffer><silent> ,t /\C\%18c \?x<cr>zz
nnoremap <buffer><silent> ,n Goi<c-r>=neosnippet#expand('new')<cr>
nmap     <buffer><silent> ,a zRgg/^2010-<cr>?^200<cr>k2yy}Pj$<c-x>o   <c-r>=neosnippet#expand('add')<cr>

function! DagbokFold(lnum)
  return getline(a:lnum) =~# '^\d' ? '>1' : '1'
endfunction

augroup dagbok
  autocmd!
  autocmd! BufWinEnter dagbok.txt silent! normal GkzoGzo,t
augroup END
