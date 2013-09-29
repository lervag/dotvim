"
" Functions sorted by name
"
" {{{1 latex#util#change_environment
function! latex#util#change_environment(new_env)
  let [env, l1, c1, l2, c2] = latex#util#get_env(1)

  if a:new_env == '\[' || a:new_env == '['
    let beg = '\['
    let end = '\]'
    let n1 = 1
    let n2 = 1
  elseif a:new_env == '\(' || a:new_env == '('
    let beg = '\('
    let end = '\)'
    let n1 = 1
    let n2 = 1
  else
    let beg = '\begin{' . a:new_env . '}'
    let end = '\end{' . a:new_env . '}'
    let n1 = len(env) + 7
    let n2 = len(env) + 5
  endif

  let line = getline(l1)
  let line = strpart(line, 0, c1 - 1) . l:beg . strpart(line, c1 + n1)
  call setline(l1, line)
  let line = getline(l2)
  let line = strpart(line, 0, c2 - 1) . l:end . strpart(line, c2 + n2)
  call setline(l2, line)
endfunction

" {{{1 latex#util#change_environment_prompt
function! latex#util#change_environment_prompt()
  let new_env = input('Change ' . latex#util#get_env() . ' for: ', '',
        \ 'customlist,' . s:sidwrap('input_complete'))
  if empty(new_env)
    return
  else
    call latex#util#change_environment(new_env)
  endif
endfunction

" {{{1 latex#util#change_environment_toggle_star
function! latex#util#change_environment_toggle_star()
  let env = latex#util#get_env()

  if env == '\('
    return
  elseif env == '\['
    let new_env = equation
  elseif env[-1:] == '*'
    let new_env = env[:-2]
  else
    let new_env = env . '*'
  endif

  call latex#util#change_environment(new_env)
endfunction

" {{{1 latex#util#close_environment
let s:bracket_pairs = [
        \ ['(', ')'],
        \ ['\[', '\]'],
        \ ['\\{', '\\}'],
        \ ['|', '|'],
        \ ['\.', '|']
      \ ]
function! latex#util#close_environment()
  " Left/Right pairs
  let [nl, nc] = searchpairpos('\C\\left\>', '', '\C\\right\>',
        \ 'bnW', 'latex#util#in_comment()')
  if nl
    let line = strpart(getline(nl), nc - 1)
    let bracket = matchstr(line, '^\\left\zs\((\|\[\|\\{\||\|\.\)\ze')
    for [open, close] in s:bracket_pairs
      let bracket = substitute(bracket, open, close, 'g')
    endfor
    return '\right' . bracket
  endif

  " Environment
  let env = latex#util#get_env()
  if env == '\['
    return '\]'
  elseif env == '\('
    return '\)'
  elseif env != ''
    return '\end{' . env . '}'
  endif

  " No closure found
  return ''
endfunction

" {{{1 latex#util#convert_back
function! latex#util#convert_back(line)
  "
  " Substitute stuff like '\IeC{\"u}' to corresponding unicode symbols
  "
  let line = a:line
  if g:latex_toc_plaintext
    let line = substitute(line, '\\IeC\s*{\\.\(.\)}', '\1', 'g')
  else
    for [pat, symbol] in s:convert_back_list
      let line = substitute(line, pat, symbol, 'g')
    endfor
  endif
  return line
endfunction

let s:convert_back_list = map([
      \ ['\\''A}'        , 'Á'],
      \ ['\\`A}'         , 'À'],
      \ ['\\^A}'         , 'À'],
      \ ['\\¨A}'         , 'Ä'],
      \ ['\\"A}'         , 'Ä'],
      \ ['\\''a}'        , 'á'],
      \ ['\\`a}'         , 'à'],
      \ ['\\^a}'         , 'à'],
      \ ['\\¨a}'         , 'ä'],
      \ ['\\"a}'         , 'ä'],
      \ ['\\''E}'        , 'É'],
      \ ['\\`E}'         , 'È'],
      \ ['\\^E}'         , 'Ê'],
      \ ['\\¨E}'         , 'Ë'],
      \ ['\\"E}'         , 'Ë'],
      \ ['\\''e}'        , 'é'],
      \ ['\\`e}'         , 'è'],
      \ ['\\^e}'         , 'ê'],
      \ ['\\¨e}'         , 'ë'],
      \ ['\\"e}'         , 'ë'],
      \ ['\\''I}'        , 'Í'],
      \ ['\\`I}'         , 'Î'],
      \ ['\\^I}'         , 'Ì'],
      \ ['\\¨I}'         , 'Ï'],
      \ ['\\"I}'         , 'Ï'],
      \ ['\\''i}'        , 'í'],
      \ ['\\`i}'         , 'î'],
      \ ['\\^i}'         , 'ì'],
      \ ['\\¨i}'         , 'ï'],
      \ ['\\"i}'         , 'ï'],
      \ ['\\''{\?\\i }'  , 'í'],
      \ ['\\''O}'        , 'Ó'],
      \ ['\\`O}'         , 'Ò'],
      \ ['\\^O}'         , 'Ô'],
      \ ['\\¨O}'         , 'Ö'],
      \ ['\\"O}'         , 'Ö'],
      \ ['\\''o}'        , 'ó'],
      \ ['\\`o}'         , 'ò'],
      \ ['\\^o}'         , 'ô'],
      \ ['\\¨o}'         , 'ö'],
      \ ['\\"o}'         , 'ö'],
      \ ['\\o }'         , 'ø'],
      \ ['\\''U}'        , 'Ú'],
      \ ['\\`U}'         , 'Ù'],
      \ ['\\^U}'         , 'Û'],
      \ ['\\¨U}'         , 'Ü'],
      \ ['\\"U}'         , 'Ü'],
      \ ['\\''u}'        , 'ú'],
      \ ['\\`u}'         , 'ù'],
      \ ['\\^u}'         , 'û'],
      \ ['\\¨u}'         , 'ü'],
      \ ['\\"u}'         , 'ü'],
      \ ['\\`N}'         , 'Ǹ'],
      \ ['\\\~N}'        , 'Ñ'],
      \ ['\\''n}'        , 'ń'],
      \ ['\\`n}'         , 'ǹ'],
      \ ['\\\~n}'        , 'ñ'],
      \], '[''\C\(\\IeC\s*{\)\?'' . v:val[0], v:val[1]]')

" {{{1 latex#util#get_env
function! latex#util#get_env(...)
  " latex#util#get_env([with_pos])
  " Returns:
  " - environment
  "         if with_pos is not given
  " - [environment, lnum_begin, cnum_begin, lnum_end, cnum_end]
  "         if with_pos is nonzero
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
        \ 'latex#util#in_comment()')

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
          \ 'latex#util#in_comment()')

    call setpos('.', saved_pos)
    return [env, lnum1, cnum1, lnum2, cnum2]
  else
    call setpos('.', saved_pos)
    return env
  endif
endfunction

" {{{1 latex#util#has_syntax
function! latex#util#has_syntax(name, ...)
  " Usage: latex#util#has_syntax(name, [line], [col])
  let line = a:0 >= 1 ? a:1 : line('.')
  let col  = a:0 >= 2 ? a:2 : col('.')
  return 0 <= index(map(synstack(line, col),
        \ 'synIDattr(v:val, "name") == "' . a:name . '"'), 1)
endfunction

" {{{1 latex#util#in_comment
function! latex#util#in_comment(...)
  let line = a:0 >= 1 ? a:1 : line('.')
  let col = a:0 >= 2 ? a:2 : col('.')
  return synIDattr(synID(line, col, 0), "name") =~# '^texComment'
endfunction

" {{{1 latex#util#kpsewhich
function! latex#util#kpsewhich(file, ...)
  let cmd  = 'kpsewhich '
  let cmd .= a:0 > 0 ? a:1 : ''
  let cmd .= ' "' . a:file . '"'
  let out = system(cmd)

  " If kpsewhich has found something, it returns a non-empty string with a
  " newline at the end; otherwise the string is empty
  if len(out)
    " Remove the trailing newline
    let out = fnamemodify(out[:-2], ':p')
  endif

  return out
endfunction

" {{{1 latex#util#select_current_env
function! latex#util#select_current_env(seltype)
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

" {{{1 latex#util#select_inline_math
function! latex#util#select_inline_math(seltype)
  " seltype is either 'inner' or 'outer'

  let dollar_pat = '\\\@<!\$'

  if latex#util#has_syntax('texMathZoneX')
    call s:search_and_skip_comments(dollar_pat, 'cbW')
  elseif getline('.')[col('.') - 1] == '$'
    call s:search_and_skip_comments(dollar_pat, 'bW')
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

  call s:search_and_skip_comments(dollar_pat, 'W')

  if a:seltype == 'inner'
    normal! h
  endif
endfunction

" {{{1 latex#util#set_default
function! latex#util#set_default(variable, default)
  if !exists(a:variable)
    let {a:variable} = a:default
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
        call add(tree, latex#util#tex2tree(strpart(a:str, i1, i2 - i1)))
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
    return '{' . join(map(a:tree, 'latex#util#tree2tex(v:val)'), '') . '}'
  endif
endfunction

" {{{1 latex#util#wrap_selection
function! latex#util#wrap_selection(wrapper)
  keepjumps normal! `>a}
  execute 'keepjumps normal! `<i\' . a:wrapper . '{'
endfunction

" {{{1 latex#util#wrap_selection_prompt
function! latex#util#wrap_selection_prompt(...)
  let env = input('Environment: ', '',
        \ 'customlist,' . s:sidwrap('input_complete'))
  if empty(env)
    return
  endif

  " Make sure custom indentation does not interfere
  let ieOld = &indentexpr
  setlocal indentexpr=""

  if visualmode() ==# 'V'
    execute 'keepjumps normal! `>o\end{' . env . '}'
    execute 'keepjumps normal! `<O\begin{' . env . '}'
    " indent and format, if requested.
    if a:0 && a:1
      normal! gv>
      normal! gvgq
    endif
  else
    execute 'keepjumps normal! `>a\end{' . env . '}'
    execute 'keepjumps normal! `<i\begin{' . env . '}'
  endif

  exe "setlocal indentexpr=" . ieOld
endfunction
" }}}1

" {{{1 s:sidwrap
let s:SID = matchstr(expand('<sfile>'), '\zs<SNR>\d\+_\ze.*$')
function! s:sidwrap(func)
  return s:SID . a:func
endfunction

" {{{1 s:input_complete
function! s:input_complete(lead, cmdline, pos)
  let suggestions = []
  for entry in g:latex_complete_environments
    let env = entry.word
    if env =~ '^' . a:lead
      call add(suggestions, env)
    endif
  endfor
  return suggestions
endfunction

" {{{1 s:search_and_skip_comments
function! s:search_and_skip_comments(pat, ...)
  " Usage: s:search_and_skip_comments(pat, [flags, stopline])
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
" }}}1 Modeline

" vim:fdm=marker:ff=unix
