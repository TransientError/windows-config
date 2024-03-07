" I use an airgapped device that can only suport vim74
" I also have to manually install plugins with pathogen

execute pathogen#infect()
" vim-surround
" vim-commentary
" material-theme
" nerdtree
" vim-over

syntax on
filetype plugin indent on

set guifont=Lucida\ Console:h14
if has("gui_running")
  let g:material_theme_style="dark"
  colorscheme material
endif

set list lcs=tab:->,trail:-

set expandtab
set ignorecase
set smartcase
set shiftwidth=2
set tabstop=2
set number
set relativenumber

let &t_SI = "\<Esc>[6 q"
let &t_EI = "\<Esc>[2 q"

let mapleader="\<space>"

nnoremap <space>qq :qa!<CR>
nnoremap <space>fp :e! ~/.vimrc<CR>
nnoremap <space>hrr :source ~/.vimrc<CR>

" windows
nnoremap <leader>wh :wincmd h<CR>
nnoremap <leader>wj :wincmd j<CR>
nnoremap <leader>wk :wincmd k<CR>
nnoremap <leader>wl :wincmd l<CR>
nnoremap <leader>ws :wincmd s<CR>
nnoremap <leader>wv :wincmd v<CR>
nnoremap <leader>w= :wincmd =<CR>
nnoremap <leader>wd :close<CR>
nnoremap <leader>bl <C-o>
nnoremap <Esc><Esc> :noh<CR>

"nerdtree
nnoremap <leader>op :NERDTreeToggle<CR>

"buffers
nnoremap <leader>bd :bdelete!<CR>
nnoremap <leader>b] :bnext<CR>
nnoremap <leader>b[ :bprevious<CR>

" autocmd
autocmd VimResized * :wincmd =

set backspace=indent,eol,start
