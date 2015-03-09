if exists('g:loaded_ctrlp_help') && g:loaded_ctrlp_help | finish | endif
let g:loaded_ctrlp_help = 1


call add(g:ctrlp_ext_vars, {
      \ 'init': 'ctrlp#help#init()',
      \ 'accept': 'ctrlp#help#accept',
      \ 'lname': 'help',
      \ 'sname': 'help',
      \ 'type': 'path',
      \ })


function! ctrlp#help#init()
  let results = []
  for tagfile in split(globpath(&runtimepath, 'doc/tags'), "\n")
    if filereadable(tagfile)
      let results += map(readfile(tagfile), 'split(v:val, "\t")[0]')
    endif
  endfor
  return results
endfunction

function! ctrlp#help#accept(mode, str)
  call ctrlp#exit()
  execute 'tab help ' . a:str
endfunction


let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#help#id()
  return s:id
endfunction
