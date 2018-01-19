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

  autocmd! BufEnter *_spec.rb let b:dispatch = '-compiler=rails spring rspec %'
  autocmd! BufEnter *_test.rb let b:dispatch = '-compiler=rails spring testunit %'

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
let g:is_posix = 1 " shell scripts are posix-compliant
let g:netrw_hide = 1
let g:neomake_javascript_enabled_makers = ['eslint', 'flow']
let g:neomake_javascript_eslint_exe = $PWD . '/node_modules/.bin/eslint'
let g:neomake_javascript_flow_exe = $PWD . '/node_modules/.bin/flow'
let g:rails_ctags_arguments = ['--languages=JavaScript,Ruby', '--exclude=node_modules', '--exclude=vendor']

" :Width # will set all width preferences to #
command! -nargs=1 Width setlocal sw=<args> sts=<args>

set runtimepath+=~/.vim/bundle/neobundle.vim
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim', 'ver.4.0'
NeoBundle 'elixir-lang/vim-elixir'
NeoBundle 'neomake/neomake', 'b8a3963'
NeoBundle 'kana/vim-textobj-user', '0.7.1'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'junegunn/fzf', '0.17.0', { 'build' : { 'linux' : './install --bin' } }
NeoBundle 'junegunn/fzf.vim', '39f0c2d'
NeoBundle 'lmeijvogel/vim-yaml-helper', '59549c3d'
NeoBundle 'nathanaelkane/vim-indent-guides', '705c5fd'
NeoBundle 'nelstrom/vim-textobj-rubyblock', '0.0.3'
NeoBundle 'radenling/vim-dispatch-neovim', 'c8c4e21'
NeoBundle 'tommcdo/vim-exchange', '4589b30'
NeoBundle 'tpope/vim-abolish', 'v1.1'
NeoBundle 'tpope/vim-bundler', 'b42217a'
NeoBundle 'tpope/vim-commentary', '73e0d9a'
NeoBundle 'tpope/vim-dispatch', 'dafa941'
NeoBundle 'tpope/vim-endwise', 'v1.2'
NeoBundle 'tpope/vim-fugitive', '06af328'
NeoBundle 'tpope/vim-rails', '0abcda9'
NeoBundle 'tpope/vim-repeat', 'v1.1'
NeoBundle 'tpope/vim-rsi', 'dfc5288'
NeoBundle 'tpope/vim-surround', '2d05440'
NeoBundle 'vim-airline/vim-airline', '7df411d'
call neobundle#end()
NeoBundleCheck
filetype plugin indent on
call neomake#configure#automake('w')
