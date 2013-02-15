" Configuration file for vim
" vim: set et ts=2 sts=2:

set background=dark
if &term =~ "xterm"
  set t_Co=256
endif
colorscheme desert

syntax on

"set autowrite		" Automatically save before commands like :next and :make
set backspace=indent,eol,start	" more powerful backspacing
set backup
set backupdir=~/.vim/backup
set backupskip+=*.tmp
"    set colorcolumn=81      " shows an ugly red bar down this column
set cursorline
set foldminlines=5
set foldnestmax=3
set formatoptions=crq
set guifont=Monospace\ 10
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
" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
"set tabstop=4
set tags+=../tags;,../TAGS
"set textwidth=0		" Don't wrap words by default
set undodir=~/.vim/backup
set undofile " omg why is this not on by default
set visualbell
set wildignore+=*.o,*.pyc
set wildmode=longest,list " don't automatically cycle through completions

if has("autocmd")
  " Enabled file type detection
  " Use the default filetype settings. If you also want to load indent files
  " to automatically do language-dependent indenting add 'indent' as well.
  filetype plugin indent on

  " Highlight long lines over 100 chars
  highlight ExtraWhitespace ctermbg=red guibg=red
  autocmd Filetype c,c++,javascript,perl,python,ruby,sh match ExtraWhitespace '\%>100c.\+'
  autocmd Bufenter *.mdwn setfiletype ikiwiki
  autocmd Bufenter *.mdwn setlocal spell
  autocmd Bufenter *.rabl setfiletype ruby
  autocmd Filetype c setlocal sts=4 sw=4
  autocmd Filetype c++ setlocal sts=4 sw=4
  autocmd Filetype debchangelog setlocal et sts=2 indentexpr=4
  autocmd Filetype git setlocal nobackup
  autocmd Filetype html setlocal tw=79
  autocmd Filetype javascript setlocal et
  autocmd Filetype perl setlocal et sts=4 sw=4
  autocmd Filetype puppet setlocal et sts=2 sw=2
  autocmd Filetype python setlocal et sts=4 sw=4 foldmethod=indent
  autocmd Filetype ruby setlocal et sw=2 sts=2 foldmethod=syntax
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

" abbreviations
abbrev ARL ActiveRecord::Base.logger = Logger.new(STDOUT)

" Make cursor keys ignore wrapping in insert or visual mode
map j gj
map k gk
map <Down> gj
map <Up> gk
inoremap <Down> <C-R>=pumvisible() ? "\<lt>Down>" : "\<lt>C-O>gj"<CR>
inoremap <Up> <C-R>=pumvisible() ? "\<lt>Up>" : "\<lt>C-O>gk"<CR>

" Emacs-style navigation
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
" leader is \ by default, so this command is \d:
map <leader>d :cd %:p:h<CR> " go to directory of current file
map <leader>nf :NERDTreeFind<CR>
map <leader>nn :NERDTreeToggle<CR>
" toggle paste mode:
map <leader>o <Esc>:set paste! linebreak!<CR>:call TShowBreak()<CR>:set paste?<CR>
map <leader>tt :tabnew<CR>
" :w!! will save the file as root
cmap w!! w !sudo tee %

let python_highlight_all=1
let ruby_space_errors=1
let g:is_posix=1 " shell scripts are posix-compliant
let g:ctrlp_open_new_file = 't'
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1

" alias :ConqueTerm to :Term:
command! -nargs=+ Term ConqueTerm <args>
command! Zsh ConqueTerm zsh

" :Width # will set all width preferences to #
command! -nargs=1 Width setlocal sw=<args> sts=<args>

runtime ftplugin/man.vim
call pathogen#infect() " requires https://github.com/tpope/vim-pathogen
