" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Define g:cfi_disable, and so on.
runtime! plugin/cfi.vim


let s:finder = {}



function! cfi#load() "{{{
    " Dummy function to load this file.
endfunction "}}}

function! cfi#get_func_name(...) "{{{
    if g:cfi_disable
        return ''
    endif

    let filetype = a:0 ? a:1 : &l:filetype
    let NONE = ""

    if !has_key(s:finder, filetype)
        return NONE
    endif

    if !s:finder[filetype]._mixed
        call extend(s:finder[filetype], deepcopy(s:base_finder), 'keep')
        let s:finder[filetype]._mixed = 1
    endif

    if !has_key(s:finder[filetype], 'find')
        return NONE
    endif

    let orig_view = winsaveview()
    try
        let val = s:finder[filetype].find()
        return type(val) == type("") ? val : NONE
    finally
        call winrestview(orig_view)
    endtry
endfunction "}}}

function! cfi#format(fmt, default) "{{{
    let name = cfi#get_func_name()
    if name != ''
        return printf(a:fmt, name)
    else
        return a:default
    endif
endfunction "}}}

function! cfi#create_finder(filetype) "{{{
    if !has_key(s:finder, a:filetype)
        let s:finder[a:filetype] = {'_mixed': 0, 'is_ready': 0, 'phase': 0}
    endif
    return s:finder[a:filetype]
endfunction "}}}

function! cfi#supported_filetype(filetype) "{{{
    return !g:cfi_disable && has_key(s:finder, a:filetype)
endfunction "}}}



" s:base_finder {{{
let s:base_finder = {}

function! s:base_finder.find() "{{{
    let NONE = 0
    let [orig_lnum, orig_col] = [line('.'), col('.')]
    let match = NONE

    if !s:has_base_finder_find_must_methods(self)
        return NONE
    endif

    try
        if s:has_complete_cache(self)
            " function's begin pos -> {original pos} -> function's end pos
            let in_function =
            \   self.pos_is_less_than(self._cache.begin_pos, [line('.'), col('.')])
            \   && self.pos_is_less_than([line('.'), col('.')], self._cache.end_pos)
            if in_function
                return self._cache.match
            endif
            " Left previous function block already.
        endif
        let self._cache = {}

        let self.phase = 1
        if self.find_begin() == 0
            return NONE
        endif
        if self.is_ready
            let match = self.get_func_name()
        endif

        let [begin_lnum, begin_col] = [line('.'), col('.')]
        let self._cache.begin_pos = [begin_lnum, begin_col]

        let self.phase = 2
        if self.find_end() == 0
            return NONE
        endif
        if self.is_ready && match is NONE
            let match = self.get_func_name()
        endif
        if match is NONE
            return NONE
        endif

        let self._cache.end_pos = [line('.'), col('.')]

        " function's begin pos -> {original pos} -> function's end pos
        let in_function =
        \   self.pos_is_less_than([begin_lnum, begin_col], [orig_lnum, orig_col])
        \   && self.pos_is_less_than([orig_lnum, orig_col], [line('.'), col('.')])
        if !in_function
            return NONE
        endif

        let self._cache.match = match
        return match
    finally
        let self.is_ready = 0
        let self.phase = 0
    endtry
endfunction "}}}

function! s:base_finder.pos_is_less_than(pos1, pos2) "{{{
    let [lnum1, col1] = a:pos1
    let [lnum2, col2] = a:pos2
    return
    \   lnum1 < lnum2
    \   || (lnum1 == lnum2
    \       && col1 < col2)
endfunction "}}}


function! s:has_base_finder_find_must_methods(this) "{{{
    return
    \   has_key(a:this, 'get_func_name')
    \   && has_key(a:this, 'find_begin')
    \   && has_key(a:this, 'find_end')
endfunction "}}}

function! s:has_complete_cache(this) "{{{
    return
    \   has_key(a:this, '_cache')
    \   && has_key(a:this._cache, 'begin_pos')
    \   && has_key(a:this._cache, 'end_pos')
    \   && has_key(a:this._cache, 'match')
endfunction "}}}

" }}}



" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
