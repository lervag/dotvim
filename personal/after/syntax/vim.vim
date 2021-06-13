if exists('b:did_after_syntax_vim') | finish | endif
let b:did_after_syntax_vim = 1

syntax region vimSet
      \ matchgroup=vimCommand
      \ start="\<CompilerSet\!\?\>"
      \ end="$"
      \ matchgroup=vimNotation
      \ end="<[cC][rR]>"
      \ keepend
      \ oneline
      \ contains=vimSetEqual,vimOption,vimErrSetting,vimComment,vimSetString,vimSetMod
