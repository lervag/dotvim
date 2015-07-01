setlocal nohlsearch

noremap <silent><buffer> q       :bwipeout<cr>
noremap <silent><buffer> <cr>    
noremap <silent><buffer> <bs>    <c-o>
noremap <silent><buffer> <tab>   /\([\|*']\)\zs\S*\ze\1<cr>
noremap <silent><buffer> <s-tab> ?\([\|*']\)\zs\S*\ze\1<cr>

augroup help_insert
  autocmd!
  autocmd InsertEnter <buffer> setlocal conceallevel=0 | highlight clear Ignore
  autocmd InsertLeave <buffer> setlocal conceallevel=2
augroup END
