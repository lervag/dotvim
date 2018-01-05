"
" Simple plugin that maps gK to open documentation with zeal
"
" Note: Could also use http://devdocs.io/
"

if !executable('zeal') || exists('g:loaded_zeal') | finish | endif
let g:loaded_zeal = 1

let s:dict = {
      \ 'make' : 'make',
      \ 'markdown' : 'markdown',
      \ 'perl' : 'perl',
      \ 'python' : 'python',
      \ 'tex' : 'latex',
      \ 'sh' : 'bash',
      \ 'zsh' : 'bash',
      \}

augroup zeal
  autocmd!
  for [s:ft, s:kwrd] in items(s:dict)
    execute 'autocmd! FileType' s:ft
          \ 'nnoremap <silent><buffer> <leader>zz'
          \ ':silent !zeal ' . s:kwrd . ':<cword> 2>&1 >/dev/null &<cr>'
  endfor
augroup END
