setl nohlsearch
setl foldmethod=expr
setl foldexpr=DagbokFold(v:lnum)

nnoremap <silent> ,t /xx\(\.\\|:\)x\+<cr>
nnoremap <silent> ,n Gonew=UltiSnips#ExpandSnippet()
" nmap     <silent> ,a ggzR/^2010-<cr>?^200<cr>k2yy}Pj$<c-a>oadd<tab>
nmap <silent> ,a zRgg/^2010-<cr>?^200<cr>k2yy}Pj$<c-a>zf

autocmd BufWinEnter dagbok.txt silent! normal GkzoGzo,t

function! DagbokFold(lnum)
  if getline(a:lnum) =~ '^\d'
    return ">1"
  else
    return "1"
  endif
endfunction

