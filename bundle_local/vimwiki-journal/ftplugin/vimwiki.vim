setlocal nolisp
setlocal nosmartindent
setlocal nomodeline
setlocal autoindent
setlocal nowrap
setlocal fdl=1

" Define commands
command! -range Sum call s:sum()

" Define mappings
nnoremap <buffer> <leader>wl :call vimwiki#backlinks()<cr>
vnoremap <leader>m :Sum<cr>
nnoremap <leader>m V}:Sum<cr>

function! VimwikiLinkHandler(link) " {{{1
  let link_info = vimwiki#base#resolve_link(a:link)

  let lnk = expand(link_info.filename)
  if filereadable(lnk) && fnamemodify(lnk, ':e') ==? 'pdf'
    silent execute '!mupdf ' lnk '&'
    return 1
  endif

  if link_info.scheme ==# 'doi'
    let url = substitute(link_info.filename, 'doi:', '', '')
    silent execute '!xdg-open http://dx.doi.org/' . url .'&'
    return 1
  endif

  return 0
endfunction

" }}}1

function! s:sum() range " {{{1
  let l:sum = 0.0
  for line in getline("'<", "'>")
    let l:sum += str2float(substitute(matchstr(line,
          \ '\<-\?\d\+\([ .]\d\+\)*\>'), '\s*', '', 'g'))
  endfor
  echom string(l:sum)
endfunction

" }}}1
