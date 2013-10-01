" {{{1 latex#init
let s:initialized = 0
function! latex#init()
  call s:init_variables()
  call s:init_blob()
  call s:init_mappings()

  call latex#set_errorformat()
  call latex#fold#init(s:initialized)
  call latex#toc#init(s:initialized)
  call latex#latexmk#init(s:initialized)
  call latex#motion#init(s:initialized)
  call latex#change#init(s:initialized)
  call latex#complete#init(s:initialized)

  "
  " This variable is used to allow a distinction between global and buffer
  " initialization
  "
  let s:initialized = 1
endfunction

" {{{1 latex#view
function! latex#view()
  let outfile = g:latex#data[b:latex.id].out()
  if !outfile
    echomsg "Can't view: Output file is not readable!"
    return
  endif

  silent execute '!' . g:latex_viewer . ' ' . outfile . ' &>/dev/null &'
  if !has("gui_running")
    redraw!
  endif
endfunction

" {{{1 latex#set_errorformat
function! latex#set_errorformat()
  "
  " Note: The error formats assume we're using the -file-line-error with
  "       [pdf]latex. For more info, see |errorformat-LaTeX|.
  "

  " Push file to file stack
  setlocal efm+=%+P**%f

  " Match errors
  setlocal efm=%E!\ LaTeX\ %trror:\ %m
  setlocal efm+=%E%f:%l:\ %m
  setlocal efm+=%E!\ %m

  " More info for undefined control sequences
  setlocal efm+=%Z<argument>\ %m

  " Show warnings
  if g:latex_errorformat_show_warnings
    " Ignore some warnings
    for w in g:latex_errorformat_ignore_warnings
      let warning = escape(substitute(w, '[\,]', '%\\\\&', 'g'), ' ')
      exe 'setlocal efm+=%-G%.%#'. warning .'%.%#'
    endfor
    setlocal efm+=%+WLaTeX\ %.%#Warning:\ %.%#line\ %l%.%#
    setlocal efm+=%+W%.%#\ at\ lines\ %l--%*\\d
    setlocal efm+=%+WLaTeX\ %.%#Warning:\ %m
    setlocal efm+=%+W%.%#%.%#Warning:\ %m
  endif

  " Ignore unmatched lines
  setlocal efm+=%-G%.%#
endfunction

" {{{1 latex#info
function! latex#info()
  let n = 0
  for d in g:latex#data
    let n += 1
    if n > 1
      echo "\n"
    endif
    let data = copy(d)
    let data.aux = data.aux()
    let data.out = data.out()
    let data.log = data.log()
    for [key, val] in sort(items(data), "s:sort_func")
      echo printf('%6s: %-s', key, s:truncate(val))
    endfor
  endfor
endfunction
" }}}1

" {{{1 s:init_variables
function! s:init_variables()
  "
  " Initialize global and local data blobs
  "
  call latex#util#set_default('g:latex#data', [])
  call latex#util#set_default('b:latex', {})

  "
  " Initialize some common patterns
  "
  call latex#util#set_default('b:notbslash', '\%(\\\@<!\%(\\\\\)*\)\@<=')
  call latex#util#set_default('b:notcomment',
        \ '\%(\%(\\\@<!\%(\\\\\)*\)\@<=%.*\)\@<!')
endfunction

" {{{1 s:init_blob
function! s:init_blob()
  let main = s:get_main_tex()
  let id   = s:get_id(main)
  if id >= 0
    let b:latex.id = id
  else
    let data = {}
    let data.tex  = main
    let data.root = fnamemodify(data.tex, ':h')
    let data.base = fnamemodify(data.tex, ':t')
    let data.name = fnamemodify(data.tex, ':t:r')
    function data.aux() dict
      return s:get_main_ext(self, 'aux')
    endfunction
    function data.log() dict
      return s:get_main_ext(self, 'log')
    endfunction
    function data.out() dict
      return s:get_main_ext(self, g:latex_latexmk_output)
    endfunction

    call add(g:latex#data, data)
    let b:latex.id = len(g:latex#data) - 1
  endif
endfunction

" {{{1 s:init_mappings
function! s:init_mappings()
  if g:latex_default_mappings
    map <silent><buffer> <localleader>li :call latex#info()<cr>
    map <silent><buffer> <LocalLeader>lv :call latex#view()<cr>
  endif
endfunction

" {{{1 s:get_id
function! s:get_id(main)
  if exists('g:latex#data') && !empty(g:latex#data)
    let id = 0
    while id < len(g:latex#data)
      if g:latex#data[id].tex == a:main
        return id
      endif
      let id += 1
    endwhile
  endif

  return -1
endfunction

" {{{1 s:get_main_tex
function! s:get_main_tex()
  if !search('\C\\begin\_\s*{document}', 'nw')
    let tex_files  = glob('*.tex', 0, 1) + glob('../*.tex', 0, 1)
    call filter(tex_files,
          \ "count(g:latex_main_tex_candidates, fnamemodify(v:val,':t:r'))")
    if !empty(tex_files)
      return fnamemodify(tex_files[0], ':p')
    endif
  endif

  return expand('%:p')
endfunction

" {{{1 s:get_main_ext
function! s:get_main_ext(texdata, ext)
  " Create set of candidates
  let candidates = [
        \ a:texdata.name,
        \ g:latex_build_dir . '/' . a:texdata.name,
        \ ]

  " Search through the candidates
  for f in map(candidates,
        \ 'a:texdata.root . ''/'' . v:val . ''.'' . a:ext')
    if filereadable(f)
      return fnamemodify(f, ':p')
    endif
  endfor

  " Return empty string if no entry is found
  return ''
endfunction

" {{{1 s:sort_func
function s:sort_func(a, b)
  if a:a[1][0] == "/" && a:b[1][0] != "/"
    return 1
  elseif a:a[1][0] != "/" && a:b[1][0] == "/"
    return -1
  elseif a:a[1][0] == "/" && a:b[1][0] == "/"
    return -1
  else
    return a:a[1] > a:b[1] ? 1 : -1
  endif
endfunction

" {{{1 s:truncate
function! s:truncate(string)
  if len(a:string) >= winwidth('.') - 20
    return a:string[0:10] . "..." . a:string[-winwidth('.')+33:]
  else
    return a:string
  endif
endfunction
" }}}1

" vim:fdm=marker:ff=unix
