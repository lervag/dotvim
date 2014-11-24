if expand('%:p') !~ 'wiki\/journal' | finish | endif

" Create new time entry
nnoremap <silent><buffer> ,l gg/^\d\d:\d\d<cr>}O<c-r>=strftime("%H:%M")<cr>  

" Day-to-day navigation
nnoremap <silent><buffer> <c-k> :VimwikiDiaryNextDay<cr>
nnoremap <silent><buffer> <c-j> :VimwikiDiaryPrevDay<cr>
