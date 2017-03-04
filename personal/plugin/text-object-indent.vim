onoremap <silent>ai :<C-u>cal IndTxtObj(0)<CR>
onoremap <silent>ii :<C-u>cal IndTxtObj(1)<CR>
vnoremap <silent>ai :<C-u>cal IndTxtObj(0)<CR><Esc>gv
vnoremap <silent>ii :<C-u>cal IndTxtObj(1)<CR><Esc>gv

function! IndTxtObj(inner)
  let curline = line('.')
  let lastline = line('$')
  let i = indent(line('.')) - &shiftwidth * (v:count1 - 1)
  let i = i < 0 ? 0 : i
  if getline('.') !~# '^\\s*$'
    let p = line('.') - 1
    let nextblank = getline(p) =~# '^\\s*$'
    while p > 0 && ((i == 0 && !nextblank) || (i > 0 && ((indent(p) >= i && !(nextblank && a:inner)) || (nextblank && !a:inner))))
      -
      let p = line('.') - 1
      let nextblank = getline(p) =~# '^\\s*$'
    endwhile
    normal! 0V
    call cursor(curline, 0)
    let p = line('.') + 1
    let nextblank = getline(p) =~# '^\\s*$'
    while p <= lastline && ((i == 0 && !nextblank) || (i > 0 && ((indent(p) >= i && !(nextblank && a:inner)) || (nextblank && !a:inner))))
      +
      let p = line('.') + 1
      let nextblank = getline(p) =~# '^\\s*$'
    endwhile
    normal! $
  endif
endfunction
