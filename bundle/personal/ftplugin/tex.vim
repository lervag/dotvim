
" Define some settings
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_MultipleCompileFormats='dvi,pdf'
let g:Tex_ViewRule_pdf = 'okular'
let g:Tex_ViewRule_dvi = 'okular'
let g:Tex_CompileRule_pdf = 'pdflatex -synctex=1 -interaction=nonstopmode $*'
let g:Tex_BIBINPUTS = $HOME
let g:Tex_Com_sqrt = "\\sqrt[<++>]{<++>}<++>"
let g:Tex_FoldedEnvironments = "verbatim,comment,eq,gather,scope,multline,"
      \ . "tikzpicture,align,figure,table,thebibliography,keywords,"
      \ . "itemize,enumerate,frame,abstract,titlepage,"
      \ . "task,answer,exercise"
let g:Tex_FoldedSections = "part,chapter,section,subsection,"
      \ . "subsubsection,paragraph,%%fakesection"
let g:Tex_FoldedMisc="preamble,<<<"

" Add mapping to be able to select a single paragraph, and to format it
map <silent> <expr> { LaTeXStartOfParagraph()
map <silent> <expr> } LaTeXEndOfParagraph()
map <silent> gwp :call LaTeXFormatParagraph()<CR>
vmap p {o}

" Add mapping for latexmk
map <silent> <Leader>lm :call Start_latexmk()<CR>
function! Start_latexmk()
  normal \ls
  let cdcmd = "cd " . expand("%:h") . "; "
  let latexmkcmd = "latexmk -pvc -silent"
  silent execute "ScreenShell " . cdcmd . latexmkcmd
endfunction

" Create a handy function and autocommand for automagically formatting LaTeX
"augroup LaTexTidy
  "autocmd!
  "autocmd InsertLeave *.tex :call TidyAndResetCursor()
"augroup END
function! TidyAndResetCursor()
  let cp = getpos('.')
  let delimitors = ['begin', 'end', 'label', '\(sub\)*section']
  let pattern = '^\s*\(\\' . join(delimitors,'\|\\') . '\)'
  let previous_environment = search(pattern, 'bnW')
  call setpos('.', [0,previous_environment+1,1,0])
  set cursorline
  redraw
  sleep 100m
  set nocursorline
  call setpos('.', cp)
endfunctio

function! LaTeXStartOfParagraph()
  let delimitors = ['begin', 'end', '\(sub\)*section', 'label']
  let pattern = '^$\|^\s*\(\\' . join(delimitors,'\|\\') . '\)'
  let cpp = getpos('.')
  let spp = searchpos(pattern,'b')
  let spp[0] += 1
  if cpp[1:2] == spp
    return 'k?' . pattern . '?1'
  elseif cpp[1]-1 == spp[1]
    return 'k?' . pattern . '?1'
  else
    return '?' . pattern . '?1'
  endif
endfunction

function! LaTeXEndOfParagraph()
  let delimitors = ['begin', 'end', '\(sub\)*section', 'label']
  let pattern = '^$\|^\s*\(\\' . join(delimitors,'\|\\') . '\)'
  let cpp = getpos('.')
  call searchpos(pattern)
  let spp = getpos('.')
  let spp[1] -= 1
  call setpos('.',spp)
  call searchpos('$')
  let spp = getpos('.')
  if cpp[1:2] == spp[1:2]
    return 'j/' . pattern . '/-1$'
  elseif cpp[1]+1 == spp[1]
    return 'j/' . pattern . '/-1$'
  else
    return '/' . pattern . '/-1$'
  endif
endfunction

function! LaTeXFormatParagraph()
  let cpp = getpos('.')
  normal vpgq
  call setpos('.', cpp)
endfunction
" vim: fdm=marker
