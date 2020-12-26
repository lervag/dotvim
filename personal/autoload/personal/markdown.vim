function! personal#markdown#init() abort " {{{1
  setlocal conceallevel=2
  setlocal foldmethod=expr
  setlocal foldexpr=personal#markdown#foldlevel(v:lnum)
  setlocal foldtext=personal#markdown#foldtext()

  call personal#markdown#color_code_blocks()

  onoremap <silent><buffer> ac :call personal#markdown#textobj_code_block(0, 0)<cr>
  xnoremap <silent><buffer> ac :<c-u>call personal#markdown#textobj_code_block(0, 1)<cr>
  onoremap <silent><buffer> ic :call personal#markdown#textobj_code_block(1, 0)<cr>
  xnoremap <silent><buffer> ic :<c-u>call personal#markdown#textobj_code_block(1, 1)<cr>

  nmap <buffer> ) <plug>(wiki-link-next)
  nmap <buffer> ( <plug>(wiki-link-prev)
endfunction

" }}}1

function! personal#markdown#color_code_blocks() abort " {{{1
  " This is based on an idea from reddit:
  " https://www.reddit.com/r/vim/comments/fob3sg/different_background_color_for_markdown_code/
  setlocal signcolumn=no

  sign define codeblock linehl=codeBlockBackground

  augroup code_block_background
    autocmd! * <buffer>
    autocmd InsertLeave  <buffer> call s:place_signs()
    autocmd BufEnter     <buffer> call s:place_signs()
    autocmd BufWritePost <buffer> call s:place_signs()
  augroup END
endfunction

" }}}1

function! personal#markdown#textobj_code_block(is_inner, vmode) abort " {{{1
  if !wiki#u#is_code(line('.'))
    if a:vmode
      normal! gv
    endif
    return
  endif

  let l:lnum1 = line('.')
  while 1
    if !wiki#u#is_code(l:lnum1-1) | break | endif
    let l:lnum1 -= 1
  endwhile

  let l:lnum2 = line('.')
  while 1
    if !wiki#u#is_code(l:lnum2+1) | break | endif
    let l:lnum2 += 1
  endwhile

  if a:is_inner
    let l:lnum1 += 1
    let l:lnum2 -= 1
  endif

  call cursor(l:lnum1, 1)
  normal! v
  call cursor(l:lnum2, strlen(getline(l:lnum2)))
endfunction

" }}}1

function! personal#markdown#foldlevel(lnum) abort " {{{1
  let l:line = getline(a:lnum)

  if wiki#u#is_code(a:lnum)
    return l:line =~# '^\s*```'
          \ ? (wiki#u#is_code(a:lnum+1) ? 'a1' : 's1')
          \ : '='
  endif

  if l:line =~# g:wiki#rx#header
    return '>' . len(matchstr(l:line, '#*'))
  endif

  return '='
endfunction

" }}}1
function! personal#markdown#foldtext() abort " {{{1
  let l:line = getline(v:foldstart)
  let l:text = substitute(l:line, '^\s*', repeat(' ',indent(v:foldstart)), '')
  return l:text
endfunction

" }}}1


function! s:place_signs() abort " {{{1
  let l:continue = 0
  let l:file = expand('%')

  execute 'sign unplace * file=' . l:file

  for l:lnum in range(1, line('$'))
    let l:line = getline(l:lnum)
    if l:continue || l:line =~# '^\s*```'
      execute printf('sign place %d line=%d name=codeblock file=%s',
            \ l:lnum, l:lnum, l:file)
    endif

    let l:continue = l:continue
          \ ? l:line !~# '^\s*```$'
          \ : l:line =~# '^\s*```'
  endfor
endfunction

" }}}1
