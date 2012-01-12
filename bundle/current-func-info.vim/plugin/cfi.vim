" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Load Once {{{
if (exists('g:loaded_cfi') && g:loaded_cfi) || &cp
    finish
endif
let g:loaded_cfi = 1
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

let g:cfi_disable = exists('g:cfi_disable') && g:cfi_disable isnot 0
command! CfiEnable  let g:cfi_disable = !!0
command! CfiDisable let g:cfi_disable = !!1


" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
