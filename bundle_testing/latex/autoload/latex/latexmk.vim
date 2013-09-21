" {{{1 latex#latexmk#init
function! latex#latexmk#init()
  " Define commands
  command! -bang  Latexmk       call latex#latexmk#compile(<q-bang> == "!")
  command! -bang  LatexmkClean  call latex#latexmk#clean(<q-bang> == "!")
  command! -bang  LatexmkStatus call latex#latexmk#status(<q-bang> == "!")
  command! LatexmkStop          call latex#latexmk#stop(0)
  command! LatexErrors          call latex#latexmk#errors(-1)

  " Create autogroup with autocommands to ensure all processes are terminated
  " properly
  augroup latex
    autocmd BufUnload <buffer> call latex#latexmk#stop(1)
    autocmd VimLeave *         call s:kill_all_pids()
  augroup END
endfunction

" {{{1 latex#latexmk#compile
function! latex#latexmk#compile()
  if b:latex#file.pid
    echomsg "latexmk is already running for `" . b:latex#file.name . "'"
    return
  endif

  " Set latexmk command with options
  let cmd  = '!cd ' . b:latex#file.root . ' && '
  let cmd .= 'max_print_line=2000 latexmk'
  let cmd .= ' -' . g:latex#latexmk#output
  let cmd .= ' -quiet '
  let cmd .= ' -pvc'
  let cmd .= g:latex#latexmk#options
  let cmd .= ' -e ' . shellescape('$pdflatex =~ s/ / -file-line-error /')
  let cmd .= ' -e ' . shellescape('$latex =~ s/ / -file-line-error /')
  let cmd .= ' ' . b:latex#file.name
  let cmd .= ' &>/dev/null &'

  echo 'Compiling to ' . g:latex#latexmk#output . ' ...'
  silent execute cmd

  " Save PID in order to be able to kill the process when wanted.
  let b:latex#file.pid = s:get_pid(b:latex#file.path)

  " Redraw screen if necessary
  if !has("gui_running")
    redraw!
  endif
endfunction

" {{{1 latex#latexmk#clean
function! latex#latexmk#clean(full)
  if b:latex#file.pid
    echomsg "latexmk is already running"
    return
  endif

  let cmd = 'cd ' . b:latex#file.root . ';'
  if a:full
    let cmd .= 'latexmk -C '
  else
    let cmd .= 'latexmk -c '
  endif
  let cmd .= b:latex#file.name . ' &>/dev/null'
  call system(cmd)
  echomsg "latexmk clean finished"

  if !has('gui_running')
    redraw!
  endif
endfunction

" {{{1 latex#latexmk#errors
function! latex#latexmk#errors(status, ...)
  if a:0 >= 1
    let log = a:1 . '.log'
  else
    let log = LatexBox_GetLogFile()
  endif

  cclose

  " set cwd to expand error file correctly
  let l:cwd = fnamemodify(getcwd(), ':p')
  execute 'lcd ' . fnameescape(LatexBox_GetTexRoot())
  try
    if g:LatexBox_autojump
      execute 'cfile ' . fnameescape(log)
    else
      execute 'cgetfile ' . fnameescape(log)
    endif
  finally
    " restore cwd
    execute 'lcd ' . fnameescape(l:cwd)
  endtry

  " Always open window if started by LatexErrors command
  if a:status < 0
    botright copen
  else
    " Write status message to screen
    redraw
    if a:status > 0 || len(getqflist())>1
      echomsg 'Compiling to ' . g:LatexBox_output_type . ' ... failed!'
    else
      echomsg 'Compiling to ' . g:LatexBox_output_type . ' ... success!'
    endif

    " Only open window when an error/warning is detected
    if g:LatexBox_quickfix
      belowright cw
      if g:LatexBox_quickfix==2
        wincmd p
      endif
    endif
  endif
endfunction

" {{{1 latex#latexmk#status
function! latex#latexmk#status(detailed)
  if a:detailed
    echomsg "TODO"
  else
    if b:latex#file.pid
      echo "latexmk is running"
    else
      echo "latexmk is not running"
    endif
  endif
endfunction

" {{{1 latex#latexmk#stop
function! latex#latexmk#stop(silent)
  if b:latex#file.pid
    call s:kill_pid(b:latex#file.pid)
    if !a:silent
      echomsg "latexmk stopped for `" . b:latex#file.name . "'"
    endif
  elseif !a:silent
    echoerr "latexmk is not running for `" . b:latex#file.name . "'"
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

function! s:set_pid()
  let b:latex#file.pid = s:get_pid(b:latex#file.path)
  call add(s:latex_pids, b:latex#file.pid)
endfunction

function! s:get_pid(path)
  return substitute(system('pgrep -f "perl.*' . a:path . '"'),'\D','','')
endfunction

function! s:kill_self()
  call s:execute('!kill ' . b:latex#file.pid)
  call remove(s:latex_pids, b:latex#file.pid)
  let b:latex#file.pid = 0
endfunction

function! s:kill_all()
  for pid in s:latex_pids
    call s:execute('!kill ' . pid)
  endfor
endfunction
" }}}1

" vim:fdm=marker:ff=unix
