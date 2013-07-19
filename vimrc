" Setup for VIM: The number one text editor!
" -----------------------------------------------------------------------------
" Author: Karl Yngve Lervåg

"{{{1 Preamble | Load packages

set nocompatible
if has('vim_starting')
  set rtp+=~/.vim/bundle/neobundle
endif
call neobundle#rc(expand('~/.vim/bundle/'))
NeoBundleLocal ~/.vim/bundle_local/

" Load packages
" {{{2 Neobundle, Unite, and neocomplete
NeoBundle 'Shougo/neobundle'
NeoBundle 'Shougo/vimproc', {
      \ 'name'  : 'neovimproc',
      \ 'build' : {
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-help'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'tsukkee/unite-tag'
NeoBundle 'Shougo/neocomplete', {
      \ 'vim_version' : '7.3.885'
      \ }

" {{{2 Projects I participate in
"NeoBundle 'git@github.com:LaTeX-Box-Team/LaTeX-Box.git'
NeoBundle 'LaTeX-Box-Team/LaTeX-Box.git', {
      \ 'type__protocol' : 'ssh',
      \ }

" {{{2 Other plugins and scripts
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'bling/vim-airline'
NeoBundle 'bogado/file-line'
NeoBundle 'dahu/vim-fanfingtastic'
NeoBundle 'ervandew/screen'
NeoBundle 'ervandew/supertab'
NeoBundle 'git://repo.or.cz/vcscommand.git'
NeoBundle 'godlygeek/tabular'
NeoBundle 'gregsexton/MatchTag'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'kien/rainbow_parentheses.vim'
NeoBundle 'mileszs/ack.vim'
NeoBundle 'Peeja/vim-cdo'
NeoBundle 'SirVer/ultisnips'
NeoBundle 'scrooloose/syntastic', 'gcc_refactor'
NeoBundle 'sjl/clam.vim'
NeoBundle 'sjl/gundo.vim'
NeoBundle 'sjl/splice.vim'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'tpope/vim-abolish'
NeoBundle 'tpope/vim-fugitive', {
      \ 'augroup' : 'fugitive',
      \ }
NeoBundle 'tpope/vim-markdown'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-speeddating'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-unimpaired'
NeoBundle 'tsaleh/vim-matchit'
NeoBundle 'tyru/current-func-info.vim'
NeoBundle 'vim-ruby/vim-ruby', {
      \ 'autoload' : {
        \ 'filetypes' : ['rb'],
        \ },
      \ }

" }}}2

" Call on_source hook when reloading .vimrc.
if !has('vim_starting')
  call neobundle#call_hook('on_source')
endif

filetype plugin indent on

NeoBundleCheck

"{{{1 General options

"{{{2 Basic options
set history=1000
set confirm
set winaltkeys=no
set ruler
set lazyredraw
set mouse=
set hidden
set modelines=5
set tags=./tags,./.tags,./../*/.tags,./../*/tags
set fillchars=fold:\ ,diff:⣿
set diffopt=filler,foldcolumn:0,context:3
set matchtime=2
set matchpairs+=<:>
set showcmd
set backspace=indent,eol,start
set autoindent
set fileformat=unix
set spelllang=en_gb
set diffopt=filler,context:4,foldcolumn:2,horizontal
set list
set listchars=tab:▸\ ,trail:\ ,nbsp:%,extends:❯,precedes:❮
set cursorline
set autochdir
set cpoptions+=J
set autoread
set wildmode=longest,list:longest
set splitbelow
set splitright

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
  let title = substitute(getline(v:foldstart), '^[ "%#*]*{\{3}\d\s*', '', '')
  if v:foldlevel > 1
    let title = repeat('  ', v:foldlevel-2) . '* ' . title
  endif
  let title = strpart(title, 0, 71)
  return printf(' %-71s #%5d', title, v:foldend - v:foldstart + 1)
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
  set colorcolumn=81
end
set smarttab
set expandtab
set wrap
set linebreak
set showbreak=↪
set formatoptions=tcrq1n
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

"{{{2 Spellfile, thesaurus, similar
set thesaurus+=~/.vim/thesaurus/mythesaurus.txt
set spellfile+=~/.vim/spell/mywords.latin1.add
set spellfile+=~/.vim/spell/mywords.utf-8.add

"{{{2 Gui and colorscheme options
syntax on
set background=light
if has("gui_running")
  set lines=56
  set guioptions=aegiLt
  set guifont=Inconsolata-g\ Medium\ 9
else
  set t_Co=256
  set background=dark
endif
if neobundle#is_sourced('vim-colors-solarized')
  colorscheme solarized
endif

"{{{2 Searching and movement
set ignorecase
set smartcase
set nohls
set incsearch
set showmatch

set scrolloff=10
set virtualedit+=block

runtime macros/matchit.vim

noremap j gj
noremap k gk
"}}}2

"{{{1 Completion

set complete+=U,s,k,kspell,d
set completeopt=longest,menu,preview

" Note: See also under plugins like supertab

"{{{1 Statusline (Airline plugin)

set noshowmode
set laststatus=2

" Separators and symbols
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_fugitive_prefix = ' '
let g:airline_readonly_symbol = ''
let g:airline_paste_symbol = 'Þ'

" Theme and customization
let g:airline_theme='solarized'
let g:airline_section_z = '%3p%% %l:%c'
let g:airline_mode_map = {
      \ 'n'  : 'N',
      \ 'i'  : 'I',
      \ 'R'  : 'R',
      \ 'c'  : 'C',
      \ 'v'  : 'V',
      \ 'V'  : 'V-L',
      \ ''  : 'V-B',
      \ }

"{{{1 Autocommands

augroup vimrc_autocommands
  autocmd!

  " When editing a file, always jump to the last known cursor position.  Don't
  " do it when the position is invalid or when inside an event handler (happens
  " when dropping a file on gvim).
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

  " Resize splits when the window is resized
  autocmd VimResized * exe "normal! \<c-w>="

  " Set omnifunction if it is not already specified
  autocmd Filetype *
        \ if &omnifunc == "" |
        \   setlocal omnifunc=syntaxcomplete#Complete |
        \ endif
augroup END

"{{{1 Key mappings

noremap  H      ^
noremap  L      g_
noremap  <f1>   <nop>
inoremap <esc>  <nop>
inoremap jk     <esc>
inoremap <f1>   <nop>
nnoremap  Y     y$
nnoremap J      mzJ`z
nnoremap <c-u>  :bd<cr>
nnoremap gb     :bnext<cr>
nnoremap gB     :bprevious<cr>
nnoremap dp     dp]c
nnoremap do     do]c

" Shortcuts for some files
map <leader>ev :e ~/.vim/vimrc<cr>
map <leader>ez :e ~/.dotfiles/zshrc<cr>
map <leader>sv :source $MYVIMRC<cr>

" Make it possible to save as sudo
cmap w!! %!sudo tee > /dev/null %

" Open url in browser
map <silent> gx :silent !xdg-open <cWORD>&<cr>

"{{{1 Plugin settings

"{{{2 Ack settings
let g:ackprg="ack-grep -H --nocolor --nogroup --column"

"{{{2 Clam
let g:clam_winpos = 'topleft'

"{{{2 Ctrl P // Unite
"{{{3 Options
let g:ctrlp_map = '<leader>tt'
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_match_window_bottom = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_max_height = 25
let g:ctrlp_mruf_include = join([
      \ '.*rc$',
      \ '\.reference.bib$',
      \ '\.\(tex\|vim\|py\|f90\|F90\|cl\)$',
      \ '[mM]akefile\(\.code\)\?$'
      \ ], '\|')
let g:ctrlp_show_hidden = 0
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  'CVS$\|\.git$\|\.hg$\|\.svn$\|.vim\/undofiles$\|\.vim\/backup$',
  \ 'file': '\.exe$\|\.so$\|\.dll$\|documents\/ntnu\/phd',
  \ }

let g:unite_enable_start_insert = 1
let g:unite_source_buffer_time_format = "(%Y-%m-%d %H:%M:%S) "
let g:unite_source_file_mru_time_format = "(%Y-%m-%d %H:%M:%S) "

if neobundle#is_sourced('unite')
  call unite#filters#matcher_default#use(['matcher_fuzzy'])
  call unite#custom#source('file',           'matchers', 'matcher_fuzzy')
  call unite#custom#source('file_rec/async', 'matchers', 'matcher_fuzzy')
  call unite#custom#source('buffer',         'matchers', 'matcher_fuzzy')
  call unite#custom#source('command',        'matchers', 'matcher_fuzzy')
  call unite#custom#source('grep',           'matchers', 'matcher_fuzzy')
  call unite#custom#source('tag',            'matchers', 'matcher_fuzzy')
  call unite#custom#source('help',           'matchers', 'matcher_fuzzy')
  call unite#custom#source('outline',        'matchers', 'matcher_fuzzy')
endif

"{{{3 Mappings
nnoremap <silent> <Leader>tf :CtrlP<cr>
nnoremap <silent> <Leader>th :CtrlP /home/lervag<cr>
nnoremap <silent> <Leader>tv :CtrlP /home/lervag/.vim<cr>

nnoremap <silent> <leader>tc :Unite -buffer-name=commands -no-split command<cr>
nnoremap <silent> <leader>tg :Unite -buffer-name=tags     -no-split tag<cr>
nnoremap <silent> <leader>tb :Unite -buffer-name=buffer   -no-split
      \ buffer file<cr>
nnoremap <silent> <leader>tp :Unite -buffer-name=files    -no-split
      \ file_rec/async:!<cr>
nnoremap <silent> <F1>       :Unite -buffer-name=help     -no-split help<cr>

" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  let b:SuperTabDisabled=1
  imap <buffer> jk      <Plug>(unite_insert_leave)
  imap <buffer> <C-c>   <Plug>(unite_exit)
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
endfunction
"}}}

"{{{2 Fanfingtastic
let g:fanfingtastic_fix_t = 1
let g:fanfingtastic_use_jumplist = 1

"{{{2 Gundo
let g:gundo_width=60
let g:gundo_preview_height=20
let g:gundo_right=1
let g:gundo_close_on_revert=1
map <silent> <F5> :GundoToggle<cr>

"{{{2 LaTeX-BoX
let g:LatexBox_latexmk_async = 1
let g:LatexBox_latexmk_preview_continuously = 1
let g:LatexBox_Folding = 1
let g:LatexBox_viewer = 'mupdf -r 95'
let g:LatexBox_quickfix = 2

"{{{2 Neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_auto_delimiter = 1
let g:neocomplete#max_list = 15

" Plugin key-mappings
inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><C-l> neocomplete#complete_common_string()

" Define keyword
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns._ = '\h\w*'

" Enable omni completion
augroup neocomplete_omni_complete
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup END

" Enable heavy omni completion
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c
      \ = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp
      \ = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

"{{{2 Rainbox Parentheses
nnoremap <leader>R :RainbowParenthesesToggle<cr>
let g:rbpt_max = 16
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

if neobundle#is_sourced('rainbow_parentheses.vim')
  augroup RainbowParens
    au!
    au VimEnter * RainbowParenthesesToggle
    au Syntax * RainbowParenthesesLoadRound
  augroup END
endif

"{{{2 Screen
let g:ScreenImpl = "GnuScreen"
let g:ScreenShellTerminal = "xfce4-terminal"

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

"{{{2 Splice
let g:splice_initial_mode = "grid"
let g:splice_initial_layout_grid = 2
let g:splice_initial_layout_compare = 1

"{{{2 Supertab
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

"{{{2 syntactics
let g:syntastic_auto_loc_list = 2
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'passive_filetypes': ['tex'] }
let g:syntastic_enabled = 1
let g:syntastic_enable_highlighting = 1
let g:syntastic_fortran_flags = " -fdefault-real-8"
let g:syntastic_fortran_include_dirs = [
                            \ '../obj/gfortran_debug',
                            \ '../objects/debug_gfortran_Linux',
                            \ ]

"{{{2 Tabular
nmap <leader>a= :Tabularize /=<cr>
vmap <leader>a= :Tabularize /=<cr>
nmap <leader>a: :Tabularize /:\zs<cr>
vmap <leader>a: :Tabularize /:\zs<cr>
nmap <leader>a& :Tabularize /&\zs<cr>
vmap <leader>a& :Tabularize /&\zs<cr>
nmap <leader>aa :Tabularize /
vmap <leader>aa :Tabularize /

"{{{2 Ultisnips
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsEditSplit = "horizontal"
let g:UltiSnipsSnippetsDir = "~/.vim/bundle_local/personal/snippets"
let g:UltiSnipsSnippetDirectories = ["snippets", "UltiSnips"]
map <leader>es :UltiSnipsEdit<cr>

"{{{2 VCSCommand
let VCSCommandSplit = 'horizontal'
if v:version < 700
  let VCSCommandDisableAll='1'
end

"{{{2 vim-ruby
let g:ruby_fold=1

" }}}2

"{{{1 Modeline
" vim: fdm=marker
"
