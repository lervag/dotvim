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

" Some initial Screen settings for latex
function! s:ScreenShellListener()
  if g:ScreenShellActive
    nmap <C-c><C-a> <Nop>
    nmap <C-c><C-l> <Nop>
    nmap <C-c><C-c> <Nop>
    vmap <C-c><C-c> <Nop>
  else
    nmap <silent> <C-c><C-l>
          \ :ScreenShell latexmk -pvc <C-R>%<CR>
  endif
endfunction

call s:ScreenShellListener()
augroup ScreenShellEnter
  au USER *.tex :call <SID>ScreenShellListener()
augroup END
augroup ScreenShellExit
  au USER *.tex :call <SID>ScreenShellListener()
augroup END
