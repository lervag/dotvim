" Vim completion script
" Language:    lisp
" Maintainer:  Andrew Beyer <abeyer@alum.rpi.edu>
" Version:     1.0
" Last Change: Fri Jan 19 00:28:27 PST 2007
" Usage:       put in autoload, set omnifunc=lispcomplete#Complete
" Options:     g:omni_lisp_ignorecase   0|1                 [&ignorecase]
"              g:omni_lisp_mode         'compound'|'simple' ['compound']
"              

" Set completion with CTRL-X CTRL-O to autoloaded function.
" This check is in place in case this script is
" sourced directly instead of using the autoload feature. 
if exists('+omnifunc')
    " Do not set the option if already set since this
    " results in an E117 warning.
    if &omnifunc == ""
        setlocal omnifunc=lispcomplete#Complete
    endif
endif

if exists('g:loaded_lisp_completion')
    finish 
endif
let g:loaded_lisp_completion = 20

" Set ignorecase to the ftplugin standard
if !exists('g:omni_lisp_ignorecase')
    let g:omni_lisp_ignorecase = &ignorecase
endif

" This script will build a completion list based on the syntax
" elements defined by the files in $VIMRUNTIME/syntax.
let s:syn_remove_words = 'match,matchgroup=,contains,'.
            \ 'links to,start=,end=,nextgroup='

let s:cache_name = []
let s:cache_list = []

" This function is used for the 'omnifunc' option.
function! lispcomplete#Complete(findstart, base)

    if a:findstart
        " Locate the start of the item, including "."
        let line = getline('.')
        let start = col('.') - 1
        while start > 0
            if line[start - 1] =~ '\k'
                let start -= 1
            else
                break
            endif
        endwhile

        return start
    endif

    " escape '*' in a:base
    let base = substitute(a:base, '\*', '\\\*', 'g')

    let filetype = substitute(&filetype, '\.', '_', 'g')
    let list_idx = index(s:cache_name, filetype, 0, &ignorecase)
    if list_idx > -1
        let compl_list = s:cache_list[list_idx]
    else
        let compl_list   = LispSyntaxList()
        let s:cache_name = add( s:cache_name,  filetype )
        let s:cache_list = add( s:cache_list,  compl_list )
    endif

    " Return list of matches.

    if base =~ '\k'
        " complete a word
        if (!exists('g:omni_lisp_mode')) || (g:omni_lisp_mode ==? 'compound')
            let slime_list  = compl_list
            let compl_list  = []
            let slime_base  = '^' . substitute(base, '-', '[a-zA-Z0-9*+/<=>]*-', 'g')
            let slime_start = 0
            let slime_end   = len(slime_list) - 1
            while (slime_start != -1) && (slime_start < slime_end)
                let slime_start = match(slime_list, slime_base, slime_start)
                if slime_start != -1
                    let compl_list = add(compl_list, slime_list[slime_start])
                    let slime_start = slime_start + 1
                endif
            endwhile
        elseif g:omni_lisp_mode ==? 'simple'
            let compstr    = join(compl_list, ' ')
            let expr       = (g:omni_lisp_ignorecase==0?'\C':'').'\<\%('.base.'\)\@!\k\+\s*'
            let compstr    = substitute(compstr, expr, '', 'g')
            let compl_list = split(compstr, '\s\+')
        else
            echoerr "Invalid g:omni_lisp_mode: " g:omni_lisp_mode
        endif
    else
        " TODO: complete a form
    endif

    return compl_list
endfunc

function! LispSyntaxList()

    let saveL = @l
    redir @l
    silent! exec 'syntax list '
    redir END

    let syntax_full = "\n".@l
    let @l = saveL

    if syntax_full =~ 'E28' 
                \ || syntax_full =~ 'E411'
                \ || syntax_full =~ 'E415'
                \ || syntax_full =~ 'No Syntax items'
        return []
    endif

    let syn_list = s:SyntaxCSyntaxGroupItems('lispVar', syntax_full)
    let syn_list = syn_list . s:SyntaxCSyntaxGroupItems('lispFunc', syntax_full)
    let syn_list = syn_list . s:SyntaxCSyntaxGroupItems('lispKey', syntax_full)

    " Convert the string to a List and sort it.
    let compl_list = sort(split(syn_list))

    return compl_list
endfunction

function! s:SyntaxCSyntaxGroupItems( group_name, syntax_full )

    let syn_list = ""

    " From the full syntax listing, strip out the portion for the
    " request group.
    " Query:
    "     \n           - must begin with a newline
    "     a:group_name - the group name we are interested in
    "     \s\+xxx\s\+  - group names are always followed by xxx
    "     \zs          - start the match
    "     .\{-}        - everything ...
    "     \ze          - end the match
    "     \n\w         - at the first newline starting with a character
    let syntax_group = matchstr(a:syntax_full, 
                \ "\n".a:group_name.'\s\+xxx\s\+\zs.\{-}\ze'."\n".'\w'
                \ )

    if syntax_group != ""
        " let syn_list = substitute( @l, '^.*xxx\s*\%(contained\s*\)\?', "", '' )
        " let syn_list = substitute( @l, '^.*xxx\s*', "", '' )

        " We only want the words for the lines begining with
        " containedin, but there could be other items.
        
        " Tried to remove all lines that do not begin with contained
        " but this does not work in all cases since you can have
        "    contained nextgroup=...
        " So this will strip off the ending of lines with known
        " keywords.
        let syn_list = substitute( 
                    \    syntax_group, '\<\('.
                    \    substitute(
                    \      escape(s:syn_remove_words, '\\/.*$^~[]')
                    \      , ',', '\\|', 'g'
                    \    ).
                    \    '\).\{-}\%($\|'."\n".'\)'
                    \    , "\n", 'g' 
                    \  )

        " Now strip off the newline + blank space + contained
        let syn_list = substitute( 
                    \    syn_list, '\%(^\|\n\)\@<=\s*\<\(contained\)'
                    \    , "", 'g' 
                    \ )

    else
        let syn_list = ''
    endif

    return syn_list
endfunction

