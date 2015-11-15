scriptencoding utf8

" {{{1 Initialize

" Use space as leader key
nnoremap <space> <nop>
let mapleader = "\<space>"

" Option hook
"   Some things, in particular for plugins, must be set at end of vimrc.  This
"   dictionary allows to create hook functions that are called at the end of
"   the vimrc file.
let s:hooks = {}

" }}}1
"{{{1 Load plugins

silent! if plug#begin('~/.vim/bundle')

" {{{2 VimPlug
Plug 'junegunn/vim-plug', { 'on' : [] }
let g:plug_window = 'tab new'

nnoremap <silent> <leader>pd :PlugDiff<cr>
nnoremap <silent> <leader>pi :PlugInstall<cr>
nnoremap <silent> <leader>pu :PlugUpdate<cr>
nnoremap <silent> <leader>ps :PlugStatus<cr>
nnoremap <silent> <leader>pc :PlugClean<cr>
" }}}2

" User interface
Plug 'altercation/vim-colors-solarized'
Plug 'moll/vim-bbye', { 'on' : 'Bdelete' }
" {{{2 indentLine
Plug 'Yggdroot/indentLine'
if has('gui_running')
  let g:indentLine_char = '┊'
else
  let g:indentLine_char = '|'
endif
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#d6d0bf'
let g:indentLine_concealcursor = ''
let g:indentLine_fileTypeExclude = ['help']

" }}}2
" {{{2 Rainbow parantheses
Plug 'luochen1990/rainbow'
let g:rainbow_active = 1
let g:rainbow_conf = {
      \ 'guifgs': ['#f92672', '#00afff', '#268bd2', '#93a1a1', '#dc322f',
      \   '#6c71c4', '#b58900', '#657b83', '#d33682', '#719e07', '#2aa198'],
      \ 'ctermfgs': ['9', '127', '4', '1', '3', '12', '5', '2', '6', '33',
      \   '104', '124', '7', '39'],
      \ 'separately' : {
      \   '*' : 0,
      \   'fortran' : {},
      \ }
      \}

Plug 'junegunn/rainbow_parentheses.vim'

" }}}2
" {{{2 vim-fontsize
Plug 'drmikehenry/vim-fontsize'

nmap <silent> <leader>+                   <plug>FontsizeBegin
nmap <silent> <sid>DisableFontsizeInc     <plug>FontsizeInc
nmap <silent> <sid>DisableFontsizeDec     <plug>FontsizeDec
nmap <silent> <sid>DisableFontsizeDefault <plug>FontsizeDefault

" }}}2

" General motions
Plug 'guns/vim-sexp'
" {{{2 targets.vim
Plug 'wellle/targets.vim'

let g:targets_argOpening = '[({[]'
let g:targets_argClosing = '[]})]'

" }}}2
" {{{2 Incsearch
Plug 'haya14busa/incsearch.vim'
let g:incsearch#auto_nohlsearch = 1
let g:incsearch#separate_highlight = 1

set hlsearch
nmap /  <plug>(incsearch-forward)
nmap ?  <plug>(incsearch-backward)
nmap g/ <plug>(incsearch-stay)
nmap n  <plug>(incsearch-nohl-n)zvzz
nmap N  <plug>(incsearch-nohl-N)zvzz
nmap *  <plug>(incsearch-nohl-*)zvzz
nmap #  <plug>(incsearch-nohl-#)zvzz
nmap g* <plug>(incsearch-nohl-g*)zvzz
nmap g# <plug>(incsearch-nohl-g#)zvzz

" Use <c-l> to clear the highlighting of :set hlsearch.
if maparg('<c-l>', 'n') ==# ''
  nnoremap <silent> <c-l> :nohlsearch<cr><c-l>
endif

" Define highlightings
function! s:hooks.incsearch()
  highlight IncSearchMatch
        \ cterm=bold,underline gui=bold,underline ctermfg=201 guifg=Magenta
  highlight IncSearchMatchReverse
        \ cterm=bold,underline gui=bold,underline ctermfg=127 guifg=LightMagenta
  highlight IncSearchOnCursor
        \ cterm=bold,underline gui=bold,underline ctermfg=39  guifg=#00afff
  highlight IncSearchCursor
        \ cterm=bold,underline gui=bold,underline ctermfg=39  guifg=#00afff
endfunction

" }}}2
" {{{2 Smalls
Plug 't9md/vim-smalls'

nmap <c-s> <plug>(smalls)
xmap <c-s> <plug>(smalls)
omap <c-s> <plug>(smalls)

" }}}2
" {{{2 vim-columnmove
Plug 'machakann/vim-columnmove'

let g:columnmove_no_default_key_mappings = 1

function! s:hooks.columnmove()
  for l:x in split('ftFT;,wbeWBE', '\zs')
    silent! call columnmove#utility#map('nxo', l:x, '<m-' . l:x . '>', 'block')
  endfor
  silent! call columnmove#utility#map('nxo', 'ge', '<m-g>e', 'block')
  silent! call columnmove#utility#map('nxo', 'gE', '<m-g>E', 'block')
endfunction

" }}}2

" General programming
Plug 'tpope/vim-commentary'
" {{{2 ConqueGDB
Plug 'vim-scripts/Conque-GDB', { 'on' : 'ConqueGDB' }

" ConqueGDB options
let g:ConqueGdb_Leader = '<leader>d'
let g:ConqueGdb_SrcSplit = 'left'

" ConqueTerm options
let g:ConqueTerm_Color = 2
let g:ConqueTerm_CloseOnEnd = 1
let g:ConqueTerm_StartMessages = 0
let g:ConqueTerm_ReadUnfocused = 1

" }}}
" {{{2 Fugitive, gitv, Lawrencium, etc...
Plug 'tpope/vim-fugitive'
Plug 'gregsexton/gitv'

let g:Gitv_OpenHorizontal = 1

nnoremap <leader>gs :Gtogglestatus<cr>
nnoremap <leader>gc :Gcommit<cr>
nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>gl :Gitv<cr>
nnoremap <leader>gL :Gitv!<cr>

command! Gtogglestatus :call Gtogglestatus()
function! Gtogglestatus()
  if buflisted(bufname('.git/index'))
    bd .git/index
  else
    Gstatus
  endif
endfunction

augroup my_fugitive
  autocmd!
  autocmd BufReadPost fugitive://* set bufhidden=delete
augroup END

Plug 'ludovicchabant/vim-lawrencium'
nnoremap <leader>hs :Hgstatus<cr>
nnoremap <leader>hl :Hglog<cr>
nnoremap <leader>hL :Hglogthis<cr>

nnoremap <leader>hd :call MyHgdiff()<cr>
function! MyHgdiff()
  let l:vimtex_fold_enabled = get(g:, 'vimtex_fold_enabled', 0)
  let g:vimtex_fold_enabled = 0
  Hgvdiff
  windo setlocal foldmethod=diff
  normal! gg]c
  let g:vimtex_fold_enabled = l:vimtex_fold_enabled
endfunction

nnoremap <leader>hr :call MyHgrecord()<cr>
function! MyHgrecord()
  let l:vimtex_fold_enabled = get(g:, 'vimtex_fold_enabled', 0)
  let g:vimtex_fold_enabled = 0
  Hgvrecord
  windo setlocal foldmethod=diff
  normal! gg]c
  let g:vimtex_fold_enabled = l:vimtex_fold_enabled
  let s:record = 1
endfunction

nnoremap <leader>ha :call MyHgabort()<cr>
function! MyHgabort()
  if get(s:, 'record', 0)
    Hgrecordabort
  else
    bdelete lawrencium
  endif
  ResizeSplits
  normal! zx
endfunction

" }}}
" {{{2 Gutentags
Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_tagfile = '.tags'

" }}}2
"{{{2 Quickrun
Plug 'thinca/vim-quickrun'
let g:quickrun_config = {}
let g:quickrun_config.python = { 'command' : 'python2' }
let g:quickrun_config._ = {
      \ 'outputter/buffer/close_on_empty' : 1
      \ }

nmap <leader>rr <plug>(quickrun)
nmap <leader>ro <plug>(quickrun-op)

nnoremap <leader>rs :call QuickRunSimfex()<cr>

function! QuickRunSimfex()
  let l:exec = '''%c -v '
  if getcwd() =~# '\/tests'
    let l:exec .= '%s'''
  else
    let l:file = fnamemodify('../tests/test_' . expand('%:t'), ':p')
    if !filereadable(l:file)
      echo 'Could not find corresponding test file.'
      return
    endif
    let l:exec .= l:file . ''''
  endif
  execute 'QuickRun -command nosetests2 -exec' l:exec
endfunction

" }}}2
" {{{2 Syntactics
Plug 'scrooloose/syntastic'
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = {
      \ 'mode':              'active',
      \ 'passive_filetypes': ['tex'],
      \ }

let g:syntastic_vim_checkers = ['vint']
let g:syntastic_python_checkers = ['pylint2']

" Fortran settings
let g:syntastic_fortran_compiler_options = ' -fdefault-real-8'
let g:syntastic_fortran_include_dirs = [
      \ '../obj/gfortran_debug',
      \ '../objects/debug_gfortran',
      \ '../thermopack/objects/debug_gfortran_Linux',
      \ ]

" Some mappings
nnoremap <leader>sc :SyntasticCheck<cr>
nnoremap <leader>si :SyntasticInfo<cr>
nnoremap <leader>st :SyntasticToggleMode<cr>

" }}}2
" {{{2 Vebugger
Plug 'idanarye/vim-vebugger'

let g:vebugger_leader = '<leader>v'

" }}}

" Completion and snippets
"{{{2 Neocomplete
Plug 'Shougo/neocomplete'
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_camel_case = 1
let g:neocomplete#enable_auto_delimiter = 1
let g:neocomplete#enable_auto_close_preview = 1

inoremap <expr> <c-l>   neocomplete#start_manual_complete()
inoremap <expr> <c-y>   neocomplete#close_popup()
inoremap <expr> <c-e>   neocomplete#cancel_popup()
inoremap <expr> <c-h>   neocomplete#smart_close_popup() . "\<c-h>"

inoremap <expr> <tab>   pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

" Define dictionaries if they don't exist
if !exists('s:hooks.neocomplete')
  let g:neocomplete#same_filetypes = {}
  let g:neocomplete#keyword_patterns = {}
  let g:neocomplete#sources#omni#input_patterns = {}
  let g:neocomplete#force_omni_input_patterns = {}
endif

" Always use completions from all buffers
let g:neocomplete#same_filetypes._ = '_'

" Define keyword patterns
let g:neocomplete#keyword_patterns.tex     = '[a-zA-ZæÆøØåÅ][0-9a-zA-ZæÆøØåÅ]\+'
let g:neocomplete#keyword_patterns.vimwiki = '[a-zA-ZæÆøØåÅ][0-9a-zA-ZæÆøØåÅ]\+'

" Define omni input patterns
let g:neocomplete#sources#omni#input_patterns.vimwiki = '\[\[\S*'
let g:neocomplete#sources#omni#input_patterns.tex =
      \ '\v\\\a*(ref|cite)\a*([^]]*\])?\{([^}]*,)*[^}]*'

" Define omni force patterns
let g:neocomplete#force_omni_input_patterns.vimwiki = '\[\[[^]|]*#\S*'

function! s:hooks.neocomplete()
  call neocomplete#custom#source('ultisnips', 'rank', 1000)
endfunction

"{{{2 Neosnippet
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

let g:neosnippet#snippets_directory = '~/.vim/snippets'

imap <c-k> <plug>(neosnippet_expand_or_jump)
smap <c-k> <plug>(neosnippet_expand_or_jump)
imap <c-s> <plug>(neosnippet_start_unite_snippet)

nnoremap <leader>es :NeoSnippetEdit<cr>

" }}}2

" Filetype specific
Plug 'chrisbra/csv.vim'
Plug 'darvelo/vim-systemd'
Plug 'whatyouhide/vim-tmux-syntax'
" {{{2 HTML, XML, ...
Plug 'gregsexton/MatchTag'

" }}}2
" {{{2 LaTeX
Plug 'git@github.com:lervag/vimtex.git'
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_index_split_pos = 'below'
let g:vimtex_view_method = 'zathura'
let g:vimtex_imaps_leader = ';'
let g:vimtex_imaps_snippet_engine = 'neosnippet'

let g:tex_stylish = 1
let g:tex_conceal = ''
let g:tex_flavor = 'latex'
let g:tex_isk='48-57,a-z,A-Z,192-255,:'

" }}}2
" {{{2 Markdown/Pandoc
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

let g:pandoc#folding#level = 9
let g:pandoc#folding#fdc = 0
let g:pandoc#formatting#mode = 'h'
let g:pandoc#toc#position = 'top'
let g:pandoc#modules#disabled = ['spell']

nnoremap <silent><leader>rp :Pandoc! #sintefpres<cr>

" }}}2
" {{{2 Python
Plug 'mitsuhiko/vim-python-combined'
Plug 'jmcantrell/vim-virtualenv', { 'on' : 
      \ [ 'VirtualEnvActivate',
      \   'VirtualEnvDeactivate',
      \   'VirtualEnvList' ] }
Plug 'davidhalter/jedi-vim'

let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#smart_auto_mappings = 0
let g:jedi#rename_command = ''

"}}}2
"{{{2 Ruby
Plug 'vim-ruby/vim-ruby'
let g:ruby_fold=1

" }}}2
" {{{2 Vimwiki
Plug 'vimwiki/vimwiki', { 'branch' : 'dev' }
Plug '~/.vim/bundle_local/vimwiki-journal'

" Set up main wiki
let s:wiki = {}
let s:wiki.path = '~/documents/wiki'
let s:wiki.diary_rel_path = 'journal'
let s:wiki.list_margin = 0
let s:wiki.nested_syntaxes = {
      \ 'python' : 'python',
      \ 'bash'   : 'sh',
      \ 'sh'     : 'sh',
      \ 'tex'    : 'latex',
      \ 'f90'    : 'fortran',
      \ 'make'   : 'make',
      \ 'vim'    : 'vim',
      \ }

" Set up global options
let g:vimwiki_list = [s:wiki]
let g:vimwiki_folding = 'expr'
let g:vimwiki_toc_header = 'Innhald'
let g:vimwiki_hl_headers = 1
let g:vimwiki_hl_cb_checked = 1
let g:vimwiki_table_mappings = 0

" }}}2

" Utility plugins
Plug 'git@github.com:lervag/file-line'
Plug 'Shougo/vimproc', { 'do' : 'make -f make_unix.mak' }
Plug 'thinca/vim-prettyprint'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-unimpaired'
Plug 'tyru/capture.vim', { 'on' : 'Capture' }
" {{{2 Ack
Plug 'mileszs/ack.vim'
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
let g:ackhighlight = 1
let g:ack_mappings = {
      \ 'o'  : '<cr>zMzvzz',
      \ 'O'  : '<cr><c-w><c-w>:ccl<cr>zMzvzz',
      \ 'p'  : '<cr>zMzvzz<c-w><c-w>',
      \ }

nnoremap <leader>fa :Ack 

" }}}2
" {{{2 Calendar
Plug 'itchyny/calendar.vim'
let g:calendar_first_day = 'monday'
let g:calendar_date_endian = 'big'
let g:calendar_frame = 'space'
let g:calendar_week_number = 1

nnoremap <silent> <leader>c :Calendar -position=below<cr>

" Connect to diary
augroup vimrc_calendar
  autocmd!
  autocmd FileType calendar 
        \ nnoremap <silent><buffer> <cr> :<c-u>call OpenDiary()<cr>
augroup END
function! OpenDiary()
  let d = b:calendar.day().get_day()
  let m = b:calendar.day().get_month()
  let y = b:calendar.day().get_year()
  let w = b:calendar.day().week()
  wincmd p
  call vimwiki#diary#calendar_action(d, m, y, w, 'V')
endfunction

" }}}2
"{{{2 Clam
Plug 'sjl/clam.vim'
let g:clam_winpos = 'topleft'

" }}}2
"{{{2 CtrlFS
Plug 'dyng/ctrlsf.vim'

let g:ctrlsf_indent = 2
let g:ctrlsf_mapping = {
      \ 'tab' : '',
      \ 'tabb': '',
      \ 'next': 'n',
      \ 'prev': 'N',
      \ }
let g:ctrlsf_position = 'bottom'

nnoremap         <leader>fp :CtrlSF 
nnoremap         <leader>ff :CtrlSF <c-r>=expand('<cWORD>')<cr>
nnoremap <silent><leader>ft :CtrlSFToggle<cr>
nnoremap <silent><leader>fu :CtrlSFUpdate<cr>
vmap     <silent><leader>f  <Plug>CtrlSFVwordExec

" Highlighting for CtrlSF selected line
function! s:hooks.ctrlsf()
  hi ctrlsfSelectedLine term=bold cterm=bold gui=bold ctermfg=39 guifg=#00afff
endfunction

" }}}2
" {{{2 Unite
Plug 'Shougo/unite.vim'
Plug 'Shougo/unite-help'
Plug 'Shougo/unite-outline'
Plug 'Shougo/neomru.vim'
Plug 'tsukkee/unite-tag'
Plug 'Shougo/neoinclude.vim'

"
" Settings
"
let g:unite_source_rec_max_cache_files=5000
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts
        \ = '--nocolor --line-numbers --nogroup -S -C4'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('ack')
  let g:unite_source_grep_command = 'ack'
  let g:unite_source_grep_default_opts = '--no-heading --no-color -C4'
  let g:unite_source_grep_recursive_opt = ''
endif

"
" More settings defined through function calls
"
function! s:hooks.unite()
  call unite#custom#profile('default', 'context', {
        \ 'start_insert' : 1,
        \ 'no_split' : 1,
        \ 'prompt' : '> ',
        \ })

  call unite#filters#matcher_default#use(['matcher_fuzzy'])

  call unite#custom#source('file_mru', 'sorters', 'sorter_selecta')
  call unite#custom#source('file_mru', 'ignore_pattern', '\v' . join([
        \ '\/\.(git|hg)\/',
        \ '\.wiki$',
        \ '\.vim\/vimrc$',
        \ '\/vim\/.*\/doc\/.*txt$',
        \ '_(LOCAL|REMOTE)_',
        \ '\~record$',
        \ '^\/tmp\/',
        \ ], '|'))
endfunction

"
" Mappings
"
nnoremap <silent> <leader><leader> :<c-u>Unite file_mru <cr>
nnoremap <silent> <leader>oo       :<c-u>Unite file<cr>
nnoremap <silent> <leader>ob       :<c-u>Unite buffer<cr>
nnoremap <silent> <leader>oh       :<c-u>Unite help<cr>
nnoremap <silent> <leader>ot       :<c-u>Unite outline tag tag/include<cr>
nnoremap <silent> <leader>om       :<c-u>Unite mapping<cr>
nnoremap <silent> <leader>oc       :<c-u>Unite command<cr>
nnoremap <silent> <leader>ow       :<c-u>Unite vimwiki<cr>
nnoremap <silent> <leader>ov       :<c-u>Unite file_rec/async:~/.vim<cr>

"
" Mappings and similar inside Unite buffers
"
function! s:unite_settings()
  let b:SuperTabDisabled=1
  nmap <buffer> q     <plug>(unite_exit)
  nmap <buffer> Q     <plug>(unite_exit)
  nmap <buffer> <esc> <plug>(unite_exit)
  imap <buffer> <esc> <plug>(unite_exit)
  imap <buffer> <c-j> <plug>(unite_select_next_line)
  imap <buffer> <c-k> <plug>(unite_select_previous_line)
  imap <buffer> <f5>  <plug>(unite_redraw)
endfunction
augroup unite
  autocmd!
  autocmd FileType unite call s:unite_settings()
augroup END

" }}}2
"{{{2 Screen
Plug 'ervandew/screen'
let g:ScreenImpl = 'Tmux'
let g:ScreenShellTerminal = 'urxvt'
let g:ScreenShellActive = 0

" Dynamic keybindings
function! s:ScreenShellListenerMain()
  if g:ScreenShellActive
    nnoremap <silent> <c-c><c-c> <s-v>:ScreenSend<cr>
    vnoremap <silent> <c-c><c-c> :ScreenSend<cr>
    nnoremap <silent> <c-c><c-a> :ScreenSend<cr>
    nnoremap <silent> <c-c><c-q> :ScreenQuit<cr>
    if exists(':C') != 2
      command -nargs=? C :call ScreenShellSend('<args>')
    endif
  else
    nnoremap <c-c><c-a> <nop>
    vnoremap <c-c><c-c> <nop>
    nnoremap <c-c><c-q> <nop>
    nnoremap <silent> <c-c><c-c> :ScreenShell<cr>
    if exists(':C') == 2
      delcommand C
    endif
  endif
endfunction

" Initialize and define auto group stuff
nnoremap <silent> <c-c><c-c> :ScreenShell<cr>
augroup ScreenShellEnter
  autocmd User * :call <sid>ScreenShellListenerMain()
augroup END
augroup ScreenShellExit
  autocmd User * :call <sid>ScreenShellListenerMain()
augroup END

" }}}2
" {{{2 Undotree
Plug 'mbbill/undotree', { 'on' : 'UndotreeToggle' }

let g:undotree_WindowLayout = 2
let g:undotree_SetFocusWhenToggle = 1

nnoremap <f5> :UndotreeToggle<cr>

" }}}2
"{{{2 vim-easy-align
Plug 'junegunn/vim-easy-align'
let g:easy_align_bypass_fold = 1

nmap ga <plug>(EasyAlign)
vmap ga <plug>(EasyAlign)
nmap gA <plug>(LiveEasyAlign)
vmap gA <plug>(LiveEasyAlign)
vmap .  <plug>(EasyAlignRepeat)

" }}}2
" {{{2 vim-sandwich
Plug 'machakann/vim-sandwich'

" Free 's', since it is used for sandwich mappings
nnoremap s <nop>
xnoremap s <nop>

" Allow repeats while keeping cursor fixed
nmap . <plug>(operator-sandwich-predot)<plug>(RepeatDot)

function! s:hooks.sandwhich()
  " Change some default options
  silent! call operator#sandwich#set('delete', 'all', 'highlight', 0)
  silent! call operator#sandwich#set('all', 'all', 'cursor', 'keep')

  " Set custom highlighting
  hi OperatorSandwichBuns cterm=bold gui=bold ctermfg=5 guifg=Magenta

  " Default recipes
  let g:sandwich#recipes  = deepcopy(g:sandwich#default_recipes)
  let g:sandwich#recipes += [
        \ {
        \   'buns' : ['{\s*', '\s*}'],
        \   'input' : ['}'],
        \   'kind' : ['delete', 'replace', 'auto', 'query'],
        \   'regex' : 1,
        \   'nesting' : 1,
        \   'match_syntax' : 1,
        \   'skip_break' : 1,
        \   'indentkeys-' : '{,},0{,0}' 
        \ },
        \ {
        \   'buns' : ['\[\s*', '\s*\]'],
        \   'input' : [']'],
        \   'kind' : ['delete', 'replace', 'auto', 'query'],
        \   'regex' : 1,
        \   'nesting' : 1,
        \   'match_syntax' : 1,
        \   'indentkeys-' : '[,]' 
        \ },
        \ {
        \   'buns' : ['(\s*', '\s*)'],
        \   'input' : [')'],
        \   'kind' : ['delete', 'replace', 'auto', 'query'],
        \   'regex' : 1,
        \   'nesting' : 1,
        \   'match_syntax' : 1,
        \   'indentkeys-' : '(,)' 
        \ },
        \]

  " Vim recipes
  let g:sandwich#recipes += [
        \ {
        \   'buns'        : ["'", "'"],
        \   'skip_regex'  : ["[^']\\%(''\\)*\\%#\\zs''",
        \                    "[^']\\%(''\\)*'\\%#\\zs'"],
        \   'filetype'    : ['vim'],
        \   'nesting'     : 0,
        \   'match_syntax': 2,
        \ }
        \]

  " Python recipes
  let g:sandwich#recipes += [
        \   {'filetype': ['python'], 'input': ["3'"], 'buns': ["'''", "'''"], 'nesting': 0 },
        \   {'filetype': ['python'], 'input': ['3"'], 'buns': ['"""', '"""'], 'nesting': 0 },
        \ ]

  " LaTeX recipes
  let g:sandwich#recipes += [
        \   {'filetype': ['tex'], 'input': ['l"'], 'buns': ['``',            "''"],             'nesting': 1 },
        \   {'filetype': ['tex'], 'input': ['l{'], 'buns': ['\{',            '\}'],             'nesting': 1, 'indentkeys-' : '{,},0{,0}' },
        \   {'filetype': ['tex'], 'input': ['m('], 'buns': ['\left(',        '\right)'],        'nesting': 1, 'indentkeys-' : '(,)' },
        \   {'filetype': ['tex'], 'input': ['m['], 'buns': ['\left[',        '\right]'],        'nesting': 1, 'indentkeys-' : '[,]' },
        \   {'filetype': ['tex'], 'input': ['m|'], 'buns': ['\left|',        '\right|'],        'nesting': 1 },
        \   {'filetype': ['tex'], 'input': ['m{'], 'buns': ['\left\{',       '\right\}'],       'nesting': 1, 'indentkeys-' : '{,},0{,0}' },
        \   {'filetype': ['tex'], 'input': ['m<'], 'buns': ['\left\langle ', '\right\rangle '], 'nesting': 1 },
        \ ]
endfunction

" }}}2

" Local filetype plugins
Plug '~/.vim/bundle_local/dagbok'
Plug '~/.vim/bundle_local/lisp'

" Local plugins
Plug '~/.vim/bundle_local/speeddating'
Plug '~/.vim/bundle_local/syntaxcomplete'

call plug#end()
endif

"{{{1 General options

"{{{2 Basic options
set history=10000
set confirm
set winaltkeys=no
set ruler
set lazyredraw
set mouse=
set hidden
set modelines=5
set tags=tags;~,.tags;~
set fillchars=vert:│,fold:\ ,diff:⣿
set diffopt=filler,foldcolumn:0,context:4
if has('gui_running')
  set diffopt=filler,foldcolumn:0,context:4,vertical
else
  set diffopt=filler,foldcolumn:0,context:4,horizontal
endif
set matchtime=2
set matchpairs+=<:>
set showcmd
set backspace=indent,eol,start
set autoindent
set fileformat=unix
set list
set listchars=tab:▸\ ,nbsp:%,extends:,precedes:
set cursorline
set autochdir
set cpoptions+=J
set autoread
set wildmenu
set wildmode=longest,list:longest,full
set wildignore=*.o,*~,*.pyc,.git/*,.hg/*,.svn/*,*.DS_Store,CVS/*,*.mod
set shortmess=aoOtT
silent! set shortmess+=cI
set splitbelow
set splitright
set previewheight=20
set nrformats-=octal
set nostartofline
if has('patch-7.4.399')
  set cryptmethod=blowfish2
else
  set cryptmethod=blowfish
endif
set path=.,**
set scrolloff=10

" Turn off all bells on terminal vim (necessary for vim through putty)
if !has('gui_running')
  set visualbell
  set t_vb=
endif

if executable('ack-grep')
  set grepprg=ack-grep\ --nocolor
endif

"{{{2 Folding
if &foldmethod ==# ''
  set foldmethod=syntax
endif
set foldlevel=0
set foldcolumn=0
set foldtext=TxtFoldText()

function! TxtFoldText()
  let level = repeat('-', min([v:foldlevel-1,3])) . '+'
  let title = substitute(getline(v:foldstart), '{\{3}\d\?\s*', '', '')
  let title = substitute(title, '^["#! ]\+', '', '')
  return printf('%-4s %-s', level, title)
endfunction

" Set foldoption for bash scripts
let g:sh_fold_enabled=7

" Navigate folds
nnoremap zf zMzvzz
nnoremap zj zcjzvzz
nnoremap zk zckzvzz

"{{{2 Tabs, spaces, wrapping
set tabstop=2
set softtabstop=2
set shiftwidth=2
set textwidth=79
set columns=80
set smarttab
set expandtab
set nowrap
set linebreak
set breakindent
set formatoptions+=rnl1j
set formatlistpat=^\\s*\\(\\(\\d\\+\\\|[a-z]\\)[.:)]\\\|[-*]\\)\\s\\+

"{{{2 Backup and Undofile
set noswapfile
set nobackup

" Sets undo file directory
if v:version >= 703
  set undofile
  set undolevels=1000
  set undoreload=10000
  if has('unix')
    set undodir=$HOME/.vim/undofiles
  elseif has('win32')
    set undodir=$VIM/undofiles
  endif
  if !isdirectory(&undodir)
    call mkdir(&undodir)
  endif
end

"{{{2 Searching and movement
set ignorecase
set smartcase
set infercase
set incsearch
set showmatch

set display+=lastline
set virtualedit+=block

runtime macros/matchit.vim

noremap j gj
noremap k gk
"}}}2

"{{{1 Completion and dictionaries/spell settings

set complete+=U,s,k,kspell,d,]
set completeopt=longest,menu,preview

" Spell check options
set spelllang=en_gb
set spellfile+=~/.vim/spell/mywords.latin1.add
set spellfile+=~/.vim/spell/mywords.utf-8.add

" Add simple switch for spell languages
let g:spell_list = ['nospell', 'en_gb', 'nn', 'nb']
function! LoopSpellLanguage()
  if !exists('b:spell_nr') | let b:spell_nr = 0 | endif
  let b:spell_nr += 1
  if b:spell_nr >= len(g:spell_list) | let b:spell_nr = 0 | endif
  if b:spell_nr == 0
    setlocal nospell
    echo 'Spell off'
  else
    let &l:spelllang = g:spell_list[b:spell_nr]
    setlocal spell
    echo 'Spell language:' g:spell_list[b:spell_nr]
  endif
endfunction
nnoremap <silent> <F6> :<c-u>call LoopSpellLanguage()<cr>

"{{{1 Customize UI

set laststatus=2
set background=dark
set winwidth=70
set noshowmode
if has('gui_running')
  set lines=50
  set columns=82
  set guifont=Inconsolata-g\ for\ Powerline\ Medium\ 10
  set guioptions=ac
  set guiheadroom=0
  set background=light
endif

if &t_Co == 8 && $TERM !~# '^linux'
  set t_Co=256
endif

silent! colorscheme solarized

" GUI cursor
highlight iCursor guibg=#b58900
highlight rCursor guibg=#dc322f
highlight vCursor guibg=#d33682
set guicursor=a:block
set guicursor+=n:Cursor
set guicursor+=o-c:iCursor
set guicursor+=v:vCursor
set guicursor+=i-ci-sm:ver30-iCursor
set guicursor+=r-cr:hor20-rCursor
set guicursor+=a:blinkon0

" Terminal cursor
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
else
  let &t_SI = "\e[5 q"
  let &t_EI = "\e[2 q"
endif

hi clear
      \ MatchParen
      \ Search
      \ SpellBad
      \ SpellCap
      \ SpellRare
      \ SpellLocal

hi MatchParen cterm=bold           gui=bold           ctermfg=33  guifg=Blue
hi Search     cterm=bold,underline gui=bold,underline ctermfg=201 guifg=Magenta
hi SpellBad   cterm=bold           gui=bold           ctermfg=124 guifg=Red
hi SpellCap   cterm=bold           gui=bold           ctermfg=33  guifg=Blue
hi SpellRare  cterm=bold           gui=bold           ctermfg=104 guifg=Purple
hi SpellLocal cterm=bold           gui=bold           ctermfg=227 guifg=Green
hi VertSplit  ctermbg=NONE guibg=NONE

"
" Initialize statusline and tabline
"
call statusline#init()
call statusline#init_tabline()

"{{{1 Autocommands

augroup vimrc_autocommands
  autocmd!

  " Only use cursorline for current window
  autocmd WinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline

  " When editing a file, always jump to the last known cursor position.  Don't
  " do it when the position is invalid or when inside an event handler (happens
  " when dropping a file on gvim).
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

  " Set omnifunction if it is not already specified
  autocmd Filetype *
        \ if &omnifunc == "" |
        \   setlocal omnifunc=syntaxcomplete#Complete |
        \ endif
augroup END

"{{{1 Custom key mappings

"
" Available for mapping
"
"   Q
"   U
"   gs
"   CTRL-H
"   CTRL-J
"

noremap  <f1>   <nop>
inoremap <f1>   <nop>
inoremap <esc>  <nop>
inoremap jk     <esc>
nnoremap Q      <nop>
nnoremap -      <C-^>
nnoremap Y      y$
nnoremap J      mzJ`z
nnoremap dp     dp]c
nnoremap do     do]c
nnoremap <silent> <c-u> :Bdelete<cr>
nnoremap <silent> gb    :bnext<cr>
nnoremap <silent> gB    :bprevious<cr>

" Backspace and return for improved navigation
nnoremap        <bs> <c-o>zvzz
nnoremap <expr> <cr> empty(&buftype) ? '<c-]>zvzz' : '<cr>'

" Shortcuts for some files
nnoremap <leader>ev :e ~/.vim/vimrc<cr>
nnoremap <leader>ez :e ~/.dotfiles/zshrc<cr>

" Make it possible to save as sudo
cnoremap w!! w !sudo tee % >/dev/null

" }}}1
" {{{1 Plugin hooks

for key in keys(s:hooks)
  call s:hooks[key]()
endfor

" }}}1

" vim: fdm=marker
