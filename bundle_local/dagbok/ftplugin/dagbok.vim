set fdm=syntax

nnoremap <silent> ,t /xx\.x<cr>
nnoremap <silent> ,n Gonew=UltiSnips#ExpandSnippet()

autocmd BufWinEnter dagbok.txt silent! normal GkzoGzo,t
