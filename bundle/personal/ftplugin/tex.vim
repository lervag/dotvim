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
setlocal viewoptions=folds,cursor
augroup texrc
  au BufWinLeave *.tex silent! mkview
  au BufWinEnter *.tex silent! loadview
augroup END

"
" Enable forward search with okular
"
function! SyncTexForward()
  let execstr = "silent !okular --unique %:p:r"
        \ . ".pdf\\\#src:" . line(".") . "%:p &"
  exec execstr
endfunction
nmap <silent> <Leader>ls :call SyncTexForward()<CR>

setl fdm=expr fde=FoldLevel(v:lnum) fdt=FoldText(v:foldstart)
let g:fold_preamble=1
let g:fold_envs=1
let g:fold_parts=[
      \ "section",
      \ "subsection",
      \ "subsubsection"
      \ ]

" {{{1 FoldLevel
fu! FoldLevel(lnum)
  let line  = getline(a:lnum)

  " Fold preamble
  if exists('g:fold_preamble')
    if line =~ '\s*\\documentclass'
      return ">1"
    endif
    if line =~ '\s*\\begin{document}'
      return "<1"
    endif
  endif

  " Fold parts and sections
  let level = 1
  for part in g:fold_parts
    if line  =~ '^\s*\\' . part . '\*\?{'
      return ">" . level
    endif
    let level += 1
  endfo

  " Fold environments
  if exists('g:fold_envs')
    if line =~ '\\begin{.*}'
      return "a1"
    endif
    if line =~ '\\end{.*}'
      return "s1"
    endif
  endif

  return "="
endfu

" {{{1 FoldText
fu! FoldText(lnum)
  let line = getline(a:lnum)

  " Define pretext
  let pretext = '    '
  if v:foldlevel == 1
    let pretext = '>   '
  elseif v:foldlevel == 2
    let pretext = '->  '
  elseif v:foldlevel == 3
    let pretext = '--> '
  elseif v:foldlevel >= 4
    let pretext = printf('--%i ',v:foldlevel)
  endif

  " Preamble
  if line =~ '\s*\\documentclass'
    return pretext . "Preamble"
  endif

  " Parts and sections
  if line =~ '\\\(\(sub\)*section\|part\|chapter\)'
    return pretext .  matchstr(line,
          \ '^\s*\\\(\(sub\)*section\|part\|chapter\)\*\?{\zs.*\ze}')
  endif

  " Environments
  if line =~ '\\begin'
    let env = matchstr(line,'\\begin\*\?{\zs\w*\*\?\ze}')

    " Get label or caption
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
      let i += 1
    endwhile

    return pretext . printf('%-12s', env) . caption . label
  endif

  " Not defined
  return "Fold text not defined"
endfu

"{{{1 Footer
"
" -----------------------------------------------------------------------------
" Copyright, Karl Yngve Lervåg (c) 2008 - 2012
" -----------------------------------------------------------------------------
" vim: foldmethod=marker
"
