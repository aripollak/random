" vim: set et sts=2 sw=2:
if ($TERM =~ ".*-256color" || $TERM == "screen") && has("termguicolors")
  set termguicolors
  let g:airline_powerline_fonts = 1
end
set background=dark
colorscheme desert

syntax on

set autoread
set backspace=indent,eol,start  " more powerful backspacing
set backup
set backupdir=~/.vim/backup
set backupskip+=*.tmp
set clipboard=unnamedplus
"    set colorcolumn=81      " shows an ugly red bar down this column
set display+=lastline
set foldlevelstart=2
set foldminlines=5
set foldnestmax=4
set formatoptions+=j
set grepformat=%f:%l:%c:%m
set grepprg=ag\ --vimgrep
set guifont=Monospace\ 10
set history=1000
set hlsearch
set ignorecase          " Do case insensitive matching
set incsearch
set linebreak
set matchtime=2
set modeline
set mouse=a
set noautoindent
if has("balloon_eval")
  set noballooneval       " disable vim-ruby's annoying tooltip
endif
set nocompatible        " Use Vim defaults instead of 100% vi compatibility
set nojoinspaces
set printoptions=paper:letter
set re=1                " works around really slow ruby syntax highlighting in schema.rb
set ruler               " show the cursor position all the time
set scrolloff=5
set shiftround
set showbreak=>\ 
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
  " Highlight long lines over 100 chars
  highlight ExtraWhitespace ctermbg=red guibg=red
  autocmd BufEnter *.mdwn setfiletype ikiwiki
  autocmd BufEnter *.rabl setfiletype ruby
  autocmd FocusGained * checktime " work around https://github.com/neovim/neovim/issues/1936
  autocmd FileType c,c++,coffee,javascript,perl,python,ruby,sh match ExtraWhitespace '\%>100c.\+'
  autocmd FileType coffee setlocal et sts=2 sw=2 foldmethod=indent
  autocmd FileType css,html,scss setlocal et sts=2 sw=2
  autocmd FileType debchangelog setlocal et nobackup spell sts=2 indentexpr=4
  autocmd FileType gitcommit setlocal nobackup spell sts=2 sw=2 tw=72
  autocmd FileType javascript setlocal et sts=2 sw=2
  autocmd FileType markdown setlocal spell
  autocmd FileType python setlocal et sts=4 sw=4 foldmethod=indent
  autocmd FileType ruby setlocal et sts=2 sw=2 tw=100 foldmethod=indent
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

map <C-P> :FZF<CR>
map <C-S> <Esc>:update<CR>
inoremap <C-S> <Esc>:update<CR>a
map <F10> <Esc>:Dispatch<CR>
inoremap <F10> <Esc>:Dispatch<CR>a
" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif
" leader is \ by default, so this command is \d:
map <leader>d :cd %:p:h<CR> " go to directory of current file
map <leader>fa :FzfAg 
map <leader>fb :FzfBuffers<CR>
map <leader>fh :FzfHistory<CR>
map <leader>ft :FzfTags<CR>
map <leader>fw :FzfWindows<CR>
map <leader>l :set list!<CR>:set list?<CR>
map <leader>nd :edit .<CR>
map <leader>nn :Explore<CR>
map <leader>ns :Sexplore<CR>
map <leader>nt :Texplore<CR>
" toggle paste mode:
map <leader>o <Esc>:set paste! linebreak!<CR>:call TShowBreak()<CR>:set paste?<CR>
map <leader>tt :tabnew<CR>
map <leader>yg :YamlGoToKey
map <leader>yp :YamlGetFullPath<CR>
map <leader>yu :YamlGoToParent<CR>
map <leader>z :!zeal "<cword>"&<CR><CR>
" :w!! will save the file as root
cmap w!! w !sudo tee %

function! AirlineThemePatch(palette)
  let g:airline#themes#dark#palette.inactive.airline_c[1] = '#202020'
endfunction

let python_highlight_all = 1
let ruby_space_errors = 1
let g:airline_theme_patch_func = 'AirlineThemePatch'
let g:fzf_command_prefix = 'Fzf'
let $FZF_DEFAULT_COMMAND = 'ag -l'
let $FZF_DEFAULT_OPTS = '--multi --history=' . $HOME . '/.cache/fzf_history'
let g:indent_guides_start_level = 2
let g:netrw_hide = 1
let g:neomake_ruby_enabled_makers = ['rubocop']
let g:rails_ctags_arguments = ['--languages=JavaScript,Ruby', '--exclude=node_modules', '--exclude=vendor']

" :Width # will set all width preferences to #
command! -nargs=1 Width setlocal sw=<args> sts=<args>

silent! call plug#begin('~/.vim/plugged')
if exists('g:loaded_plug')
  Plug 'junegunn/fzf', { 'tag': '0.18.0', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim', { 'commit': '39f0c2d' }
  Plug 'kana/vim-textobj-user', { 'tag': '0.7.6' }
  Plug 'kchmck/vim-coffee-script'
  Plug 'lmeijvogel/vim-yaml-helper', { 'commit': '59549c3d' }
  Plug 'michaeljsmith/vim-indent-object'
  Plug 'nathanaelkane/vim-indent-guides', { 'commit': '705c5fd' }
  Plug 'nelstrom/vim-textobj-rubyblock', { 'tag': '0.0.3' }
  Plug 'neomake/neomake', { 'commit': 'b8a3963' }
  Plug 'radenling/vim-dispatch-neovim'
  Plug 'tommcdo/vim-exchange', { 'commit': '4589b30' }
  Plug 'tpope/vim-abolish', { 'tag': 'v1.1' }
  Plug 'tpope/vim-bundler', { 'commit': 'b42217a' }
  Plug 'tpope/vim-commentary', { 'commit': '73e0d9a' }
  Plug 'tpope/vim-dispatch', { 'commit': '178acd0' }
  Plug 'tpope/vim-endwise', { 'tag': 'v1.2' }
  Plug 'tpope/vim-fugitive', { 'commit': 'bd0b87d' }
  Plug 'tpope/vim-rails', { 'commit': '0abcda9' }
  Plug 'tpope/vim-repeat', { 'tag': 'v1.1' }
  Plug 'tpope/vim-rsi', { 'commit': 'dfc5288' }
  Plug 'tpope/vim-surround', { 'commit': '2d05440' }
  Plug 'vim-airline/vim-airline', { 'commit': '86e73ca' }
  call plug#end()
  call neomake#configure#automake('w')
endif

filetype plugin indent on
