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
