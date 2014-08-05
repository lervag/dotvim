if !expand('%:p') =~ 'wiki\/journal' | finish | endif

" Set spell option
syn spell default

" Standard syntax elements
syn match TODO    /TODO/
syn match line    /-\{10,}/
syn match number  /\d\+\.\d\+/
syn match time    /\d\d:\d\d/
syn match date    /\d\d\d\d-\d\d-\d\d/

" Set colors
hi def  date    guifg=blue 
hi def  line    guifg=black 
hi link line    line
hi link time    number
hi link numbers number
hi link TODO    TODO

