
" Use space as leader key
nnoremap <space> <nop>
let mapleader = "\<space>"

" Define some paths/variables
let s:main = fnamemodify(expand('<sfile>'), ':h')
let s:init_script = s:main . '/init.sh'
let s:plug = s:main . '/autoload/plug.vim'
let s:bundle = s:main . '/bundle'
let s:personal = s:main . '/personal'
let s:devhosts = [
      \ 'yoga',
      \ 'vsl136',
      \ 'vsl142',
      \ 'unity.sintef.no',
      \]
let s:is_devhost = index(s:devhosts, hostname()) >= 0
let s:lervag = s:is_devhost ? 'git@github.com:lervag/' : 'lervag/'

" {{{1 Load plugins

if !filereadable(expand(s:plug))
  let s:stop = 1
  execute 'silent !' . s:init_script
  " vint: -ProhibitAutocmdWithNoGroup
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  " vint: +ProhibitAutocmdWithNoGroup
endif

silent! if plug#begin(s:bundle)

" My own plugins
call plug#(s:personal)
call plug#(s:lervag . 'vimtex')
call plug#(s:lervag . 'file-line')
call plug#(s:lervag . 'vim-foam')
if s:is_devhost
  call plug#(s:lervag . 'wiki')
  call plug#(s:lervag . 'vim-sintef')
endif

" Essentials
Plug 'junegunn/vim-plug', { 'on' : [] }
Plug 'gregsexton/gitv', { 'on' : 'Gitv' }
Plug 'tpope/vim-fugitive'
Plug 'wellle/targets.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'junegunn/vim-easy-align'
Plug 'dyng/ctrlsf.vim'
Plug 'machakann/vim-sandwich'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'junegunn/vader.vim', {
      \ 'on' : ['Vader'],
      \ 'for' : ['vader'],
      \}
Plug 'SirVer/ultisnips'
Plug 'Konfekt/FastFold'
Plug 'itchyny/calendar.vim'

" Filetype specific
Plug 'darvelo/vim-systemd'
Plug 'whatyouhide/vim-tmux-syntax'
Plug 'gregsexton/MatchTag'
Plug 'vim-ruby/vim-ruby'
Plug 'elzr/vim-json'
Plug 'gisraptor/vim-lilypond-integrator'
Plug 'davidhalter/jedi-vim'
Plug 'vim-python/python-syntax'
Plug 'tmhedberg/SimpylFold'

" Miscellaneous
Plug 'luochen1990/rainbow'
Plug 'machakann/vim-columnmove'
Plug 'dhruvasagar/vim-table-mode'
Plug 'idanarye/vim-vebugger'
Plug 'Shougo/vimproc', { 'do' : 'make -f make_unix.mak' }
Plug 'mbbill/undotree', { 'on' : 'UndotreeToggle' }
Plug 'tyru/capture.vim', { 'on' : 'Capture' }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'
if has('nvim') || v:version >= 800
  Plug 'w0rp/ale'
endif
if !has('nvim')
  Plug 'nhooyr/neoman.vim'
endif
Plug 'tweekmonster/helpful.vim'
Plug 'andymass/vim-matchup'

" Completion
Plug 'roxma/vim-hug-neovim-rpc',
      \ !has('nvim') ? {} : { 'on' : [] }
Plug 'roxma/nvim-completion-manager'
Plug 'roxma/ncm-github'
Plug 'Shougo/neco-vim'
Plug 'Shougo/neco-syntax'
Plug 'wellle/tmux-complete.vim'

" Uncertain - might replace or remove
Plug 'ludovicchabant/vim-lawrencium'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-scriptease'

" For improved search highlighting and similar
Plug 'junegunn/vim-slash'

" Testing
Plug 'tweekmonster/braceless.vim'
Plug 'frioux/vim-regedit'

call plug#end() | endif

if exists('s:stop')
  finish
endif

" {{{1 Autocommands

augroup vimrc_autocommands
  autocmd!

  " Only use cursorline for current window
  autocmd WinEnter,FocusGained * setlocal cursorline
  autocmd WinLeave,FocusLost   * setlocal nocursorline

  " When editing a file, always jump to the last known cursor position.  Don't
  " do it when the position is invalid or when inside an event handler (happens
  " when dropping a file on gvim).
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line('$') |
        \   execute 'normal! g`"' |
        \ endif

  " Set keymapping for command window
  autocmd CmdwinEnter * nnoremap <buffer> q <c-c><c-c>

  " Close preview after complete
  autocmd CompleteDone * pclose
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
  set smarttab
  set autoindent
  set incsearch
endif

" Neovim specific options
if has('nvim')
  set inccommand=split
endif

" Basic
set cpoptions+=J
set tags=tags;~,.tags;~
set path=.,**
set fileformat=unix
set wildignore=*.o
set wildignore+=*~
set wildignore+=*.pyc
set wildignore+=.git/*
set wildignore+=.hg/*
set wildignore+=.svn/*
set wildignore+=*.DS_Store
set wildignore+=CVS/*
set wildignore+=*.mod
set diffopt=filler,foldcolumn:0,context:4
if has('gui_running')
  set diffopt+=vertical
else
  set diffopt+=horizontal
endif

" Backup, swap and undofile
set noswapfile
set nobackup
set undofile
set undolevels=1000
set undoreload=10000
set undodir=$HOME/.vim/undofiles

if !isdirectory(&undodir)
  call mkdir(&undodir)
endif

" Behaviour
set autochdir
set lazyredraw
set confirm
set hidden
set shortmess=aoOtT
silent! set shortmess+=cI
silent! set shortmess+=F
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

" Completion
set wildmode=longest:full,full
set wildcharm=<c-z>
set complete+=U,s,k,kspell,d,]
set completeopt=longest,menu,preview

" Presentation
set list
set listchars=tab:▸\ ,nbsp:%,trail:\ ,extends:,precedes:
set fillchars=vert:│,fold:\ ,diff:⣿
set matchtime=2
set matchpairs+=<:>
set cursorline
set scrolloff=10
set splitbelow
set splitright
set previewheight=20
set noshowmode

if !has('gui_running')
  set visualbell
  set t_vb=
endif

" Folding
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

set display=lastline
set virtualedit=block

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
elseif executable('ack-grep')
  set grepprg=ack-grep\ --nocolor
endif

" {{{1 Appearance and UI

set background=light
set winwidth=70

if has('gui_running')
  set lines=50
  set guifont=Inconsolata-g\ for\ Powerline\ Medium\ 9
  set guioptions=ac
  set guiheadroom=0
else
  if &t_Co == 8 && $TERM !~# '^linux'
    set t_Co=256
  endif

  " Set terminal cursor
  if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\e[6 q\<Esc>\e]12;3\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\e]12;14\x7\<Esc>\\"
  else
    let &t_SI = "\e[6 q\e]12;3\x7"
    let &t_EI = "\e[2 q\e]12;14\x7"
    silent !echo -ne "\e[2 q\e]12;14\x7"
    autocmd vimrc_autocommands VimLeave *
          \ silent !echo -ne "\e[2 q\e]112\x7"
  endif
endif

" Set colorscheme and custom colors
autocmd vimrc_autocommands ColorScheme * call personal#custom_colors()
silent! colorscheme my_solarized

" Set gui cursor
set guicursor=a:block
set guicursor+=n:Cursor
set guicursor+=o-c:iCursor
set guicursor+=v:vCursor
set guicursor+=i-ci-sm:ver30-iCursor
set guicursor+=r-cr:hor20-rCursor
set guicursor+=a:blinkon0

" Initialize statusline and tabline
call statusline#init()
call statusline#init_tabline()

" {{{1 Mappings

"
" Available for mapping
"
"   Q
"   U
"   ctrl-h
"   ctrl-j
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
nnoremap <c-e>  <c-^>
nnoremap <c-p>  <c-i>
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" Buffer navigation
nnoremap <silent> gb    :bnext<cr>
nnoremap <silent> gB    :bprevious<cr>

" Utility maps for repeatable quickly change current word
nnoremap c*   *``cgn
nnoremap c#   *``cgN
nnoremap cg* g*``cgn
nnoremap cg# g*``cgN

" Navigate folds
nnoremap          zf zMzvzz
nnoremap <silent> zj :silent! normal! zc<cr>zjzvzz
nnoremap <silent> zk :silent! normal! zc<cr>zkzvzz[z

" Backspace and return for improved navigation
nnoremap        <bs> <c-o>zvzz
nnoremap <expr> <cr> empty(&buftype) ? '<c-]>zvzz' : '<cr>'

" Shortcuts for some files
nnoremap <silent> <leader>ev :execute 'edit' resolve($MYVIMRC)<cr>
nnoremap <silent> <leader>xv :source $MYVIMRC<cr>
nnoremap <leader>ez :edit ~/.dotfiles/zshrc<cr>

vnoremap <silent><expr> ++ personal#visual_math#yank_and_analyse()
nmap     <silent>       ++ vip++<esc>

" Terminal mappings
if has('nvim')
  nnoremap <c-c><c-c> :split term://zsh<cr>i
  tnoremap <esc>      <c-\><c-n>
endif

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

let g:Gitv_WipeAllOnClose = 1
let g:Gitv_DoNotMapCtrlKey = 1

nnoremap <leader>gl :Gitv --all<cr>
nnoremap <leader>gL :Gitv! --all<cr>
xnoremap <leader>gl :Gitv! --all<cr>

nmap     <leader>gs :Gstatus<cr>gg<c-n>
nnoremap <leader>ge :Gedit<cr>
nnoremap <leader>gd :Gdiff<cr>

command! Gtogglestatus :call Gtogglestatus()

function! Gtogglestatus()
  if buflisted(bufname('.git/index'))
    bd .git/index
  else
    Gstatus
  endif
endfunction

augroup vimrc_fugitive
  autocmd!
  autocmd BufReadPost fugitive:// setlocal bufhidden=delete
  autocmd FileType git setlocal foldlevel=1
augroup END

" }}}2
" {{{2 feature: completion

let g:tmuxcomplete#trigger = ''

let g:cm_sources_override = {
      \ 'cm-bufkeyword' : {'abbreviation' : 'key'},
      \ 'cm-ultisnips' : {
      \   'abbreviation' : 'snip',
      \   'priority' : 8,
      \ },
      \ 'cm-tmux' : {'enable' : 0},
      \ 'neco-syntax' : {'priority' : 4},
      \}
let g:cm_completeopt = 'menu,menuone,noinsert,noselect,preview'

inoremap <expr> <cr>    pumvisible() ? "\<c-y>\<cr>" : "\<cr>"
inoremap <expr> <tab>   pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

augroup my_cm_setup
  autocmd!
  autocmd User CmSetup call cm#register_source({
        \ 'name' : 'wiki',
        \ 'priority': 9,
        \ 'scoping': 1,
        \ 'scopes': ['wiki'],
        \ 'abbreviation': 'wiki',
        \ 'cm_refresh_patterns': ['\[\[[^]|]*#?$'],
        \ 'cm_refresh': {'omnifunc': 'wiki#complete#omnicomplete'},
        \ })
  autocmd User CmSetup call cm#register_source({
        \ 'name' : 'vimtex',
        \ 'priority': 8,
        \ 'scoping': 1,
        \ 'scopes': ['tex'],
        \ 'abbreviation': 'tex',
        \ 'cm_refresh_patterns': g:vimtex#re#ncm,
        \ 'cm_refresh': {'omnifunc': 'vimtex#complete#omnifunc'},
        \ })
  autocmd User CmSetup call cm#register_source({
        \ 'name' : 'foam',
        \ 'priority': 8,
        \ 'scoping': 1,
        \ 'scopes': ['foam'],
        \ 'abbreviation': 'foam',
        \ 'cm_refresh_patterns': g:foam#complete#re_refresh_ncm,
        \ 'cm_refresh': {'omnifunc': 'foam#complete#omnifunc'},
        \ })
  autocmd User CmSetup call cm#register_source({
        \ 'name' : 'tmuxcomplete',
        \ 'priority': 2,
        \ 'abbreviation': 'tmux',
        \ 'cm_refresh': {'omnifunc': 'tmuxcomplete#complete'},
        \ })
augroup END

" }}}2

" {{{2 plugin: ale

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] [%severity%] %s'

let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_text_changed = 'never'

let g:ale_statusline_format = ['Errors: %d', 'Warnings: %d', '']

let g:ale_linters = {
      \ 'tex': [],
      \ 'python': ['pylint'],
      \}

nmap <silent> <leader>aa <Plug>(ale_lint)
nmap <silent> <leader>aj <Plug>(ale_next_wrap)
nmap <silent> <leader>ak <Plug>(ale_previous_wrap)

highlight link ALEErrorLine ErrorMsg
highlight link ALEWarningLine WarningMsg
highlight link ALEInfoLine ModeMsg

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
        \ nnoremap <silent><buffer> <cr> :<c-u>call OpenDiary()<cr>
augroup END
function! OpenDiary()
  let l:date = printf('%d-%0.2d-%0.2d',
        \ b:calendar.day().get_year(),
        \ b:calendar.day().get_month(),
        \ b:calendar.day().get_day())

  call wiki#journal#make_note(l:date)
endfunction

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
" {{{2 plugin: CtrlP

let g:ctrlp_map = ''
let g:ctrlp_switch_buffer = 'e'
let g:ctrlp_working_path_mode = 'rc'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files']

if executable('rg')
  let g:ctrlp_user_command += ['rg %s --files --color=never --glob ""']
  let g:ctrlp_use_caching = 0
elseif executable('ag')
  let g:ctrlp_user_command += ['ag %s -l --nocolor -g ""']
  let g:ctrlp_use_caching = 0
endif

let g:ctrlp_match_func = {'match': 'pymatcher#PyMatch'}
let g:ctrlp_tilde_homedir = 1
let g:ctrlp_match_window = 'top,order:ttb,min:30,max:30'
let g:ctrlp_status_func = {
      \ 'main' : 'statusline#ctrlp',
      \ 'prog' : 'statusline#ctrlp',
      \}
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_mruf_exclude = '\v' . join([
      \ '\/\.%(git|hg)\/',
      \ '\.wiki$',
      \ '\.snip$',
      \ '\.vim\/vimrc$',
      \ '\/vim\/.*\/doc\/.*txt$',
      \ '_%(LOCAL|REMOTE)_',
      \ '\~record$',
      \ '^\/tmp\/',
      \ '^man:\/\/',
      \], '|')
" let g:ctrlp_custom_ignore = ''

" Mappings
nnoremap <silent> <leader>oo       :CtrlP<cr>
nnoremap <silent> <leader>og       :CtrlPRoot<cr>
nnoremap <silent> <leader>ov       :CtrlP ~/.vim<cr>
nnoremap <silent> <leader>op       :call CtrlPVimPlugs()<cr>
nnoremap <silent> <leader>ob       :CtrlPBuffer<cr>
nnoremap <silent> <leader>ow       :CtrlP ~/documents/wiki<cr>
nnoremap <silent> <leader>ot       :CtrlPTag<cr>
nnoremap <silent> <leader><leader> :call CtrlPDisableMatchFunc('CtrlPMRU')<cr>

" Wrapper to search through plugin source files
function! CtrlPVimPlugs() " {{{3
  let l:ctrlp_working_path_mode = g:ctrlp_working_path_mode
  let l:ctrlp_user_command = g:ctrlp_user_command
  let l:ctrlp_custom_ignore = get(g:, 'ctrlp_custom_ignore', '')
  let g:ctrlp_working_path_mode = 'c'
  let g:ctrlp_user_command = []
  let g:ctrlp_custom_ignore = '\v(LICENSE|tags|\.png$|\.jpg$)'

  CtrlP ~/.vim/bundle

  let g:ctrlp_working_path_mode = l:ctrlp_working_path_mode
  let g:ctrlp_user_command = l:ctrlp_user_command
  let g:ctrlp_custom_ignore = l:ctrlp_custom_ignore
endfunction

" }}}3

" Disable pymatcher for e.g. CtrlPMRU
function! CtrlPDisableMatchFunc(cmd) " {{{3
  let g:ctrlp_match_func = {}
  execute a:cmd
  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
endfunction

" }}}3

" }}}2
" {{{2 plugin: FastFold

nmap <sid>(DisableFastFoldUpdate) <plug>(FastFoldUpdate)
let g:fastfold_fold_command_suffixes =  ['x','X']
let g:fastfold_fold_movement_commands = []

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
      \   'fortran' : {},
      \ }
      \}

" }}}2
" {{{2 plugin: targets.vim

let g:targets_argOpening = '[({[]'
let g:targets_argClosing = '[]})]'
let g:targets_separators = ', . ; : + - = ~ _ * # / | \ &'
let g:targets_nl = 'nN'

" }}}2
" {{{2 plugin: UltiSnips

let g:UltiSnipsExpandTrigger = '<plug>(ultisnips_expand)'
let g:UltiSnipsJumpForwardTrigger = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
let g:UltiSnipsRemoveSelectModeMappings = 0
let g:UltiSnipsSnippetDirectories = [s:main . '/UltiSnips']

nnoremap <leader>es :UltiSnipsEdit!<cr>
inoremap <silent> <c-u> <c-r>=cm#sources#ultisnips#trigger_or_popup("\<plug>(ultisnips_expand)")<cr>

" }}}2
" {{{2 plugin: undotree

let g:undotree_WindowLayout = 2
let g:undotree_SetFocusWhenToggle = 1

nnoremap <f5> :UndotreeToggle<cr>

" }}}2
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
nnoremap <leader>is  :set opfunc=VimuxOperator<cr>g@
nnoremap <leader>iss :call VimuxRunCommand(getline('.'))<cr>
xnoremap <leader>is  "vy :call VimuxSendText(@v)<cr>

function! VimuxOperator(type)
  let l:text = join(getline(line("'["), line("']")), "\n")
  call VimuxSendText(l:text)
endfunction

" }}}2
" {{{2 plugin: vim-easy-align

let g:easy_align_bypass_fold = 1

nmap ga <plug>(LiveEasyAlign)
vmap ga <plug>(LiveEasyAlign)
nmap gA <plug>(EasyAlign)
vmap gA <plug>(EasyAlign)
vmap .  <plug>(EasyAlignRepeat)

" }}}2
" {{{2 plugin: vim-columnmove

let g:columnmove_no_default_key_mappings = 1

for s:x in split('ftFT;,wbeWBE', '\zs')
  silent! call columnmove#utility#map('nxo', s:x, '<m-' . s:x . '>', 'block')
endfor
unlet s:x
silent! call columnmove#utility#map('nxo', 'ge', '<m-g>e', 'block')
silent! call columnmove#utility#map('nxo', 'gE', '<m-g>E', 'block')

" }}}2
" {{{2 plugin: vim-gutentags

let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_generate_on_new = 0
let g:gutentags_file_list_command = {
      \ 'markers': {
      \   '.git': 'git ls-files',
      \   '.hg': 'hg files',
      \ },
      \}

" }}}2
" {{{2 plugin: vim-lawrencium

nnoremap <leader>hs :Hgstatus<cr>
nnoremap <leader>hl :Hglog<cr>
nnoremap <leader>hL :Hglogthis<cr>
nnoremap <leader>hd :call MyHgWrapper('Hgvdiff')<cr>
nnoremap <leader>hr :call MyHgWrapper('Hgvrecord')<cr>
nnoremap <leader>ha :call MyHgabort()<cr>

function! MyHgWrapper(com)
  execute a:com
  windo setlocal foldmethod=diff
  normal! gg]c
endfunction

function! MyHgabort()
  if exists(':Hgrecordabort')
    Hgrecordabort
  else
    bdelete lawrencium
  endif
  WinResize
  normal! zx
endfunction

" }}}
" {{{2 plugin: vim-matchup

let g:matchup_matchparen_status_offscreen = 0

" }}}2
" {{{2 plugin: vim-plug

let g:plug_window = 'tab new'

nnoremap <silent> <leader>pd :PlugDiff<cr>
nnoremap <silent> <leader>pi :PlugInstall<cr>
nnoremap <silent> <leader>pu :PlugUpdate<cr>
nnoremap <silent> <leader>ps :PlugStatus<cr>
nnoremap <silent> <leader>pc :PlugClean<cr>

" }}}2
" {{{2 plugin: vim-sandwich

let g:sandwich_no_default_key_mappings = 1
let g:operator_sandwich_no_default_key_mappings = 1
let g:textobj_sandwich_no_default_key_mappings = 1

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

" Change some default options
silent! call operator#sandwich#set('delete', 'all', 'highlight', 0)
silent! call operator#sandwich#set('all', 'all', 'cursor', 'keep')

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

" }}}2
" {{{2 plugin: vim-slash

noremap <plug>(slash-after) zz

" }}}2
" {{{2 plugin: vim-table-mode

let g:table_mode_auto_align = 0

" }}}2
" {{{2 plugin: vim-vebugger

let g:vebugger_leader = '<leader>v'

" }}}

" {{{2 filetype: json

let g:vim_json_syntax_conceal = 0

" }}}2
" {{{2 filetype: python

" Note: I should remember to install python-jedi and python2-jedi!
" Note: See ~/.vim/personal/ftplugin/python.vim for more settings

" I prefer to map jedi.vim features manually
let g:jedi#auto_initialization = 0

" Syntax
let g:python_highlight_all = 1

" Folding
let g:SimpylFold_docstring_preview = 1

" Indent, text object and a couple of nice maps
let g:braceless_block_key = 'i'
augroup MyBraceless
  autocmd!
  autocmd User BracelessInit nunmap J
  autocmd User BracelessInit iunmap <cr>
  autocmd FileType python BracelessEnable +indent
augroup END

" }}}2
" {{{2 filetype: ruby

let g:ruby_fold=1

" }}}2
" {{{2 filetype: tex

let g:tex_stylish = 1
let g:tex_conceal = ''
let g:tex_flavor = 'latex'
let g:tex_isk='48-57,a-z,A-Z,192-255,:'

let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_index_split_pos = 'below'
let g:vimtex_fold_enabled = 1
let g:vimtex_toc_fold = 1
let g:vimtex_toc_hotkeys = {'enabled' : 1}
let g:vimtex_format_enabled = 1
let g:vimtex_view_method = 'zathura'
let g:vimtex_imaps_leader = '\|'
let g:vimtex_complete_img_use_tail = 1
let g:vimtex_view_automatic = 0
let g:vimtex_view_forward_search_on_start = 0

if has('nvim')
  let g:vimtex_compiler_progname = 'nvr'
endif

"
" NOTE: See also ~/.vim/personal/ftplugin/tex.vim
"             or ~/.config/nvim/personal/ftplugin/tex.vim
"

" }}}2
" {{{2 filetype: vim

" Internal vim plugin
let g:vimsyn_embed = 'P'

" }}}2
" {{{2 filetype: wiki

if isdirectory(glob('~/documents/wiki'))
  let g:wiki = { 'root' : '~/documents/wiki' }

  " Used for order of projects in weekly/monthly summaries
  let g:wiki.projects = [
        \ 'Diverse',
        \ 'Leiested - Linux',
        \ 'Leiested - FerroCool',
        \ 'Tekna',
        \ 'Sommerjobb-administrasjon',
        \ 'FerroCool',
        \ 'FerroCool 2',
        \ 'RPT',
        \ 'Trafo',
        \ 'ELEGANCY',
        \]

  " Used for order of maconomy prints
  let g:sintef_projects = [
        \ 'Diverse',
        \ 'Borte',
        \ 'Intern',
        \ 'Leiested',
        \ 'Tekna',
        \ 'Sommerjobb',
        \ 'FerroCool',
        \ 'RPT',
        \ 'Trafo',
        \ 'HYVA',
        \ 'ELEGANCY',
        \ 'NCCS',
        \]
endif

" }}}2

" }}}1

" vim: fdm=marker
