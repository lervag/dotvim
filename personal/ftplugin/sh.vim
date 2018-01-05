" Internal sh syntax plugin: Set bash as default variant
let g:is_bash = 1

" Use custom folding
setlocal foldmethod=expr
setlocal foldexpr=BashFoldLevel()

" {{{1 BashFoldLevel

let s:re_start = '\v^\s*%(' . join([
      \ 'if>.*%(;\s*then)?$',
      \ '%(while|for).*%(;\s*do)?$',
      \ 'case.*%(\s*in)$',
      \ '%(function\s+)?\S+%(\(\))? \{',
      \], '|') . ')'

let s:re_end = '\v^\s*%(' . join([
      \ 'fi\s*$',
      \ 'done\s*$',
      \ 'esac\s*$',
      \ '\}$',
      \], '|') . ')'

function! BashFoldLevel()
  let l:line = getline(v:lnum)

  if l:line =~# s:re_end
    return 's1'
  endif

  if l:line =~# s:re_start
    return 'a1'
  endif

  return '='
endfunction

" }}}1
