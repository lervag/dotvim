let s:converter = {
      \ 'name' : 'converter_mypath',
      \}

function! s:converter.filter(candidates, context)
  for l:c in a:candidates
    if l:c.word =~# '\/Documents'
      let l:c.abbr = '~/documents/' . matchstr(l:c.word, '\/Documents\/\zs.*')
    else
      let l:c.abbr = fnamemodify(l:c.word, ':~')
    endif
  endfor
  return a:candidates
endfunction

function! unite#filters#converter_mypath#define()
  return s:converter
endfunction
