set ts=4
set nu
set expandtab
set history=200
syntax on  " 自动语法高亮
set hls    "高亮搜索内容
cnoremap <expr> %% getcmdtype( ) == ':' ? expand('%:h').'/' : '%%'     "将:edit %%转换成%:h
"开启自带插件
set nocompatible      
filetype plugin on
"将方向键禁用
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

set background=dark
"set cursorline              " 突出显示当前行
"set ruler                   " 打开状态栏标尺
"set nobackup                " 覆盖文件时不备份
"set autochdir               " 自动切换当前目录为当前文件所在的目录
set ignorecase smartcase    " 搜索时忽略大小写，但在有一个或以上大写字母时仍保持对大小写敏感
set noerrorbells            " 关闭错误信息响铃
set showmatch               " 插入括号时，短暂地跳转到匹配的对应括号
set matchtime=2             " 短暂跳转到匹配括号的时间
set autoindent    
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
nnoremap <F5> :!ctags -R<CR>
source /usr/share/vim/vim73/autoload/php-doc.vim
inoremap <C-P> <ESC>:ccall PhpDocSingle()<CR>i
nnoremap <C-p> :call PhpDocSingle()<CR>
vnoremap <C-p> :call PhpDocSingle()<CR>
let g:neocomplcache_enable_at_startup = 1
let Tlist_Ctags_Cmd='/usr/bin/ctags'

let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Use_Right_Window=1
