"
" Vimrc helper functions
"

function! vimrc#init() abort " {{{1
  " Use space as leader key
  nnoremap <space> <nop>
  let g:mapleader = "\<space>"

  " Add personal files to runtimepath
  let &runtimepath = vimrc#path('personal') . ',' . &runtimepath
  let &runtimepath .= ',' . vimrc#path('personal/after')
  
  " Get some system information and define some paths/urls
  let g:vimrc#bootstrap = !filereadable(vimrc#path('autoload/plug.vim'))
  let g:vimrc#is_devhost = index([
        \ 'yoga',
        \ 'vsl136',
        \ 'vsl142',
        \ 'unity.sintef.no',
        \], hostname()) >= 0

  let g:vimrc#path_bundles = vimrc#path('bundle')
  let g:vimrc#path_lervag = g:vimrc#is_devhost
        \ ? 'git@github.com:lervag/'
        \ : 'lervag/'

  " If plug.vim is not available, then we source the init script and 
  if g:vimrc#bootstrap
    execute 'silent !' . vimrc#path('init.sh')

    " vint: -ProhibitAutocmdWithNoGroup
    autocmd VimEnter * nested PlugInstall --sync | source $MYVIMRC
    " vint: +ProhibitAutocmdWithNoGroup
  endif
endfunction

" }}}1
function! vimrc#path(name) abort " {{{1
  return s:path . '/' . a:name
endfunction

" }}}1

let s:path = fnamemodify(expand('<sfile>'), ':p:h:h')
