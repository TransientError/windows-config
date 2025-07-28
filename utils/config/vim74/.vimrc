" I use an airgapped device that can only suport vim74
" I also have to manually install plugins with pathogen

execute pathogen#infect()
" vim-surround
" vim-commentary
" material-theme
" nerdtree
" vim-over
" vim-whichkey
" emmet-vim
" vim-easymotion 
" vim-closetag
" vim-ps1
" vimwiki

syntax on
filetype plugin indent on

set guifont=Lucida\ Console:h14
set guioptions-=m
set guioptions-=T
set guioptions-=r

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
set backspace=indent,eol,start
set incsearch

let mapleader="\<space>"
let g:over_enable_auto_nohlsearch = 1
let g:over#command_line#substitute#replace_pattern_visually = 1
let g:over_enable_cmd_window = 1

nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
nmap s <Plug>(easymotion-overwin-f2)
nmap f <Plug>(easymotion-overwin-f)
let g:EasyMotion_smartcase = 1

nnoremap <leader>qq :qa!<CR>
nnoremap <leader>qr :!taskkill /im gvim.exe /f && gvim && exit /b<CR>
nnoremap <leader>fp :e! ~/.vimrc<CR>
nnoremap <leader>hrr :source ~/.vimrc<CR>

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

" vimwiki
nnoremap <leader>t :VimwikiToggleListItem<CR>
nnoremap <tab> :VimwikiToggleListItem<CR>

" autocmd
autocmd VimResized * :wincmd =
