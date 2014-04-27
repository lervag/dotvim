if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

let s:cpo_save = &cpo
set cpo&vim

setlocal nolisp
setlocal nosmartindent
setlocal autoindent

let &cpo = s:cpo_save
unlet s:cpo_save
