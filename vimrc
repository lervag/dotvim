" Setup for VIM: The number one text editor!
" -----------------------------------------------------------------------------
" Author: Karl Yngve Lervåg
"
"{{{1 Preamble
filetype off
if !exists("pathogen_loaded")
  source ~/.vim/bundle/vim-pathogen/autoload/pathogen.vim
  call pathogen#infect()
  call pathogen#helptags()
  let pathogen_loaded = 1
endif
filetype plugin indent on
set nocompatible

"{{{1 General options
"{{{2 Basic
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
  let level = strpart(repeat('-', v:foldlevel-1) . '*',0,3)
  if v:foldlevel > 3
    let level = strpart(level, 1) . v:foldlevel
  endif
  let title = substitute(getline(v:foldstart), '^[ "%#*]*{\{3}\d\s*', '', '')
  let title = strpart(title, 0, 69)
  return printf('%-3s %-69s#%5d', level, title, v:foldend - v:foldstart + 1)
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
  set guifont=Inconsolata-dz\ for\ Powerline\ Medium\ 9
else
  set t_Co=256
  set background=dark
endif
colorscheme solarized

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

"{{{1 Completion
"
" Note: See also under plugins like supertab
"
set complete+=U,s,k,kspell,d
set completeopt=longest,menu,preview

"{{{1 Statusline
set laststatus=2
if !exists("g:Powerline_loaded")
  set statusline=[%n]\ %t                         " tail of the filename
  set statusline+=\ %m                            " modified flag
  set statusline+=[%{strlen(&fenc)?&fenc:'none'}, " file encoding
  set statusline+=%{&ff}                          " file format
  set statusline+=%Y                              " filetype
  set statusline+=%H                              " help file flag
  set statusline+=%R]                             " read only flag
  if v:version >= 703
    set statusline+=%q                            " quickfix-tag
    set statusline+=%w                            " preview-tag
  end
  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*
  set statusline+=%=                              " left/right separator
  set statusline+=(%v,                            " cursor column
  set statusline+=%l/%L)                          " cursor line/total lines
  set statusline+=\ %P                            " percent through file
end

"{{{1 Autocommands
"{{{2 General autocommands
augroup GeneralAutocommands
  autocmd!

  " Create directory if it does not exist when opening a new file
  autocmd BufNewFile  * :call EnsureDirExists()

  " When editing a  file, always jump to the last  known cursor position. Don't
  " do it when the position is invalid or when inside an event handler (happens
  " when dropping a file on gvim).
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

  " Resize splits when the window is resized
  autocmd VimResized * exe "normal! \<c-w>="
augroup END

"{{{2 Specific autocommands
augroup SpecificAutocommands
  autocmd!

  " Set omnifunction if it is not already specified
  autocmd Filetype *
        \ if &omnifunc == "" |
        \   setlocal omnifunc=syntaxcomplete#Complete |
        \ endif

  " Textfiles
  au BufReadPost *.txt setlocal ft=text
  au FileType text setlocal textwidth=78
  au FileType text setlocal formatoptions-=c

  " C++
  au BufReadPost *.c++ setlocal cindent

  " Python
  au FileType python syn keyword pythonDecorator True None False self

  " Makefile
  au FileType make set nolist
augroup END

"{{{1 General key mappings

noremap  H      ^
noremap  L      g_
noremap  Y      y$
noremap  <F1>   <nop>
nnoremap J      mzJ`z
nnoremap <C-U>  :bd<CR>
inoremap <esc>  <nop>
inoremap jk     <esc>
inoremap <F1>   <nop>
nnoremap gb     :ls<CR>:buffer<Space>
nnoremap <c-j>  <c-w><c-j>
nnoremap <c-k>  <c-w><c-k>
nnoremap <c-l>  <c-w><c-l>
nnoremap <c-h>  <c-w><c-h>

" Shortcuts for some files
map <leader>ev :split ~/.vim/vimrc<cr>
map <leader>sv :source $MYVIMRC<cr>
map <leader>ez :e ~/.dotfiles/zshrc<cr>
map <leader>es :e  ~/.vim/bundle/personal/snippets/<CR>

" Make it possible to save as sudo
cmap w!! %!sudo tee > /dev/null %

"{{{1 Plugin settings
"{{{2 Ack settings
let g:ackprg="ack-grep -H --nocolor --nogroup --column"

"{{{2 Clam

let g:clam_winpos = 'topleft'


"{{{2 Ctrl P

" Set options
let g:ctrlp_map = '<leader>tt'
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_match_window_bottom = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_max_height = 25
let g:ctrlp_mruf_include = join([
      \ '.*rc$',
      \ '\.reference.bib$',
      \ '\.\(tex\|py\|f90\|F90\|cl\)$',
      \ '[mM]akefile\(\.code\)\?$'
      \ ], '\|')
let g:ctrlp_show_hidden = 0
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  'CVS$\|\.git$\|\.hg$\|\.svn$\|.vim\/undofiles$\|\.vim\/backup$',
  \ 'file': '\.exe$\|\.so$\|\.dll$\|documents\/ntnu\/phd',
  \ }
let g:ctrlp_extensions = ['tag', 'line']

" Add some mappings
nmap <silent> <Leader>tb :CtrlPBuffer<cr>
nmap <silent> <Leader>tf :CtrlP<cr>
nmap <silent> <Leader>th :CtrlP /home/lervag<cr>
nmap <silent> <Leader>tv :CtrlP /home/lervag/.vim<cr>

"{{{2 delimitMate
" General options
let loaded_delimitMate             = 1
let delimitMate_expand_space       = 1
let delimitMate_excluded_regions   = "Comments,String"
let delimitMate_matchpairs         = "(:),[:],{:}"
let delimitMate_quotes             = "\" '"
let delimitMate_excluded_ft        = "sh,zsh,text,vim"

" Tweak for some file types
au FileType lisp let b:delimitMate_quotes = '"'

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
let g:LatexBox_latexmk_options = '-pvc'
let g:LatexBox_ignore_warnings = ['Package pgfplots Warning']
let g:LatexBox_Folding=1
let g:LatexBox_viewer='mupdf -r 95'

"{{{2 Powerline

let g:Powerline_symbols = "fancy"
let g:Powerline_stl_path_style= "short"
let g:Powerline_mode_n = "N "
let g:Powerline_mode_i = "I "
let g:Powerline_mode_R = "R "
let g:Powerline_mode_v = "V "
let g:Powerline_mode_V = "VL"
let g:Powerline_mode_cv= "VB"
let g:Powerline_mode_s = "S "
let g:Powerline_mode_S = "SL"
let g:Powerline_mode_cs= "SB"

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
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound

"{{{2 vim-ruby

let g:ruby_fold=1

"{{{2 Screen
let g:ScreenImpl = "Tmux"

"
" Dynamic keybindings
"
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

"
" Initialize and define auto group stuff
"
nmap <silent> <C-c><C-c> :ScreenShell<cr>
augroup ScreenShellEnter
  au USER * :call <SID>ScreenShellListenerMain()
augroup END
augroup ScreenShellExit
  au USER * :call <SID>ScreenShellListenerMain()
augroup END

"{{{2 Snipmate
let g:snippets_dir = "~/.vim/bundle/personal/snippets/"

"{{{2 Supertab
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
let g:SuperTabRetainCompletionDuration = "session"
let g:SuperTabLongestEnhanced = 1
let g:SuperTabLongestHighlight = 1
let g:SuperTabUndoBreak = 1

augroup Supertab
  autocmd!
  autocmd FileType fortran call SuperTabSetDefaultCompletionType("<c-n>")
  autocmd FileType text    call SuperTabSetDefaultCompletionType("<c-n>")
augroup END

"{{{2 Neocomplcache (old)
"let g:neocomplcache_enable_at_startup = 1
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"
"inoremap <expr><C-g>     neocomplcache#undo_completion()
"imap <expr><CR> neocomplcache#sources#snippets_complete#expandable()
"      \ ? "\<Plug>(neocomplcache_snippets_jump)" :
"      \ pumvisible() ? neocomplcache#smart_close_popup() :     "\<CR>"

"{{{2 Splice

let g:splice_initial_mode = "compare"
let g:splice_initial_layout_grid = 2
let g:splice_initial_layout_compare = 1

"{{{2 syntactics
let g:syntastic_auto_loc_list = 2
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'passive_filetypes': ['tex', 'fortran'] }
let g:syntastic_enabled = 1
let g:syntastic_enable_highlighting = 1
let g:syntastic_fortran_flags = " -fdefault-real-8"
                            \ . " -I../obj/gfortran_debug"
                            \ . " -I../objects/debug_gfortran_Linux"

"{{{2 Tabular
nmap <leader>a= :Tabularize /=<cr>
vmap <leader>a= :Tabularize /=<cr>
nmap <leader>a: :Tabularize /:\zs<cr>
vmap <leader>a: :Tabularize /:\zs<cr>
nmap <leader>a& :Tabularize /&\zs<cr>
vmap <leader>a& :Tabularize /&\zs<cr>
nmap <leader>aa :Tabularize /
vmap <leader>aa :Tabularize /

"{{{2 Tagbar
let g:tagbar_expand=1
let g:tagbar_autoclose=1
let g:tagbar_autofocus=1
nnoremap <silent> <leader>b :TagbarToggle<CR>

"{{{2 VCSCommand
let VCSCommandSplit = 'horizontal'
if v:version < 700
  let VCSCommandDisableAll='1'
end

"{{{1 Functions
"{{{2 EnsureDirExists()
function! EnsureDirExists ()
  let dir = expand("%:h")
  if !isdirectory(dir)
    call AskQuit("Directory '" . dir . "' doesn't exist.", "&Create it?")
    try
      call mkdir(dir, 'p')
    catch
      call AskQuit("Can't create '" . dir . "'", "&Continue anyway?")
    endtry
  endif
endfunction

"{{{2 AskQuit
function! AskQuit (msg, proposed_action)
  if confirm(a:msg, "&Quit?\n" . a:proposed_action) == 1
    exit
  endif
endfunction

"{{{2 ChooseVCSCommandType
function! ChooseVCSCommandType()
  let choice = confirm("Choose VCS Type", "&CVS\n&Mercurial")
  if choice == 1
    let b:VCSCommandVCSType="CVS"
  elseif choice == 2
    let b:VCSCommandVCSType="Mercurial"
  endif
endfunction

"{{{1 Modeline
" vim: fdm=marker
"
