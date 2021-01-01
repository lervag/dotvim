if exists('b:current_syntax')
  finish
endif
let b:current_syntax = 1

" Ensure syntax at top of buffer window is correct
syntax sync minlines=100

" Set spell option
syn spell default

" Standard syntax elements
syn match date    /^\d\d\d\d-\d\d-\d\d/
syn match entries /^  .*/                    contains=error,number
syn match entries /^  \(La meg\|Sto opp\).*/ contains=error,time
syn match entries /^  Trening.*/             contains=trening

syn match are        /^  Are/
syn match areentries /^    \(Sto opp\|Dupp\|Mat\|La seg\|\s*\).*/
      \ contains=error,number,time

syn match error   /[0-9x]\+.[0-9x]\+.*/         contained
syn match time    /[0-9][0-9]:[0-9][0-9]/       contained
syn match number  /[0-9]\+\.[0-9]\+\( \w\+\)\?/ contained
syn match trening /\%>17c.*/                    contained

" Syntax regions
syn region gullkorn
      \ matchgroup=entries
      \ start = /^  Gullkorn\s\+/
      \ end =   /^\ze  \w\+/
      \ contains=@Spell

syn region snop
      \ matchgroup=entries
      \ start = /^  Snop\s\+/
      \ end =   /^\ze  \w\+/
      \ contains=@Spell

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
hi link date    MoreMsg
hi link entries Statement
hi link time    number
hi link numbers number
hi link unit    number

hi link are     entries
hi def areentries guifg=black
