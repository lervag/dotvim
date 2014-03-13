set fdm=syntax

nnoremap <silent> ,t /xx\(\.\\|:\)x\+<cr>
nnoremap <silent> ,n Gonew=UltiSnips#ExpandSnippet()
nmap <silent> ,a ggzR/^2010-<cr>?^200<cr>k2yy}Pj$<c-a>oadd<tab>

autocmd BufWinEnter dagbok.txt silent! normal GkzoGzo,t
