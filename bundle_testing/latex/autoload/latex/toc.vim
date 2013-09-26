" {{{1 latex#toc#open
function! latex#toc#open()
  " Check if buffer exists
  let winnr = bufwinnr(bufnr('LaTeX TOC'))
  if winnr >= 0
    silent execute winnr . 'wincmd w'
    return
  endif

  " Get file names
  let auxfile = g:latex#data[b:latex.id].aux()
  let texfile = g:latex#data[b:latex.id].tex

  " Create TOC window
  let calling_buf = bufnr('%')
  let calling_file = expand('%:p')
  if g:latex_toc_resize
    silent exe "set columns+=" . g:latex_toc_width
  endif
  silent exe g:latex_toc_split_side g:latex_toc_width . 'vnew LaTeX\ TOC'

  " Parse TOC data
  if auxfile == ""
    call append('$', "TeX file not compiled")
  else
    let toc = s:read_toc(auxfile, texfile)
    let closest_index = s:find_closest_section(toc, calling_file)
    let b:toc = toc.data
    let b:toc_numbers = 1
    let b:calling_win = bufwinnr(calling_buf)

    " Add TOC entries and jump to the closest section
    for entry in toc.data
      call append('$', entry['number'] . "\t" . entry['text'])
    endfor

    execute 'normal! ' . (closest_index + 1) . 'G'
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

    let tree = latex#util#tex2tree(s:convert_back(line))

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
function! s:find_closest_section(toc, file)
  if !has_key(a:toc.fileindices, a:file)
    echoerr 'File not included in main tex file!'
    return
  endif

  let imax = len(a:toc.fileindices[a:file])
  let imin = 0
  while imin < imax - 1
    let i = (imax + imin) / 2
    let tocindex = a:toc.fileindices[a:file][i]
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

  return a:toc.fileindices[a:file][imin]
endfunction

" {{{1 s:convert_back
function! s:convert_back(line)
  "
  " Substitute stuff like '\IeC{\"u}' to corresponding unicode symbols
  "
  let line = a:line
  if g:latex_toc_plaintext
    let line = substitute(line, '\\IeC\s*{\\.\(.\)}', '\1', 'g')
  else
    for [pat, symbol] in s:convert_back_list
      let line = substitute(a:line, pat, symbol, 'g')
    endfor
  endif
  return line
endfunction

let s:convert_back_list = map([
      \ ['\\''A}'        , 'Á'],
      \ ['\\`A}'         , 'À'],
      \ ['\\^A}'         , 'À'],
      \ ['\\¨A}'         , 'Ä'],
      \ ['\\"A}'         , 'Ä'],
      \ ['\\''a}'        , 'á'],
      \ ['\\`a}'         , 'à'],
      \ ['\\^a}'         , 'à'],
      \ ['\\¨a}'         , 'ä'],
      \ ['\\"a}'         , 'ä'],
      \ ['\\''E}'        , 'É'],
      \ ['\\`E}'         , 'È'],
      \ ['\\^E}'         , 'Ê'],
      \ ['\\¨E}'         , 'Ë'],
      \ ['\\"E}'         , 'Ë'],
      \ ['\\''e}'        , 'é'],
      \ ['\\`e}'         , 'è'],
      \ ['\\^e}'         , 'ê'],
      \ ['\\¨e}'         , 'ë'],
      \ ['\\"e}'         , 'ë'],
      \ ['\\''I}'        , 'Í'],
      \ ['\\`I}'         , 'Î'],
      \ ['\\^I}'         , 'Ì'],
      \ ['\\¨I}'         , 'Ï'],
      \ ['\\"I}'         , 'Ï'],
      \ ['\\''i}'        , 'í'],
      \ ['\\`i}'         , 'î'],
      \ ['\\^i}'         , 'ì'],
      \ ['\\¨i}'         , 'ï'],
      \ ['\\"i}'         , 'ï'],
      \ ['\\''{\?\\i }'  , 'í'],
      \ ['\\''O}'        , 'Ó'],
      \ ['\\`O}'         , 'Ò'],
      \ ['\\^O}'         , 'Ô'],
      \ ['\\¨O}'         , 'Ö'],
      \ ['\\"O}'         , 'Ö'],
      \ ['\\''o}'        , 'ó'],
      \ ['\\`o}'         , 'ò'],
      \ ['\\^o}'         , 'ô'],
      \ ['\\¨o}'         , 'ö'],
      \ ['\\"o}'         , 'ö'],
      \ ['\\''U}'        , 'Ú'],
      \ ['\\`U}'         , 'Ù'],
      \ ['\\^U}'         , 'Û'],
      \ ['\\¨U}'         , 'Ü'],
      \ ['\\"U}'         , 'Ü'],
      \ ['\\''u}'        , 'ú'],
      \ ['\\`u}'         , 'ù'],
      \ ['\\^u}'         , 'û'],
      \ ['\\¨u}'         , 'ü'],
      \ ['\\"u}'         , 'ü'],
      \ ['\\`N}'         , 'Ǹ'],
      \ ['\\\~N}'        , 'Ñ'],
      \ ['\\''n}'        , 'ń'],
      \ ['\\`n}'         , 'ǹ'],
      \ ['\\\~n}'        , 'ñ'],
      \], '[''\C\(\\IeC\s*{\)\?'' . v:val[0], v:val[1]]')
" }}}1

" vim:fdm=marker:ff=unix
