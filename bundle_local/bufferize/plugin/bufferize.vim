" Define the Bufferize command
command! -nargs=* -complete=command Bufferize call s:bufferize(<q-args>)

function! s:bufferize(cmd)
  " Run command and collect output
  let save_more = &more
  set nomore
  redir => output
  silent execute a:cmd
  redir END
  let &more = save_more

  " Put the output in a new buffer
  new
  silent put =output
  call setline(1, split(output, "\n"))

  " Set buffer options
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal nomodified
  nnoremap <buffer> <cr> gf
  nnoremap <buffer> q :q<cr>
endfunction
