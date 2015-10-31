"
" Statusline functions
"
" Inspiration:
" - https://github.com/blaenk/dots/blob/master/vim/.vimrc
" - http://www.blaenkdenum.com/posts/a-simpler-vim-statusline/
"

function! statusline#init() " {{{1
  augroup statusline
    autocmd!
    autocmd VimEnter,VimLeave       * :call statusline#refresh()
    autocmd WinEnter,WinLeave       * :call statusline#refresh()
    autocmd BufWinEnter,BufWinLeave * :call statusline#refresh()
  augroup END

  nnoremap <space>a            :source /home/lervag/.vim/autoload/statusline.vim<cr>
  nnoremap <silent> <leader>qq :call statusline#toggle_detailed()<cr>
endfunction

" }}}1
function! statusline#refresh() " {{{1
  for nr in range(1, winnr('$'))
    call s:set_statusline(nr)
  endfor
endfunction

"}}}1
function! statusline#toggle_detailed() " {{{1
  let w:statusline_detailed = !get(w:, 'statusline_detailed', 0)
endfunction

"}}}1

"
" The main statusline function
"
function! s:set_statusline(winnum) " {{{1
  let active = a:winnum == winnr()
  let bufnum = winbufnr(a:winnum)
  let type = getbufvar(bufnum, '&buftype')
  let name = bufname(bufnum)

  " Alternative statuslines
  if type ==# 'help'
    return '%#SLHelp# HELP %* ' . fnamemodify(name, ':t:r')
  endif

  " Ignore some buffers
  if name =~# '^\%(undotree\|diffpanel\)'
    return
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

  call setwinvar(a:winnum, '&statusline', stat)
endfunction

" }}}1

"
" CtrlP statusline
"
function! statusline#ctrlp_main(focus, byfname, re, prv, cur, nxt, marked) " {{{1
  let line  = ' CtrlP:'

  let line .= ' ' . a:prv
  let line .= ' ' . (a:cur ==# 'mru files' ? 'mru' : a:cur)
  let line .= ' ' . a:nxt

  if a:cur =~# '^\%(files\|dir\|mixed\)'
    let line .= ' ' . fnamemodify(getcwd(), ':~')
  endif

  return line
endfunction

" }}}1
function! statusline#ctrlp_progress(length) " {{{1
  return ' CtrlP: Loading ... (' . a:length . ')'
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
