" Use the Solarized Dark theme
set background=dark
colorscheme gruvbox

" Make Vim more useful
set nocompatible
" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
" Enhance command-line completion
set wildmenu
" Allow cursor keys in insert mode
"set esckeys
" Allow backspace in insert mode
set backspace=indent,eol,start
" Optimize for fast terminal connections
set ttyfast
" Add the g flag to search/replace by default
set gdefault
" Use UTF-8 without BOM
set encoding=utf-8 nobomb
" Change mapleader
let mapleader=","
" Don’t add empty newlines at the end of files
set binary
set noeol
" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
	set undodir=~/.vim/undo
endif

" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Respect modeline in files
set modeline
set modelines=4
" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure
" Enable line numbers
set number
" Enable syntax highlighting
syntax on
" Highlight current line
set cursorline
" Make tabs as wide as four spaces
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list
" Highlight searches
set hlsearch
" Ignore case of searches
set ignorecase
" Highlight dynamically as pattern is typed
set incsearch
" Always show status line
set laststatus=2
" Enable mouse in all modes
set mouse=a
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Show the cursor position
set ruler
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd
" Use relative line numbers
if exists("&relativenumber")
	set relativenumber
	au BufReadPost * set relativenumber
endif
" Start scrolling three lines before the horizontal window border
set scrolloff=3

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>
" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Automatic commands
if has("autocmd")
	" Enable file type detection
	filetype on
	" Treat .json files as .js
	autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
	" Treat .md files as Markdown
	autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
	autocmd FileType typescript setlocal formatprg=prettier\ --parser\ typescript
endif

" set the runtime path to include Vundle and initialize
"set rtp+=~/.vim/bundle/Vundle.vim
"call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
"Plugin 'VundleVim/Vundle.vim'
" All of your Plugins must be added before the following line
"call vundle#end()            " required

call plug#begin('~/.vim/plugged')
Plug 'Quramy/tsuquyomi'
"Plug 'HerringtonDarkholme/yats.vim'
"Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
Plug 'leafgarland/typescript-vim'
" For async completion
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'Shougo/echodoc.vim',
" For Denite features
Plug 'Shougo/denite.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'mileszs/ack.vim'

Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

Plug 'flazz/vim-colorschemes'
Plug 'morhetz/gruvbox'
Plug 'christoomey/vim-tmux-navigator'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Yggdroot/indentLine'

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'dense-analysis/ale'

"Plug 'prettier/vim-prettier', {
"  \ 'do': 'npm install',
"  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
" Initialize plugin system
call plug#end()
let g:deoplete#enable_at_startup = 1
let g:echodoc_enable_at_startup = 1
let g:echodoc#type = 'virtual'
"let g:nvim_typescript#default_mappings = 1
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ deoplete#mappings#manual_complete()
function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

let g:tsuquyomi_use_local_typescript = 0

"set rtp+=/usr/local/opt/fzf

"let g:ale_completion_enabled = 1
"let g:ale_completion_tsserver_autoimport = 1


let g:ale_linters = {
\   'javascript': ['eslint'],
\   'typescript': ['tsserver', 'tslint']
\}

let g:ale_fixers = {'typescript': ['tslint', 'prettier']}

" Bind F8 to fixing problems with ALE
nmap <F8> <Plug>(ale_fix)
let g:ale_fix_on_save = 1
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
  let g:ack_default_options =
              \ " -s -H --nocolor --nogroup --column --smart-case"

endif

let g:tmux_navigator_save_on_switch = 2
noremap <leader>a  :Ag <C-r>=expand('<cword>')<CR><CR>
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL

"let g:ackprg = 'ag --nogroup --nocolor --column'