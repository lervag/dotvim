" {{{1 latex#complete#omnifunc
let s:completion_type = ''
function! latex#complete#omnifunc(findstart, base)
  if a:findstart
    "
    " First call:  Find start of text to be completed
    "
    " Note: g:latex_complete.patterns is a dictionary where the keys are the
    " types of completion and the values are the patterns that must match for
    " the given type.  Currently, it completes labels (e.g. \ref{...), bibtex
    " entries (e.g. \cite{...) and commands (e.g. \...).
    "
    let line = getline('.')
    let pos  = col('.') - 1
    for [type, pattern] in items(g:latex_complete.patterns)
      echom type
      if line =~ pattern . '$'
        echom "ja"
        let s:completion_type = type
        while pos > 0 && line[pos - 1] !~ '{\|,'
          let pos -= 1
        endwhile
        return pos > 0 ? pos : -2
      endif
    endfor
  else
    "
    " Second call:  Find list of matches
    "
    if s:completion_type == 'ref'
      return latex#complete#labels(a:base)
    elseif s:completion_type == 'bib'
      return latex#complete#bibtex(a:base)
    endif
  endif
endfunction

" {{{1 latex#complete#labels
function! latex#complete#labels(regex)
  let labels = s:get_labels(g:latex#data[b:latex.id].aux())
  let matches = filter(copy(labels), 'match(v:val[0], "' . a:regex . '") != -1')

  if empty(matches)
    " Also try to match label and number
    let regex_split = split(a:regex)
    if len(regex_split) > 1
      let base = regex_split[0]
      let number = escape(join(regex_split[1:], ' '), '.')
      let matches = filter(copy(labels),
            \ 'match(v:val[0], "' . base   . '") != -1 &&' .
            \ 'match(v:val[1], "' . number . '") != -1')
    endif
  endif

  if empty(matches)
    " Also try to match number
    let matches = filter(copy(labels),
          \ 'match(v:val[1], "' . a:regex . '") != -1')
  endif

  let suggestions = []
  for m in matches
    let entry = {
          \ 'word': m[0],
          \ 'menu': printf("%7s [p. %s]", '('.m[1].')', m[2])
          \ }
    if g:latex_complete.close_braces && !s:next_chars_match('^\s*[,}]')
      let entry = copy(entry)
      let entry.abbr = entry.word
      let entry.word = entry.word . '}'
    endif
    call add(suggestions, entry)
  endfor

  return suggestions
endfunction

" {{{1 latex#complete#bibtex
function! latex#complete#bibtex(regexp)
  let res = []

  for m in s:bibtex_search(a:regexp)
    let type = m['type']   == '' ? '[-]' : '[' . m['type']   . '] '
    let auth = m['author'] == '' ? ''    :       m['author'][:20] . ' '
    let year = m['year']   == '' ? ''    : '(' . m['year']   . ')'
    let w = {
          \ 'word': m['key'],
          \ 'abbr': type . auth . year,
          \ 'menu': m['title']
          \ }

    " Close braces if desired
    if g:latex_complete.close_braces && !s:next_chars_match('^\s*[,}]')
      let w.word = w.word . '}'
    endif

    call add(res, w)
  endfor

  return res
endfunction
" }}}1

" Label extraction
" {{{1 s:get_labels

" s:label_cache is a dictionary that maps filenames to tuples of the form
"
"   [ time, labels, inputs ]
"
" where time is modification time of the cache entry, labels is a list like
" returned by extract_labels, and inputs is a list like returned by
" s:extract_inputs.
let s:label_cache = {}

function! s:get_labels(file)
  "
  " s:get_labels compares modification time of each entry in the label cache
  " and updates it if necessary.  During traversal of the label cache, all
  " current labels are collected and returned.
  "
  if !filereadable(a:file)
    return []
  endif

  " Open file in temporary split window for label extraction.
  if !has_key(s:label_cache , a:file)
        \ || s:label_cache[a:file][0] != getftime(a:file)
    let s:label_cache[a:file] = [
          \ getftime(a:file),
          \ s:extract_labels(a:file),
          \ s:extract_inputs(a:file),
          \ ]
  endif

  " We need to create a copy of s:label_cache[fid][1], otherwise all inputs'
  " labels would be added to the current file's label cache upon each
  " completion call, leading to duplicates/triplicates/etc. and decreased
  " performance.  Also, because we don't anything with the list besides
  " matching copies, we can get away with a shallow copy for now.
  let labels = copy(s:label_cache[a:file][1])

  for input in s:label_cache[a:file][2]
    let labels += s:get_labels(input)
  endfor

  return labels
endfunction

" {{{1 s:extract_labels
function! s:extract_labels(file)
  "
  " Searches file for commands of the form
  "
  "   \newlabel{name}{{number}{page}.*}.*
  "
  " and returns a list of [name, number, page] tuples.
  "
  let matches = []
  let lines = readfile(a:file)
  let lines = filter(lines, 'v:val =~ ''\\newlabel{''')
  let lines = filter(lines, 'v:val !~ ''@cref''')
  let lines = map(lines, 'latex#util#convert_back(v:val)')
  for line in lines
    let tree = latex#util#tex2tree(line)
    call add(matches, [
          \ latex#util#tree2tex(tree[1][0]),
          \ latex#util#tree2tex(tree[2][0][0]),
          \ latex#util#tree2tex(tree[2][1][0]),
          \ ])
  endfor
  return matches
endfunction

" {{{1 s:extract_inputs
function! s:extract_inputs(file)
  "
  " Searches file for \@input{file} entries and returns list of all files.
  "
  let matches = []
  for line in filter(readfile(a:file), 'v:val =~ ''\\@input{''')
    call add(matches, matchstr(line, '{\zs.*\ze}'))
  endfor
  return matches
endfunction
" }}}1

" BibTeX extraction
" {{{1 s:bibtex_search
let s:bstfile = expand('<sfile>:p:h') . '/vimcomplete'
function! s:bibtex_search(regexp)
  let res = []

  " Find data from external bib files
  let bibdata = latex#util#find_bibliographies()
  if bibdata != ''
    " Write temporary aux file
    let tmpbase = g:latex#data[b:latex.id].root . '/bibtex_search_tmp'
    let auxfile = tmpbase . '.aux'
    let bblfile = tmpbase . '.bbl'
    let blgfile = tmpbase . '.blg'
    call writefile([
          \ '\citation{*}',
          \ '\bibstyle{' . s:bstfile . '}',
          \ '\bibdata{' . bibdata . '}' ],
          \ auxfile)
    let cmd = '!cd ' . g:latex#data[b:latex.id].root
          \ . '; bibtex -terse '
          \ . fnamemodify(auxfile, ':t') . ' >/dev/null'
    silent execute cmd
    if !has('gui_running')
      redraw!
    endif

    " Parse temporary aux file
    let lines = split(substitute(join(readfile(bblfile), "\n"),
          \ '\n\n\@!\(\s\=\)\s*\|{\|}', '\1', 'g'), "\n")

    for line in filter(lines, 'v:val =~ a:regexp')
      let matches = matchlist(line,
            \ '^\(.*\)||\(.*\)||\(.*\)||\(.*\)||\(.*\)')
      if !empty(matches) && !empty(matches[1])
        call add(res, {
              \ 'key':    matches[1],
              \ 'type':   matches[2],
              \ 'author': matches[3],
              \ 'year':   matches[4],
              \ 'title':  matches[5],
              \ })
      endif
    endfor

    call delete(auxfile)
    call delete(bblfile)
    call delete(blgfile)
  endif

  " Find data from 'thebibliography' environments
  let lines = readfile(g:latex#data[b:latex.id].tex)
  if match(lines, '\C\\begin{thebibliography}')
    for line in filter(filter(lines, 'v:val =~ ''\C\\bibitem'''),
          \ 'v:val =~ a:regexp')
      let match = matchlist(line, '\\bibitem{\([^}]*\)')[1]
      call add(res, {
            \ 'key': match,
            \ 'type': '',
            \ 'author': '',
            \ 'year': '',
            \ 'title': match,
            \ })
    endfor
  endif

  return res
endfunction
" }}}1

" Other
" {{{1 s:next_chars_match
function! s:next_chars_match(regex)
  return strpart(getline('.'), col('.') - 1) =~ a:regex
endfunction
" }}}1

" vim:fdm=marker:ff=unix
