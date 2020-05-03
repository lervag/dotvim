" Only load file once
if exists('b:did_ft_python') | finish | endif
let b:did_ft_python = 1

setlocal define=^\s*\\(def\\\\|class\\)
setlocal colorcolumn=80

call personal#python#set_path()
