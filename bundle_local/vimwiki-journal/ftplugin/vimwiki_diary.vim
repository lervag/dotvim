if expand('%:p') !~ 'wiki\/journal' | finish | endif

" Create new time entry
nnoremap <silent><buffer> ,l gg/^\d\d:\d\d<cr>}O<c-r>=strftime("%H:%M")<cr>  

" Day-to-day navigation
nnoremap <silent><buffer> <c-k> :VimwikiDiaryNextDay<cr>
nnoremap <silent><buffer> <c-j> :VimwikiDiaryPrevDay<cr>

" Simple create wiki link
vunmap   <buffer><cr>
vnoremap <silent><buffer><unique> <cr> :call <sid>normalize()<cr>
function! s:normalize() " {{{1
  let sel_save = &selection
  let &selection = "old"
  let rv = @"
  let rt = getregtype('"')

  try
    normal! gv""y
    let replace = '[[..a/' . @" . '|' . @" . ']]'
    call setreg('"', replace, 'v')
    normal! `>""pgvd
  finally
    call setreg('"', rv, rt)
    let &selection = sel_save
  endtry
endfunction " }}}1

