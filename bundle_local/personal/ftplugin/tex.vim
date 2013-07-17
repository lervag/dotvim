"
" Personal settings for LaTeX files
" Author: Karl Yngve Lervåg
"

" Only load file once
if exists('b:did_ft_latex') | finish | endif
let b:did_ft_latex = 1

let g:Tex_BIBINPUTS = $HOME
setlocal smartindent
nmap <buffer> <f5>   <plug>LatexChangeEnv
vmap <buffer> <f7>   <plug>LatexWrapSelection
vmap <buffer> <S-F7> <Plug>LatexEnvWrapSelection
imap <buffer> <M-i> \item 

function! SyncTexForward()
  let execstr = "silent !okular --unique %:p:r"
        \ . ".pdf\\\#src:" . line(".") . "%:p &"
  exec execstr
endfunction
nmap <silent> <Leader>ls :call SyncTexForward()<CR>
