if exists('s:did_ftplugin') | finish | endif
let s:did_ftplugin = 1

inoremap <silent><expr> __ neosnippet#anonymous('_${1}${0}')
inoremap <silent><expr> ^^ neosnippet#anonymous('^${1}${0}')

call vimtex#imaps#add_map({
      \ 'lhs' : 'é',
      \ 'rhs' : '\item ',
      \ 'leader'  : '',
      \ 'wrapper' : 'vimtex#imaps#wrap_trivial'
      \})

" vim: fdm=marker sw=2
