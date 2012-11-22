setl foldmethod=expr
setl foldexpr=Markdown_FoldLevel()
setl foldtext=Markdown_FoldText()

function! Markdown_FoldLevel()
  " Check for hash headers
  let hashCount = len(matchstr(getline(v:lnum), '^#\{1,6}'))
  if hashCount > 0
    return ">" . hashCount
  endif

  " Keep fold level
  return "="
endfunction

function! Markdown_FoldText()

  " Check for hash headers
  let level = 0
  let line = getline(v:foldstart)
  let hashCount = len(matchstr(line, '^#\{1,6}'))
  if hashCount > 0
    let level = hashCount
  else
    if line != ''
      let nextline = getline(v:foldstart + 1)
      if nextline =~ '^==='
        let level = 1
      elseif nextline =~ '^---'
        let level = 2
      endif
    endif
  endif

  " Check for underlined headers
  let title = substitute(getline(v:foldstart), '^#\+\s*', '', '')
  return repeat('#', level) . ' ' . title
endfunction
