function! personal#ctrlp#vim_plugs() " {{{1
  " Wrapper to search through plugin source files
  let l:ctrlp_working_path_mode = g:ctrlp_working_path_mode
  let l:ctrlp_user_command = g:ctrlp_user_command
  let l:ctrlp_custom_ignore = get(g:, 'ctrlp_custom_ignore', '')
  let g:ctrlp_working_path_mode = 'c'
  let g:ctrlp_user_command = []
  let g:ctrlp_custom_ignore = '\v(LICENSE|tags|\.png$|\.jpg$)'

  CtrlP ~/.vim/bundle

  let g:ctrlp_working_path_mode = l:ctrlp_working_path_mode
  let g:ctrlp_user_command = l:ctrlp_user_command
  let g:ctrlp_custom_ignore = l:ctrlp_custom_ignore
endfunction

" }}}1
function! personal#ctrlp#disable_matchfunc(cmd) " {{{1
  " Disable pymatcher for e.g. CtrlPMRU
  let g:ctrlp_match_func = {}
  execute a:cmd
  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
endfunction

" }}}1
