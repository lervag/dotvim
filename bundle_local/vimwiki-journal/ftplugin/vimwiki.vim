setlocal nolisp
setlocal nosmartindent
setlocal nomodeline
setlocal autoindent
setlocal nowrap
setlocal fdl=1

command! -n=? -com=buffer CtrlPVimwiki call ctrlp#init(ctrlp#vimwiki#cmd())
nnoremap <buffer> <space>w :CtrlPVimwiki<cr>

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
