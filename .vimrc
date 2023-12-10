" vim: set et sts=2 sw=2:
syntax on

set autoread
set backspace=indent,eol,start  " more powerful backspacing
set backup
set backupdir=~/.vim/backup
set backupskip+=*.tmp
set clipboard=unnamedplus
set conceallevel=2
set display+=lastline
set foldlevelstart=2
set foldminlines=5
set foldnestmax=4
set formatoptions+=j
set grepformat=%f:%l:%c:%m
set grepprg=rg\ --vimgrep
set guifont=Monospace\ 10
set history=1000
set hlsearch
set ignorecase          " Do case insensitive matching
if exists("&inccommand")
  set inccommand=split
endif
set incsearch
set matchtime=2
set mouse=a
set noautoindent
set nocompatible        " Use Vim defaults instead of 100% vi compatibility
set nojoinspaces
set ruler               " show the cursor position all the time
set scrolloff=5
set shiftround
set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set showmode
set sidescroll=10
set smartcase " only ignore case when pattern contains just lowercase letters
" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set tags+=../tags;,../TAGS
set title
set undodir=~/.vim/backup
set undofile " omg why is this not on by default
set visualbell
set wildignore+=*.o,*.pyc
set wildmode=longest,list " don't automatically cycle through completions

set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
if &termencoding ==# 'utf-8' || &encoding ==# 'utf-8'
  let &listchars = "tab:\u21e5 ,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u00b7"
endif

if has("autocmd")
  autocmd BufNewFile,BufRead *.rabl setlocal filetype=ruby
  autocmd BufNewFile,BufRead .eslintrc.json setlocal filetype=jsonc
  autocmd BufNewFile,BufRead tsconfig.json setlocal filetype=jsonc
  autocmd FileType coffee setlocal et sts=2 sw=2 foldmethod=indent
  autocmd FileType css,html,scss setlocal et sts=2 sw=2
  autocmd FileType debchangelog setlocal et nobackup spell sts=2 indentexpr=4
  autocmd FileType gitcommit setlocal nobackup spell sts=2 sw=2 tw=72
  autocmd FileType javascript,javascriptreact,typescript,typescriptreact setlocal et sts=2 sw=2
  autocmd FileType json setlocal et sts=2 sw=2
  autocmd FileType lua setlocal et sts=2 sw=2
  autocmd FileType markdown setlocal spell
  autocmd FileType cfg,python setlocal et sts=4 sw=4 foldmethod=indent
  autocmd FileType ruby,rspec setlocal et sts=2 sw=2 tw=100 foldmethod=indent
  autocmd FileType sh setlocal et isf-==
  autocmd FileType vim setlocal et sts=2 sw=2
  autocmd FileType xml setlocal et sts=2 sw=2
  autocmd FileType yaml setlocal et sts=2 sw=2

  " Return to last edit position
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
endif " has ("autocmd")

" abbreviations
abbrev ARL ActiveRecord::Base.logger = Logger.new(STDOUT)
abbrev binpry require 'pry'; binding.pry
abbrev ipyrepl import IPython; IPython.embed()

" Make cursor keys ignore wrapping in insert or visual mode
map j gj
map k gk
map <Down> gj
map <Up> gk

map <C-S> <Esc>:update<CR>
inoremap <C-S> <Esc>:update<CR>a
" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif
" leader is \ by default, so this command is \d:
map <leader>d :cd %:p:h<CR> " go to directory of current file
map <leader>l :set list!<CR>:set list?<CR>
map <leader>nd :edit .<CR>
map <leader>ne :Ntree<CR>
map <leader>nn :Explore<CR>
map <leader>ns :Sexplore<CR>
map <leader>nt :Texplore<CR>
" toggle paste mode:
map <leader>o <Esc>:set paste!<CR>:set paste?<CR>
map <leader>tt :tabnew<CR>

let python_highlight_all = 1
let ruby_space_errors = 1
let g:airline_theme = 'powerlineish'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#format = 2
let g:airline#extensions#default#section_truncate_width = {
    \ 'b': 90, 'x': 90, 'y': 90, 'z': 45, 'warning': 80, 'error': 80, }
let g:airline_highlighting_cache = 1
let g:indent_bar_set_conceal = 0
let g:netrw_hide = 1

" :Width # will set all width preferences to #
command! -nargs=1 Width setlocal sw=<args> sts=<args>

silent! call plug#begin('~/.vim/plugged')
if exists('g:loaded_plug')
  Plug 'airblade/vim-gitgutter', { 'commit': '400a120' }
  Plug 'gko/vim-coloresque', { 'commit': 'e12a500' }
  Plug 'hashivim/vim-terraform'
  Plug 'iibe/gruvbox-high-contrast'
  Plug 'juniway/indent-bar'
  Plug 'kana/vim-textobj-user', { 'tag': '0.7.6' }
  Plug 'michaeljsmith/vim-indent-object'
  Plug 'MaxMEllon/vim-jsx-pretty'
  Plug 'nelstrom/vim-textobj-rubyblock', { 'tag': '0.0.3' }
  Plug 'tommcdo/vim-exchange', { 'commit': '17f1a2c' }
  Plug 'tpope/vim-abolish', { 'tag': 'v1.1' }
  Plug 'tpope/vim-bundler', { 'tag': 'v2.2' }
  Plug 'tpope/vim-commentary', { 'commit': 'f8238d7' }
  Plug 'tpope/vim-dispatch', { 'commit': '6cc2691' }
  Plug 'tpope/vim-endwise', { 'commit': 'bf90d8b' }
  Plug 'tpope/vim-fugitive', { 'tag': 'v3.7' }
  Plug 'tpope/vim-rails', { 'commit': '1ad9663' }
  Plug 'tpope/vim-rhubarb'
  Plug 'tpope/vim-repeat', { 'tag': 'v1.2' }
  Plug 'tpope/vim-rsi', { 'commit': 'e181883' }
  Plug 'tpope/vim-surround', { 'commit': 'f51a26d' }
  Plug 'vim-airline/vim-airline', { 'commit': 'e6bb842' }
  Plug 'vim-airline/vim-airline-themes'
  call plug#end()
endif

filetype plugin indent on

if has("termguicolors")
  set termguicolors
  let g:airline_powerline_fonts = 1
  let g:gruvbox_contrast_light = 'hard'
  let g:gruvbox_contrast_dark = 'hard'
  colorscheme gruvbox-high-contrast
end
