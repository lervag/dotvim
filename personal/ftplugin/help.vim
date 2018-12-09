augroup help_insert
  autocmd!
  autocmd InsertEnter <buffer> setlocal conceallevel=0 | highlight clear Ignore
  autocmd InsertLeave <buffer> setlocal conceallevel=2
augroup END

setlocal iskeyword+=-

"
" Only apply the following settings when viewing help files, not when editing
" them
"
if &modifiable | finish | endif

setlocal nohlsearch

noremap <silent><buffer> q     :bwipeout<cr>
noremap <silent><buffer> <cr>  
noremap <silent><buffer> <bs>  <c-o>
noremap <silent><buffer> <c-n> /\([\|*']\)\zs\S*\ze\1<cr>
noremap <silent><buffer> <c-p> ?\([\|*']\)\zs\S*\ze\1<cr>
noremap <silent><buffer> <tab>
      \ :call search('<bar>[^ <bar>]\+<bar>\<bar>''[A-Za-z0-9_-]\{2,}''')<cr>
noremap <silent><buffer> <s-tab>
      \ :call search('<bar>[^ <bar>]\+<bar>\<bar>''[A-Za-z0-9_-]\{2,}''','b')<cr>
