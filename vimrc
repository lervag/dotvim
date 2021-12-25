" Use space as leader key
nnoremap <space> <nop>
let g:mapleader = "\<space>"

" Add personal files to runtimepath
set runtimepath^=~/.vim/personal

" {{{1 Autocommands

augroup vimrc_autocommands
  autocmd!

  " Only use cursorline for current window, except when in diff mode
  autocmd WinEnter,FocusGained * if !&diff | setlocal cursorline | endif
  autocmd WinLeave,FocusLost   * if !&diff | setlocal nocursorline | endif
  autocmd OptionSet diff call personal#init#toggle_diff()

  " When editing a file, always jump to the last known cursor position.
  autocmd BufReadPost * call personal#init#go_to_last_known_position()

  " Set keymapping for command window
  autocmd CmdwinEnter * nnoremap <buffer> q     <c-c><c-c>
  autocmd CmdwinEnter * nnoremap <buffer> <c-f> <c-c>
augroup END

" {{{1 Options

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
silent! set diffopt+=indent-heuristic,algorithm:patience
silent! set diffopt+=hiddenoff

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
silent! set pumwidth=35

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
set printexpr=personal#print_file(v:fname_in)

" {{{1 Appearance and UI

set winwidth=70
if has('termguicolors')
  set termguicolors
endif
silent! colorscheme my_solarized

call personal#init#cursor()
call personal#init#statusline()

" {{{1 Mappings

" Disable some mappings
noremap  <f1>   <nop>
inoremap <f1>   <nop>
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

nnoremap <leader>pp :hardcopy<cr>
xnoremap <leader>pp :hardcopy<cr>

" Terminal mappings
tnoremap <esc> <c-\><c-n>
nnoremap <silent> <c-c><c-c> :terminal<cr>

" Utility maps for repeatable quickly change/delete current word
nnoremap c*   *``cgn
nnoremap c#   *``cgN
nnoremap cg* g*``cgn
nnoremap cg# g*``cgN
nnoremap d*   *``dgn
nnoremap d#   *``dgN
nnoremap dg* g*``dgn
nnoremap dg# g*``dgN

" {{{1 Configure plugins

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

" }}}1
