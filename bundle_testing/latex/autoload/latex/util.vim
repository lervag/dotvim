" {{{1 latex#util#set_default
function! latex#util#set_default(variable, default)
  if !exists(a:variable)
    let {a:variable} = a:default
  endif
endfunction

" {{{1 latex#util#in_comment
function! latex#util#in_comment(...)
  let line = a:0 >= 1 ? a:1 : line('.')
  let col = a:0 >= 2 ? a:2 : col('.')
  return synIDattr(synID(line, col, 0), "name") =~# '^texComment'
endfunction

" {{{1 latex#util#get_env

" LatexBox_GetCurrentEnvironment([with_pos])
" Returns:
" - environment
"         if with_pos is not given
" - [environment, lnum_begin, cnum_begin, lnum_end, cnum_end]
"         if with_pos is nonzero
function! latex#util#get_env(...)
  if a:0 > 0
    let with_pos = a:1
  else
    let with_pos = 0
  endif

  let begin_pat = '\C\\begin\_\s*{[^}]*}\|\\\@<!\\\[\|\\\@<!\\('
  let end_pat = '\C\\end\_\s*{[^}]*}\|\\\@<!\\\]\|\\\@<!\\)'
  let saved_pos = getpos('.')

  " move to the left until on a backslash
  let [bufnum, lnum, cnum, off] = getpos('.')
  let line = getline(lnum)
  while cnum > 1 && line[cnum - 1] != '\'
    let cnum -= 1
  endwhile
  call cursor(lnum, cnum)

  " match begin/end pairs but skip comments
  let flags = 'bnW'
  if strpart(getline('.'), col('.') - 1) =~ '^\%(' . begin_pat . '\)'
    let flags .= 'c'
  endif
  let [lnum1, cnum1] = searchpairpos(begin_pat, '', end_pat, flags,
        \ 'LatexBox_InComment()')

  let env = ''

  if lnum1
    let line = strpart(getline(lnum1), cnum1 - 1)

    if empty(env)
      let env = matchstr(line, '^\C\\begin\_\s*{\zs[^}]*\ze}')
    endif
    if empty(env)
      let env = matchstr(line, '^\\\[')
    endif
    if empty(env)
      let env = matchstr(line, '^\\(')
    endif
  endif

  if with_pos == 1
    let flags = 'nW'
    if !(lnum1 == lnum && cnum1 == cnum)
      let flags .= 'c'
    endif

    let [lnum2, cnum2] = searchpairpos(begin_pat, '', end_pat, flags,
          \ 'LatexBox_InComment()')

    call setpos('.', saved_pos)
    return [env, lnum1, cnum1, lnum2, cnum2]
  else
    call setpos('.', saved_pos)
    return env
  endif
endfunction

" {{{1 latex#util#tex2tree
function! latex#util#tex2tree(str)
  let tree = []
  let i1 = 0
  let i2 = -1
  let depth = 0
  while i2 < len(a:str)
    let i2 = match(a:str, '[{}]', i2 + 1)
    if i2 < 0
      let i2 = len(a:str)
    endif
    if i2 >= len(a:str) || a:str[i2] == '{'
      if depth == 0
        let item = substitute(strpart(a:str, i1, i2 - i1),
              \ '^\s*\|\s*$', '', 'g')
        if !empty(item)
          call add(tree, item)
        endif
        let i1 = i2 + 1
      endif
      let depth += 1
    else
      let depth -= 1
      if depth == 0
        call add(tree, LatexBox_TexToTree(strpart(a:str, i1, i2 - i1)))
        let i1 = i2 + 1
      endif
    endif
  endwhile
  return tree
endfunction

" {{{1 latex#util#tree2tex
function! latex#util#tree2tex(tree)
  if type(a:tree) == type('')
    return a:tree
  else
    return '{' . join(map(a:tree, 'LatexBox_TreeToTex(v:val)'), '') . '}'
  endif
endfunction

" {{{1 Modeline
" vim:fdm=marker:ff=unix
