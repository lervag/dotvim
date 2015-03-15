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

"
" A collection of interesting plugins that I want to check out when I get the
" time for it.
"
" Plug 'xolox/vim-easytags'
" Plug 'kana/vim-operator-user'

" User interface
Plug 'altercation/vim-colors-solarized'
Plug 'drmikehenry/vim-fontsize'
Plug 'moll/vim-bbye', { 'on': 'Bdelete' }
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

let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#tabline#tab_min_count = 1
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#excludes = ['thesaurus']

" }}}2
" {{{2 Goyo
Plug 'junegunn/goyo.vim',
      \ { 'on' : 'Goyo' }
let g:goyo_margin_top = 0
let g:goyo_margin_bottom = 0

map <F8> :Goyo<cr>

autocmd! User GoyoEnter
autocmd  User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave
autocmd  User GoyoLeave nested call <SID>goyo_leave()

function! s:goyo_enter() " {{{3
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd QuitPre <buffer> let b:quitting = 1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!

  call fontsize#inc()
  call fontsize#inc()
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
endfunction " }}}3

" }}}2
" {{{2 Rainbox Parentheses
Plug 'kien/rainbow_parentheses.vim'
nnoremap <leader>R :RainbowParenthesesToggle<cr>
let g:rbpt_max = 14
let g:rbpt_colorpairs = [
      \ ['033', '#268bd2'],
      \ ['037', '#2aa198'],
      \ ['061', '#6c71c4'],
      \ ['064', '#859900'],
      \ ['125', '#d33682'],
      \ ['136', '#b58900'],
      \ ['160', '#dc322f'],
      \ ['166', '#cb4b16'],
      \ ['234', '#002b36'],
      \ ['235', '#073642'],
      \ ['240', '#586e75'],
      \ ['241', '#657b83'],
      \ ['244', '#839496'],
      \ ['245', '#93a1a1'],
      \ ]

augroup RainbowParens
  au!
  au VimEnter * RainbowParenthesesToggle
  au Syntax * RainbowParenthesesLoadRound
augroup END

" }}}2

" General motions
Plug 'coderifous/textobj-word-column.vim'
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
" {{{2 Fugitive and gitv
Plug 'tpope/vim-fugitive'
Plug 'gregsexton/gitv'

let g:Gitv_OpenHorizontal = 1

nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gc :Gcommit<cr>
nnoremap <leader>gd :Gdiff<cr>:ResizeSplits<cr>
nnoremap <leader>gl :Gitv<cr>
nnoremap <leader>gL :Gitv!<cr>

" }}}2
" {{{2 Lawrencium
Plug 'ludovicchabant/vim-lawrencium'
nnoremap <leader>hs :Hgstatus<cr>
nnoremap <leader>hd :Hgvdiff<cr>:ResizeSplits<cr>

" }}}
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
let g:splice_initial_mode = "grid"
let g:splice_initial_layout_grid = 1
let g:splice_initial_diff_grid = 1

" }}}2
" {{{2 Syntactics
Plug 'scrooloose/syntastic',
      \ { 'for' : ['f90'] }
let g:syntastic_always_populate_loc_list=1
let g:syntastic_aggregate_errors = 1
" let g:syntastic_error_symbol='E'
" let g:syntastic_warning_symbol='W'
" let g:syntastic_style_error_symbol='SE'
" let g:syntastic_style_warning_symbol='SW'

" Disable for LaTeX
let g:syntastic_mode_map = {
      \ 'mode':              'active',
      \ 'passive_filetypes': ['tex'],
      \ }

" Fortran settings
let g:syntastic_fortran_compiler_options = " -fdefault-real-8"
let g:syntastic_fortran_include_dirs = [
                            \ '../obj/gfortran_debug',
                            \ '../objects/debug_gfortran',
                            \ '../thermopack/objects/debug_gfortran_Linux',
                            \ ]

" Some mappings
nmap ,sc :SyntasticCheck<cr>
nmap ,si :SyntasticInfo<cr>
nmap ,st :SyntasticToggleMode<cr>

" }}}2
" {{{2 Vebugger
Plug 'idanarye/vim-vebugger'

let g:vebugger_leader = '\v'

" }}}
" {{{2 VCSCommand
Plug 'git://repo.or.cz/vcscommand.git'
let g:VCSCommandSplit = 'vertical'
nnoremap <leader>vs :VCSStatus<cr>
nnoremap <leader>vc :VCSCommit<cr>
nnoremap <leader>vd :VCSDiff<cr>
nnoremap <leader>vD :VCSVimDiff<cr>

" }}}

" Completion and snippets
Plug 'honza/vim-snippets'
"{{{2 Neocomplete
Plug 'Shougo/neocomplete'
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_camel_case = 1
let g:neocomplete#enable_auto_delimiter = 1
let g:neocomplete#enable_refresh_always = 1
let g:neocomplete#enable_omni_fallback = 1

" Plugin key-mappings
inoremap <expr> <C-l> neocomplete#complete_common_string()

" Enable omni completion
augroup neocomplete_omni_complete
  autocmd!
  autocmd FileType css        setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html       setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType markdown   setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType xml        setlocal omnifunc=xmlcomplete#CompleteTags
augroup END

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
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
let g:SuperTabRetainCompletionDuration = "session"
let g:SuperTabLongestEnhanced = 1
let g:SuperTabCrMapping = 0

augroup Supertab
  autocmd!
  autocmd FileType fortran call SuperTabSetDefaultCompletionType("<c-n>")
  autocmd FileType text    call SuperTabSetDefaultCompletionType("<c-n>")
augroup END

" }}}2
"{{{2 Ultisnips
Plug 'SirVer/ultisnips'
let g:UltiSnipsJumpForwardTrigger="<m-u>"
let g:UltiSnipsJumpBackwardTrigger="<s-m-u>"
let g:UltiSnipsEditSplit = "horizontal"
let g:UltiSnipsSnippetsDir = "~/.vim/bundle_local/UltiSnips/UltiSnips"
map <leader>es :UltiSnipsEdit!<cr>

" }}}2

" Filetype specific
Plug 'chrisbra/csv.vim', { 'for': 'csv' }
Plug 'darvelo/vim-systemd', { 'for': [ 'systemd', 'udev' ] }
Plug 'whatyouhide/vim-tmux-syntax', { 'for': 'tmux-conf' }
" {{{2 HTML, XML, ...
Plug 'gregsexton/MatchTag'

" }}}2
" {{{2 LaTeX
Plug 'git@github.com:lervag/vimtex.git', { 'for' : 'tex' }
let g:vimtex_fold_automatic = 0
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_toc_resize = 0
let g:vimtex_toc_split_pos = 'below'
let g:vimtex_view_method = 'zathura'
let g:vimtex_view_mupdf_send_keys = 'H'

let g:tex_isk='48-57,a-z,A-Z,192-255,:'

" Custom mappings
augroup latex_settings
  autocmd!
  autocmd FileType tex inoremap <silent><buffer> <m-i> \item<space>
augroup END

" }}}2
" {{{2 Pandoc (including Markdown)
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

let g:pandoc#folding#level = 9
let g:pandoc#folding#fdc = 0
let g:pandoc#formatting = "h"
let g:pandoc#spell#enabled = 0
let g:pandoc#toc#position = "top"

" }}}2
" {{{2 Python
Plug 'mitsuhiko/vim-python-combined', { 'for': 'python' }
Plug 'jmcantrell/vim-virtualenv', { 'on': [ 'VirtualEnvActivate',
                                          \ 'VirtualEnvDeactivate',
                                          \ 'VirtualEnvList' ] }
Plug 'davidhalter/jedi-vim', { 'for': 'python' }

let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0

"}}}2
"{{{2 Ruby
Plug 'vim-ruby/vim-ruby', { 'for' : 'ruby' }
let g:ruby_fold=1

" }}}2
" {{{2 Vimwiki
Plug 'vimwiki/vimwiki',                     { 'branch' : 'dev' }
Plug '~/.vim/bundle_local/vimwiki-journal'

" Set up main wiki
let s:wiki = {}
let s:wiki.path = '~/documents/wiki'
let s:wiki.diary_rel_path = 'journal'
let s:wiki.list_margin = 0
let s:wiki.nested_syntaxes = {
      \ 'python' : 'python',
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
Plug 'tyru/capture.vim', { 'on': 'Capture' }
Plug 'xolox/vim-misc'
Plug 'xolox/vim-reload'
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
autocmd FileType calendar nmap <silent><buffer> <cr> :<c-u>call OpenDiary()<cr>
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
nnoremap <silent> <space>f :CtrlP /home/lervag<cr>
nnoremap <silent> <space>v :CtrlP /home/lervag/.vim<cr>
nnoremap <silent> <space>q :CtrlPQuickfix<cr>
nnoremap <silent> <space>t :CtrlPTag<cr>
nnoremap <silent> <space>b :CtrlPBuffer<cr>

" Add some extensions
Plug '~/.vim/bundle_local/ctrlp'
nnoremap <space>w :CtrlPVimwiki<cr>
nnoremap <space>h :CtrlPHelp<cr>

" }}}2
"{{{2 Screen
Plug 'ervandew/screen', { 'on' : 'ScreenShell' }
let g:ScreenImpl = "GnuScreen"
let g:ScreenShellTerminal = "xfce4-terminal"
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
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

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
Plug '~/.vim/bundle_local/dagbok',    { 'for' : 'dagbok' }
Plug '~/.vim/bundle_local/fortran',   { 'for' : 'fortran' }
Plug '~/.vim/bundle_local/help',      { 'for' : 'help' }
Plug '~/.vim/bundle_local/lisp',      { 'for' : 'lisp' }
Plug '~/.vim/bundle_local/make',      { 'for' : 'make' }
Plug '~/.vim/bundle_local/markdown',  { 'for' : 'markdown' }
Plug '~/.vim/bundle_local/python',    { 'for' : 'python' }
Plug '~/.vim/bundle_local/ruby',      { 'for' : 'ruby' }
Plug '~/.vim/bundle_local/tex',       { 'for' : 'tex' }
Plug '~/.vim/bundle_local/text',      { 'for' : 'text' }
Plug '~/.vim/bundle_local/vim',       { 'for' : 'vim' }
Plug '~/.vim/bundle_local/quickfix/', { 'for' : 'qf' }

" Local plugins
Plug '~/.vim/bundle_local/UltiSnips'
Plug '~/.vim/bundle_local/resize_splits'
Plug '~/.vim/bundle_local/speeddating'
Plug '~/.vim/bundle_local/syntaxcomplete'
Plug '~/.vim/bundle_local/text-object-indent'
Plug '~/.vim/bundle_local/toggle-verbose'
Plug '~/.vim/bundle_local/man-wrapper'
" {{{2 open-in-browser
Plug '~/.vim/bundle_local/open-in-browser',
      \ { 'on' : ['OpenInBrowser', '<plug>(open-in-browser)'] }

map <silent> gx <Plug>(open-in-browser)
" }}}2

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
set tags=./tags,./.tags,./../*/.tags,./../*/tags
set fillchars=fold:\ ,diff:⣿
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

" Turn off all bells on terminal vim (necessary for vim through putty)
if !has('gui_running')
  set visualbell
  set t_vb=
endif

if executable("ack-grep")
  set grepprg=ack-grep\ --nocolor
endif

"{{{2 Folding
if &foldmethod == ""
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
  execute "set colorcolumn=" . join(range(81,335), ',')
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
  if has("unix")
    set undodir=$HOME/.vim/undofiles
  elseif has("win32")
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
if has("gui_running")
  set lines=50
  set columns=82
  set guifont=Inconsolata-g\ Medium\ 10
  set guioptions=aeci
  set guiheadroom=0
  set background=light
endif

if &t_Co == 8 && $TERM !~# '^linux'
  set t_Co=16
endif

silent! colorscheme solarized

if has("gui_running")
  highlight iCursor guibg=#b58900
  highlight rCursor guibg=#dc322f
  highlight vCursor guibg=#d33682
  set guicursor+=n-c:blinkon0-block-Cursor
  set guicursor+=o:blinkon0-hor50-Cursor
  set guicursor+=v:blinkon0-block-vCursor
  set guicursor+=i:blinkon0-ver20-iCursor
  set guicursor+=r:blinkon0-hor20-rCursor
endif

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
