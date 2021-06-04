if exists('g:tables_loaded')
  finish
endif
let g:tables_loaded = 1

let s:save_cpoptions = &cpoptions
set cpoptions&vim

" Commands
command! PrepareTable call s:prepare_table()

function! s:prepare_table() abort " {{{1
  if getline('.') !~# '^\s*\|' | return | endif

  let l:start = search('^\s*\($\|[^|]\)', 'nWb') + 1
  let l:end = search('^\s*\($\|[^|]\)', 'nW') - 1

  if l:start >= l:end | return | endif

  execute printf('%s,%s s/[-:]\zs+\ze[-:]/|/', l:start, l:end)
  execute printf('%s,%s EasyAlign * |', l:start, l:end)
endfunction

" }}}1

let &cpoptions = s:save_cpoptions
