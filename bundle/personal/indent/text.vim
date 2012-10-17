" Vim indent file
" Language: Text files
" Created:  2012-10-15

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal nocindent
setlocal nosmartindent
setlocal autoindent
setlocal indentexpr=GetTextIndent()
setlocal formatoptions+=o

function! GetTextIndent()
  let pind  = indent(v:lnum - 1)
  let cind  = indent(v:lnum)
  let pline = getline(v:lnum - 1)
  let cline = getline(v:lnum)

  " Standard lists (started with *)
  if cline =~ '^\s*\*'
    return cind
  elseif pline =~ '^\s*\*'
    return pind + &sw
  endif

  " Numbered lists
  if cline =~ '^\s*\d\+\.\?\s\+'
    return cind
  elseif pline =~ '^\s*\d\+\.\?\s\+'
    let match = searchpos('^\s*\d\+\.\?\s\+','bcne')
    return match[1]
  endif

  " Per default, return previous indent
  return pind
endfunction
