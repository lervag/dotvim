"
" Various personal stuff
"

function! personal#print_file(fname)
  let l:pdf = a:fname . '.pdf'
  call system(printf('ps2pdf %s %s', a:fname, l:pdf))

  echohl ModeMsg
  let l:reply = input('View file before printing [y/N]? ')
  echohl None
  echon "\n"
  if l:reply =~# '^y'
    call system('mupdf ' . l:pdf)
  endif

  echohl ModeMsg
  let l:reply = input('Save file to $HOME [Y/n]? ')
  echohl None
  echon "\n"
  if empty(l:reply) || l:reply =~# '^n'
    call system(printf('cp %s ~/vim-hardcopy.pdf', l:pdf))
  endif

  echohl ModeMsg
  let l:reply = input('Send file to printer [y/N]? ')
  echohl None
  echon "\n"
  if l:reply =~# '^y'
    call system('lp ' . l:pdf)
    let l:error = v:shell_error
  else
    let l:error = 1
  endif

  call delete(a:fname)
  call delete(l:pdf)
  return l:error
endfunction
