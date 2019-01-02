setlocal nohlsearch
setlocal foldmethod=expr
setlocal foldexpr=DagbokFold(v:lnum)
setlocal fo-=n

nnoremap <buffer><silent> ,t /\C\%18c \?x<cr>zz
nnoremap <buffer><silent> ,n Gonew<c-r>=UltiSnips#ExpandSnippet()<cr>
nmap     <buffer><silent> ,a zRgg/^2006-<cr>?^200<cr>k2yy}Pj$<c-a>oadd
nnoremap <buffer><silent> ,v :silent !xdg-open https://docs.google.com/spreadsheets/d/1s8OIUtS7xa_8tECA7RNpARiRyy5SWnOc4U5pFYZOEyQ/edit\#gid=0<cr>

function! DagbokFold(lnum)
  return getline(a:lnum) =~# '^\d' ? '>1' : '1'
endfunction

augroup dagbok
  autocmd!
  autocmd! BufWinEnter dagbok.txt silent! normal GkzoGzo,t
augroup END
