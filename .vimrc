" Configuration file for vim

set background=dark
colorscheme desert
if has("gui_running")
    set guifont=Monospace\ 10
elseif &term =~ "xterm"
    if glob("~/.vim/colors/desertEx.vim")
	set t_Co=256
	colorscheme desert256
    endif
endif

syntax on

"set autowrite		" Automatically save before commands like :next and :make
"set cindent
set backspace=indent,eol,start	" more powerful backspacing
set backup		" keep a backup file
set backupskip+=*.tmp
set cursorline
set foldnestmax=2
set formatoptions=crq
set hidden
set history=1000
set hlsearch
set ignorecase		" Do case insensitive matching
set incsearch
set linebreak
set listchars=tab:>-,eol:<,precedes:<,extends:>
set modeline
set mouse=a
set noautoindent
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set printoptions=paper:letter
set ruler		" show the cursor position all the time
set scrolloff=5
set shiftwidth=4 " when using < or >
set showbreak=>\ 
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set showmode
set sidescroll=10
set smartcase " only ignore case when pattern contains just lowercase letters
set softtabstop=4
"set tabstop=4
set tags+=../tags;,../TAGS
"set textwidth=0		" Don't wrap words by default
set visualbell
set wildignore+=*.o,*.pyc
set wildmode=longest,list " don't automatically cycle through completions

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

if has("autocmd")
 " Enabled file type detection
 " Use the default filetype settings. If you also want to load indent files
 " to automatically do language-dependent indenting add 'indent' as well.
 filetype plugin on
 filetype indent on

 autocmd Bufenter *.mdwn setfiletype ikiwiki
 autocmd Filetype c setlocal sts=4 sw=4
 autocmd Filetype c++ setlocal sts=4 sw=4
 autocmd Filetype debchangelog setlocal et sts=2 indentexpr=4
 autocmd Filetype html setlocal tw=79
 autocmd Filetype perl setlocal et sts=4 sw=4
 autocmd Filetype python setlocal et sts=4 sw=4 foldmethod=indent
 autocmd Filetype ruby setlocal et
 autocmd Filetype sh setlocal et isf-==
 autocmd Filetype svn setlocal nobackup
 autocmd Filetype tex setlocal tw=70
 autocmd Filetype xml setlocal et sw=2 sts=2

 " Return to last edit position
 autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
endif " has ("autocmd")

" The following are commented out as they cause vim to behave a lot
" different from regular vi. They are highly recommended though.

" Make cursor keys ignore wrapping in insert or visual mode
map j gj
map k gk
map <Down> gj
map <Up> gk
if v:version >= 700
  inoremap <Down> <C-R>=pumvisible() ? "\<lt>Down>" : "\<lt>C-O>gj"<CR>
  inoremap <Up> <C-R>=pumvisible() ? "\<lt>Up>" : "\<lt>C-O>gk"<CR>
endif

" Many shells allow editing in "Emacs Style".
" Although I love Vi, I am quite used to this kind of editing now.
" So here it is - command line editing commands in emacs style:
map <C-A> <Home>
"  map <C-F> <Right>
"  map <C-B> <Left>
map <C-E> <End>
map <C-D> <Delete>
cmap <C-A> <Home>
cmap <C-E> <End>
cmap <C-D> <Delete>
inoremap <C-A> <Home>
inoremap <C-E> <End>
inoremap <C-D> <Delete>
  
function! TShowBreak()
  if &showbreak == ''
    set showbreak=>\ 
  else
    set showbreak=
  endif
endfunction

map <C-S> <Esc>:update<CR>
inoremap <C-S> <Esc>:update<CR>a
map <C-\> :nohlsearch<CR>
map <leader>d :cd %:p:h<CR> " go to directory of current file
map <leader>o <Esc>:set paste! linebreak!<CR>:call TShowBreak()<CR>:set paste?<CR>
map <leader>tt :tabnew<CR>

let g:is_posix=1 " shell scripts are posix-compliant
let is_mzscheme=1 " for special mzscheme syntax where applicable

" Width # will set all width preferences to #
command! -nargs=1 Width setlocal sw=<args> sts=<args>

runtime ftplugin/man.vim
