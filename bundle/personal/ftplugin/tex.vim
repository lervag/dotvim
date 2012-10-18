"
" Define some settings
"
setlocal smartindent
imap <buffer> [[     \begin{
imap <buffer> ]]     <plug>LatexCloseCurEnv
imap <buffer> ((     \eqref{
nmap <buffer> <f5>   <plug>LatexChangeEnv
vmap <buffer> <f7>   <plug>LatexWrapSelection
vmap <buffer> <S-F7> <Plug>LatexEnvWrapSelection
let g:Tex_BIBINPUTS = $HOME

"
" Some key mappings
"
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
