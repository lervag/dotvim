"
" Personal settings for LaTeX files
"
" Last Update: 2012-10-18
" Author:      Karl Yngve Lervåg
"

"
" Only load file once
"
if exists('b:did_latex') | finish | endif
let b:did_latex = 1

"
" Define some settings
"
let g:Tex_BIBINPUTS = $HOME
setlocal smartindent
nmap <buffer> <f5>   <plug>LatexChangeEnv
vmap <buffer> <f7>   <plug>LatexWrapSelection
vmap <buffer> <S-F7> <Plug>LatexEnvWrapSelection
imap <buffer> <M-i> \item 

"
" Enable forward search with okular
"
function! SyncTexForward()
  let execstr = "silent !okular --unique %:p:r"
        \ . ".pdf\\\#src:" . line(".") . "%:p &"
  exec execstr
endfunction
nmap <silent> <Leader>ls :call SyncTexForward()<CR>

"
" Remember folds
"
setl viewoptions=folds,cursor
augroup texrc
  au BufWinLeave *.tex silent! mkview
  au BufWinEnter *.tex silent! loadview
augroup END
