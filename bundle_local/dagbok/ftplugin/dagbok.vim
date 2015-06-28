setl nohlsearch
setl foldmethod=expr
setl foldexpr=DagbokFold(v:lnum)

nnoremap <buffer><silent> ,t /\%17cx<cr>zz
nnoremap <buffer><silent> ,n Gonew=UltiSnips#ExpandSnippet()
nmap     <buffer><silent> ,a zRgg/^2010-<cr>?^200<cr>k2yy}Pj$<c-a>

function! DagbokFold(lnum)
  return getline(a:lnum) =~# '^\d' ? '>1' : '1'
endfunction

silent! normal GkzoGzo,t
