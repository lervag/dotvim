" vim:foldmethod=marker:fen:
scriptencoding utf-8

if g:cfi_disable || get(g:, 'loaded_cfi_ftplugin_fortran')
    finish
endif
let g:loaded_cfi_ftplugin_fortran = 1

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

let s:begin_pattern = '^\s*\(program\|module\|subroutine\|function\)\>'
      \ . '\s\+\(\w\+\)'

let s:finder = cfi#create_finder('fortran')

function! s:finder.find() "{{{
    let NONE = 0
    let orig_lnum = line('.')
    let save_view = winsaveview()

    try
        let pos = search(s:begin_pattern, 'bW')
        if pos == 0
            return NONE
        endif

        let m = matchlist(getline(line('.')), s:begin_pattern)
        if empty(m)
            return NONE
        endif
        return m[2]
    finally
        call winrestview(save_view)
    endtry
endfunction "}}}

unlet s:finder

let &cpo = s:save_cpo
