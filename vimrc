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
if &foldmethod == ""
  set foldmethod=syntax
endif
set foldlevel=0
set foldcolumn=0
set hidden
set modelines=5
set tags=./tags,./.tags,./../*/.tags,./../*/tags
set fillchars=fold:\ ,diff:⣿
set complete+=U,s,kspell
set completeopt=menuone,menu,preview,longest
set matchtime=2
set matchpairs+=<:>
set showcmd
set backspace=indent,eol,start
set autoindent
set nocindent
set fileformat=unix
set smarttab
set spelllang=en_gb
set diffopt=filler,context:4,foldcolumn:2,horizontal
set grepprg=ack-grep
set list
set listchars=tab:▸\ ,trail:\ ,nbsp:%,extends:❯,precedes:❮
set cursorline
set autochdir
set cpoptions+=J
set autoread
set wildmode=longest,list:longest
set iskeyword+=-

" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"

" Set foldoption for bash scripts
let g:sh_fold_enabled=7

"{{{2 Tabs, spaces, wrapping
set softtabstop=2
set shiftwidth=2
set textwidth=79
set columns=80
if v:version >= 703
  set colorcolumn=81
end
set expandtab
set wrap
set linebreak
set showbreak=↪
set formatoptions=tcrq1n
set formatlistpat=^\\s*\\(\\(\\d\\+\\\|[a-z]\\)[.:)]\\\|[-*]\\)\\s\\+

"{{{2 Backup and Undofile
set backup
if has("unix")
  set clipboard=autoselect
  set backupdir=$HOME/.vim/backup
  set directory=$HOME/.vim/backup
elseif has("win32")
  source $VIMRUNTIME/mswin.vim
  set backupdir=$VIM/backup
  set directory=$VIM/backup
endif

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
call togglebg#map("<F6>")

"{{{2 Searching and movement

set ignorecase
set smartcase
set nohlsearch
set incsearch
set showmatch

set scrolloff=10
set virtualedit+=block

runtime macros/matchit.vim

noremap j gj
noremap k gk

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

  " Set omnifunction if it is not already specified
  if exists("+omnifunc")
    autocmd Filetype *
          \ if &omnifunc == "" |
          \   setlocal omnifunc=syntaxcomplete#Complete |
          \ endif
  endif

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

  " Textfiles
  au BufReadPost *.txt setlocal textwidth=78
  au BufReadPost *.txt setlocal formatoptions-=c

  " Fortran
  au BufReadPost *.f90 set foldmethod=syntax

  " MATLAB
  au BufReadPost *.m set foldmethod=manual

  " C++
  au BufReadPost *.c++ setlocal cindent

  " Python
  au FileType python syn keyword pythonDecorator True None False self

  " Makefile
  au FileType make set nolist
augroup END

"{{{1 General key mappings
" Exit insert mode
inoremap jkj <Esc>

" Open certain files with ,v...
map ,vv :e $MYVIMRC<cr>
map ,vs :e  ~/.vim/snippets/<cr>

" Mappings for switching and closing buffers
nnoremap <silent> <C-p> :bp<CR>
nnoremap <silent> <C-n> :bn<CR>
nnoremap <C-U> :bd<CR>

" Mappings for controlling the error window
map ,ec :botright cope<cr>
map ,en :cn<cr>
map ,ep :cp<cr>

" Spell checking
let sc_on = 0
nnoremap <leader>ss :let sc_on = SpellCheck(sc_on)<CR>
nnoremap <leader>sq :ChooseLanguage()<CR>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

" Other stuff
noremap Y y$
imap <silent> <c-r><c-d> <c-r>=strftime("%e %b %Y")<CR>
imap <silent> <c-r><c-t> <c-r>=strftime("%l:%M %p")<CR>
map <F1> <nop>
map <F12> ggVGg? " encypt the file (toggle)
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name")
      \ . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
map <F9> :call ScreenShellSend('make')<CR>

" Make it possible to save as sudo
cmap w!! %!sudo tee > /dev/null %

map ,gg :grep <C-R>=expand(expand("<cword>") . " " . expand("%:h"))<CR><CR>
map ,go :botright cwindow<CR>
map ,gp :cprev<CR>
map ,gn :cnext<CR>

" Open a Quickfix window for the last search.
nnoremap <silent> <leader>/ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" Ack for the last search.
nnoremap <silent> <leader>? :execute "Ack! '" . substitute(substitute(substitute(@/, "\\\\<", "\\\\b", ""), "\\\\>", "\\\\b", ""), "\\\\v", "", "") . "'"<CR>

" Navigate folds
nnoremap zj zcjzo
nnoremap zk zckzo
nnoremap <space> za
nnoremap zf zMzvzz

" Keep search matches in the middle of the window
nnoremap <silent> n nzzzv:call PulseCursorLine()<cr>
nnoremap <silent> N Nzzzv:call PulseCursorLine()<cr>

" Easier to type, and I never use the default behavior.
noremap H ^
noremap L g_

" Turn off stupid keys
noremap  <F1> <nop>
inoremap <F1> <nop>
nnoremap K <nop>

" Error navigation {{{2
"
"             Location List     QuickFix Window
"            (e.g. Syntastic)     (e.g. Ack)
"            ----------------------------------
" Next      |     M-k               M-Down     |
" Previous  |     M-l                M-Up      |
"            ----------------------------------
"
nnoremap ˚ :lnext<cr>zvzz
nnoremap ¬ :lprevious<cr>zvzz
nnoremap <m-Down> :cnext<cr>zvzz
nnoremap <m-Up> :cprevious<cr>zvzz

"{{{1 Shell command

" Thanks to Steve Losh for this
function! s:ExecuteInShell(command) " {{{
    let command = join(map(split(a:command), 'expand(v:val)'))
    let winnr = bufwinnr('^' . command . '$')
    silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command)
                             \ : winnr . 'wincmd w'
    setlocal buftype=nowrite
          \ bufhidden=wipe
          \ nobuflisted noswapfile nowrap nonumber
    echo 'Execute ' . command . '...'
    silent! execute 'silent %!'. command
    silent! redraw
    silent! execute 'au BufUnload <buffer> execute bufwinnr('
          \ . bufnr('#') . ') . ''wincmd w'''
    silent! execute 'nnoremap <silent> <buffer>'
          \ . ' <LocalLeader>r :call <SID>ExecuteInShell('
          \ . command . ')<CR>:AnsiEsc<CR>'
    silent! execute 'nnoremap <silent> <buffer> q :q<CR>'
    silent! execute 'AnsiEsc'
    echo 'Shell command ' . command . ' executed.'
endfunction " }}}

command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
nnoremap <leader>! :Shell 

"{{{1 Plugin settings
"{{{2 Ack settings
let g:ackprg="ack-grep -H --nocolor --nogroup --column"
let g:ackhighlight=1

"{{{2 ConqueTerm
let g:ConqueTerm_SendVisKey = ',cc'
let g:ConqueTerm_SendFileKey = ',ca'
let g:ConqueTerm_ExecFileKey = ',cf'
let g:ConqueTerm_CloseOnEnd = 1
let g:ConqueTerm_TERM = 'xterm'

"{{{2 Ctrl P

" Set options
let g:ctrlp_map = '<leader>tt'
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_working_path_mode = 'rc'
let g:ctrlp_match_window_bottom = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_max_height = 25
let g:ctrlp_mruf_last_entered = 1
let g:ctrlp_mruf_exclude = 'phd/journal.txt\|\.aux$'
let g:ctrlp_dotfiles = 0
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_use_caching = 100
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$\|.vim\/undofiles$\|\.vim\/backup$',
  \ 'file': '\.exe$\|\.so$\|\.dll$\|documents\/ntnu\/phd',
  \}
let g:ctrlp_extensions = ['tag', 'line']

" Add some mappings
nmap <silent> <Leader>tf :CtrlP<cr>
nmap <silent> <Leader>th :CtrlP /home/lervag<cr>
nmap <silent> <Leader>tv :CtrlP /home/lervag/.vim<cr>

"{{{2 delimitMate
" General options
let delimitMate_expand_space       = 1
let delimitMate_excluded_regions   = "Comments,String"
let delimitMate_matchpairs         = "(:),[:],{:}"
let delimitMate_quotes             = "\" '"
let delimitMate_excluded_ft        = "sh,zsh,text"

" Tweak for some file types
au FileType vim  let b:delimitMate_quotes = "'"
au FileType lisp let b:delimitMate_quotes = '"'

"{{{2 Gundo
let g:gundo_width=60
let g:gundo_preview_height=20
let g:gundo_right=1
let g:gundo_close_on_revert=1
map <silent> <F5> :GundoToggle<cr>

"{{{2 LaTeX-BoX
let g:LatexBox_latexmk_options = '-pvc'
let g:LatexBox_cite_pattern = '\c\\\a*cite\a*\*\?\_\s*{'
let g:LatexBox_ref_pattern = '\\v\?\(eq\|page\|[cC]\)\?ref\*\?\_\s*{'
let g:LatexBox_Folding=1
let g:LatexBox_fold_parts=[
      \ "section",
      \ "subsection",
      \ "subsubsection"
      \ ]

"{{{2 Lisp (built-in)

set lispwords+=alet,alambda,dlambda,aif
let g:lisp_rainbow = 1

"{{{2 Powerline

let g:Powerline_symbols = "fancy"

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
let g:SuperTabContextDefaultCompletionType = "<c-n>"
let g:SuperTabRetainCompletionDuration = "session"
let g:SuperTabLongestEnhanced = 1
let g:SuperTabCrMapping = 0
let g:SuperTabUndoBreak = 1

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

"{{{2 Switch.vim
nnoremap - :Switch<cr>
let g:switch_definitions =
    \ [
    \   ['.true.', '.false.']
    \ ]

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
nnoremap <silent> <leader>tb :TagbarToggle<CR>

"{{{2 VCSCommand
let VCSCommandSplit = 'horizontal'
if v:version < 700
  let VCSCommandDisableAll='1'
end
map ,cc :call ChooseVCSCommandType()<cr>

"{{{1 Functions
function! EnsureDirExists ()                                              "{{{2
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
function! SpellCheck(sc_on)                                               "{{{2
  if a:sc_on
    echo "Spell checking turned off!"
    set nospell
    return 0
  else
    echo "Spell checking turned on!"
    set spell
    return 1
  endif
endfunction
function! ChooseVCSCommandType()                                          "{{{2
  let choice = confirm("Choose VCS Type", "&CVS\n&Mercurial")
  if choice == 1
    let b:VCSCommandVCSType="CVS"
  elseif choice == 2
    let b:VCSCommandVCSType="Mercurial"
  endif
endfunction
function! ChooseLanguage()                                                "{{{2
  let choice =
        \ confirm("Choose Language",
        \ "&Bokmaal\n&Nynorsk\nEnglish &GB\nEnglish &USA")
  if choice == 1
    set spelllang=nb
  elseif choice == 2
    set spelllang=nn
  elseif choice == 3
    set spelllang=en_us
  elseif choice == 4
    set spelllang=en_gb
  endif
endfunction
function! ChooseMakePrg()                                                 "{{{2
  let choice = confirm("Choose make program" , "&Python\n&Makefile")
  if choice == 1
    set makeprg=python\ %
  elseif choice == 2
    set makeprg=make
  endif
endfunction
function! CreateTags()                                                    "{{{2
  !silent! lcd %:h
  let choice = confirm("What kind of tags?" , "&Stop\n&C++\n&Fortran" , 1)
  if choice == 2
    silent execute "!ctags -o tagsmenu --c++-kinds=cf *.cpp"
    silent execute "!ctags *.cpp"
    silent execute "!sed -i '/TAG/d' tagsmenu"
  elseif choice == 3
    silent execute "!ctags -o tagsmenu *.f90"
    silent execute "!ctags *.f90"
    silent execute "!sed -i '/TAG/d' tagsmenu"
  endif
  silent! lcd -
endfunction
function! ShowFunctions()                                                 "{{{2
  30vsplit tagsmenu
  set nowrap
  setlocal ts=99
  map <CR> 0ye:bd<CR>:tag <C-R>"<CR>
endfunction
function! UpdateCopyrightLine()                                           "{{{2
  let copyrights = {
    \ 'Copyright (c) .\{-}, \d\d\d\d-\zs\d\d\d\d' : 'strftime("%Y")',
    \}

  for [copyright, year] in items(copyrights)
    silent! execute "'[,']s/" . copyright . '/\= ' . replacement . '/'
  endfor
endfunction
function! AskQuit (msg, proposed_action)                                  "{{{2
  if confirm(a:msg, "&Quit?\n" . a:proposed_action) == 1
    exit
  endif
endfunction

function! PulseCursorLine()                                               "{{{2
    let current_window = winnr()

    windo set nocursorline
    execute current_window . 'wincmd w'

    setlocal cursorline

    redir => old_hi
        silent execute 'hi CursorLine'
    redir END
    let old_hi = split(old_hi, '\n')[0]
    let old_hi = substitute(old_hi, 'xxx', '', '')

    hi CursorLine guibg=#2a2a2a ctermbg=233
    redraw
    sleep 20m

    hi CursorLine guibg=#333333 ctermbg=235
    redraw
    sleep 20m

    hi CursorLine guibg=#3a3a3a ctermbg=237
    redraw
    sleep 20m

    hi CursorLine guibg=#444444 ctermbg=239
    redraw
    sleep 20m

    hi CursorLine guibg=#3a3a3a ctermbg=237
    redraw
    sleep 20m

    hi CursorLine guibg=#333333 ctermbg=235
    redraw
    sleep 20m

    hi CursorLine guibg=#2a2a2a ctermbg=233
    redraw
    sleep 20m

    execute 'hi ' . old_hi

    windo set cursorline
    execute current_window . 'wincmd w'
endfunction

" }}}
"{{{1 Footer
"
" -----------------------------------------------------------------------------
" Copyright, Karl Yngve Lervåg (c) 2008 - 2011
" -----------------------------------------------------------------------------
" vim: foldmethod=marker:ff=unix
"
