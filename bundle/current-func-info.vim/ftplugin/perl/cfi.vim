" vim:foldmethod=marker:fen:
scriptencoding utf-8


if g:cfi_disable || get(g:, 'loaded_cfi_ftplugin_perl')
    finish
endif
let g:loaded_cfi_ftplugin_perl = 1

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}



let s:BEGIN_PATTERN = '\C'.'^\s*'.'sub\>'.'\s\+'.'\(\w\+\)'.'\%('.'\s*'.'([^()]*)'.'\)\='
let s:BLOCK_FIRST_BRACE = '[[:space:][:return:]]*'.'\zs{'

let s:finder = cfi#create_finder('perl')

function! s:finder.get_func_name() "{{{
    let NONE = 0
    if self.phase !=# 1
        return NONE
    endif
    let m = matchlist(getline('.'), s:BEGIN_PATTERN)
    if empty(m)
        return NONE
    endif
    return m[1]
endfunction "}}}

function! s:finder.find_begin() "{{{
    let NONE = 0
    if search(s:BEGIN_PATTERN.s:BLOCK_FIRST_BRACE, 'bW') == 0
        return NONE
    endif
    let self.is_ready = 1
    return line('.')
endfunction "}}}

function! s:finder.find_end() "{{{
    let NONE = 0
    if searchpair('{', '', '}', 'W') == 0
        return NONE
    endif
    return line('.')
endfunction "}}}

unlet s:finder




let &cpo = s:save_cpo
