function! personal#syntax#colortest(outfile, bgend) abort " {{{1
  let result = []
  for bg in range(a:bgend)
    let kw = printf('%-7s', printf('c_%d_%d', 11, bg))
    let h = printf('hi %s ctermfg=%d ctermbg=%d', kw, 11, bg)
    let s = printf('syn keyword %s %s', kw, kw)
    call add(result, printf('%-32s | %s', h, s))
  endfor
  call writefile(result, a:outfile)
  execute 'edit '.a:outfile
  source %
endfunction

" Increase numbers in next line to see more colors.
command! VimColorTest call personal#syntax#colortest('vim-color-test.tmp', 256)

" }}}1
function! personal#syntax#color_code_blocks() abort " {{{1
  " This is based on an idea from reddit:
  " https://www.reddit.com/r/vim/comments/fob3sg/different_background_color_for_markdown_code/
  highlight codeBlockBackground ctermbg=231
  sign define codeblock linehl=codeBlockBackground

  augroup code_block_background
    autocmd! * <buffer>
    autocmd InsertLeave  <buffer> call s:place_signs()
    autocmd BufEnter     <buffer> call s:place_signs()
    autocmd BufWritePost <buffer> call s:place_signs()
  augroup END
endfunction

" }}}1

function! s:place_signs() abort " {{{1
  let l:continue = 0
  let l:file = expand('%')

  execute 'sign unplace * file=' . l:file

  for l:lnum in range(1, line('$'))
    let l:line = getline(l:lnum)
    if l:continue || l:line =~# '^\s*```.*$'
      execute printf('sign place %d line=%d name=codeblock file=%s',
            \ l:lnum, l:lnum, l:file)
      let l:continue = l:line !~# '^\s*```$'
    endif
  endfor
endfunction

" }}}1
