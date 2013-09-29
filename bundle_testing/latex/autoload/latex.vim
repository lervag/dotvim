" {{{1 latex#init
function! latex#init()
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

  "
  " Check if blob already exists
  "
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

  call latex#set_errorformat()

  call latex#latexmk#init()

  call s:init_folding()
  call s:init_commands()
  call s:init_mapping()

  "
  " Highlight matching parens ($, (), ...)
  "
  if !g:latex_motion_loaded_matchparen
    " Disable matchparen autocommands
    augroup latex_highlight_pairs
      autocmd!
      autocmd BufEnter *.tex
            \   if !exists("g:loaded_matchparen") || !g:loaded_matchparen
            \ |   runtime plugin/matchparen.vim
            \ | endif
      autocmd BufEnter *.tex
            \ 3match none | unlet! g:loaded_matchparen | au! matchparen
      autocmd! CursorMoved  *.tex call latex#motion#find_matching_pair('h')
      autocmd! CursorMovedI *.tex call latex#motion#find_matching_pair('i')
    augroup END
  endif

  " Set omnicompletion
  setlocal omnifunc=latex#complete#omnifunc
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
" }}}1

" {{{1 s:init_folding
function! s:init_folding()
  if g:latex_fold_enabled
    setl foldmethod=expr
    setl foldexpr=latex#fold#level(v:lnum)
    setl foldtext=latex#fold#text()
    call latex#fold#refresh()
    "
    " The foldexpr function returns "=" for most lines, which means it can
    " become slow for large files.  The following is a hack that is based on
    " this reply to a discussion on the Vim Developer list:
    " http://permalink.gmane.org/gmane.editors.vim.devel/14100
    augroup FastFold
      autocmd!
      autocmd InsertEnter *.tex setlocal foldmethod=manual
      autocmd InsertLeave *.tex setlocal foldmethod=expr
    augroup end
  endif
endfunction

" {{{1 s:init_commands
function! s:init_commands()
  command! LatexView      call latex#view()
  command! LatexTOC       call latex#toc#open()
  command! LatexTOCToggle call latex#toc#toggle()
endfunction

" {{{1 s:init_mapping
function! s:init_mapping()
  map <buffer> <localleader>ll :Latexmk<CR>
  "map <buffer> <localleader>lL :Latexmk!<CR>
  "map <buffer> <localleader>lc :LatexmkClean<CR>
  "map <buffer> <localleader>lC :LatexmkClean!<CR>
  "map <buffer> <localleader>lg :LatexmkStatus<CR>
  "map <buffer> <localleader>lG :LatexmkStatus!<CR>
  "map <buffer> <localleader>lk :LatexmkStop<CR>
  "map <buffer> <localleader>le :LatexErrors<CR>

"inoremap <silent> <Plug>LatexCloseCurEnv
"      \ <C-R>=<SID>CloseCurEnv()<CR>
"vnoremap <silent> <Plug>LatexWrapSelection
"      \ :<c-u>call <SID>WrapSelection('')<CR>i
"vnoremap <silent> <Plug>LatexEnvWrapSelection
"      \ :<c-u>call <SID>PromptEnvWrapSelection()<CR>
"vnoremap <silent> <Plug>LatexEnvWrapFmtSelection
"      \ :<c-u>call <SID>PromptEnvWrapSelection(1)<CR>
"nnoremap <silent> <Plug>LatexChangeEnv
"      \ :call <SID>ChangeEnvPrompt()<CR>

"nnoremap <silent> <plug>LatexBox_JumpToMatch
"      \ :call <sid>latex_find_matching_pair('n')<cr>
"vnoremap <silent> <Plug>LatexBox_JumpToMatch
"      \ :call <sid>latex_find_matching_pair('v')<cr>
"onoremap <silent> <Plug>LatexBox_JumpToMatch
"      \ v:call <sid>latex_find_matching_pair('o')<cr>
"vnoremap <silent> <plug>LatexBox_SelectInlineMathInner
"      \ :<c-u>call <sid>latex_select_inline_math('inner')<cr>
"vnoremap <silent> <plug>LatexBox_SelectInlineMathOuter
"      \ :<c-u>call <sid>latex_select_inline_math('outer')<cr>
"vnoremap <silent> <Plug>LatexBox_SelectCurrentEnvInner
"      \ :<c-u>call <sid>latex_select_current_env('inner')<cr>
"vnoremap <silent> <Plug>LatexBox_SelectCurrentEnvOuter
"      \ :<c-u>call <sid>latex_select_current_env('outer')<cr>

  map <buffer> <LocalLeader>lv :LatexView<CR>
  map <silent> <buffer> <LocalLeader>lt :LatexTOC<CR>
  map <silent> <buffer> <LocalLeader>lT :LatexTOCToggle<CR>

  "if !exists('g:latex_mappings_loaded_matchparen')
  "  nmap <buffer> % <Plug>LatexBox_JumpToMatch
  "  vmap <buffer> % <Plug>LatexBox_JumpToMatch
  "  omap <buffer> % <Plug>LatexBox_JumpToMatch
  "endif

  "vmap <buffer> ie <plug>LatexBox_SelectCurrentEnvInner
  "vmap <buffer> ae <plug>LatexBox_SelectCurrentEnvOuter
  "omap <buffer> ie :normal vie<CR>
  "omap <buffer> ae :normal vae<CR>
  "vmap <buffer> i$ <plug>LatexBox_SelectInlineMathInner
  "vmap <buffer> a$ <plug>LatexBox_SelectInlineMathOuter
  "omap <buffer> i$ :normal vi$<CR>
  "omap <buffer> a$ :normal va$<CR>

  "noremap  <buffer> <silent> ]] :call latex#motion#next_section(0,0,0)<cr>
  "noremap  <buffer> <silent> ][ :call latex#motion#next_section(1,0,0)<cr>
  "noremap  <buffer> <silent> [] :call latex#motion#next_section(1,1,0)<cr>
  "noremap  <buffer> <silent> [[ :call latex#motion#next_section(0,1,0)<cr>
  "vnoremap <buffer> <silent> ]] :<c-u>call latex#motion#next_section(0,0,1)<cr>
  "vnoremap <buffer> <silent> ][ :<c-u>call latex#motion#next_section(1,0,1)<cr>
  "vnoremap <buffer> <silent> [] :<c-u>call latex#motion#next_section(1,1,1)<cr>
  "vnoremap <buffer> <silent> [[ :<c-u>call latex#motion#next_section(0,1,1)<cr>
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
        \ a:texdata.name . '.' . a:ext,
        \ g:latex_build_dir . '/' . a:texdata.name . '.' . a:ext,
        \ ]

  " Search through the candidates
  for f in candidates
    if filereadable(f)
      return fnamemodify(f, ':p')
    endif
  endfor

  return 0
endfunction
" }}}1

" vim:fdm=marker:ff=unix
