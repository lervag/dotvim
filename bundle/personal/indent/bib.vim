" Vim indent file
" Language: Bibtex
" Created:  2011-10-24

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal nolisp
setlocal nosmartindent
setlocal autoindent
setlocal indentexpr=GetBibIndent()

if exists("*GetBibIndent")
  finish
endif

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
  if cline =~ '^@'
    let ind = 0
  endif

  " Check conditions and return
  if line =~ '^@'
    if cline =~ '^\s*}'
      let ind = 0
    else
      let ind = &sw
    endif
  elseif line =~ '.\+}' || line =~ '= \d\+,'
    if cline =~ '^\s*}'
      let ind = 0
    else
      let line = search('.*= {','bcn')
      let ind = indent(line)
    endif
  elseif line =~ '.*= {.*'
    let match = searchpos('.*= {','bcne')
    let ind = match[1]
  endif
  return ind
endfunction

