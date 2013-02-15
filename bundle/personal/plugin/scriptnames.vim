function! s:PutInBuffer(cmd, ...)
  let save_more = &more
  set nomore
  redir => lines
  silent execute a:cmd
  redir END
  let &more = save_more
  new
  setlocal buftype=nofile bufhidden=hide noswapfile
  silent put =lines
  silent! g/^\s*$/d
  silent! %s/^\s*\d\+:\s*//e
  if a:0 > 0
    for filter in a:000
      silent execute 'v/' . filter . '/d'
    endfor
  endif
  0
endfunction
command! -nargs=+ Redirect call s:PutInBuffer(<f-args>)
