syn region vimSet
      \ matchgroup=vimCommand
      \ start="\<CompilerSet\!\?\>"
      \ end="$"
      \ matchgroup=vimNotation
      \ end="<[cC][rR]>"
      \ keepend
      \ oneline
      \ contains=vimSetEqual,vimOption,vimErrSetting,vimComment,vimSetString,vimSetMod
