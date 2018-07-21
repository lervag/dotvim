function! personal#qf#adjust_height(minheight, maxheight) abort " {{{1
  execute max([a:minheight, min([line('$') + 1, a:maxheight])])
        \ . 'wincmd _'
endfunction

" }}}1
function! personal#qf#delete_line(...) abort " {{{1
  if a:0 == 1 && type(a:1) == type('')
    " called from g@
    let [l1, l2] = [line("'["), line("']")]
  elseif a:0 == 2
    " called from cmdline
    let [l1, l2] = [a:1, a:2]
  else
    echom 'Argument error (kickfix#QDeleteLine)'
    return
  endif
  let curline = line('.')
  let l:oldqf = getqflist()
  let nqf = copy(l:oldqf)
  call remove(nqf, l1 - 1, l2 - 1)
  call setqflist(nqf, 'r')
  call cursor(curline, 0)
endfunction

" }}}1
function! personal#qf#filter(include) abort " {{{1
  let l:rx = input(a:include ? 'Filter (include): ' : 'Filter (remove): ')
  let l:new = []
  let l:oldqf = getqflist()
  for l:entry in l:oldqf
    let l:string = bufname(l:entry.bufnr) . ' | ' . l:entry.text
    if (a:include && match(l:string, l:rx) >= 0)
          \ || (!a:include && match(l:string, l:rx) < 0)
      call add(l:new, copy(l:entry))
    endif
  endfor
  call setqflist(l:new, 'r')
endfunction

" }}}1
