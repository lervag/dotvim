" {{{1 latex#motion#next_section
let s:notcomment = '\%(\%(\\\@<!\%(\\\\\)*\)\@<=%.*\)\@<!'
let s:section_pattern = s:notcomment . '\v\s*\\(' . join([
      \ '(sub)*section',
      \ 'chapter',
      \ 'part',
      \ 'appendix',
      \ '(front|back|main)matter'], '|') . ')>'

function! latex#motion#next_section(type, backwards, visual)
  " Restore visual mode if desired
  if a:visual
    normal! gv
  endif

  " For the [] and ][ commands we move up or down before the search
  if a:type == 1
    if a:backwards
      normal! k
    else
      normal! j
    endif
  endif

  " Define search pattern and do the search while preserving "/
  let save_search = @/
  let flags = 'W'
  if a:backwards
    let flags = 'b' . flags
  endif
  call search(s:section_pattern, flags)
  let @/ = save_search

  " For the [] and ][ commands we move down or up after the search
  if a:type == 1
    if a:backwards
      normal! j
    else
      normal! k
    endif
  endif
endfunction

" {{{1 latex#motion#jump_to_next_braces
function! latex#motion#jump_to_next_braces(invert)
  let flags = ''
  if a:invert
    normal h
    let flags .= 'b'
  else
    let flags .= 'c'
  endif
  if search('[][}{]', flags) > 0
    normal l
  endif
  let prev = strpart(getline('.'), col('.') - 2, 1)
  let next = strpart(getline('.'), col('.') - 1, 1)
  if next =~ '[]}]' && prev !~ '[][{}]'
    return "\<Right>"
  else
    return ''
  endif
endfunction

" {{{1 s:latex_has_syntax
function! s:latex_has_syntax(name, ...)
  " Usage: s:latex_has_syntax(name, [line], [col])
  let line = a:0 >= 1 ? a:1 : line('.')
  let col  = a:0 >= 2 ? a:2 : col('.')
  return 0 <= index(map(synstack(line, col),
        \ 'synIDattr(v:val, "name") == "' . a:name . '"'), 1)
endfunction

" {{{1 s:latex_search_and_skip_comments
function! s:latex_search_and_skip_comments(pat, ...)
  " Usage: s:latex_search_and_skip_comments(pat, [flags, stopline])
  let flags             = a:0 >= 1 ? a:1 : ''
  let stopline  = a:0 >= 2 ? a:2 : 0
  let saved_pos = getpos('.')

  " search once
  let ret = search(a:pat, flags, stopline)

  if ret
    " do not match at current position if inside comment
    let flags = substitute(flags, 'c', '', 'g')

    " keep searching while in comment
    while latex#util#in_comment()
      let ret = search(a:pat, flags, stopline)
      if !ret
        break
      endif
    endwhile
  endif

  if !ret
    " if no match found, restore position
    call setpos('.', saved_pos)
  endif

  return ret
endfunction

" {{{1 s:latex_find_matching_pair
" Allow to disable functionality if desired
if !exists('g:latex_mappings_loaded_matchparen')
  " Disable matchparen autocommands
  augroup latex_highlight_pairs
    "autocmd!
    autocmd BufEnter *
          \ if !exists("g:loaded_matchparen") || !g:loaded_matchparen
            \ | runtime plugin/matchparen.vim
          \ | endif
    autocmd BufEnter *.tex
          \ 3match none | unlet! g:loaded_matchparen | au! matchparen
    autocmd! CursorMoved  *.tex call s:latex_find_matching_pair('h')
    autocmd! CursorMovedI *.tex call s:latex_find_matching_pair('i')
  augroup END
endif

function! s:latex_find_matching_pair(mode)
  if a:mode =~ 'h\|i'
    2match none
  elseif a:mode == 'v'
    normal! gv
  endif

  if latex#util#in_comment() | return | endif

  " open/close pairs (dollars signs are treated apart)
  let dollar_pat = '\$'
  let notbslash = '\%(\\\@<!\%(\\\\\)*\)\@<='
  let notcomment = '\%(\%(\\\@<!\%(\\\\\)*\)\@<=%.*\)\@<!'
  let anymatch =  '\('
        \ . join(g:latex_motion_open_pats + g:latex_motion_close_pats, '\|')
        \ . '\|' . dollar_pat . '\)'

  let lnum = line('.')
  let cnum = searchpos('\A', 'cbnW', lnum)[1]
  " if the previous char is a backslash
  if strpart(getline(lnum), 0,  cnum-1) !~ notbslash . '$'
    let cnum = cnum-1
  endif
  let delim = matchstr(getline(lnum), '\C^'. anymatch , cnum - 1)

  if empty(delim) || strlen(delim)+cnum-1< col('.')
    if a:mode =~ 'n\|v\|o'
      " if not found, search forward
      let cnum = match(getline(lnum), '\C'. anymatch , col('.') - 1) + 1
      if cnum == 0 | return | endif
      call cursor(lnum, cnum)
      let delim = matchstr(getline(lnum), '\C^'. anymatch , cnum - 1)
    elseif a:mode =~ 'i'
      " if not found, move one char bacward and search
      let cnum = searchpos('\A', 'bnW', lnum)[1]
      " if the previous char is a backslash
      if strpart(getline(lnum), 0,  cnum-1) !~ notbslash . '$'
        let cnum = cnum-1
      endif
      let delim = matchstr(getline(lnum), '\C^'. anymatch , cnum - 1)
      if empty(delim) || strlen(delim)+cnum< col('.')
        return
      endif
    elseif a:mode =~ 'h'
      return
    endif
  endif

  if delim =~ '^\$'
    " match $-pairs
    " check if next character is in inline math
    let [lnum0, cnum0] = searchpos('.', 'nW')
    if lnum0 && s:HasSyntax('texMathZoneX', lnum0, cnum0)
      let [lnum2, cnum2] = searchpos(notcomment . notbslash. dollar_pat,
            \ 'nW', line('w$')*(a:mode =~ 'h\|i') , 200)
    else
      let [lnum2, cnum2]
            \ = searchpos('\%(\%'. lnum . 'l\%'
              \ . cnum . 'c\)\@!'. notcomment . notbslash . dollar_pat,
            \ 'bnW', line('w0')*(a:mode =~ 'h\|i') , 200)
    endif

    if a:mode =~ 'h\|i'
      execute '2match MatchParen /\%(\%' . lnum . 'l\%'
            \ . cnum . 'c\$' . '\|\%' . lnum2 . 'l\%' . cnum2 . 'c\$\)/'
    elseif a:mode =~ 'n\|v\|o'
      call cursor(lnum2,cnum2)
    endif
  else
    " match other pairs
    for i in range(len(g:latex_motion_open_pats))
      let open_pat = notbslash . g:latex_motion_open_pats[i]
      let close_pat = notbslash . g:latex_motion_close_pats[i]

      if delim =~# '^' . open_pat
        " if on opening pattern, search for closing pattern
        let [lnum2, cnum2] = searchpairpos('\C' . open_pat, '', '\C'
              \ . close_pat, 'nW', 'latex#util#in_comment()',
              \ line('w$')*(a:mode =~ 'h\|i') , 200)
        if a:mode =~ 'h\|i'
          execute '2match MatchParen /\%(\%' . lnum . 'l\%' . cnum
                \ . 'c' . g:latex_motion_open_pats[i] . '\|\%'
                \ . lnum2 . 'l\%' . cnum2 . 'c'
                \ . g:latex_motion_close_pats[i] . '\)/'
        elseif a:mode =~ 'n\|v\|o'
          call cursor(lnum2,cnum2)
          if strlen(close_pat)>1 && a:mode =~ 'o'
            call cursor(lnum2, matchend(getline('.'), '\C'
                  \ . close_pat, col('.')-1))
          endif
        endif
        break
      elseif delim =~# '^' . close_pat
        " if on closing pattern, search for opening pattern
        let [lnum2, cnum2] =  searchpairpos('\C' . open_pat, '',
              \ '\C\%(\%'. lnum . 'l\%' . cnum . 'c\)\@!'
              \ . close_pat, 'bnW', 'latex#util#in_comment()',
              \ line('w0')*(a:mode =~ 'h\|i') , 200)
        if a:mode =~ 'h\|i'
          execute '2match MatchParen /\%(\%' . lnum2 . 'l\%' . cnum2
                \ . 'c' . g:latex_motion_open_pats[i] . '\|\%'
                \ . lnum . 'l\%' . cnum . 'c'
                \ . g:latex_motion_close_pats[i] . '\)/'
        elseif a:mode =~ 'n\|v\|o'
          call cursor(lnum2,cnum2)
        endif
        break
      endif
    endfor
  endif
endfunction

" {{{1 s:latex_select_inline_math
function! s:latex_select_inline_math(seltype)
  " seltype is either 'inner' or 'outer'

  let dollar_pat = '\\\@<!\$'

  if s:latex_has_syntax('texMathZoneX')
    call s:latex_search_and_skip_comments(dollar_pat, 'cbW')
  elseif getline('.')[col('.') - 1] == '$'
    call s:latex_search_and_skip_comments(dollar_pat, 'bW')
  else
    return
  endif

  if a:seltype == 'inner'
    normal! l
  endif

  if visualmode() ==# 'V'
    normal! V
  else
    normal! v
  endif

  call s:latex_search_and_skip_comments(dollar_pat, 'W')

  if a:seltype == 'inner'
    normal! h
  endif
endfunction

" {{{1 s:latex_select_current_env
function! s:latex_select_current_env(seltype)
  let [env, lnum, cnum, lnum2, cnum2] = latex#util#get_env(1)
  call cursor(lnum, cnum)
  if a:seltype == 'inner'
    if env =~ '^\'
      call search('\\.\_\s*\S', 'eW')
    else
      call search('}\(\_\s*\[\_[^]]*\]\)\?\_\s*\S', 'eW')
    endif
  endif
  if visualmode() ==# 'V'
    normal! V
  else
    normal! v
  endif
  call cursor(lnum2, cnum2)
  if a:seltype == 'inner'
    call search('\S\_\s*', 'bW')
  else
    if env =~ '^\'
      normal! l
    else
      call search('}', 'eW')
    endif
  endif
endfunction

" {{{1 Modeline
" vim:fdm=marker:ff=unix
