if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

let s:cpo_save = &cpo
set cpo&vim

setlocal nolisp
setlocal nosmartindent
setlocal autoindent
setlocal indentexpr=GetDagbokIndent()

let &cpo = s:cpo_save
unlet s:cpo_save

if exists('*GetDagbokIndent')
  finish
endif

function GetDagbokIndent()
  let lnum = v:lnum - 1
  if lnum == 0
    return 0
  endif

  " Get some initial conditions
  let ind   = indent(lnum)
  let pline = getline(lnum)
  let cline = getline(v:lnum)

  " Zero indent for first line of each entry
  if cline =~# '^\d\+'
    return 0
  endif

  " Indent 18 for continuation of notes
  if pline =~# '^\s\+\%(Notat\|Snop\)'
    return 18
  elseif pline =~# '^\d\+'
    return 2
  endif

  return ind
endfunction
