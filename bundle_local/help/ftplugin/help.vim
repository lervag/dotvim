setlocal nohlsearch

noremap <buffer>         q       :q<cr>
noremap <buffer>         <cr>    
noremap <buffer><silent> <bs>    <c-o>
noremap <buffer>         <tab>   /\([\|*']\)\zs\S*\ze\1<cr>
noremap <buffer>         <s-tab> ?\([\|*']\)\zs\S*\ze\1<cr>

augroup help_insert
  autocmd!
  autocmd InsertEnter <buffer> setlocal conceallevel=0 | highlight clear Ignore
  autocmd InsertLeave <buffer> setlocal conceallevel=2
augroup END
