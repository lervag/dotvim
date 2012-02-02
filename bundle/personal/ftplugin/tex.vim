"{{{1 Define some settings
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_MultipleCompileFormats='dvi,pdf'
let g:Tex_ViewRule_pdf = 'okular'
let g:Tex_ViewRule_dvi = 'okular'
let g:Tex_CompileRule_pdf = 'pdflatex -synctex=1 -interaction=nonstopmode $*'
let g:Tex_BIBINPUTS = $HOME
let g:Tex_Com_sqrt = "\\sqrt[<++>]{<++>}<++>"
let g:Tex_FoldedEnvironments =
      \   "verbatim,comment,split,eq,gather,multline,align,"
      \ . "itemize,enumerate,scope,tikzpicture,figure,table,thebibliography,"
      \ . "columns,textblock,frame,exercise,answer,task,"
      \ . "thebibliography,keywords,abstract,titlepage"
let g:Tex_FoldedSections = "part,chapter,section,subsection,"
      \ . "subsubsection,paragraph,%%fakesection"
let g:Tex_FoldedMisc="preamble,<<<"
let g:tex_comment_nospell=1

"{{{1 Add mapping to be able to select a single paragraph, and to format it
noremap <silent> <expr> { LaTeXStartOfParagraph()
noremap <silent> <expr> } LaTeXEndOfParagraph()
noremap <silent> gwp :call LaTeXFormatParagraph()<CR>
vnoremap p {o}
vmap <silent>ip <esc>{v}
vmap <silent>ap <esc>{v}
onoremap <silent>ap :normal vap<CR>
onoremap <silent>ip :normal vip<CR>

"{{{1 Add mapping for latexmk
map <silent> <Leader>lm :call Start_latexmk()<CR>
function! Start_latexmk()
  normal \ls
  let cdcmd = "cd " . expand("%:h") . "; "
  let latexmkcmd = "latexmk -pvc -silent"
  silent execute "ScreenShell " . cdcmd . latexmkcmd
endfunction

"{{{1 Create a handy function and autocommand for automagically formatting LaTeX
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


function! LaTeXStartOfParagraph()               "{{{1
  let delimitors = ['begin', 'end', '\(sub\)*section', 'label', '%']
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

function! LaTeXEndOfParagraph()               "{{{1
  let delimitors = ['begin', 'end', '\(sub\)*section', 'label', '%']
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

function! LaTeXFormatParagraph()              "{{{1
  let cpp = getpos('.')
  normal vpgq
  call setpos('.', cpp)
endfunction
" {{{1 Modeline
" vim: fdm=marker
