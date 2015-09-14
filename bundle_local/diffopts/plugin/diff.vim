let s:file = expand('<sfile>')

function! s:setup_diff_mode()
  execute "nnoremap \<leader>x :source " . s:file . "\<cr>"
  execute "nnoremap \<leader>z :split " . s:file . "\<cr>"

  if ! &diff | return | endif

  " Equalize splits
  ResizeSplits

  " nnoremap <silent> ]C /\v^[<>=]{4,7}($\|\s)<cr>
  " nnoremap <silent> [C ?\v^[<>=]{4,7}($\|\s)<cr>
  " nnoremap <silent> <c-w>u :wincmd p <bar> undo <bar> wincmd p <bar> diffupdate<cr>

  if s:fugitive()
    nnoremap <silent> <leader>gl :diffget //3<cr>
    nnoremap <silent> <leader>gr :diffget //2<cr>
  else
    nnoremap <silent> <leader>gl :diffget LO<cr>
    nnoremap <silent> <leader>gr :diffget RE<cr>
    nnoremap <silent> <leader>gb :diffget BA<cr>
  endif
endfunction

function! s:fugitive()
  redir => l:output
  silent buffers
  redir END
  return len(filter(split(l:output, '\n'), "v:val =~# 'fugitive:'")) > 0
endfunction

command! DiffMode :call s:setup_diff_mode()

if &diff
  call s:setup_diff_mode()
endif
