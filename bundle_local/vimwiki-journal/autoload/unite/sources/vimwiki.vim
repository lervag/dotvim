let s:save_cpo = &cpo
set cpo&vim

let s:vimwiki = {
      \ 'name': 'vimwiki',
      \ 'sorters': 'sorter_word',
      \}

function! s:vimwiki.gather_candidates(args, context)
  let lines = globpath('~/documents/wiki/', '**/*.wiki', 0, 1)

  return map(lines, '{
        \   "word": substitute(fnamemodify(v:val, ":p:r"),
        \                      "^.*documents\/wiki\/", "", ""),
        \   "kind": "file",
        \   "action__path": v:val,
        \ }')
endfunction

function! unite#sources#vimwiki#define()
  return s:vimwiki
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
