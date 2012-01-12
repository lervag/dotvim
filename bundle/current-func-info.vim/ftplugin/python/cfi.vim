" vim:foldmethod=marker:fen:
scriptencoding utf-8


if g:cfi_disable || get(g:, 'loaded_cfi_ftplugin_python')
    finish
endif
let g:loaded_cfi_ftplugin_python = 1

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}



let s:BEGIN_PATTERN = '\C'.'^\s*'.'def\>'.'\s\+'.'\(\w\+\)'

let s:finder = cfi#create_finder('python')

function! s:finder.find() "{{{
    let NONE = 0
    let orig_lnum = line('.')
    let indent_num = s:get_indent_num('.')
    let save_view = winsaveview()

    try
        let pos = search(s:BEGIN_PATTERN, 'bW')
        if pos == 0
            return NONE
        endif
        " ...now at function name pos.

        " Function's indent must be lower than indent_num.
        if s:get_indent_num('.') >= indent_num
            return NONE
        endif

        " NOTE: s:get_multiline_string_range() changes current pos.
        " So save info about pos before calling it.
        let n = s:get_indent_num('.')
        let [begin, end] = [line('.'), orig_lnum]
        let multi_str_range = s:get_multiline_string_range(begin, end)
        " The range from function name to current pos
        " must has stepwise indent num.
        for lnum in range(begin, end)
            if s:get_indent_num(lnum) < n && !s:in_multiline_string(multi_str_range, lnum)
                return NONE
            endif
        endfor

        let m = matchlist(getline(begin), s:BEGIN_PATTERN)
        if empty(m)
            return NONE
        endif
        return m[1]
    finally
        call winrestview(save_view)
    endtry
endfunction "}}}

function! s:get_indent_num(lnum) "{{{
    return strlen(matchstr(getline(a:lnum), '^[ \t]*'))
endfunction "}}}

function! s:get_multiline_string_range(search_begin, search_end) "{{{
    let MULTI_STR_RX = '\%('.'"""'.'\|'."'''".'\)'
    let range = []

    while 1
        " begin of multi string
        let begin = search(MULTI_STR_RX, 'W')
        if begin == 0 || !(a:search_begin <= begin && begin <= a:search_end)
            return range
        endif
        " end of multi string
        let end = search(MULTI_STR_RX, 'W')
        if end == 0 || !(a:search_begin <= end && end <= a:search_end)
            return range
        endif

        call add(range, [begin, end])
    endwhile
endfunction "}}}

function! s:in_multiline_string(range, lnum) "{{{
    " Ignore `begin` and `end` lnum.
    " Because they are lnums where """ or ''' is.
    for [begin, end] in a:range
        if begin < a:lnum && a:lnum < end
            return 1
        endif
    endfor
    return 0
endfunction "}}}

unlet s:finder




let &cpo = s:save_cpo
