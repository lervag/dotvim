function! personal#python#includexpr()
  let line = getline('.')
  let fname = substitute(v:fname, '\.', '/', 'g')

  if line =~# '^\s*from'
    let pre = matchstr(line, '^\s*from \zs\S*')
    let pre = substitute(pre, '^\.\.', '../', '')
    let pre = substitute(pre, '^\.', '', '')
    let pre = substitute(pre, '\w\zs\.', '/', 'g')

    for cand in [
          \ findfile(pre . '/' . fname),
          \ findfile(pre),
          \ findfile(pre . '/__init__.py'),
          \ pre,
          \]
      if filereadable(cand)
        return cand
      endif
    endfor

    return ''
  else
    return substitute(matchstr(line, '^\s*import \zs\S*'), '\.', '/', 'g')
  endif
endfunction

function! personal#python#set_path()
  let &l:path = &path

  " Add standard python paths
  python3 << EOF
import os
import sys
import vim
for p in sys.path:
    # Add each directory in sys.path, if it exists.
    if os.path.isdir(p):
        # Command 'set' needs backslash before each space.
        vim.command(r"setlocal path+=%s" % (p.replace(" ", r"\ ")))
EOF

  " Add package root to path
  let path = expand('%:p:h')
  let top_level = ''
  while len(path) > 1
    if filereadable(path . '/__init__.py')
      let top_level = path
    endif
    let path = fnamemodify(path, ':h')
  endwhile

  if !empty(top_level)
    let &l:path .= ',' . top_level . '/**'
  endif
endfunction

" vim: fdm=syntax
