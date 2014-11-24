if exists('g:loaded_ctrlp_help') && g:loaded_ctrlp_help | finish | endif
let g:loaded_ctrlp_help = 1


call add(g:ctrlp_ext_vars, {
      \ 'init': 'ctrlp#help#init()',
      \ 'accept': 'ctrlp#help#accept',
      \ 'lname': 'help',
      \ 'sname': 'help',
      \ 'type': 'line',
      \ })


function! ctrlp#help#init()
  return map(split(globpath(&runtimepath, 'doc/*.txt'), "\n"),
        \ 'fnamemodify(v:val, ":t:r")')
endfunction

function! ctrlp#help#accept(mode, str)
  call ctrlp#exit()
  execute 'help ' . a:str
endfunction


let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#help#id()
  return s:id
endfunction
