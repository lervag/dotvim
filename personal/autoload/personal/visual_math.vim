"
" Vim plugin for math on visual regions
"
" Credits: Damian Conway
"
" To use, define the following mappings:
"
"   vmap <silent><expr> ++ personal#visual_math#analyse()
"   nmap <silent>       ++ vip++
"

function! personal#visual_math#yank_and_analyse() " {{{1
  return 'y'
        \ . ":call personal#visual_math#analyse()\<CR>"
        \ . ":silent normal! gv\<CR>"
endfunction

" }}}1
function! personal#visual_math#analyse() " {{{1
  " Parse numerical data
  let selection = split(getreg(''))
  let raw_numbers = filter(selection,
        \ 'v:val =~# ''^[+-]\?\d\+\%([.]\d\+\)\?\([eE][+-]\?\d\+\)\?$''')

  " If no numerical data, try time data...
  let temporal = empty(raw_numbers)
  if temporal
    let raw_numbers = filter(selection,
          \ 'v:val =~# ''^\d\+\%([:]\d\+\)\+\%([.]\d\+\)\?$''')
    call map(raw_numbers, 's:str2sec(v:val)')
  endif

  " If still no numerical data, we're finished
  if empty(raw_numbers) | return | endif

  " Convert to calculable terms...
  let numbers = map(copy(raw_numbers), 'str2float(v:val)')

  " Calculate various interesting metrics...
  let sum = s:tidy(eval(len(numbers) ? join(numbers, ' + ') : '0'))
  let avg = s:average(raw_numbers)
  let min = s:tidy(s:min(numbers))
  let max = s:tidy(s:max(numbers))

  " Convert temporals...
  if temporal
    let sum = s:tidystr(s:sec2str(sum))
    let avg = s:tidystr(s:sec2str(avg))
    let min = s:tidystr(s:sec2str(min))
    let max = s:tidystr(s:sec2str(max))
  endif

  " Write report
  let gap = repeat(' ', 5)
  echohl Identifier
  echon 'sum: ' . sum . gap
  echon 'avg: ' . avg . gap
  echon 'min: ' . min . gap
  echon 'max: ' . max . gap
  echohl None
endfunction

" }}}1

"
" Utility functions
"
function! s:str2sec(time) " {{{1
  let components = split(a:time, ':')
  let multipliers = [60, 60*60, 60*60*24]
  let duration = str2float(remove(components, -1))
  while len(components)
    let duration += 1.0 * remove(multipliers,0) * remove(components, -1)
  endwhile
  return string(duration)
endfunction

" }}}1
function! s:sec2str(duration) " {{{1
  let fraction = str2float(a:duration)
  let duration = str2nr(a:duration)
  let fraction -= duration
  let fracstr = substitute(string(fraction), '^0', '', '')

  let sec = duration % 60
  let duration = duration / 60
  if !duration
    return printf('0:%02d', sec) . (fraction > 0 ? fracstr : '')
  endif

  let min = duration % 60
  let duration = duration / 60
  if !duration
    return printf('%d:%02d', min, sec) . (fraction > 0 ? fracstr : '')
  endif

  let hrs = duration % 24
  let duration = duration / 24
  if !duration
    return printf('%d:%02d:%02d', hrs, min, sec) . (fraction > 0 ? fracstr : '')
  endif

  return printf('%d:%02d:%02d:%02d', duration, hrs, min, sec) . (fraction > 0 ? fracstr : '')
endfunction

" }}}1
function! s:tidy(number) " {{{1
  let tidied = printf('%g', a:number)
  return substitute(tidied, '[.]0\+$', '', '')
endfunction

" }}}1
function! s:tidystr(str) " {{{1
  return substitute(a:str, '[.]0\+$', '', '')
endfunction

" }}}1
function! s:average(numbers) " {{{1
  " Compute average...
  let summation = eval( len(a:numbers) ? join( a:numbers, ' + ') : '0' )
  let avg = 1.0 * summation / s:max([len(a:numbers), 1])

  " Determine significant figures...
  let min_decimals = 15
  for num in a:numbers
    let decimals = strlen(matchstr(num, '[.]\d\+$')) - 1
    if decimals < min_decimals
      let min_decimals = decimals
    endif
  endfor

  " Adjust answer...
  return min_decimals > 0 ? printf('%0.'.min_decimals.'f', avg)
        \                       : string(avg)
endfunction

" }}}1
function! s:max(numbers) " {{{1
  if !len(a:numbers)
    return 0
  endif
  let numbers = copy(a:numbers)
  let maxnum = numbers[0]
  for nextnum in numbers[1:]
    if nextnum > maxnum
      let maxnum = nextnum
    endif
  endfor
  return maxnum
endfunction

" }}}1
function! s:min(numbers) " {{{1
  if !len(a:numbers)
    return 0
  endif
  let numbers = copy(a:numbers)
  let minnum = numbers[0]
  for nextnum in numbers[1:]
    if nextnum < minnum
      let minnum = nextnum
    endif
  endfor
  return minnum
endfunction

" }}}1

" vim: fdm=marker sw=2
