" Use the Solarized Dark theme
set background=dark

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

set completeopt-=preview
" Use relative line numbers
"if exists("&relativenumber")
"	set relativenumber
"	au BufReadPost * set relativenumber
"endif
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
    autocmd vimenter * ++nested colorscheme gruvbox
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
let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
call plug#begin('~/.vim/plugged')
"Plug 'Quramy/tsuquyomi'
"Plug 'HerringtonDarkholme/yats.vim'
"Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
"Plug 'leafgarland/typescript-vim'
" For async completion

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
Plug 'Shougo/echodoc.vim'
Plug 'puremourning/vimspector'
Plug 'pangloss/vim-javascript'

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'wokalski/autocomplete-flow'
  " For func argument completion
  Plug 'Shougo/neosnippet'
  Plug 'Shougo/neosnippet-snippets'
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
"Plug 'ternjs/tern_for_vim', { 'do': 'npm install && npm install -g tern' }
"Plug 'carlitux/deoplete-ternjs'


Plug 'dense-analysis/ale'

Plug 'prettier/vim-prettier', {
  \ 'do': 'npm install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
" Initialize plugin system
call plug#end()
let g:deoplete#enable_at_startup = 1
"let g:echodoc#enable_at_startup = 1
"let g:echodoc#type = 'virtual'
"let g:neosnippet#enable_completed_snippet = 1
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
"imap <C-k>     <Plug>(neosnippet_expand_or_jump)
"smap <C-k>     <Plug>(neosnippet_expand_or_jump)
"xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.

" For conceal markers.
"if has('conceal')
"  set conceallevel=2 concealcursor=niv
"endif

"let g:echodoc#type = 'virtual'
set rtp+=/opt/homebrew/Cellar/fzf/0.34.0/
noremap <leader>a  :Rg <C-r>=expand('<cword>')<CR><CR>
nnoremap <C-p> :GFiles<Cr>
nnoremap <silent> <Leader>f :Rg<CR>
nnoremap <silent> <Leader>/ :BLines<CR>
nnoremap <silent> <Leader>' :Marks<CR>
nnoremap <silent> <Leader>g :Commits<CR>
nnoremap <silent> <Leader>H :Helptags<CR>
nnoremap <silent> <Leader>h :History<CR>
"let g:ale_completion_enabled = 1
"let g:ale_completion_tsserver_autoimport = 1


let g:ale_linters = {
\   'javascript': ['tsserver', 'eslint'],
\   'typescript': ['tsserver', 'eslint']
\}

"let g:ale_fixers = {'typescript': ['eslint', 'prettier']}
let g:ale_fixers = {'javascript': ['eslint', 'prettier']}

" Bind F8 to fixing problems with ALE
nmap <F8> <Plug>(ale_fix)
let g:ale_fix_on_save = 1

function ALELSPMappings()
	let l:lsp_found=0
	for l:linter in ale#linter#Get(&filetype) | if !empty(l:linter.lsp) | let l:lsp_found=1 | endif | endfor
	if (l:lsp_found)
		nnoremap <buffer> <C-]> :ALEGoToDefinition<CR>
		nnoremap <buffer> <C-^> :ALEFindReferences<CR>
	else
		silent! unmap <buffer> <C-]>
		silent! unmap <buffer> <C-^>
	endif
endfunction
autocmd BufRead,FileType * call ALELSPMappings()

let g:tmux_navigator_save_on_switch = 2
let g:NERDTreeWinSize=45
let g:vimspector_base_dir='/Users/mihail.andritchi@fintecture.com/.vim/plugged/vimspector'
let g:javascript_plugin_jsdoc = 1

colorscheme gruvbox
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL

