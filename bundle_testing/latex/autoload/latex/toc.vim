" {{{1 latex#toc#open
function! latex#toc#open()
  " Check if buffer exists
  let winnr = bufwinnr(bufnr('LaTeX TOC'))
  if winnr >= 0
    silent execute winnr . 'wincmd w'
    return
  endif

  " Create TOC window
  let auxfile = g:latex#data[b:latex_id].aux()
  let texfile = g:latex#data[b:latex_id].tex
  let calling_buf = bufnr('%')
  if g:latex_toc_resize
    silent exe "set columns+=" . g:latex_toc_width
  endif
  silent exe g:latex_toc_split_side g:latex_toc_width . 'vnew LaTeX\ TOC'

  " Parse TOC data
  if auxfile
    let toc = s:read_toc(auxfile, texfile)
    let closest_index = s:find_closest_section(toc)
    let b:toc = toc.data
    let b:toc_numbers = 1
    let b:calling_win = bufwinnr(calling_buf)

    " Add TOC entries and jump to the closest section
    for entry in toc.data
      call append('$', entry['number'] . "\t" . entry['text'])
    endfor

    execute 'normal! ' . (closest_index + 1) . 'G'
  else
    call append('$', "TeX file not compiled")
  endif

  " Add help info
  if !g:latex_toc_hide_help
    call append('$', "")
    call append('$', "<Esc>/q: close")
    call append('$', "<Space>: jump")
    call append('$', "<Enter>: jump and close")
    call append('$', "s:       hide numbering")
  endif
  0delete _

  " Set filetype and lock buffer
  setlocal filetype=latextoc
  setlocal nomodifiable
endfunction

" {{{1 latex#toc#toggle
function! latex#toc#toggle()
  if bufwinnr(bufnr('LaTeX TOC')) >= 0
    if g:latex_toc_resize
      silent exe "set columns-=" . g:latex#toc#width
    endif
    silent execute 'bwipeout' . bufnr('LaTeX TOC')
  else
    call latex#toc#open()
  endif
endfunction
" }}}1

" {{{1 s:read_toc
function! s:read_toc(auxfile, texfile, ...)
  let texfile = a:texfile
  let prefix = fnamemodify(a:auxfile, ':p:h')

  if a:0 != 2
    let toc = []
    let fileindices = { texfile : [] }
  else
    let toc = a:1
    let fileindices = a:2
    let fileindices[texfile] = []
  endif

  for line in readfile(a:auxfile)
    " Check for included files, include if found
    let included = matchstr(line, '^\\@input{\zs[^}]*\ze}')
    if included != ''
      let newaux = prefix . '/' . included
      let newtex = fnamemodify(fnamemodify(newaux, ':t:r') . '.tex', ':p')
      call s:read_toc(newaux, newtex, toc, fileindices)
      continue
    endif

    " Parse TOC statements from aux files
    let line = matchstr(line,
          \ '\\@writefile{toc}{\\contentsline\s*\zs.*\ze}\s*$')
    if empty(line)
      continue
    endif

    let tree = latex#util#tex2tree(line)

    if len(tree) < 3
      " unknown entry type: just skip it
      continue
    endif

    " Parse level
    let level = tree[0][0]
    " parse page
    if !empty(tree[2])
      let page = tree[2][0]
    else
      let page = ''
    endif

    " Parse number
    if len(tree[1]) > 3 && empty(tree[1][1])
      call remove(tree[1], 1)
    endif
    if len(tree[1]) > 1
      if !empty(tree[1][1])
        let secnum = latex#util#tree2tex(tree[1][1])
        let secnum = s:utf8_conversion(secnum)
        let secnum = substitute(secnum, '\\\S\+\s', '', 'g')
        let secnum = substitute(secnum, '\\\S\+{\(.\{-}\)}', '\1', 'g')
        let secnum = substitute(secnum, '^{\+\|}\+$', '', 'g')
      endif
      let tree = tree[1][2:]
    else
      let secnum = ''
      let tree = tree[1]
    endif

    " Parse title
    let text = latex#util#tree2tex(tree)
    let text = s:utf8_conversion(text)
    let text = substitute(text, '^{\+\|}\+$', '', 'g')

    " Add TOC entry
    call add(fileindices[texfile], len(toc))
    call add(toc,
          \ {
            \ 'file':   texfile,
            \ 'level':  level,
            \ 'number': secnum,
            \ 'text':   text,
            \ 'page':   page,
          \ })
  endfor

  return {'data': toc, 'fileindices': fileindices}
endfunction

" {{{1 s:find_closest_section
"
" 1. Binary search for the closest section
" 2. Return the index of the TOC entry
"
function! s:find_closest_section(toc)
  let file = expand('%:p')
  if !has_key(a:toc.fileindices, file)
    echoe 'File not included in main tex file!'
  endif

  let imax = len(a:toc.fileindices[file])
  let imin = 0
  while imin < imax - 1
    let i = (imax + imin) / 2
    let tocindex = a:toc.fileindices[file][i]
    let entry = a:toc.data[tocindex]
    let titlestr = entry['text']
    let titlestr = escape(titlestr, '\')
    let titlestr = substitute(titlestr, ' ', '\\_\\s\\+', 'g')
    let [lnum, cnum]
          \ = searchpos('\\' . entry['level'] . '\_\s*{' . titlestr . '}', 'nW')
    if lnum
      let imax = i
    else
      let imin = i
    endif
  endwhile

  return a:toc.fileindices[file][imin]
endfunction

" {{{1 s:utf8_conversion
function! s:utf8_conversion(line)
  let line = a:line
  if g:latex_toc_plaintext
    let line = substitute(line, "\\\\IeC\s*{\\\\.\\(.\\)}", '\1', 'g')
  else
    let line = substitute(line, "\\\\IeC\s*{\\\\'a}", 'á', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\`a}", 'à', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\^a}", 'à', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\¨a}", 'ä', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\\"a}", 'ä', 'g')

    let line = substitute(line, "\\\\IeC\s*{\\\\'e}", 'é', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\`e}", 'è', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\^e}", 'ê', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\¨e}", 'ë', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\\"e}", 'ë', 'g')

    let line = substitute(line, "\\\\IeC\s*{\\\\'i}", 'í', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\`i}", 'î', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\^i}", 'ì', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\¨i}", 'ï', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\\"i}", 'ï', 'g')

    let line = substitute(line, "\\\\IeC\s*{\\\\'o}", 'ó', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\`o}", 'ò', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\^o}", 'ô', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\¨o}", 'ö', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\\"o}", 'ö', 'g')

    let line = substitute(line, "\\\\IeC\s*{\\\\'u}", 'ú', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\`u}", 'ù', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\^u}", 'û', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\¨u}", 'ü', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\\"u}", 'ü', 'g')

    let line = substitute(line, "\\\\IeC\s*{\\\\'A}", 'Á', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\`A}", 'À', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\^A}", 'À', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\¨A}", 'Ä', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\\"A}", 'Ä', 'g')

    let line = substitute(line, "\\\\IeC\s*{\\\\'E}", 'É', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\`E}", 'È', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\^E}", 'Ê', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\¨E}", 'Ë', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\\"E}", 'Ë', 'g')

    let line = substitute(line, "\\\\IeC\s*{\\\\'I}", 'Í', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\`I}", 'Î', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\^I}", 'Ì', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\¨I}", 'Ï', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\\"I}", 'Ï', 'g')

    let line = substitute(line, "\\\\IeC\s*{\\\\'O}", 'Ó', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\`O}", 'Ò', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\^O}", 'Ô', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\¨O}", 'Ö', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\\"O}", 'Ö', 'g')

    let line = substitute(line, "\\\\IeC\s*{\\\\'U}", 'Ú', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\`U}", 'Ù', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\^U}", 'Û', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\¨U}", 'Ü', 'g')
    let line = substitute(line, "\\\\IeC\s*{\\\\\"U}", 'Ü', 'g')
  endif
  return line
endfunction
" }}}1

" vim:fdm=marker:ff=unix
