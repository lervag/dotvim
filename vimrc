scriptencoding utf8

"{{{1 Load plugins

silent! if plug#begin('~/.vim/bundle')

" {{{2 VimPlug
Plug 'junegunn/vim-plug', { 'on' : [] }
let g:plug_window = 'tab new'

nnoremap <silent> <space>pd :PlugDiff<cr>
nnoremap <silent> <space>pi :PlugInstall<cr>
nnoremap <silent> <space>pu :PlugUpdate<cr>
nnoremap <silent> <space>ps :PlugStatus<cr>
nnoremap <silent> <space>pc :PlugClean<cr>
" }}}2

" User interface
Plug 'altercation/vim-colors-solarized'
Plug 'drmikehenry/vim-fontsize'
Plug 'moll/vim-bbye', { 'on' : 'Bdelete' }
" {{{2 Airline
Plug 'bling/vim-airline'
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_section_z = '%3p%% %l:%c'
let g:airline_mode_map = {
      \ '__' : '-',
      \ 'n'  : 'N',
      \ 'i'  : 'I',
      \ 'R'  : 'R',
      \ 'c'  : 'C',
      \ 'v'  : 'V',
      \ 'V'  : 'V',
      \ '' : 'V',
      \ 's'  : 'S',
      \ 'S'  : 'S',
      \ '' : 'S',
      \ }

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.crypt = 'decrypted'

let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" }}}2
" {{{2 Goyo
Plug 'junegunn/goyo.vim', { 'on' : 'Goyo' }
let g:goyo_height = 100
let g:goyo_width = 82

map <F8> :Goyo<cr>

augroup vimrc_goyo
  autocmd!
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
augroup END

function! s:goyo_enter() " {{{3
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd vimrc_goyo QuitPre <buffer> let b:quitting = 1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!

  call fontsize#inc()
  call fontsize#inc()
  set columns+=8
  vertical resize 82
endfunction " }}}3
function! s:goyo_leave() " {{{3
  if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif

  call fontsize#default()
  set columns-=8
endfunction " }}}3

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

" General motions
Plug 'guns/vim-sexp'
" {{{2 Incsearch
Plug 'haya14busa/incsearch.vim'
let g:incsearch#auto_nohlsearch = 1
let g:incsearch#separate_highlight = 1

set hlsearch
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

" Use <c-l> to clear the highlighting of :set hlsearch.
if maparg('<c-l>', 'n') ==# ''
  nnoremap <silent> <c-l> :nohlsearch<cr><c-l>
endif

"
" Highlight options are defined under "Customize UI" (see below)
"

" }}}2
" {{{2 Smalls
Plug 't9md/vim-smalls'

nmap <c-s> <plug>(smalls)
xmap <c-s> <plug>(smalls)
omap <c-s> <plug>(smalls)

" }}}2

" General programming
Plug 'tpope/vim-commentary'
" {{{2 Fugitive, gitv, Lawrencium, etc...
Plug 'tpope/vim-fugitive'
Plug 'gregsexton/gitv'

let g:Gitv_OpenHorizontal = 1

nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gc :Gcommit<cr>
nnoremap <leader>gd :Gdiff<cr>:ResizeSplits<cr>
nnoremap <leader>gl :Gitv<cr>
nnoremap <leader>gL :Gitv!<cr>

Plug 'ludovicchabant/vim-lawrencium'
nnoremap <leader>hs :Hgstatus<cr>
nnoremap <leader>hd :Hgvdiff<cr>:ResizeSplits<cr>
nnoremap <leader>hl :Hglog<cr>
nnoremap <leader>hL :Hglogthis<cr>

" }}}
" {{{2 Gutentags
Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_tagfile = '.tags'

" }}}2
"{{{2 Quickrun
Plug 'thinca/vim-quickrun'
let g:quickrun_config = {}
let g:quickrun_config._ = {
      \ 'outputter/buffer/close_on_empty' : 1
      \ }

map <space>r <plug>(quickrun-op)

" }}}2
"{{{2 Splice
Plug 'sjl/splice.vim'
let g:splice_initial_mode = 'grid'
let g:splice_initial_layout_grid = 1
let g:splice_initial_diff_grid = 1

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
let g:syntastic_python_checkers = ['pylint']

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

let g:vebugger_leader = '\v'

" }}}

" Completion and snippets
"{{{2 Neocomplete
Plug 'Shougo/neocomplete'
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_camel_case = 1
let g:neocomplete#enable_auto_delimiter = 1
let g:neocomplete#enable_refresh_always = 1

" Plugin key-mappings
inoremap <expr><c-g> neocomplete#undo_completion()
inoremap <expr><c-l> neocomplete#complete_common_string()

" Define omni patterns
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.vimwiki = '#\S*'

if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.vimwiki =
      \ '\[\[[^\]]*\|[[.\{-}#\S*'
let g:neocomplete#sources#omni#input_patterns.tex =
      \ '\v\\\a*(ref|cite)\a*([^]]*\])?\{([^}]*,)*[^}]*'

" Define keyword patterns
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns._       = '[a-åA-Å][a-åA-Å0-9]\+'
let g:neocomplete#keyword_patterns.tex     = '[a-åA-Å][a-åA-Å0-9]\+'
let g:neocomplete#keyword_patterns.vimwiki = '[a-åA-Å][a-åA-Å0-9]\+'

" {{{2 Supertab
Plug 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextDefaultCompletionType = '<c-x><c-o>'
let g:SuperTabRetainCompletionDuration = 'session'
let g:SuperTabLongestEnhanced = 1
let g:SuperTabCrMapping = 0

augroup vimrc_supertab
  autocmd!
  autocmd FileType fortran call SuperTabSetDefaultCompletionType('<c-n>')
  autocmd FileType text    call SuperTabSetDefaultCompletionType('<c-n>')
augroup END

" }}}2
"{{{2 Ultisnips
Plug 'SirVer/ultisnips'
let g:UltiSnipsJumpForwardTrigger='<m-u>'
let g:UltiSnipsJumpBackwardTrigger='<s-m-u>'
let g:UltiSnipsEditSplit = 'horizontal'
let g:UltiSnipsSnippetsDir = '~/.vim/bundle_local/UltiSnips/UltiSnips'
map <leader>es :UltiSnipsEdit!<cr>

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

let g:tex_stylish = 1
let g:tex_flavor = 'latex'
let g:tex_isk='48-57,a-z,A-Z,192-255,:'

" Custom mappings
augroup vimrc_latex
  autocmd!
  autocmd FileType tex inoremap <silent><buffer> <m-i> \item<space>
augroup END

" }}}2
" {{{2 Pandoc (including Markdown)
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

let g:pandoc#folding#level = 9
let g:pandoc#folding#fdc = 0
let g:pandoc#formatting#mode = 'h'
let g:pandoc#toc#position = 'top'
let g:pandoc#modules#disabled = ['spell']

map <silent><leader>pp :Pandoc! #sintefpres<cr>

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
Plug 'bogado/file-line'
Plug 'Shougo/vimproc', { 'do' : 'make -f make_unix.mak' }
Plug 'thinca/vim-prettyprint'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
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

nnoremap <space>a :Ack 

" }}}2
" {{{2 Calendar
Plug 'itchyny/calendar.vim'
let g:calendar_first_day = 'monday'
let g:calendar_date_endian = 'big'
let g:calendar_frame = 'space'
let g:calendar_week_number = 1

nnoremap <silent> <localleader>cal :Calendar -position=below<cr>

" Connect to diary
augroup vimrc_calendar
  autocmd!
  autocmd FileType calendar 
        \ nmap <silent><buffer> <cr> :<c-u>call OpenDiary()<cr>
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
"{{{2 CtrlP
Plug 'kien/ctrlp.vim'
let g:ctrlp_custom_ignore = {}
let g:ctrlp_custom_ignore.dir =
      \ '\vCVS|\.(git|hg|vim\/undofiles|vim\/backup)$'
let g:ctrlp_custom_ignore.file =
      \ '\v\.(aux|pdf|gz|wiki)$'
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_map = ''
let g:ctrlp_match_window = 'top,order:ttb,max:25'
let g:ctrlp_mruf_exclude  = '\v\.(pdf|aux|bbl|blg|wiki)$'
let g:ctrlp_mruf_exclude .= '|share\/vim.*doc\/'
let g:ctrlp_mruf_exclude .= '|\/\.git\/'
let g:ctrlp_mruf_exclude .= '|journal\.txt$'
let g:ctrlp_mruf_exclude .= '|^\/tmp'
let g:ctrlp_root_markers = ['CVS']
let g:ctrlp_show_hidden = 0
let g:ctrlp_extensions = ['tag']

nnoremap <silent> <space><space> :CtrlPMRUFiles<cr>
nnoremap <silent> <space>oo :CtrlP<cr>
nnoremap <silent> <space>oh :CtrlP /home/lervag<cr>
nnoremap <silent> <space>ov :CtrlP /home/lervag/.vim<cr>
nnoremap <silent> <space>t :CtrlPTag<cr>
nnoremap <silent> <space>b :CtrlPBuffer<cr>

" Add some extensions
Plug '~/.vim/bundle_local/ctrlp'
nnoremap <space>w :CtrlPVimwiki<cr>
nnoremap <space>h :CtrlPHelp<cr>

" }}}2
"{{{2 Screen
Plug 'ervandew/screen'
let g:ScreenImpl = 'GnuScreen'
let g:ScreenShellTerminal = 'urxvt'
let g:ScreenShellActive = 0

" Dynamic keybindings
function! s:ScreenShellListenerMain()
  if g:ScreenShellActive
    nmap <silent> <C-c><C-c> <S-v>:ScreenSend<CR>
    vmap <silent> <C-c><C-c> :ScreenSend<CR>
    nmap <silent> <C-c><C-a> :ScreenSend<CR>
    nmap <silent> <C-c><C-q> :ScreenQuit<CR>
    if exists(':C') != 2
      command -nargs=? C :call ScreenShellSend('<args>')
    endif
  else
    nmap <C-c><C-a> <Nop>
    vmap <C-c><C-c> <Nop>
    nmap <C-c><C-q> <Nop>
    nmap <silent> <C-c><C-c> :ScreenShell<cr>
    if exists(':C') == 2
      delcommand C
    endif
  endif
endfunction

" Initialize and define auto group stuff
nmap <silent> <C-c><C-c> :ScreenShell<cr>
augroup ScreenShellEnter
  au USER * :call <SID>ScreenShellListenerMain()
augroup END
augroup ScreenShellExit
  au USER * :call <SID>ScreenShellListenerMain()
augroup END

" }}}2
" {{{2 Undotree
Plug 'mbbill/undotree', { 'on' : 'UndotreeToggle' }

let g:undotree_WindowLayout = 2
let g:undotree_SetFocusWhenToggle = 1

nnoremap <f5> :UndotreeToggle<cr>

" }}}2
" {{{2 vim-online-thesaurus
Plug 'beloglazov/vim-online-thesaurus'
let g:online_thesaurus_map_keys = 0
nnoremap <c-K> :OnlineThesaurusCurrentWord<CR>

" }}}2
"{{{2 vim-easy-align
Plug 'junegunn/vim-easy-align'
let g:easy_align_bypass_fold = 1
map ga <Plug>(EasyAlign)
map gA <Plug>(LiveEasyAlign)
vmap . <Plug>(EasyAlignRepeat)

" }}}2

" Local filetype plugins
Plug '~/.vim/bundle_local/dagbok'
Plug '~/.vim/bundle_local/fortran'
Plug '~/.vim/bundle_local/help'
Plug '~/.vim/bundle_local/lisp'
Plug '~/.vim/bundle_local/make'
Plug '~/.vim/bundle_local/markdown'
Plug '~/.vim/bundle_local/python'
Plug '~/.vim/bundle_local/ruby'
Plug '~/.vim/bundle_local/tex'
Plug '~/.vim/bundle_local/text'
Plug '~/.vim/bundle_local/vim'
Plug '~/.vim/bundle_local/quickfix'

" Local plugins
Plug '~/.vim/bundle_local/UltiSnips'
Plug '~/.vim/bundle_local/resize_splits'
Plug '~/.vim/bundle_local/speeddating'
Plug '~/.vim/bundle_local/syntaxcomplete'
Plug '~/.vim/bundle_local/text-object-indent'
Plug '~/.vim/bundle_local/toggle-verbose'
Plug '~/.vim/bundle_local/man-wrapper'
Plug '~/.vim/bundle_local/open-in-browser'

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
if has('gui_running')
  set diffopt=filler,foldcolumn:0,context:4,vertical
else
  set diffopt=filler,foldcolumn:0,context:4
endif
set matchtime=2
set matchpairs+=<:>
set showcmd
set backspace=indent,eol,start
set autoindent
set fileformat=unix
set list
set listchars=tab:▸\ ,nbsp:%,extends:,precedes:
set cursorline
set autochdir
set cpoptions+=J
set autoread
set wildmenu
set wildmode=longest,list:longest,full
set wildignore=*.o,*~,*.pyc,.git/*,.hg/*,.svn/*,*.DS_Store,CVS/*
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
nnoremap <space> za
vnoremap <space> za

"{{{2 Tabs, spaces, wrapping
set softtabstop=2
set shiftwidth=2
set textwidth=79
set columns=80
if v:version >= 703
  execute 'set colorcolumn=' . join(range(81,335), ',')
end
set smarttab
set expandtab
set nowrap
set linebreak
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
nmap <silent> <F6> :<c-u>call LoopSpellLanguage()<cr>
imap <silent> <F6> <c-o>:call LoopSpellLanguage()<cr>

"{{{1 Customize UI

set laststatus=2
set background=dark
if has('gui_running')
  set lines=50
  set columns=82
  set guifont=Inconsolata-g\ Medium\ 10
  set guioptions=ac
  set guiheadroom=0
  set background=light
endif

if &t_Co == 8 && $TERM !~# '^linux'
  set t_Co=16
endif

silent! colorscheme solarized

if has('gui_running')
  highlight iCursor guibg=#b58900
  highlight rCursor guibg=#dc322f
  highlight vCursor guibg=#d33682
  set guicursor+=n-c:blinkon0-block-Cursor
  set guicursor+=o:blinkon0-hor50-Cursor
  set guicursor+=v:blinkon0-block-vCursor
  set guicursor+=i:blinkon0-ver20-iCursor
  set guicursor+=r:blinkon0-hor20-rCursor
endif

highlight VertSplit ctermbg=NONE guibg=NONE

highlight clear
      \ MatchParen
      \ Search
      \ SpellBad
      \ SpellCap
      \ SpellRare
      \ SpellLocal

highlight MatchParen term=bold cterm=bold gui=bold ctermfg=33  guifg=Blue
highlight SpellBad   term=bold cterm=bold gui=bold ctermfg=124 guifg=Red
highlight SpellCap   term=bold cterm=bold gui=bold ctermfg=33  guifg=Blue
highlight SpellRare  term=bold cterm=bold gui=bold ctermfg=104 guifg=Purple
highlight SpellLocal term=bold cterm=bold gui=bold ctermfg=227 guifg=Yellow

highlight Search
      \ term=bold,underline cterm=bold,underline gui=bold,underline
      \ ctermfg=201 guifg=Magenta
highlight IncSearchMatch
      \ term=bold,underline cterm=bold,underline gui=bold,underline
      \ ctermfg=201 guifg=Magenta
highlight IncSearchMatchReverse
      \ term=bold,underline cterm=bold,underline gui=bold,underline
      \ ctermfg=127 guifg=LightMagenta
highlight IncSearchOnCursor
      \ term=bold,underline cterm=bold,underline gui=bold,underline
      \ ctermfg=39 guifg=#00afff
highlight IncSearchCursor
      \ term=bold,underline cterm=bold,underline gui=bold,underline
      \ ctermfg=39 guifg=#00afff

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

noremap  <f1>   <nop>
inoremap <f1>   <nop>
inoremap <esc>  <nop>
inoremap jk     <esc>
nnoremap -      <C-^>
nnoremap Y      y$
nnoremap J      mzJ`z
nnoremap dp     dp]c
nnoremap do     do]c
nnoremap <silent> <c-u> :Bdelete<cr>:ResizeSplits<cr>
nnoremap <silent> gb    :bnext<cr>
nnoremap <silent> gB    :bprevious<cr>

" Shortcuts for some files
map <leader>ev :e ~/.vim/vimrc<cr>
map <leader>ez :e ~/.dotfiles/zshrc<cr>

" Make it possible to save as sudo
cmap w!! %!sudo tee > /dev/null %

" sudo to write
cnoremap w!! w !sudo tee % >/dev/null

" }}}1

" vim: fdm=marker
