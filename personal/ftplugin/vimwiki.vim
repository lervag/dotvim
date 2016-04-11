setlocal nolisp
setlocal nosmartindent
setlocal nomodeline
setlocal autoindent
setlocal nowrap
setlocal foldlevel=1

" Define mappings
nnoremap <buffer> <leader>wl :call vimwiki#backlinks()<cr>

" {{{1 Journal settings
if expand('%:p') =~# 'wiki\/journal'
  nnoremap <silent><buffer> <leader>wk :call vimwiki#new_entry()<cr>
  nnoremap <silent><buffer> <c-k>      :VimwikiDiaryNextDay<cr>
  nnoremap <silent><buffer> <c-j>      :VimwikiDiaryPrevDay<cr>
endif

" }}}1
" {{{1 Link handler

function! VimwikiLinkHandler(link)
  let link_info = vimwiki#base#resolve_link(a:link)

  let lnk = expand(link_info.filename)
  if filereadable(lnk) && fnamemodify(lnk, ':e') ==? 'pdf'
    silent execute '!zathura ' lnk '&'
    return 1
  endif

  if link_info.scheme ==# 'file'
    let fname = link_info.filename
    if isdirectory(fname)
      execute 'Unite file:' . fname
      return 1
    elseif filereadable(fname)
      execute 'edit' fname
      return 1
    endif
  endif

  if link_info.scheme ==# 'doi'
    let url = substitute(link_info.filename, 'doi:', '', '')
    silent execute '!xdg-open http://dx.doi.org/' . url .'&'
    return 1
  endif

  return 0
endfunction

"}}}1
" {{{1 Sum command and mapping

command! -range Sum call s:sum()
vnoremap <leader>m :Sum<cr>
nnoremap <leader>m V}:Sum<cr>

function! s:sum() range
  let l:sum = 0.0
  for line in getline("'<", "'>")
    let l:sum += str2float(substitute(matchstr(line,
          \ '-\?\<\d\+\([ .]\d\+\)*\>'), '\s*', '', 'g'))
  endfor
  let @" = string(l:sum)
  echom string(l:sum)
endfunction

" }}}1

" vim: fdm=marker
