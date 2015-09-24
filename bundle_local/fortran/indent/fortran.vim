"
" Personal Vim indent file
"
" Based on:
"   Vim's fortran-indent (0.40)
"   Sebastian Burtons indent plugin (0.3.1)
"

" Only load this indent file when no other was loaded.
if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

let s:cposet=&cpoptions
set cpoptions&vim

setlocal indentkeys+==~end,=~case,=~if,=~else,=~do,=~where,=~elsewhere,=~select
setlocal indentkeys+==~endif,=~enddo,=~endwhere,=~endselect,=~elseif
setlocal indentkeys+==~type,=~interface,=~forall,=~associate,=~block,=~enum
setlocal indentkeys+==~endforall,=~endassociate,=~endblock,=~endenum
setlocal indentkeys+==~function,=~subroutine,=~module,=~contains,=~program
setlocal indentkeys+==~endfunction,=~endsubroutine,=~endmodule
setlocal indentkeys+==~endprogram

setlocal indentexpr=FortranGetIndent()

function! FortranGetIndent()
  " No indentation for preprocessor instructions
  if getline(v:lnum) =~ '^\s*#'
    return 0
  endif

  " No indentation at the top of the file
  if lnum == 0
    return 0
  endif

  " Previous non-blank non-preprocessor line
  let lnum = SebuPrevNonBlankNonCPP(v:lnum-1)
  let ind = indent(lnum)
  let prevline = getline(lnum)

  " Strip tail comment
  let prevstat = substitute(prevline, '!.*$', '', '')
  let prev2line = getline(lnum-1)
  let prev2stat = substitute(prev2line, '!.*$', '', '')

  "
  " Indent do loops only if they are all guaranteed to be of do/end do type
  "
  if exists('b:fortran_do_enddo') || exists('g:fortran_do_enddo')
    if prevstat =~? '^\s*\(\d\+\s\)\=\s*\(\a\w*\s*:\)\=\s*do\>'
      let ind = ind + &sw
    endif
    if getline(v:lnum) =~? '^\s*\(\d\+\s\)\=\s*end\s*do\>'
      let ind = ind - &sw
    endif
  endif

  "
  " Add a shiftwidth to statements following if, else, else if, case,
  " where, else where, forall, type, interface and associate statements
  "
  if prevstat =~? '^\s*\(case\|else\|else\s*if\|else\s*where\)\>'
        \ ||prevstat=~? '^\s*\(type\|interface\|associate\|enum\)\>'
        \ ||prevstat=~?'^\s*\(\d\+\s\)\=\s*\(\a\w*\s*:\)\=\s*\(forall\|where\|block\)\>'
        \ ||prevstat=~? '^\s\+.*)\s*then\>\s*$'
        "\ ||prevstat=~? '^\s*\(\d\+\s\)\=\s*\(\a\w*\s*:\)\=\s*if\>'
    let ind = ind + &sw
    "
    " Remove unwanted indent after logical and arithmetic ifs
    "
    if prevstat =~? '\<if\>' && prevstat !~? '\<then\>'
      let ind = ind - &sw
    endif
    "
    " Remove unwanted indent after type( statements
    "
    if prevstat =~? '^\s*type\s*('
      let ind = ind - &sw
    endif
  endif

  "
  " Indent program units unless instructed otherwise
  "
  if !exists('b:fortran_indent_less') && !exists('g:fortran_indent_less')
    let prefix='\(\(pure\|impure\|elemental\|recursive\)\s\+\)\{,2}'
    let type='\(\(integer\|real\|double\s\+precision\|complex\|logical'
          \.'\|character\|type\|class\)\s*\S*\s\+\)\='
    if prevstat =~? '^\s*\(module\|contains\|program\)\>'
            \ ||prevstat =~? '^\s*'.prefix.'subroutine\>'
            \ ||prevstat =~? '^\s*'.prefix.type.'function\>'
            \ ||prevstat =~? '^\s*'.type.prefix.'function\>'
      let ind = ind + &sw
    endif
    if getline(v:lnum) =~? '^\s*contains\>'
          \ ||getline(v:lnum)=~? '^\s*end\s*'
          \ .'\(function\|subroutine\|module\|program\)\>'
      let ind = ind - &sw
    endif
  endif

  "
  " Subtract a shiftwidth from else, else if, elsewhere, case, end if,
  " end where, end select, end forall, end interface, end associate,
  " end enum, and end type statements
  "
  if getline(v:lnum) =~? '^\s*\(\d\+\s\)\=\s*'
        \. '\(else\|else\s*if\|else\s*where\|case\|'
        \. 'end\s*\(if\|where\|select\|interface\|'
        \. 'type\|forall\|associate\|enum\|block\)\)\>'
    let ind = ind - &sw
    "
    " Fix indent for case statement immediately after select
    "
    if prevstat =~? '\<select\s\+\(case\|type\)\>'
      let ind = ind + &sw
    endif
  endif

  "First continuation line
  if prevstat =~# '&\s*$' && prev2stat !~# '&\s*$'
    let ind = ind + &sw
  endif
  if prevstat =~# '&\s*$' && prevstat =~# '\<else\s*if\>'
    let ind = ind - &sw
  endif
  "Line after last continuation line
  if prevstat !~# '&\s*$' && prev2stat =~# '&\s*$' && prevstat !~? '\<then\>'
    let ind = ind - &sw
  endif

  " Continued statement indentation rule
  " Truth table (kind of)
  " Symbol '&'                    |       Result
  " No                    0       0       |       0       No change
  " Appearing             0       1       |       1       Indent
  " Disappering   1       0       |       -1      Unindent
  " Continued             1       1       |       0       No change
  let result = -SebuIsFortranContStat(lnum-1)+SebuIsFortranContStat(lnum)
  " One shiftwidth indentation for continued statements
  let ind += result*&sw
  return ind
endfunction

" SebuPrevNonBlankNonCPP(lnum) is modified prevnonblank(lnum):
" Returns the line number of the first line at or above 'lnum' that is
" neither blank nor preprocessor instruction.
function! SebuPrevNonBlankNonCPP(lnum)
  let lnum = prevnonblank(a:lnum)
  while getline(lnum) =~ '^#'
    let lnum = prevnonblank(lnum-1)
  endwhile
  return lnum
endfunction

" SebuIsFortranContStat(lnum):
" Returns 1 if the 'lnum' statement ends with the Fortran continue mark '&'
" and 0 else.
function! SebuIsFortranContStat(lnum)
  let line = getline(a:lnum)
  return substitute(line,'!.*$','','') =~ '&\s*$'
endfunction

let &cpoptions=s:cposet
unlet s:cposet
