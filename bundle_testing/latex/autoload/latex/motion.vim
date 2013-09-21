"
" Common patterns are predefined for optimization
"
let s:notbslash = '\%(\\\@<!\%(\\\\\)*\)\@<='
let s:notcomment = '\%(\%(\\\@<!\%(\\\\\)*\)\@<=%.*\)\@<!'
let s:section_pattern = s:notcomment . '\v\s*\\(' . join([
      \ '(sub)*section',
      \ 'chapter',
      \ 'part',
      \ 'appendix',
      \ '(front|back|main)matter'], '|') . ')>'
let s:dollar_pat = '\$'
let s:anymatch = '\('
      \ . join(g:latex_motion_open_pats + g:latex_motion_close_pats, '\|')
      \ . '\|' . s:dollar_pat . '\)'

" {{{1 latex#motion#find_matching_pair
function! latex#motion#find_matching_pair(mode)
  if a:mode =~ 'h\|i'
    2match none
  elseif a:mode == 'v'
    normal! gv
  endif

  if latex#util#in_comment() | return | endif

  let lnum = line('.')
  let cnum = searchpos('\A', 'cbnW', lnum)[1]

  " Check if previous char is a backslash
  if strpart(getline(lnum), 0, cnum-1) !~ s:notbslash . '$'
    let cnum = cnum-1
  endif
  let delim = matchstr(getline(lnum), '\C^'. s:anymatch , cnum-1)

  if empty(delim) || strlen(delim)+cnum-1 < col('.')
    if a:mode =~ 'n\|v\|o'
      " if not found, search forward
      let cnum = match(getline(lnum), '\C'. s:anymatch , col('.') - 1) + 1
      if cnum == 0 | return | endif
      call cursor(lnum, cnum)
      let delim = matchstr(getline(lnum), '\C^'. s:anymatch , cnum - 1)
    elseif a:mode =~ 'i'
      " if not found, move one char bacward and search
      let cnum = searchpos('\A', 'bnW', lnum)[1]
      " if the previous char is a backslash
      if strpart(getline(lnum), 0,  cnum-1) !~ s:notbslash . '$'
        let cnum = cnum-1
      endif
      let delim = matchstr(getline(lnum), '\C^'. s:anymatch , cnum - 1)
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
    if lnum0 && latex#util#has_syntax('texMathZoneX', lnum0, cnum0)
      let [lnum2, cnum2] = searchpos(s:notcomment . s:notbslash. s:dollar_pat,
            \ 'nW', line('w$')*(a:mode =~ 'h\|i'), 200)
    else
      let [lnum2, cnum2] = searchpos('\%(\%'. lnum . 'l\%'
            \ . cnum . 'c\)\@!'. s:notcomment . s:notbslash . s:dollar_pat,
            \ 'bnW', line('w0')*(a:mode =~ 'h\|i'), 200)
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
      let open_pat = s:notbslash . g:latex_motion_open_pats[i]
      let close_pat = s:notbslash . g:latex_motion_close_pats[i]

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

" {{{1 latex#motion#jump_to_braces
function! latex#motion#jump_to_braces(backwards)
  let flags = ''
  if a:backwards
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

" {{{1 latex#motion#next_section
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
" }}}1

" vim:fdm=marker:ff=unix
