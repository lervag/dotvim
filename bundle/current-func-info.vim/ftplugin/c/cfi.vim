" vim:foldmethod=marker:fen:
scriptencoding utf-8


if g:cfi_disable || get(g:, 'loaded_cfi_ftplugin_c')
    finish
endif
let g:loaded_cfi_ftplugin_c = 1

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}



let s:finder = cfi#create_finder('c')

function! s:finder.get_func_name() "{{{
    let NONE = 0
    let pat = '\C'.'\(\w\+\)('
    let orig_pos = [line('.'), col('.')]

    if search(pat, 'bW') == 0
        return NONE
    endif
    let funcname_lnum = line('.')

    " Jump to function-like word, and check arguments, and block.
    for [fn; args] in [
    \   ['search', '(', 'W'],
    \   ['searchpair', '(', '', ')'],
    \   ['search', '{'],
    \]
        if call(fn, args) == 0
            return NONE
        endif
    endfor

    if orig_pos != [line('.'), col('.')]
        return NONE
    endif

    let m = matchlist(getline(funcname_lnum), pat)
    if empty(m)
        return NONE
    endif
    return m[1]
endfunction "}}}

function! s:finder.find_begin() "{{{
    let NONE = 0
    let [orig_lnum, orig_col] = [line('.'), col('.')]

    let vb = &vb
    setlocal vb t_vb=
    normal! [m
    let &vb = vb

    if line('.') == orig_lnum && col('.') == orig_col
        return NONE
    endif
    let self.is_ready = 1
    return line('.')
endfunction "}}}

function! s:finder.find_end() "{{{
    let NONE = 0
    let [orig_lnum, orig_col] = [line('.'), col('.')]

    let vb = &vb
    setlocal vb t_vb=
    normal! ]M
    let &vb = vb

    if line('.') == orig_lnum && col('.') == orig_col
        return NONE
    endif
    let self.is_ready = 1
    return line('.')
endfunction "}}}




let &cpo = s:save_cpo
