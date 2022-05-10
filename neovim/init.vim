call plug#begin('~/.local/share/nvim/plugged')
Plug 'kaicataldo/material.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'lambdalisue/suda.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'sbdchd/neoformat'
Plug 'jparise/vim-graphql'
Plug 'alvan/vim-closetag'
Plug 'easymotion/vim-easymotion'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-commentary'
call plug#end()

set colorcolumn=120
set expandtab shiftwidth=2
set mouse=a
set number relativenumber
set list listchars=tab:▸▸,trail:·
set smartcase
set autochdir

let g:closetag_filenames = '*.html,*.xml,*.plist,*.*proj'

let g:lightline = { 'colorscheme': 'material_vim' }
let g:material_theme_style = 'dark'
set background=dark
colorscheme material

nmap == :Neoformat<CR>

if (has("termguicolors"))
  set termguicolors
endif

let mapleader = "\<Space>"
map <leader>wh :wincmd h<CR>
map <leader>wj :wincmd j<CR>
map <leader>wk :wincmd k<CR>
map <leader>wl :wincmd l<CR>
map <leader>ws :wincmd s<CR>
map <leader>wv :wincmd v<CR>
map <leader>wd :q<CR>
map <leader>cf :Neoformat<CR>

let g:EasyMotion_smartcase = 1
" search
map / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

map n <Plug>(easymotion-next)
map N <Plug>(easymotion-prev)

" snipe
nmap s <Plug>(easymotion-s2)
