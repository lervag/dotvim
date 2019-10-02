let s:file = fnameescape(expand('<sfile>'))

execute 'nnoremap <space>ar :source' s:file . "\<cr>"
nmap <space>aa <space>ar:call CreateNotes()<cr>

function! CreateNotes() abort " {{{1
  let l:title = expand('<cword>')
  let l:template = join([
        \ '# Note',
        \ 'model: Basic',
        \ 'tags: {tag}',
        \ '',
        \ '## Front',
        \ '**{tag}**',
        \ '',
        \ '{q}',
        \ '',
        \ '## Back',
        \ '{a}',
        \], "\n")
  let l:template = substitute(l:template, '{tag}', l:title, 'g')
  let l:start_pos = getcurpos()

  normal! dd
  let l:lnum = search('^$', 'n')
  let l:lines = getline(line('.'), l:lnum-1)

  let l:current = {}
  let l:list = []
  for l:line in l:lines
    if empty(l:current)
      let l:current.q = matchstr(l:line, '^Q: \zs.*')
    else
      let l:current.a = matchstr(l:line, '^A: \zs.*')
      call add(l:list, l:current)
      let l:current = {}
    endif
    normal! dd
  endfor

  for l:e in l:list
    let l:new = copy(l:template)
    let l:new = substitute(l:new, '{q}', l:e.q, 'g')
    let l:new = substitute(l:new, '{a}', l:e.a, 'g')
    call append(line('.')-1, split(l:new, "\n") + [''])
  endfor

  normal! dd

  keepjumps call setpos('.', l:start_pos)
endfunction

" }}}1
