if exists('b:did_ftplugin_personal') | finish | endif
let b:did_ftplugin_personal = 1

nmap <buffer> <cr> <plug>(vimtex-context-menu)

setlocal textwidth=0
setlocal wrap
