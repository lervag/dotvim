if exists('g:loaded_ctrlp_vimwiki') && g:loaded_ctrlp_vimwiki | finish | endif
let g:loaded_ctrlp_vimwiki = 1

cal add(g:ctrlp_ext_vars, {
      \ 'init'  : 'ctrlp#vimwiki#init(s:crbufnr)',
      \ 'accept': 'ctrlp#vimwiki#accept',
      \ 'lname' : 'vimwiki',
      \ 'sname' : 'vwiki',
      \ 'type'  : 'path',
      \ })

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

function! ctrlp#vimwiki#init(bufnr)
  return Complete_wikifiles(0,'')
endfunction

function! ctrlp#vimwiki#accept(mode, str)
  call ctrlp#acceptfile(a:mode, a:str . '.wiki')
endfunction

function! ctrlp#vimwiki#cmd()
  return s:id
endfunction
