" Configuration file for vim
" vim: set et sts=2:

set background=dark
if &term =~ "xterm"
  set t_Co=256
endif
colorscheme desert

syntax on

set autoread
set backspace=indent,eol,start	" more powerful backspacing
set backup
set backupdir=~/.vim/backup
set backupskip+=*.tmp
set clipboard=unnamedplus
"    set colorcolumn=81      " shows an ugly red bar down this column
set display+=lastline
set foldlevelstart=2
set foldminlines=5
set foldnestmax=4
set formatoptions=crq
set guifont=Monospace\ 10
set hidden
set history=1000
set hlsearch
set ignorecase		" Do case insensitive matching
set incsearch
set linebreak
set modeline
set mouse=a
set noautoindent
if has("balloon_eval")
    set noballooneval       " disable vim-ruby's annoying tooltip
endif
set nocompatible        " Use Vim defaults instead of 100% vi compatibility
set printoptions=paper:letter
set ruler		" show the cursor position all the time
set scrolloff=5
set shiftround
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
set tags+=../tags;,../TAGS
set undodir=~/.vim/backup
set undofile " omg why is this not on by default
set visualbell
set wildignore+=*.o,*.pyc
set wildmode=longest,list " don't automatically cycle through completions

if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
  if &termencoding ==# 'utf-8' || &encoding ==# 'utf-8'
    let &listchars = "tab:\u21e5 ,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u00b7"
  endif
endif

if has("autocmd")
  " Highlight long lines over 100 chars
  highlight ExtraWhitespace ctermbg=red guibg=red
  autocmd Filetype c,c++,coffee,javascript,perl,python,ruby,sh match ExtraWhitespace '\%>100c.\+'
  autocmd Filetype *.mdwn setfiletype ikiwiki
  autocmd Bufenter *.rabl setfiletype ruby
  autocmd Filetype c setlocal sts=4 sw=4
  autocmd Filetype c++ setlocal sts=4 sw=4
  autocmd Filetype coffee setlocal et sw=2 sts=2 foldmethod=indent
  autocmd Filetype debchangelog setlocal et sts=2 indentexpr=4
  autocmd Filetype git setlocal nobackup
  autocmd Filetype html setlocal tw=79
  autocmd Filetype javascript setlocal et
  autocmd Filetype gitcommit,markdown setlocal spell
  autocmd Filetype perl setlocal et sts=4 sw=4
  autocmd Filetype puppet setlocal et sts=2 sw=2
  autocmd Filetype python setlocal et sts=4 sw=4 foldmethod=indent
  autocmd Filetype ruby setlocal et sw=2 sts=2 foldmethod=indent
  autocmd Filetype sh setlocal et isf-==
  autocmd Filetype svn setlocal nobackup
  autocmd Filetype tex setlocal tw=70
  autocmd Filetype xml setlocal et sw=2 sts=2
  autocmd Filetype yaml setlocal et sw=2 sts=2

  " Return to last edit position
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
endif " has ("autocmd")

" abbreviations
abbrev ARL ActiveRecord::Base.logger = Logger.new(STDOUT)
abbrev binpry require 'pry'; binding.pry

" Make cursor keys ignore wrapping in insert or visual mode
map j gj
map k gk
map <Down> gj
map <Up> gk
inoremap <Down> <C-R>=pumvisible() ? "\<lt>Down>" : "\<lt>C-O>gj"<CR>
inoremap <Up> <C-R>=pumvisible() ? "\<lt>Up>" : "\<lt>C-O>gk"<CR>

function! TShowBreak()
  if &showbreak == ''
    set showbreak=>\ 
  else
    set showbreak=
  endif
endfunction

map <C-S> <Esc>:update<CR>
inoremap <C-S> <Esc>:update<CR>a
" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif
" leader is \ by default, so this command is \d:
map <leader>d :cd %:p:h<CR> " go to directory of current file
map <leader>nf :NERDTreeFind<CR>
map <leader>nn :NERDTreeToggle<CR>
" toggle paste mode:
map <leader>o <Esc>:set paste! linebreak!<CR>:call TShowBreak()<CR>:set paste?<CR>
map <leader>tt :tabnew<CR>
map <leader>yg :YamlGoToKey 
map <leader>yp :YamlGetFullPath<CR>
map <leader>yu :YamlGoToParent<CR>
" :w!! will save the file as root
cmap w!! w !sudo tee %

let python_highlight_all=1
let ruby_space_errors=1
let g:is_posix=1 " shell scripts are posix-compliant
let g:ctrlp_max_height = 20
let g:ctrlp_open_new_file = 't'
let g:syntastic_ruby_checkers = ['mri', 'rubocop']

" alias :ConqueTerm to :Term:
command! -nargs=+ Term ConqueTerm <args>
command! Zsh ConqueTerm zsh

" :Width # will set all width preferences to #
command! -nargs=1 Width setlocal sw=<args> sts=<args>

runtime ftplugin/man.vim
runtime macros/matchit.vim

set runtimepath+=~/.vim/bundle/neobundle.vim
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'kana/vim-textobj-user', '0.6.3'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'kien/ctrlp.vim', 'b5d3fe66'
NeoBundle 'lmeijvogel/vim-yaml-helper', '59549c3d'
NeoBundle 'nelstrom/vim-textobj-rubyblock', '0.0.3'
NeoBundle 'scrooloose/nerdtree', 'a1433c48'
NeoBundle 'scrooloose/syntastic', 'e34f421b'
NeoBundle 'tommcdo/vim-exchange', 'f841536e'
NeoBundle 'tpope/vim-abolish', 'f0d785d9'
NeoBundle 'tpope/vim-bundler', 'v2.0'
NeoBundle 'tpope/vim-commentary', 'v1.2'
NeoBundle 'tpope/vim-dispatch', 'v1.1'
NeoBundle 'tpope/vim-endwise', 'v1.2'
NeoBundle 'tpope/vim-fugitive', 'v2.1'
NeoBundle 'tpope/vim-rails', 'v5.1'
NeoBundle 'tpope/vim-rsi', 'ec39927'
call neobundle#end()
NeoBundleCheck
filetype plugin indent on
