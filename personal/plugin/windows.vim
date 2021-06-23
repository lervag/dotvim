if exists('g:windows_loaded')
  finish
endif
let g:windows_loaded = 1

let s:save_cpoptions = &cpoptions
set cpoptions&vim

" Commands
command! WinOnly
      \ call s:remove_all_but_current()
command! WinResize
      \ call s:resize_windows()
command! -bang -complete=buffer -nargs=? WinBufDelete
      \ call s:buf_delete(<q-bang>, <q-args>)

" Mappings
nnoremap <silent> <c-w><c-o> :WinOnly<cr>
nnoremap <silent> <c-u>      :WinBufDelete<cr>
nnoremap <silent> <leader>q  :WinResize<cr>

" Main functions
function! s:remove_all_but_current() " {{{1
  silent! wincmd o

  for bfr in getbufinfo()
    if bfr.hidden && !bfr.changed
      execute 'bwipeout' bfr.bufnr
    endif
  endfor
endfunction

" }}}1
function! s:resize_windows() " {{{1
  let l:width = s:get_target_width()
  if l:width == &columns | return | endif

  if has('gui') || empty($TMUX . $STY)
    let &columns = l:width
  else
    let l:winid = systemlist('xdotool getactivewindow')[0]
    call system(printf('xdotool windowsize --usehints %s %d %d',
          \ l:winid, l:width, &lines+1))
    sleep 50m
  endif

  wincmd =
  redraw!
endfunction

" }}}1
function! s:buf_delete(bang, buffer_name) " {{{1
  let buffer = s:str2bufnr(a:buffer_name)
  let w:bdelete_back = 1

  if buffer < 0
    echoerr 'E516: No buffers were deleted. No match for' a:buffer_name
  endif

  if getbufvar(buffer, '&modified') && empty(a:bang)
    echoerr 'E89: No write since last change for buffer' buffer
          \ '(add ! to override)'
  endif

  " If the buffer is set to delete and it contains changes, we can't switch
  " away from it. Hide it before eventual deleting:
  if getbufvar(buffer, '&modified') && !empty(a:bang)
    call setbufvar(buffer, '&bufhidden', 'hide')
  endif

  " For cases where adding buffers causes new windows to appear or hiding some
  " causes windows to disappear and thereby decrement, loop backwards.
  for window in reverse(range(1, winnr('$')))
    " For invalid window numbers, winbufnr returns -1.
    if winbufnr(window) != buffer | continue | endif
    execute window . 'wincmd w'

    " bprevious also wraps around the buffer list, if necessary:
    try
      execute bufnr('#') > 0 && buflisted(bufnr('#'))
            \ ? 'buffer #'
            \ : 'bprevious'
    catch /^Vim([^)]*):E85:/
      " E85: There is no listed buffer
    endtry

    " If no new buffer, then create new empty buffer
    if bufnr('%') == buffer
      call s:new(a:bang) 
    endif
  endfor

  " Because tabbars and other appearing/disappearing windows change
  " the window numbers, find where we were manually:
  let back = filter(range(1, winnr('$')), "getwinvar(v:val, 'bdelete_back')")[0]
  if back | execute back . 'wincmd w' | unlet w:bdelete_back | endif

  " If it hasn't been already deleted by &bufhidden, end its pains now.
  " Unless it previously was an unnamed buffer and :enew returned it again.
  if bufexists(buffer) && buffer != bufnr('%')
    try
      execute 'bdelete' . a:bang . ' ' . buffer
    catch /E516/
      " E516: No buffers were deleted. No match for buffer
    endtry
  endif
endfunction

" }}}1

" Utility functions
function! s:get_target_width() " {{{1
  let l:heights = map(filter(split(winrestcmd(), '|'),
        \ {_, x -> x =~# '^:\?\d'}),
        \ {_, x -> matchstr(x, '\d\+$')})

  let l:total_height = 0
  for l:h in l:heights
    let l:total_height += l:h
  endfor

  let l:count = float2nr(ceil(l:total_height/(1.0*&lines)))
  return l:count*82 + l:count - 1
endfunction

" }}}1
function! s:str2bufnr(buffer) " {{{1
  if empty(a:buffer)
    return bufnr('%')
  elseif a:buffer =~# '^\d\+$'
    return bufnr(str2nr(a:buffer))
  else
    return bufnr(a:buffer)
  endif
endfunction

" }}}1
function! s:new(bang) " {{{1
  execute 'enew' . a:bang

  setlocal noswapfile

  " If empty and out of sight, delete it right away:
  setlocal bufhidden=wipe

  " Regular buftype warns people if they have unsaved text there.  Wouldn't
  " want to lose someone's data:
  setlocal buftype=

  " Hide the buffer from buffer explorers and tabbars:
  setlocal nobuflisted
endfunction

" }}}1
function! s:has_sign_cols() " {{{1
  return len(split(execute('sign place'), "\n")) > 1
endfunction

" }}}1

let &cpoptions = s:save_cpoptions
