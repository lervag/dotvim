"
" Search for links to current page
"
function! vimwiki#backlinks()
  let path = VimwikiGet('path')
  let l:file = fnamemodify(expand('%'),':r')
  let l:search = '"\[\[(.*\/)?' . l:file . '(\||\]\])" '
  execute 'Ack ' . l:search . path
endfunction

"
" Create new journal entry
"
function! vimwiki#new_entry()
  let l:current = expand('%:t:r')

  " Get next weekday
  let l:candidate = systemlist('date -d "' . l:current . ' +1 day" +%F')[0]
  while systemlist('date -d "' . l:candidate . '" +%u')[0] > 5
    let l:candidate = systemlist('date -d "' . l:candidate . ' +1 day" +%F')[0]
  endwhile

  let l:next = expand('%:p:h') . '/' . l:candidate . '.wiki'
  if !filereadable(l:next)
    execute 'write' l:next
  endif

  VimwikiDiaryNextDay
endfunction
