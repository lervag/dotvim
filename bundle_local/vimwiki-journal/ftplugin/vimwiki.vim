"
" My own extra settings for vimwiki
"
setlocal nolisp
setlocal nosmartindent
setlocal nomodeline
setlocal autoindent
setlocal nowrap
setlocal fdl=1

"
" Special setup for journal entries
"
if !expand('%:p') =~ 'wiki\/journal' | finish | endif

nnoremap <silent> ,l gg/^\d\d:\d\d<cr>}O<c-r>=strftime("%H:%M")<cr>  
nnoremap <silent> <c-k> :VimwikiDiaryNextDay<cr>
nnoremap <silent> <c-j> :VimwikiDiaryPrevDay<cr>

