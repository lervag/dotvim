if exists('b:current_syntax')
  finish
endif

" Standard syntax elements
syn match date    /^\d\d\d\d-\d\d-\d\d/
syn match entries /^  .*/                    contains=error,number
syn match entries /^  \(La meg\|Sto opp\).*/ contains=error,time
syn match error   /[0-9x]\+.[0-9x]\+.*/           contained
syn match time    /[0-9x][0-9x]:[0-9x][0-9x]/     contained
syn match number  /[0-9x]\+\.[0-9x]\+\( \w\+\)\?/ contained

" Define spell region
syn spell default
syn region notat
      \ matchgroup=entries
      \ start = /^  Notat\s\+/
      \ end =   /^$/
      \ contains=@Spell

" Define fold regions
syn region fold
      \ start = /^\d\d\d\d-\d\d-\d\d/
      \ end =   /^$/
      \ transparent fold

" Set colors
hi def date    guifg=blue 
hi def entries guifg=green 
hi link time    number
hi link numbers number
hi link unit    number
