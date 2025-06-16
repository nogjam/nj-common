" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2019 Dec 17
"
" To use it, copy it to
"	       for Unix:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"	 for MS-Windows:  $VIM\_vimrc
"	      for Haiku:  ~/config/settings/vim/vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings, bail
" out.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

" t_Co = maximum number of colors that can be displayed by the host terminal.
if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

" clang-format Python plugin
map <C-I> :py3f /usr/share/clang/clang-format-18/clang-format.py<cr>
imap <C-I> <c-o>:py3f /usr/share/clang/clang-format-18/clang-format.py<cr>

" ---------------------------------
" --- Custom user configuration ---
" ---------------------------------
colorscheme habamax
set backupdir-=.
set backupdir^=~/tmp,/tmp
" Insensitive casing (search)
set ic
" Incremental search
set is
set list
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
set number
set undofile
set undodir=$HOME/.vim/vimundo
" The famous Vim vertical ruler
set colorcolumn=73,80,88,100,120
" Spell checking
set spell

" Use four spaces instead of tabs
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" User macros
let @b = 'i[^[<80><fd>aea]^[<80><fd>a%l'
let @c = 'i{^[<80><fd>aea}^[<80><fd>a%l'
let @g = 'i''^[<80><fd>amaea''^[<80><fd>a`al'
let @m = 'i`^[<80><fd>amaea`^[<80><fd>a`al'
let @p = 'i`^[<80><fd>amaea`^[<80><fd>a`al'
let @r = 'hxwxb'
let @t = 'i"^[<80><fd>amaea"^[<80><fd>a`al'
