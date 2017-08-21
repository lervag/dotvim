if exists('b:did_ftplugin_personal') | finish | endif
let b:did_ftplugin_personal = 1

call vimtex#imaps#add_map({
      \ 'lhs' : '<m-i>',
      \ 'rhs' : '\item ',
      \ 'leader'  : '',
      \ 'wrapper' : 'vimtex#imaps#wrap_environment',
      \ 'context' : [
      \   'itemize',
      \   'enumerate',
      \   {'envs' : ['description'], 'rhs' : '\item['},
      \ ],
      \})

" vim: fdm=marker sw=2
