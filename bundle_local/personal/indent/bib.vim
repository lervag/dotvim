" Vim indent file
" Language: Bibtex
" Created:  2011-10-24

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

let s:cpo_save = &cpo
set cpo&vim

setlocal nolisp
setlocal nosmartindent
setlocal autoindent
setlocal indentexpr=GetBibIndent()

if exists("*GetBibIndent")
  finish
endif

" {{{1 GetBibIndent
function GetBibIndent()
  " Find first non-blank line above the current line
  let lnum = prevnonblank(v:lnum - 1)
  if lnum == 0
    return 0
  endif

  " Get some initial conditions
  let ind   = indent(lnum)
  let line  = getline(lnum)
  let cline = getline(v:lnum)

  " Zero indent for first line of each entry
  if cline =~ '^\s*@'
    return 0
  endif

  " Title line of entry
  if line =~ '^@'
    if cline =~ '^\s*}'
      return 0
    else
      return &sw
    endif
  endif

  if line =~ '='
    " Indent continued bib info entries
    if s:count('{', line) - s:count('}', line) > 0
      let match = searchpos('.*=\s*{','bcne')
      return match[1]
    endif
  elseif s:count('{', line) - s:count('}', line) < 0
    return &sw
  endif

  return ind
endfunction

" {{{1 s:count
function! s:count(pattern, line)
  let sum = 0
  let indx = match(a:line, a:pattern)
  while indx >= 0
    let sum += 1
    let indx += 1
    let indx = match(a:line, a:pattern, indx)
  endwhile
  return sum
endfunction
" }}}1

let &cpo = s:cpo_save
unlet s:cpo_save

" vim:fdm=marker:ff=unix
