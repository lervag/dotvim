
function! vimwiki#backlinks()
  let path = VimwikiGet('path')
  let l:file = fnamemodify(expand('%'),':r')
  let l:search = '"\[\[(.*\/)?' . l:file . '(\||\]\])" '
  execute 'Ack ' . l:search . path
endfunction

