set nowrap

nnoremap <buffer> q :close<cr>

au FileType qf call AdjustWindowHeight(2, 20)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$") + 1, a:maxheight]), a:minheight]) . "wincmd _"
endfunction
