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
  if getcwd() =~ 'wiki'
    return Complete_wikifiles(0,'')
  else
    return map(globpath('~/documents/wiki', '**/*.wiki', 0, 1),
          \ 'fnamemodify(v:val, ":.:r")')
  endif
endfunction

function! ctrlp#vimwiki#accept(mode, str)
  call ctrlp#acceptfile(a:mode, a:str . '.wiki')
endfunction


" Extension ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#vimwiki#id()
  return s:id
endfunction
