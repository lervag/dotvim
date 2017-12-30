function! personal#vimux#operator(type) abort " {{{1
  let l:text = join(getline(line("'["), line("']")), "\n")
  call VimuxSendText(l:text)
endfunction

" }}}1
