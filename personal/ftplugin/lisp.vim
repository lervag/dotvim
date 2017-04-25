"
" Personal settings for lisp files
" Author: Karl Yngve Lervåg
"

" Only load the file once
if exists('b:did_ft_lisp') | finish | endif
let b:did_ft_lisp = 1

setlocal foldmethod=marker foldmarker=(,) foldminlines=3
setlocal suffixesadd=.lisp,cl path=/usr/src/lisp/**
setlocal include=(:file\
setlocal lisp autoindent showmatch cpoptions-=mp
setlocal lispwords+=alet,alambda,dlambda,aif
setlocal iskeyword+=-
