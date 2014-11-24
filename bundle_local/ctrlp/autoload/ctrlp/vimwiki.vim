if exists('g:loaded_ctrlp_vimwiki') && g:loaded_ctrlp_vimwiki | finish | endif
let g:loaded_ctrlp_vimwiki = 1


call add(g:ctrlp_ext_vars, {
      \ 'init'  : 'ctrlp#vimwiki#init(s:crbufnr)',
      \ 'accept': 'ctrlp#vimwiki#accept',
      \ 'lname' : 'vimwiki',
      \ 'sname' : 'vwiki',
      \ 'type'  : 'path',
      \ })

function! ctrlp#vimwiki#init(bufnr)
  let s:prepend = expand('~/documents/wiki/')
  return map(globpath(s:prepend, '**/*.wiki', 0, 1),
        \ 'strpart(fnamemodify(v:val, ":p:r"), ' . len(s:prepend) . ')')
endfunction

function! ctrlp#vimwiki#accept(mode, str)
  call ctrlp#acceptfile(a:mode, s:prepend . a:str . '.wiki')
endfunction


" Extension ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#vimwiki#id()
  return s:id
endfunction
