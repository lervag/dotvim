function! s:man(...)
  source $VIMRUNTIME/ftplugin/man.vim
  execute 'Man' join(a:000, ' ')
  if line('$') == 1 | cquit | endif
  only

  setlocal readonly
  setlocal nomodifiable
  setlocal noexpandtab
  setlocal nolist
  setlocal tabstop=8
  setlocal softtabstop=8
  setlocal shiftwidth=8
  setlocal colorcolumn=

  noremap <buffer>         q       :q<cr>
  noremap <buffer>         <cr>    :MyMan <c-r><c-w><cr>
  noremap <buffer><silent> <bs>    <c-o><c-o>
  nmap    <buffer>         <tab>   /\w\+(\d)<cr>
  nmap    <buffer>         <s-tab> ?\w\+(\d)<cr>
endfunction

command! -nargs=+ ManWrapper call s:man(<f-args>)

