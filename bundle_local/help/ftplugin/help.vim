setlocal nohlsearch

noremap <buffer>         q       :q<cr>
noremap <buffer>         <cr>    
noremap <buffer><silent> <bs>    <c-o>
noremap <buffer>         <tab>   /\([\|*']\)\zs\S*\ze\1<cr>
noremap <buffer>         <s-tab> ?\([\|*']\)\zs\S*\ze\1<cr>
