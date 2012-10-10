"
" Define some settings
"
setlocal smartindent
imap <buffer> [[     \begin{
imap <buffer> ]]     <plug>LatexCloseCurEnv
imap <buffer> ((     \eqref{
nmap <buffer> <f5>   <plug>LatexChangeEnv
vmap <buffer> <f7>   <plug>LatexWrapSelection
vmap <buffer> <S-F7> <Plug>LatexEnvWrapSelection
let g:Tex_BIBINPUTS = $HOME

"
" Remember folds
"
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview

"
" Enable forward search with okular
"
function! SyncTexForward()
  let execstr = "silent !okular --unique %:p:r"
        \ . ".pdf\\\#src:" . line(".") . "%:p &"
  exec execstr
endfunction
nmap <silent> <Leader>ls :call SyncTexForward()<CR>

" {{{1 Folding
" {{{2 Fold function
fu! FoldTeXLines(lnum)
  " Get the line and next line
  let line  = getline(a:lnum)
  let nline = getline(a:lnum + 1)
  let ret   = "="

  " Fold the preamble
  if line =~ '\s*\\documentclass'
    return ">1"
  endif
  if line =~ '\s*\\begin{document}'
    return "<1"
  endif

  " If the line is a new section, start a fold at the good level
  if line =~ '\\section\*\?{.*}'
    let ret = ">1"
  elseif line =~ '\\subsection\*\?{.*}'
    let ret = ">2"
  elseif line =~ '\\subsubsection\*\?{.*}'
    let ret = ">3"
  endif

  " Some environments
  if line =~ '\\begin{.*}'
    let ret = "a1"
  endif
  if line =~ '\\end{.*}'
    let ret = "s1"
  endif

  return ret
endfu

" {{{2 Fold text
fu! FoldText(lnum)
  " Get line
  let line = getline(a:lnum)
  let nline = getline(a:lnum+1)

  " preamble
  if line =~ '\s*\\documentclass'
    return "    Preamble"
  endif

  " Sections
  if line =~ '^\s*\\\(sub\)*section'
    let title = matchstr(line,'^\s*\\\(sub\)*section\*\?{\zs.*\ze}')
    if line =~ '^\s*\\section'
      let pretext = '>   '
    elseif line =~ '^\s*\\subsection'
      let pretext = '->  '
    elseif line =~ '^\s*\\subsubsection'
      let pretext = '--> '
    endif
    return pretext . title
  endif

  " Environments
  if line =~ '\\begin'
    let pretext = '    '
    if v:foldlevel == 1
      let pretext = '>   '
    elseif v:foldlevel == 2
      let pretext = '->  '
    elseif v:foldlevel == 3
      let pretext = '--> '
    elseif v:foldlevel > 3
      let pretext = '--- '
    endif
    let env = matchstr(line,'\\begin\*\?{\zs\w*\*\?\ze}')
    let label = ''
    let caption = ''
    let i = v:foldstart
    while i <= v:foldend
      if getline(i) =~ '^\s*\\label'
        let label = ' (' . matchstr(getline(i), '^\s*\\label{\zs.*\ze}') . ')'
      end
      if getline(i) =~ '^\s*\\caption'
        let env .=  ': '
        let caption = matchstr(getline(i), '^\s*\\caption.*{\zs.\{1,30}')
        let caption = substitute(caption, '}.*', '')
      end
      let i = i + 1
    endwhile
    return pretext . printf('%-12s', env) . caption . label
  endif

  " Not defined
  return "Not defined"
endfu

setl fdm=expr fde=FoldTeXLines(v:lnum) fdt=FoldText(v:foldstart)

"{{{1 Footer
"
" -----------------------------------------------------------------------------
" Copyright, Karl Yngve Lervåg (c) 2008 - 2012
" -----------------------------------------------------------------------------
" vim: foldmethod=marker
"
