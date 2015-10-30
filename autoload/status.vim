"
" Status line functions
"

function! status#refresh() " {{{1
  for nr in range(1, winnr('$'))
    let bufnum = winbufnr(nr)
    let name = bufname(bufnum)
    if name !~# '^\%(undotree\|diffpanel\)'
      call setwinvar(nr, '&statusline', '%!status#get(' . nr . ')')
    endif
  endfor
endfunction

"}}}1
function! status#toggle_detailed() " {{{1
  let w:status_detailed = !get(w:, 'status_detailed', 0)
endfunction

"}}}1
function! status#get(winnum) " {{{1
  let active = a:winnum == winnr()
  let bufnum = winbufnr(a:winnum)
  let type = getbufvar(bufnum, '&buftype')
  let name = bufname(bufnum)

  " Alternative statuslines
  if type ==# 'help'
    return '%#SLHelp# HELP %* ' . fnamemodify(name, ':t:r')
  endif

  "
  " Build statusline
  "

  " file name
  let stat = ' %<%f'

  " file modified
  let modified = getbufvar(bufnum, '&modified')
  let stat .= s:color(active, 'SLLineNr', modified ? ' +' : '')

  " read only
  let readonly = getbufvar(bufnum, '&readonly')
  let stat .= s:color(active, 'SLLineNR', readonly ? ' RO' : '')

  " right side
  let stat .= '%='

  " ...
  if getwinvar(a:winnum, 'status_detailed', 0)
    let stat .= s:color(active, 'SLDetails', '%3p%% (%l:%c)')
  endif

  " git branch
  if exists('*fugitive#head')
    let head = fugitive#head()

    if empty(head) && exists('*fugitive#detect') && !exists('b:git_dir')
      call fugitive#detect(getcwd())
      let head = fugitive#head()
    endif
  endif

  if !empty(head)
    let stat .= s:color(active, 'SLBranch', ' ← ') . head
  endif

  return stat . ' '
endfunction

" }}}1

"
" CtrlP status line
"
function! status#ctrlp_main(...) " {{{1
  "
  " Arguments: focus, byfname, s:regexp, prv, item, nxt, marked
  "            a:1    a:2      a:3       a:4  a:5   a:6  a:7
  "
  let regex = a:3 ? '%2*regex %*' : ''
  let prv = '%#StatusLineNC# '.a:4.' %*'
  let item = ' ' . (a:5 == 'mru files' ? 'mru' : a:5) . ' '
  let nxt = '%#StatusLineNC# '.a:6.' %*'
  let byfname = '%2* '.a:2.' %*'
  let dir = '%#SLBranch# ← %*%#StatusLineNC#' . fnamemodify(getcwd(), ':~') . '%* '

  " only outputs current mode
  retu ' %#SLArrows#»%*' . item . '%#SLArrows#«%* ' . '%=%<' . dir
  " retu prv . '%4*»%*' . item . '%4*«%*' . nxt . '%=%<' . dir
endfunction

" }}}1
function! status#ctrlp_progress(length) " {{{1
  return '%#Function# ' . a:length . ' %* %=%<%#LineNr# ' . getcwd() . ' %*'
endfunction

" }}}1

"
" Utilities
"

function! s:color(active, group, content) " {{{1
  if a:active
    return '%#' . a:group . '#' . a:content . '%*'
  else
    return a:content
  endif
endfunction

" }}}1
