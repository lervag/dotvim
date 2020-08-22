" Source: https://gist.github.com/PeterRincker/582ea9be24a69e6dd8e237eb877b8978
"
" :[range]SortGroup[!] [n|f|o|b|x] /{pattern}/
" e.g. :SortGroup /^header/
" e.g. :SortGroup n /^header/
" See :h :sort for details
command! -range=% -bang -nargs=+ SortGroup
      \ <line1>,<line2>call <SID>sort_by_header(<bang>0, <q-args>)

function! s:sort_by_header(bang, pat) range
  let pat = a:pat
  let opts = ''
  if pat =~# '^\s*[nfxbo]\s'
    let opts = matchstr(pat, '^\s*\zs[nfxbo]')
    let pat = matchstr(pat, '^\s*[nfxbo]\s*\zs.*')
  endif
  let pat = trim(pat)
  let sep = '/'
  if !empty(pat)
        \ && pat[0] == matchstr(pat, '.$')
        \ && pat[0] =~# '\W'
    let [sep, pat] = [pat[0], pat[1:-2]]
  endif
  if empty(pat)
    let pat = @/
  endif

  let ranges = []
  execute a:firstline . ',' . a:lastline
        \ . 'g' . sep . pat . sep
        \ . 'call add(ranges, line("."))'

  let converters = {
        \ 'n': {s-> str2nr(matchstr(s, '-\?\d\+.*'))},
        \ 'x': {s-> str2nr(matchstr(s, '-\?\%(0[xX]\)\?\x\+.*'), 16)},
        \ 'o': {s-> str2nr(matchstr(s, '-\?\%(0\)\?\x\+.*'), 8)},
        \ 'b': {s-> str2nr(matchstr(s, '-\?\%(0[bB]\)\?\x\+.*'), 2)},
        \ 'f': {s-> str2float(matchstr(s, '-\?\d\+.*'))},
        \}
  let arr = []
  for i in range(len(ranges))
    let end = max([get(ranges, i+1, a:lastline+1) - 1, ranges[i]])
    let line = getline(ranges[i])
    let d = {}
    let d.key = call(get(converters, opts, {s->s}), [strpart(line, match(line, pat))])
    let d.group = getline(ranges[i], end)
    call add(arr, d)
  endfor
  call sort(arr, {a,b -> a.key == b.key ? 0 : (a.key < b.key ? -1 : 1)})
  if a:bang
    call reverse(arr)
  endif
  let lines = []
  call map(arr, 'extend(lines, v:val.group)')
  let start = max([a:firstline, get(ranges, 0, 0)])
  call setline(start, lines)
  call setpos("'[", start)
  call setpos("']", start+len(lines)-1)
endfunction
