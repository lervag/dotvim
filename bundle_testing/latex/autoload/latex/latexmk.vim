" {{{1 latex#latexmk#init
let s:latexmk_initialized = 0
function! latex#latexmk#init()
  "
  " Initialize pid for current tex file
  "
  if !has_key(g:latex#data[b:latex.id], 'pid')
    let g:latex#data[b:latex.id].pid = 0
  endif

  "
  " Initialize public interface
  "
  if s:latexmk_initialized
    return
  endif
  let s:latexmk_initialized = 1

  "
  " Define commands
  "
  command!       Latexmk       call latex#latexmk#compile()
  command!       LatexmkStop   call latex#latexmk#stop()
  command! -bang LatexmkClean  call latex#latexmk#clean(<q-bang> == "!")
  command!       LatexmkErrors call latex#latexmk#errors()
  command! -bang LatexmkStatus call latex#latexmk#status(<q-bang> == "!")

  "
  " Ensure that latexmk processes are stopped when appropriate
  "
" augroup latex_latexmk
"   autocmd BufUnload <buffer> call latex#latexmk#stop(1)
"   autocmd VimLeave *         call s:kill_all_pids()
" augroup END
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

  call s:latexmk_start()
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
  let cmd = 'cd ' . data.root . ';'
  if a:full
    let cmd .= 'latexmk -C '
  else
    let cmd .= 'latexmk -c '
  endif
  let cmd .= data.base . ' &>/dev/null'
  call system(cmd)
  echomsg "latexmk clean finished"

  " Redraw screen if necessary
  if !has('gui_running')
    redraw!
  endif
endfunction

" {{{1 latex#latexmk#stop
function! latex#latexmk#stop()
  let data = g:latex#data[b:latex.id]
  if data.pid
    call s:kill_pid(data.pid)
    let g:latex#data[b:latex.id].pid = 0
    echomsg "latexmk stopped for `" . data.base . "'"
  else
    echomsg "latexmk is not running for `" . data.base . "'"
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
    echomsg "TODO"
  else
    if g:latex#data[b:latex.id].pid
      echo "latexmk is running"
    else
      echo "latexmk is not running"
    endif
  endif
endfunction
" }}}1

" {{{1 Utility functions
function! s:execute(cmd)
  silent execute a:cmd
  if !has('gui_running')
    redraw!
  endif
endfunction

function! s:latexmk_start()
  "
  " Start the process and save the PID
  "
  call s:execute(g:latex#data[b:latex.id].cmd)
  let g:latex#data[b:latex.id].pid = split(system('pgrep -f "perl.*'
        \ . g:latex#data[b:latex.id].base . '"'),'\D')
  echomsg 'latexmk compilation started'
endfunction

function! s:kill_self()
  call s:execute('!kill ' . b:latex#file.pid)
  call remove(s:latex_pids, b:latex#file.pid)
  let b:latex#file.pid = 0
endfunction
" }}}1

" vim:fdm=marker:ff=unix
