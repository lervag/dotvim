let s:file = expand('<sfile>')

function! s:setup_diff_mode()
  execute "nnoremap \<leader>x :source " . s:file . "\<cr>"
  execute "nnoremap \<leader>z :split " . s:file . "\<cr>"

  if ! &diff | return | endif

  ResizeSplits

  nnoremap dol :diffget 1<cr>
  nnoremap dor :diffget 3<cr>
  nnoremap dp  :diffput 2<cr>
  nnoremap <leader>q :xa!<cr>

  nnoremap <leader>dr :3wincmd w<cr>
  nnoremap <leader>do :2wincmd w<cr>
  nnoremap <leader>dl :1wincmd w<cr>

  echom "..."
endfunction

command! DiffMode :call s:setup_diff_mode()

if &diff
  call s:setup_diff_mode()
endif
