" Only load file once
if exists('b:did_ft_python') | finish | endif
let b:did_ft_python = 1

setlocal define=^\s*\\(def\\\\|class\\)
setlocal colorcolumn=80

" Use some features from jedi.vim
nnoremap <silent><buffer> <leader>jd :call jedi#goto()<cr>
nnoremap <silent><buffer> <leader>ju :call jedi#usages()<cr>
xnoremap <silent><buffer> <leader>jr :call jedi#rename()<cr>
nnoremap <silent><buffer> K          :call jedi#show_documentation()<cr>

call personal#python#set_path()
