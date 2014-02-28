if exists('b:current_syntax')
  finish
endif

" Standard syntax elements
syn match date    /^\d\d\d\d-\d\d-\d\d/
syn match entries /^  .*\%<17c/
syn match number  /[0-9x][0-9x]:[0-9x][0-9x]/
syn match number  /[0-9x]\+\.[0-9x]\+/

" Define some common errors
syn match error   /[0-9x]\+,[0-9x]\+/

" Set colors
hi def date    guifg=blue 
hi def entries guifg=green 
hi def time    guifg=magenta 
