if exists('g:loaded_bdelete') || &compatible | finish | endif
let g:loaded_bdelete = 1

function! s:MyBdelete()
  try
    Bdelete
  catch /E516/
  catch
  endtry
endfunction

command! -bang -complete=buffer -nargs=? Bdelete
      \ :call s:bdelete(<q-bang>, <q-args>)

function! s:bdelete(bang, buffer_name)
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

function! s:str2bufnr(buffer)
  if empty(a:buffer)
    return bufnr('%')
  elseif a:buffer =~# '^\d\+$'
    return bufnr(str2nr(a:buffer))
  else
    return bufnr(a:buffer)
  endif
endfunction

function! s:new(bang)
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
