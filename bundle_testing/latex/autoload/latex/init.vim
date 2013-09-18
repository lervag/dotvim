" {{{1 latex#init#set_errorformat
"
" Note: The error formats assume we're using the -file-line-error with
"       [pdf]latex. For more info, see |errorformat-LaTeX|.

function! latex#init#set_errorformat()
  setlocal efm=%E!\ LaTeX\ %trror:\ %m
  setlocal efm+=%E%f:%l:\ %m

  " Show or ignore warnings
  if g:latex_errorformat_show_warnings
    for w in g:latex_errorformat_ignore_warnings
      let warning = escape(substitute(w, '[\,]', '%\\\\&', 'g'), ' ')
      exe 'setlocal efm+=%-G%.%#'. warning .'%.%#'
    endfor
    setlocal efm+=%+WLaTeX\ %.%#Warning:\ %.%#line\ %l%.%#
    setlocal efm+=%+W%.%#\ at\ lines\ %l--%*\\d
    setlocal efm+=%+WLaTeX\ %.%#Warning:\ %m
    setlocal efm+=%+W%.%#%.%#Warning:\ %m
  else
    setlocal efm+=%-WLaTeX\ %.%#Warning:\ %.%#line\ %l%.%#
    setlocal efm+=%-W%.%#\ at\ lines\ %l--%*\\d
    setlocal efm+=%-WLaTeX\ %.%#Warning:\ %m
    setlocal efm+=%-W%.%#%.%#Warning:\ %m
  endif

  " Consider the remaining statements that starts with "!" as errors
  setlocal efm+=%E!\ %m

  " Push file to file stack
  setlocal efm+=%+P**%f

  " Ignore unmatched lines
  setlocal efm+=%-G\\s%#
  setlocal efm+=%-G%.%#
endfunction

