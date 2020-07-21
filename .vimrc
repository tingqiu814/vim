set nocompatible              " be iMproved, required
filetype off                  " required

let g:go_version_warning = 0
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Bundle 'Valloric/YouCompleteMe'

Plugin 'fatih/vim-go'
Plugin 'Valloric/YouCompleteMe'

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" tree
Plugin 'scrooloose/nerdtree'

" theme color
Plugin 'davidklsn/vim-sialoquent'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" 自动补全括号
Plugin 'jiangmiao/auto-pairs'
" 文件搜索
Plugin 'kien/ctrlp.vim'
" 缩进虚线
" Plugin 'Yggdroot/indentLine'
" ctrl I 切换显示
" map <C-I> :IndentLinesToggle<CR>
" Ag
Plugin 'rking/ag.vim'

" Plugin 'vim-scripts/indentpython.vim'

" c-n NerdTree
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

set expandtab
set sw=2
set ts=2
set hls nu
set paste
set ic
filetype indent on

" autocmd FileType go nmap <Leader>r :!go run %<CR>
autocmd FileType go nmap <F5> :!go run %<CR>

" 按F5运行python
map <F5> :call RunPython()<CR>
function RunPython()
    let mp = &makeprg
    let ef = &errorformat
    let exeFile = expand("%:t")
    setlocal makeprg=python\ -u
    set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
    silent make %
    copen
    let &makeprg = mp
    let &errorformat = ef
endfunction


" run goimports fmt when write
autocmd BufWritePre *.go :GoImports
" set runtimepath^=~/.vim/bundle/ag
"调用ag进行搜索提升速度，同时不使用缓存文件
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_use_caching = 0
endif

" ag
" command! -bang -nargs=* Ag
"   \ call fzf#vim#ag(<q-args>,
"   \                 <bang>0 ? fzf#vim#with_preview('up:60%')
"   \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
"   \                 <bang>0)
nnoremap <silent> <C-A> :Ag<CR>

" git 侧边栏
Plugin 'airblade/vim-gitgutter'
nmap [c <Plug>(GitGutterPrevHunk)
nmap ]c <Plug>(GitGutterNextHunk)
" git 状态栏
Plugin 'vim-airline/vim-airline'

"
Plugin 'tpope/vim-fugitive'
