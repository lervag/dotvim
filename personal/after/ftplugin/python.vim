if exists('b:did_after_ftplugin_python') | finish | endif
let b:did_after_ftplugin_python = 1

setlocal includeexpr=personal#python#includexpr()
