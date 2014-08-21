" Only load file once
if exists('b:did_ft_python') | finish | endif
let b:did_ft_python = 1

setlocal sts=4
setlocal sw=4
setlocal expandtab
setlocal smarttab
setlocal smartindent
setlocal makeprg=python\ %
setlocal fdm=indent
setlocal omnifunc=pythoncomplete#Complete

syn keyword pythonDecorator True None False self

