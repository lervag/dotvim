if exists('b:current_syntax')
  finish
endif

syn match date    /^\d\d\d\d-\d\d-\d\d/
syn match entries /^  .*\%<17c/
syn match number  /[0-9x][0-9x]:[0-9x][0-9x]/
syn match number  /[0-9x]\+,[0-9x]/
syn match error   /[0-9x]\+\.[0-9x]\+/

hi def date    guifg=blue 
hi def entries guifg=green 
hi def time    guifg=magenta 
