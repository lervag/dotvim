if exists('b:ft_personal_markdown') | finish | endif
let b:did_personal_markdown = 1

set conceallevel=2

let s:file = fnameescape(expand('<sfile>'))
execute 'nnoremap <space>ar :source' s:file . "\<cr>"

nmap <silent> <space>aa <space>ar:call CreateNotes()<cr>

call personal#syntax#color_code_blocks()

function! CreateNotes() abort " {{{1
  " Create notes from list of question/answers
  "
  " <category>
  " tags: list (default = category)
  " Q: ...
  " A: ...
  " tags: new list
  " Q: ...
  " A: ...
  "
  if getline('.') =~# '^\s*$' | return | endif

  let l:template = join([
        \ '# Note',
        \ 'model: Basic',
        \ 'tags: {tags}',
        \ '',
        \ '## Front',
        \ '**{category}**',
        \ '',
        \ '{q}',
        \ '',
        \ '## Back',
        \ '{a}',
        \], "\n")

  let l:lnum_start = search('^\n\zs\|\%^', 'ncb')
  if l:lnum_start > line('.')
    let l:lnum_start = line('.')
  endif

  let l:lnum_end = search('\n$\|\%$', 'nc')
  if l:lnum_end - 1 <= l:lnum_start | return | endif

  let l:lines = getline(l:lnum_start, l:lnum_end)

  let l:tags = remove(l:lines, 0)
  let l:template = substitute(l:template, '{category}', l:tags, 'g')

  let l:current = {}
  let l:list = []
  for l:line in l:lines
    if l:line =~# '^tags\?:'
      let l:tags = matchstr(l:line, '^tags\?: \zs.*')
      continue
    endif

    if empty(l:current)
      let l:current.tags = l:tags
      let l:current.q = matchstr(l:line, '^Q: \zs.*')
    else
      let l:current.a = matchstr(l:line, '^A: \zs.*')
      call add(l:list, l:current)
      let l:current = {}
    endif
  endfor

  " Remove existing lines
  execute l:lnum_start . ',' . l:lnum_end 'd'

  " Add new notes
  for l:e in l:list
    let l:new = copy(l:template)
    let l:new = substitute(l:new, '{tags}', l:e.tags, 'g')
    let l:new = substitute(l:new, '{q}', l:e.q, 'g')
    let l:new = substitute(l:new, '{a}', l:e.a, 'g')
    call append(line('.')-1, split(l:new, "\n") + [''])
  endfor

  keepjumps call cursor(l:lnum_start, 1)
endfunction

" }}}1
