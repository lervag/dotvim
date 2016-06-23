if exists('b:did_ftplugin_personal') | finish | endif
let b:did_ftplugin_personal = 1

inoremap <buffer><silent><expr> __ neosnippet#anonymous('_${1}${0}')
inoremap <buffer><silent><expr> ^^ neosnippet#anonymous('^${1}${0}')

call vimtex#imaps#add_map({
      \ 'lhs' : 'é',
      \ 'rhs' : '\item ',
      \ 'leader'  : '',
      \ 'wrapper' : 'vimtex#imaps#wrap_trivial'
      \})

" vim: fdm=marker sw=2
