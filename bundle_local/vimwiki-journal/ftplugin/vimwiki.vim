setlocal nolisp
setlocal nosmartindent
setlocal nomodeline
setlocal autoindent
setlocal nowrap
setlocal fdl=1

nnoremap <buffer> <leader>wl :call vimwiki#backlinks()<cr>

"
" Custom link handlers
"
function! VimwikiLinkHandler(link)
  let link_info = vimwiki#base#resolve_link(a:link)

  let lnk = expand(link_info.filename)
  if filereadable(lnk) && fnamemodify(lnk, ':e') ==? 'pdf'
    silent execute '!mupdf ' lnk '&'
    return 1
  endif

  return 0
endfunction
