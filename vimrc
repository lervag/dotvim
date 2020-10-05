" Vim configuration
"
" Author: Karl Yngve Lervåg

call vimrc#init()

" {{{1 Load plugins

call plug#begin(g:vimrc#path_bundles)

Plug 'junegunn/vim-plug', {'on': []}

" My own plugins
call plug#(g:vimrc#path_lervag . 'vimtex')
call plug#(g:vimrc#path_lervag . 'file-line')
call plug#(g:vimrc#path_lervag . 'vim-foam')
call plug#(g:vimrc#path_lervag . 'vim-rmarkdown')
if g:vimrc#is_devhost
  call plug#(g:vimrc#path_lervag . 'wiki.vim')
  call plug#(g:vimrc#path_lervag . 'wiki-ft.vim')
  call plug#(g:vimrc#path_lervag . 'vim-sintef')
endif

" Plugin: UI
Plug 'Konfekt/FastFold'
Plug 'luochen1990/rainbow'
Plug 'andymass/vim-matchup'
Plug 'RRethy/vim-illuminate'

" Plugin: Completion and snippets
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Shougo/neco-vim'
Plug 'Shougo/neoinclude.vim'
Plug 'neoclide/coc-neco'
Plug 'jsfaint/coc-neoinclude'
Plug 'SirVer/ultisnips'

" Plugin: Text objects and similar
Plug 'wellle/targets.vim'
Plug 'machakann/vim-sandwich'

" Plugin: Finder, motions, and tags
Plug 'junegunn/fzf', {
      \ 'dir': '~/.fzf',
      \ 'do': './install --all --no-update-rc',
      \}
Plug 'junegunn/fzf.vim'
Plug 'pbogut/fzf-mru.vim'
if has('nvim') || v:version >= 800
  Plug 'ludovicchabant/vim-gutentags'
endif
Plug 'dyng/ctrlsf.vim'
Plug 'machakann/vim-columnmove'

" Plugin: Linting, debugging, and code runners
if has('nvim') || v:version >= 800
  Plug 'dense-analysis/ale'
endif
Plug 'idanarye/vim-vebugger', {'branch': 'develop'}
Plug 'sakhnik/nvim-gdb'

" Plugin: Editing
Plug 'junegunn/vim-easy-align'
Plug 'dhruvasagar/vim-table-mode'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'zirrostig/vim-schlepp'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'brianrodri/vim-sort-folds'

" Plugin: VCS
Plug 'rbong/vim-flog'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'rhysd/git-messenger.vim'
Plug 'ludovicchabant/vim-lawrencium'
Plug 'airblade/vim-rooter'

" Plugin: Tmux (incl. filetype)
Plug 'whatyouhide/vim-tmux-syntax'
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'

" Plugin: Various
Plug 'itchyny/calendar.vim'
Plug 'tweekmonster/helpful.vim'
Plug 'Shougo/vimproc', {'do': 'make -f make_unix.mak'}
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'tyru/capture.vim', {'on': 'Capture'}
Plug 'tpope/vim-unimpaired'
Plug 'cespare/vim-toml'
Plug 'chrisbra/Colorizer'
Plug 'RRethy/vim-hexokinase', {'do': 'make hexokinase'}

" Filetype: python
if has('nvim')
  Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
  Plug 'vim-python/python-syntax', {'on': []}
else
  Plug 'numirias/semshi', {'on': []}
  Plug 'vim-python/python-syntax'
endif
Plug 'kalekundert/vim-coiled-snake'  " Folding
Plug 'Vimjas/vim-python-pep8-indent' " Indents
Plug 'jeetsukumaran/vim-pythonsense' " Text objects and motions

" Filetype: vim
Plug 'tpope/vim-scriptease'

" Filetype: markdown
Plug 'plasticboy/vim-markdown'

" Filetype: various
Plug 'darvelo/vim-systemd'
Plug 'gregsexton/MatchTag'
Plug 'vim-ruby/vim-ruby'
Plug 'elzr/vim-json'
Plug 'gisraptor/vim-lilypond-integrator'
Plug 'https://gitlab.com/HiPhish/info.vim'
Plug 'tpope/vim-apathy'
Plug 'rust-lang/rust.vim'

call plug#end()

" }}}1

if g:vimrc#bootstrap | finish | endif

" {{{1 Autocommands

augroup vimrc_autocommands
  autocmd!

  " Specify some maps for filenames to filetypes
  autocmd BufNewFile,BufRead *pylintrc set filetype=cfg

  " Only use cursorline for current window, except when in diff mode
  autocmd WinEnter,FocusGained * if !&diff | setlocal cursorline | endif
  autocmd WinLeave,FocusLost   * if !&diff | setlocal nocursorline | endif
  autocmd OptionSet diff call personal#init#toggle_diff()

  " When editing a file, always jump to the last known cursor position.
  autocmd BufReadPost * call personal#init#go_to_last_known_position()

  " Set keymapping for command window
  autocmd CmdwinEnter * nnoremap <buffer> q     <c-c><c-c>
  autocmd CmdwinEnter * nnoremap <buffer> <c-f> <c-c>

  " Close preview after complete
  autocmd CompleteDone * if pumvisible() == 0 | silent! pclose | endif
augroup END

" {{{1 Options

" Vim specific options
if !has('nvim')
  set history=10000
  set nrformats-=octal
  if has('patch-7.4.399')
    set cryptmethod=blowfish2
  else
    set cryptmethod=blowfish
  endif
  set autoread
  set backspace=indent,eol,start
  set wildmenu
  set laststatus=2
  set autoindent
  set incsearch
  set viminfo='300,<100,s300,h
else
  set shada=!,'300,<100,s300,h
endif

" Neovim specific options
if has('nvim')
  set inccommand=nosplit
endif

" Basic
set tags=tags;~,.tags;~
set path=.,,
if &modifiable
  set fileformat=unix
endif
set wildignore=*.o
set wildignore+=*~
set wildignore+=*.pyc
set wildignore+=.git/*
set wildignore+=.hg/*
set wildignore+=.svn/*
set wildignore+=*.DS_Store
set wildignore+=CVS/*
set wildignore+=*.mod
set diffopt=filler,vertical,foldcolumn:0,context:4
if has('patch-8.1.360')
  set diffopt+=indent-heuristic,algorithm:histogram
  set diffopt+=hiddenoff
endif

" Backup, swap and undofile
set noswapfile
set undofile
set undodir=$HOME/.cache/vim/undo
set backup
set backupdir=$HOME/.cache/vim/backup
if !isdirectory(&undodir)
  call mkdir(&undodir, 'p')
endif
if !isdirectory(&backupdir)
  call mkdir(&backupdir, 'p')
endif

" Behaviour
set autochdir
set lazyredraw
set confirm
set hidden
set shortmess=aoOtT
silent! set shortmess+=cI
set textwidth=79
set nowrap
set linebreak
set comments=n:>
set nojoinspaces
set formatoptions+=ronl1j
set formatlistpat=^\\s*[-*]\\s\\+
set formatlistpat+=\\\|^\\s*(\\(\\d\\+\\\|[a-z]\\))\\s\\+
set formatlistpat+=\\\|^\\s*\\(\\d\\+\\\|[a-z]\\)[:).]\\s\\+
set winaltkeys=no
set mouse=
set gdefault
set updatetime=500

" Completion
set wildmode=longest:full,full
set wildcharm=<c-z>
set complete+=U,s,k,kspell,]
set completeopt=menuone
silent! set completeopt+=noinsert,noselect

" Presentation
set list
set listchars=tab:▸\ ,nbsp:␣,trail:\ ,extends:…,precedes:…
set fillchars=vert:│,fold:\ ,diff:⣿
set matchtime=2
set matchpairs+=<:>
if !&diff
  set cursorline
endif
set scrolloff=5
set splitbelow
set splitright
set previewheight=20
set noshowmode

if !has('gui_running')
  set visualbell
  set t_vb=
endif

" Folding
set foldlevelstart=0
set foldcolumn=0
set foldtext=personal#fold#foldtext()

" Indentation
set softtabstop=-1
set shiftwidth=2
set expandtab
set copyindent
set preserveindent
silent! set breakindent

" Searching and movement
set nostartofline
set ignorecase
set smartcase
set infercase
set showmatch
set tagcase=match

set display=lastline
set virtualedit=block

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
elseif executable('ack-grep')
  set grepprg=ack-grep\ --nocolor
endif

" Printing
set printexpr=PrintFile(v:fname_in)

function! PrintFile(fname)
  let l:pdf = a:fname . '.pdf'
  call system(printf('ps2pdf %s %s', a:fname, l:pdf))

  echohl ModeMsg
  let l:reply = input('View file before printing [y/N]? ')
  echohl None
  echon "\n"
  if l:reply =~# '^y'
    call system('mupdf ' . l:pdf)
  endif

  echohl ModeMsg
  let l:reply = input('Save file to $HOME [Y/n]? ')
  echohl None
  echon "\n"
  if empty(l:reply) || l:reply =~# '^n'
    call system(printf('cp %s ~/vim-hardcopy.pdf', l:pdf))
  endif

  echohl ModeMsg
  let l:reply = input('Send file to printer [y/N]? ')
  echohl None
  echon "\n"
  if l:reply =~# '^y'
    call system('lp ' . l:pdf)
    let l:error = v:shell_error
  else
    let l:error = 1
  endif

  call delete(a:fname)
  call delete(l:pdf)
  return l:error
endfunction

" {{{1 Appearance and UI

set winwidth=70
if has('termguicolors')
  set termguicolors
endif
silent! colorscheme my_solarized

call personal#init#cursor()
call personal#init#statusline()
call personal#init#tabline()

" {{{1 Mappings

"
" Available for mapping
"
"   Q
"   U
"   ctrl-s
"   ctrl-space
"

" Disable some mappings
noremap  <f1>   <nop>
inoremap <f1>   <nop>
inoremap <esc>  <nop>
nnoremap Q      <nop>

" Some general/standard remappings
inoremap jk     <esc>
nnoremap Y      y$
nnoremap J      mzJ`z
nnoremap dp     dp]c
nnoremap do     do]c
nnoremap '      `
nnoremap <c-e>       <c-^>
nnoremap <c-w><c-e>  <c-w><c-^>
nnoremap <c-p>  <c-i>
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
xnoremap <expr> j v:count ? 'j' : 'gj'
xnoremap <expr> k v:count ? 'k' : 'gk'
nnoremap gV     `[V`]

nnoremap <c-w>-     <c-w>s
nnoremap <c-w><bar> <c-w>v

" Buffer navigation
nnoremap <silent> gb    :bnext<cr>
nnoremap <silent> gB    :bprevious<cr>

" Navigate folds
nnoremap          zv zMzvzz
nnoremap <silent> zj zcjzOzz
nnoremap <silent> zk zckzOzz

" Backspace and return for improved navigation
nnoremap        <bs> <c-o>zvzz

" Shortcuts for some files
nnoremap <silent> <leader>ev :execute 'edit' resolve($MYVIMRC)<cr>
nnoremap <silent> <leader>xv :source $MYVIMRC<cr>
nnoremap <leader>ez :edit ~/.zshrc<cr>

xnoremap <silent><expr> ++ personal#visual_math#yank_and_analyse()
nmap     <silent>       ++ vip++<esc>

nnoremap <leader>pp :hardcopy<cr>
xnoremap <leader>pp :hardcopy<cr>

" Terminal mappings
tnoremap <esc> <c-\><c-n>
if has('nvim')
  nnoremap <silent> <c-c><c-c> :split term://zsh<cr>i
  tnoremap <c-w>    <c-\><c-n><c-w>
else
  nnoremap <silent> <c-c><c-c> :terminal<cr>
endif

" Utility maps for repeatable quickly change/delete current word
nnoremap c*   *``cgn
nnoremap c#   *``cgN
nnoremap cg* g*``cgn
nnoremap cg# g*``cgN
nnoremap d*   *``dgn
nnoremap d#   *``dgN
nnoremap dg* g*``dgn
nnoremap dg# g*``dgN

" Improved search related mappings
cmap <expr> <cr> personal#search#wrap("\<cr>", {'after': 'zz'})
map  <expr> n    personal#search#wrap('n', {'after': 'zz'})
map  <expr> N    personal#search#wrap('N', {'after': 'zz'})
map  <expr> gd   personal#search#wrap('gd', {'after': 'zz'})
map  <expr> gD   personal#search#wrap('gD', {'after': 'zz'})
map  <expr> *    personal#search#wrap('*', {'immobile': 1})
map  <expr> #    personal#search#wrap('#', {'immobile': 1})
map  <expr> g*   personal#search#wrap('g*', {'immobile': 1})
map  <expr> g#   personal#search#wrap('g#', {'immobile': 1})
xmap <expr> *    personal#search#wrap_visual('/')
xmap <expr> #    personal#search#wrap_visual('?')

" {{{1 Configure plugins

" {{{2 internal

" Disable a lot of unnecessary internal plugins
let g:loaded_2html_plugin = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_gzip = 1
let g:loaded_logipat = 1
let g:loaded_rrhelper = 1
let g:loaded_spellfile_plugin = 1
let g:loaded_tarPlugin = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zipPlugin = 1

" }}}2

" {{{2 feature: git

let g:flog_default_arguments = {}
let g:flog_default_arguments.format = '[%h] %s%d'
let g:flog_default_arguments.date = 'format:%Y-%m-%d %H:%M:%S'

nnoremap <silent><leader>gl :silent Flog -all<cr>
nnoremap <silent><leader>gL :silent Flog -all -path=%<cr>

augroup vimrc_flog
  autocmd!
  autocmd FileType floggraph setlocal nolist
  autocmd FileType floggraph nmap <buffer><silent> q <plug>(FlogQuit)
augroup END

nnoremap <silent><leader>gs :call personal#git#fugitive_toggle()<cr>
nnoremap <silent><leader>ge :Gedit<cr>
nnoremap <silent><leader>gd :Gdiff<cr>

augroup vimrc_fugitive
  autocmd!
  autocmd BufReadPost fugitive:// setlocal bufhidden=delete
  autocmd FileType git setlocal foldlevel=1
  autocmd FileType git,fugitive nnoremap <buffer><silent> q :bwipeout!<cr>
augroup END

" }}}2
" {{{2 feature: completion and language server client

" See also: coc-settings.json

let g:coc_global_extensions = [
      \ 'coc-vimtex',
      \ 'coc-omni',
      \ 'coc-snippets',
      \ 'coc-python',
      \ 'coc-json',
      \ 'coc-yaml',
      \ 'coc-rust-analyzer',
      \ 'coc-vimlsp',
      \]

inoremap <silent><expr> <c-space> coc#refresh()

inoremap <expr><cr>    pumvisible() ? "\<c-y>\<cr>" : "\<cr>"
inoremap <expr><tab>   pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

imap <silent> <c-u>      <plug>(coc-snippets-expand)

nmap <silent> <leader>ld <plug>(coc-definition)zv
nmap <silent> <leader>lr <plug>(coc-references)
nmap <silent> <leader>lt <plug>(coc-type-definition)
nmap <silent> <leader>li <plug>(coc-implementation)

nmap <silent> <leader>lp <plug>(coc-diagnostic-prev)
nmap <silent> <leader>ln <plug>(coc-diagnostic-next)
nmap <silent> <leader>lk :<c-u>call CocAction('doHover')<cr>

nnoremap <silent> K :call <sid>show_documentation()<cr>
function! s:show_documentation()
  if index(['vim', 'help'], &filetype) >= 0
    execute 'help ' . expand('<cword>')
  elseif &filetype ==# 'tex'
    VimtexDocPackage
  else
    call CocAction('doHover')
  endif
endfunction

if exists('*CocActionAsync')
  augroup coc_settings
    autocmd!
    autocmd CursorHold * silent call CocActionAsync('highlight')
  augroup END
endif

" }}}2

" {{{2 plugin: ale

let g:ale_set_signs = 0

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_delay = 0

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] [%severity%] %s'

let g:ale_statusline_format = ['Errors: %d', 'Warnings: %d', '']

let g:ale_linters = {
      \ 'tex': [],
      \ 'python': ['pylint'],
      \ 'markdown': [],
      \}

nmap <silent> <leader>aa <Plug>(ale_lint)
nmap <silent> <leader>aj <Plug>(ale_next_wrap)
nmap <silent> <leader>ak <Plug>(ale_previous_wrap)

" }}}2
" {{{2 plugin: calendar.vim

let g:calendar_first_day = 'monday'
let g:calendar_date_endian = 'big'
let g:calendar_frame = 'space'
let g:calendar_week_number = 1

nnoremap <silent> <leader>c :Calendar -position=here<cr>

" Connect to diary
augroup vimrc_calendar
  autocmd!
  autocmd FileType calendar
        \ nnoremap <silent><buffer> <cr>
        \ :<c-u>call personal#wiki#open_diary()<cr>
  autocmd FileType calendar
        \ nnoremap <silent><buffer> <c-e> <c-^>
  autocmd FileType calendar
        \ nnoremap <silent><buffer> <c-u> :WinBufDelete<cr>
augroup END

" }}}2
" {{{2 plugin: CtrlFS

let g:ctrlsf_indent = 2
let g:ctrlsf_regex_pattern = 1
let g:ctrlsf_position = 'bottom'
let g:ctrlsf_context = '-B 2'
let g:ctrlsf_default_root = 'project+fw'
let g:ctrlsf_populate_qflist = 1
if executable('rg')
  let g:ctrlsf_ackprg = 'rg'
endif

nnoremap         <leader>ff :CtrlSF 
nnoremap <silent><leader>ft :CtrlSFToggle<cr>
nnoremap <silent><leader>fu :CtrlSFUpdate<cr>
vmap     <silent><leader>f  <Plug>CtrlSFVwordExec

" }}}2
" {{{2 plugin: FastFold

" nmap <sid>(DisableFastFoldUpdate) <plug>(FastFoldUpdate)
let g:fastfold_fold_command_suffixes =  []
let g:fastfold_fold_movement_commands = []

" }}}2
" {{{2 plugin: Fzf

let g:fzf_layout = {'window': {'width': 0.9, 'height': 0.85} }
let g:fzf_colors = {
      \ 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'],
      \}
let g:fzf_preview_window = ''

let g:fzf_mru_no_sort = 1
let g:fzf_mru_exclude = '\v' . join([
      \ '\.git/',
      \ '^/tmp/',
      \ 'documents/wiki/',
      \], '|')

let $FZF_DEFAULT_OPTS = '--reverse --inline-info'

function! s:nothing()
endfunction

augroup my_fzf_config
  autocmd!
  autocmd User FzfStatusLine call s:nothing()
  autocmd FileType fzf silent! tunmap <esc>
augroup END

function! MyFiles(...) abort
  let l:dir = a:0 > 0 ? a:1 : FindRootDirectory()
  if empty(l:dir)
    let l:dir = getcwd()
  endif
  let l:dir = substitute(fnamemodify(l:dir, ':p'), '\/$', '', '')

  let l:prompt_dir = len(l:dir) > 15 ? pathshorten(l:dir) : l:dir

  call fzf#vim#files(l:dir, {
      \ 'options': [
      \   '-m',
      \   '--prompt', 'Files ' . l:prompt_dir . '::'
      \ ],
      \})
endfunction

command! -bang Zotero call fzf#run(fzf#wrap(
            \ 'zotero',
            \ { 'source':  'fd -t f -e pdf . ~/.local/zotero/',
            \   'sink':    {x -> system(['zathura', '--fork', x])},
            \   'options': '-m -d / --with-nth=-1' },
            \ <bang>0))

nnoremap <silent> <leader><leader> :FZFFreshMru --prompt "History > "<cr>
nnoremap <silent> <leader>ob       :Buffers<cr>
nnoremap <silent> <leader>ot       :Tags<cr>
nnoremap <silent> <leader>ow       :WikiFzfPages<cr>
nnoremap <silent> <leader>oz       :Zotero<cr>
nnoremap <silent> <leader>oo       :call MyFiles()<cr>
nnoremap <silent> <leader>op       :call MyFiles('~/.vim/bundle')<cr>
nnoremap <silent> <leader>ov       :call fzf#run(fzf#wrap({
      \ 'dir': '~/.vim',
      \ 'source': 'git ls-files --exclude-standard --others --cached',
      \ 'options': [
      \   '--prompt', 'Files ~/.vim::',
      \ ],
      \}))<cr>

" }}}2
" {{{2 plugin: rainbow

let g:rainbow_active = 1
let g:rainbow_conf = {
      \ 'guifgs': ['#f92672', '#00afff', '#268bd2', '#93a1a1', '#dc322f',
      \   '#6c71c4', '#b58900', '#657b83', '#d33682', '#719e07', '#2aa198'],
      \ 'ctermfgs': ['9', '127', '4', '1', '3', '12', '5', '2', '6', '33',
      \   '104', '124', '7', '39'],
      \ 'separately' : {
      \   'gitconfig' : 0,
      \   'wiki' : 0,
      \   'md' : 0,
      \   'help' : 0,
      \   'lua' : 0,
      \   'fortran' : {},
      \   'systemd' : 0,
      \   'cfg' : 0,
      \   'vim' : 0,
      \   'toml' : 0,
      \   'qf' : 0,
      \   'javascript' : 0,
      \   'man' : 0,
      \ }
      \}

" }}}2
" {{{2 plugin: targets.vim

let g:targets_argOpening = '[({[]'
let g:targets_argClosing = '[]})]'
let g:targets_separators = ', . ; : + - = ~ _ * # / | \ &'
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB rr ll rb al rB Al bb aa bB Aa BB AA'

" }}}2
" {{{2 plugin: UltiSnips

let g:UltiSnipsExpandTrigger = '<nop>'
let g:UltiSnipsJumpForwardTrigger = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
let g:UltiSnipsRemoveSelectModeMappings = 0
let g:UltiSnipsSnippetDirectories = [vimrc#path('UltiSnips')]

nnoremap <leader>es :UltiSnipsEdit!<cr>

" }}}2
" {{{2 plugin: undotree

let g:undotree_WindowLayout = 2
let g:undotree_SetFocusWhenToggle = 1

nnoremap <f5> :UndotreeToggle<cr>

" }}}2
" {{{2 plugin: vim-columnmove

let g:columnmove_no_default_key_mappings = 1

for s:x in split('ftFT;,wbeWBE', '\zs') + ['ge', 'gE']
  silent! call columnmove#utility#map('nxo', s:x, 'ø' . s:x, 'block')
endfor
unlet s:x

" }}}2
" {{{2 plugin: vim-easy-align

let g:easy_align_bypass_fold = 1

nmap <leader>ea <plug>(LiveEasyAlign)
vmap <leader>ea <plug>(LiveEasyAlign)
nmap <leader>eA <plug>(EasyAlign)
vmap <leader>eA <plug>(EasyAlign)
vmap .  <plug>(EasyAlignRepeat)

" }}}2
" {{{2 plugin: vim-gutentags

let g:gutentags_define_advanced_commands = 1
let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')
let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+aimS',
      \ ]
let g:gutentags_file_list_command = {
      \ 'markers': {
      \   '.git': 'git ls-files',
      \   '.hg': 'hg files',
      \ },
      \}

" }}}2
" {{{2 plugin: vim-hexokinase

let g:Hexokinase_highlighters = ['backgroundfull']
let g:Hexokinase_ftEnabled = ['css', 'html']

" }}}2
" {{{2 plugin: vim-illuminate

let g:Illuminate_delay = 0
let g:Illuminate_ftblacklist = [
      \ 'dagbok',
      \ 'wiki',
      \ 'python',
      \]

" }}}2
" {{{2 plugin: vim-lawrencium

nnoremap <leader>hs :Hgstatus<cr>
nnoremap <leader>hl :Hglog<cr>
nnoremap <leader>hL :Hglogthis<cr>
nnoremap <leader>hd :call personal#hg#wrapper('Hgvdiff')<cr>
nnoremap <leader>hr :call personal#hg#wrapper('Hgvrecord')<cr>
nnoremap <leader>ha :call personal#hg#abort()<cr>

" }}}
" {{{2 plugin: vim-matchup

let g:matchup_matchparen_status_offscreen = 0
let g:matchup_override_vimtex = 1

" }}}2
" {{{2 plugin: vim-plug

" See autoload/vimrc.vim

" }}}2
" {{{2 plugin: vim-rooter

let g:rooter_manual_only = 1
let g:rooter_patterns = ['.git', '.hg', '.bzr', '.svn']

" }}}
" {{{2 plugin: vim-sandwich

let g:sandwich_no_default_key_mappings = 1
let g:operator_sandwich_no_default_key_mappings = 1
let g:textobj_sandwich_no_default_key_mappings = 1

" Support for python like function names
let g:sandwich#magicchar#f#patterns = [
  \   {
  \     'header' : '\<\%(\h\k*\.\)*\h\k*',
  \     'bra'    : '(',
  \     'ket'    : ')',
  \     'footer' : '',
  \   },
  \ ]


try
  " Change some default options
  call operator#sandwich#set('delete', 'all', 'highlight', 0)
  call operator#sandwich#set('all', 'all', 'cursor', 'keep')

  " Surround mappings (similar to surround.vim)
  nmap gs  <plug>(operator-sandwich-add)
  nmap gss <plug>(operator-sandwich-add)iW
  nmap ds  <plug>(operator-sandwich-delete)<plug>(textobj-sandwich-query-a)
  nmap dss <plug>(operator-sandwich-delete)<plug>(textobj-sandwich-auto-a)
  nmap cs  <plug>(operator-sandwich-replace)<plug>(textobj-sandwich-query-a)
  nmap css <plug>(operator-sandwich-replace)<plug>(textobj-sandwich-auto-a)
  xmap sa  <plug>(operator-sandwich-add)
  xmap sd  <plug>(operator-sandwich-delete)
  xmap sr  <plug>(operator-sandwich-replace)

  " Text objects
  xmap is  <plug>(textobj-sandwich-query-i)
  xmap as  <plug>(textobj-sandwich-query-a)
  omap is  <plug>(textobj-sandwich-query-i)
  omap as  <plug>(textobj-sandwich-query-a)
  xmap iss <plug>(textobj-sandwich-auto-i)
  xmap ass <plug>(textobj-sandwich-auto-a)
  omap iss <plug>(textobj-sandwich-auto-i)
  omap ass <plug>(textobj-sandwich-auto-a)

  " Allow repeats while keeping cursor fixed
  silent! runtime autoload/repeat.vim
  nmap . <plug>(operator-sandwich-predot)<plug>(RepeatDot)

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
catch
endtry

" }}}2
" {{{2 plugin: vim-schlepp

vmap <unique> <up>    <Plug>SchleppUp
vmap <unique> <down>  <Plug>SchleppDown
vmap <unique> <left>  <Plug>SchleppLeft
vmap <unique> <right> <Plug>SchleppRight

" }}}2
" {{{2 plugin: vim-sort-folds

xnoremap <silent> <leader>s :call sortfolds#SortFolds()<cr>

" }}}
" {{{2 plugin: vim-table-mode

let g:table_mode_auto_align = 0

" }}}2
" {{{2 plugin: vim-tmux-navigator

let g:tmux_navigator_disable_when_zoomed = 1

" }}}
" {{{2 plugin: vim-vebugger

let g:vebugger_leader = '<leader>d'

" }}}
" {{{2 plugin: vimux

let g:VimuxOrientation = 'h'
let g:VimuxHeight = '50'
let g:VimuxResetSequence = ''

" Open and manage panes/runners
nnoremap <leader>io :call VimuxOpenRunner()<cr>
nnoremap <leader>iq :VimuxCloseRunner<cr>
nnoremap <leader>ip :VimuxPromptCommand<cr>
nnoremap <leader>in :VimuxInspectRunner<cr>

" Send commands
nnoremap <leader>ii  :call VimuxSendText("jkk\n")<cr>
nnoremap <leader>is  :set opfunc=personal#vimux#operator<cr>g@
nnoremap <leader>iss :call VimuxRunCommand(getline('.'))<cr>
xnoremap <leader>is  "vy :call VimuxSendText(@v)<cr>

" }}}2

" {{{2 filetype: json

let g:vim_json_syntax_conceal = 0

" }}}2
" {{{2 filetype: man

let g:man_hardwrap = 1

" }}}2
" {{{2 filetype: markdown

let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_override_foldtext = 0
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_no_extensions_in_markdown = 1
let g:vim_markdown_conceal = 2
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_math = 1
let g:vim_markdown_strikethrough = 1

" }}}2
" {{{2 filetype: python

" Note: See more settings at:
"       ~/.vim/personal/ftplugin/python.vim
"       ~/.vim/personal/after/ftplugin/python.vim

" let g:semshi#excluded_hl_groups = []
let g:semshi#mark_selected_nodes = 2
let g:semshi#simplify_markup = 1
let g:semshi#error_sign = 0

" Syntax
let g:python_highlight_all = 1

" Folding
let g:coiled_snake_foldtext_flags = []

" }}}2
" {{{2 filetype: ruby

let g:ruby_fold=1

" }}}2
" {{{2 filetype: tex

let g:tex_stylish = 1
let g:tex_conceal = ''
let g:tex_flavor = 'latex'
let g:tex_isk='48-57,a-z,A-Z,192-255,:'

let g:vimtex_fold_enabled = 1
let g:vimtex_fold_types = {
      \ 'markers' : {'enabled': 0},
      \ 'sections' : {'parse_levels': 1},
      \}
let g:vimtex_format_enabled = 1
let g:vimtex_view_method = 'zathura'
let g:vimtex_view_automatic = 0
let g:vimtex_view_forward_search_on_start = 0
let g:vimtex_toc_config = {
      \ 'split_pos' : 'full',
      \ 'mode' : 2,
      \ 'fold_enable' : 1,
      \ 'hotkeys_enabled' : 1,
      \ 'hotkeys_leader' : '',
      \ 'refresh_always' : 0,
      \}
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_quickfix_autoclose_after_keystrokes = 3
let g:vimtex_imaps_enabled = 1
let g:vimtex_complete_img_use_tail = 1
let g:vimtex_complete_bib = {
      \ 'simple' : 1,
      \ 'menu_fmt' : '@year, @author_short, @title',
      \}
let g:vimtex_echo_verbose_input = 0

if has('nvim')
  let g:vimtex_compiler_progname = 'nvr'
endif

"
" NOTE: See also ~/.vim/personal/ftplugin/tex.vim
"

" }}}2
" {{{2 filetype: vim

" Internal vim plugin
let g:vimsyn_embed = 'P'

" }}}2
" {{{2 filetype: wiki

let g:wiki_root = '~/documents/wiki'
let g:wiki_toc_title = 'Innhald'
let g:wiki_viewer = {'pdf': 'zathura'}
let g:wiki_export = {
      \ 'output': 'printed',
      \}
let g:wiki_filetypes = ['wiki', 'md']
let g:wiki_month_names = [
      \ 'januar',
      \ 'februar',
      \ 'mars',
      \ 'april',
      \ 'mai',
      \ 'juni',
      \ 'juli',
      \ 'august',
      \ 'september',
      \ 'oktober',
      \ 'november',
      \ 'desember'
      \]
let g:wiki_template_title_week = '# Samandrag veke %(week), %(year)'
let g:wiki_template_title_month = '# Samandrag frå %(month-name) %(year)'
let g:wiki_write_on_nav = 1

let g:wiki_toc_depth = 2
let g:wiki_file_open = 'personal#wiki#file_open'

augroup MyWikiAutocmds
  autocmd!
  autocmd User WikiLinkOpened normal! zz
  autocmd User WikiBufferInitialized
        \ nmap <buffer> gf <plug>(wiki-link-open)
augroup END

" }}}2

" }}}1
