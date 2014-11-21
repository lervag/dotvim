setlocal nolisp
setlocal nosmartindent
setlocal nomodeline
setlocal autoindent
setlocal nowrap
setlocal fdl=1

let g:ctrlp_extensions += ['vimwiki']

nnoremap <buffer> <leader>wl :call vimwiki#backlinks()<cr>

function! VimwikiLinkHandler(link)
  let [idx, scheme, path, subdir, lnk, ext, url, anchor] =
       \ vimwiki#base#resolve_scheme(a:link, 0)

  let lnk = expand(lnk)
  if filereadable(lnk) && fnamemodify(lnk, ':e') == 'pdf'
    silent execute '!mupdf ' . lnk .'&'
    return 1
  endif

  return 0
endfunction

