" {{{1 latex#latexmk#init
function! latex#latexmk#init(initialized)
  "
  " Initialize pid for current tex file
  "
  if !has_key(g:latex#data[b:latex.id], 'pid')
    let g:latex#data[b:latex.id].pid = 0
  endif

  "
  " If all buffers for a given latex project are closed, kill latexmk
  "
  augroup latex_latexmk
    autocmd BufUnload <buffer> call s:stop_buffer()
  augroup END

  "
  " Set default mappings
  "
  if g:latex_default_mappings
    nmap <silent><buffer> <localleader>ll :call latex#latexmk#compile()<cr>
    nmap <silent><buffer> <localleader>lc :call latex#latexmk#clean(0)<cr>
    nmap <silent><buffer> <localleader>lC :call latex#latexmk#clean(1)<cr>
    nmap <silent><buffer> <localleader>lg :call latex#latexmk#status(0)<cr>
    nmap <silent><buffer> <localleader>lG :call latex#latexmk#status(1)<cr>
    nmap <silent><buffer> <localleader>lk :call latex#latexmk#stop()<cr>
    nmap <silent><buffer> <localleader>le :call latex#latexmk#errors()<cr>
  endif

  "
  " Ensure that all latexmk processes are stopped when vim exits
  " Note: Only need to define this once, globally.
  "
  if !a:initialized
    augroup latex_latexmk
      autocmd!
      autocmd VimLeave *.tex call s:stop_all()
    augroup END
  endif
endfunction

" {{{1 latex#latexmk#compile
function! latex#latexmk#compile()
  let data = g:latex#data[b:latex.id]
  if data.pid
    echomsg "latexmk is already running for `" . data.base . "'"
    return
  endif

  "
  " Set latexmk command with options
  "
  let cmd  = '!cd ' . data.root . ' && '
  let cmd .= 'max_print_line=2000 latexmk'
  let cmd .= ' -' . g:latex_latexmk_output
  let cmd .= ' -quiet '
  let cmd .= ' -pvc'
  let cmd .= g:latex_latexmk_options
  let cmd .= ' -e ' . shellescape('$pdflatex =~ s/ / -file-line-error /')
  let cmd .= ' -e ' . shellescape('$latex =~ s/ / -file-line-error /')
  let cmd .= ' ' . data.base
  let cmd .= ' &>/dev/null &'
  let g:latex#data[b:latex.id].cmd = cmd

  "
  " Start latexmk and save PID
  "
  call s:execute(cmd)
  let g:latex#data[b:latex.id].pid = system('pgrep -nf latexmk')[:-2]
  echomsg 'latexmk started successfully'
endfunction

" {{{1 latex#latexmk#clean
function! latex#latexmk#clean(full)
  let data = g:latex#data[b:latex.id]
  if data.pid
    echomsg "latexmk is already running"
    return
  endif

  "
  " Run latexmk clean process
  "
  let cmd = '!cd ' . data.root . ';'
  if a:full
    let cmd .= 'latexmk -C '
  else
    let cmd .= 'latexmk -c '
  endif
  let cmd .= data.base . ' &>/dev/null'
  let g:latex#data[b:latex.id].clean_cmd = cmd

  call s:execute(cmd)
  if a:full
    echomsg "latexmk full clean finished"
  else
    echomsg "latexmk clean finished"
  endif
endfunction

" {{{1 latex#latexmk#stop
function! latex#latexmk#stop()
  let pid  = g:latex#data[b:latex.id].pid
  let base = g:latex#data[b:latex.id].base
  if pid
    call s:execute('!kill ' . pid)
    let g:latex#data[b:latex.id].pid = 0
    echomsg "latexmk stopped for `" . base . "'"
  else
    echomsg "latexmk is not running for `" . base . "'"
  endif
endfunction

" {{{1 latex#latexmk#errors
function! latex#latexmk#errors()
  let log = g:latex#data[b:latex.id].log()

  cclose

  if g:latex_latexmk_autojump
    execute 'cfile ' . log
  else
    execute 'cgetfile ' . log
  endif

  botright copen
endfunction

" {{{1 latex#latexmk#status
function! latex#latexmk#status(detailed)
  if a:detailed
    let running = 0
    for data in g:latex#data
      if data.pid
        if !running
          echo "latexmk is running"
          let running = 1
        endif

        let name = data.tex
        if len(name) >= winwidth('.') - 20
          let name = "..." . name[-winwidth('.')+23:]
        endif

        echom printf('pid: %6s, file: %-s', data.pid, name)
      endif
    endfor

    if !running
      echo "latexmk is not running"
    endif
  else
    if g:latex#data[b:latex.id].pid
      echo "latexmk is running"
    else
      echo "latexmk is not running"
    endif
  endif
endfunction
" }}}1

" {{{1 s:stop_buffer
function! s:stop_buffer()
  "
  " Only run if latex variables are set
  "
  if !exists('b:latex') | return | endif
  let id = b:latex.id
  let pid = g:latex#data[id].pid

  "
  " Only stop if latexmk is running
  "
  if pid
    "
    " Count the number of buffers that point to current latex blob
    "
    let n = 0
    for b in filter(range(1, bufnr("$")), 'buflisted(v:val)')
      if id == getbufvar(b, 'latex', {'id' : -1}).id
        let n += 1
      endif
    endfor

    "
    " Only stop if current buffer is the last for current latex blob
    "
    if n == 1
      call latex#latexmk#stop()
    endif
  endif
endfunction

" {{{1 s:stop_all
function! s:stop_all()
  for data in g:latex#data
    if data.pid
      call s:execute('!kill ' . data.pid)
    endif
  endfor
endfunction

" {{{1 s:execute
function! s:execute(cmd)
  silent execute a:cmd
  if !has('gui_running')
    redraw!
  endif
endfunction
" }}}1

" vim:fdm=marker:ff=unix
