if exists('b:ft_personal_markdown') | finish | endif
let b:did_personal_markdown = 1

set conceallevel=2

call personal#syntax#color_code_blocks()

if expand('%:p') ==# expand('~/notes.md')
  ALEDisableBuffer
endif

let s:file = fnameescape(expand('<sfile>'))
execute 'nnoremap <silent><buffer> <space>ar :source' s:file . "\<cr>"

nnoremap <silent><buffer> <space>aa :call CreateNotes()<cr>
nnoremap <silent><buffer> <space>ai :call PrepareImage()<cr>

function! CreateNotes() abort " {{{1
  " Create notes from list of question/answers
  "
  " <category>
  " tags: list (default = category)
  " Q: ...
  " ...
  " A: ...
  " ...
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

    if l:line =~# '^Q:'
      if !empty(l:current)
        call add(l:list, l:current)
        let l:current = {}
      endif
      let l:current.tags = l:tags
      let l:current.q = [matchstr(l:line, '^Q: \zs.*')]
      let l:current.pointer = l:current.q
    elseif l:line =~# '^A:'
      let l:current.a = [matchstr(l:line, '^A: \zs.*')]
      let l:current.pointer = l:current.a
    else
      let l:current.pointer += [l:line]
    endif
  endfor

  if !empty(l:current)
    call add(l:list, l:current)
  endif

  if line('$') == l:lnum_end
    call append(line('$'), '')
  endif

  " Remove existing lines
  execute l:lnum_start . ',' . l:lnum_end 'd'

  " Add new notes
  for l:e in l:list
    let l:new = copy(l:template)
    let l:new = substitute(l:new, '{tags}', l:e.tags, 'g')
    let l:new = substitute(l:new, '{q}', join(l:e.q, "\n"), 'g')
    let l:new = substitute(l:new, '{a}', join(l:e.a, "\n"), 'g')
    let l:new = substitute(l:new, "  \n", "\n\n", 'g')
    call append(line('.')-1, split(l:new, "\n") + [''])
  endfor
  execute line('.') . 'd'

  keepjumps call cursor(l:lnum_start, 1)
endfunction

" }}}1
function! PrepareImage() abort " {{{1
  " Get origin file
  let l:file = fnamemodify(expand('<cfile>'), ':p')
  let l:cursor = filereadable(l:file)
  if !l:cursor
    let l:file = input('File: ', '', 'file')
    if empty(l:file) || !filereadable(l:file) | return | endif
  endif

  " Specify destination file name
  let l:newname = input('Name: ', fnamemodify(l:file, ':t:r'))
  if empty(l:newname) | return | endif
  redraw!

  let l:filename = l:newname . '.' . fnamemodify(l:file, ':e')
  let l:link = printf('![%s](%s)', l:newname, l:filename)
  let l:destination = fnamemodify(
        \ (!empty($APY_BASE) ? $APY_BASE
        \   : '~/documents/anki/lervag/collection.media/') . l:filename, ':p')

  " Check if destination already exists
  if filereadable(l:destination)
    echo 'Destination file exists!'
    echo l:destination
    if input('Overwrite? ') !~? 'y\%[es]\s*$'
      return
    endif
  endif

  " Move file to destination
  let l:status = rename(l:file, fnameescape(l:destination))
  if l:status != 0
    echo 'Error: File was not renamed'
    echo ' ' l:file
    echo ' ' l:destination
    return
  endif

  " Add link text
  if l:cursor
    call search('\f\+', 'bc')
    normal! v
    call search('\f\+', 'ce')
    normal! "_x
  endif
  execute 'silent normal!' "i\<c-r>=l:link\<cr>"
endfunction

" }}}1
