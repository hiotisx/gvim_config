source $VIMRUNTIME/vimrc_example.vim

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

"General - 通用配置
set nocompatible
set nobackup
set noswapfile
set history=1024
set autochdir
set whichwrap=b,s,<,>,[,]
set nobomb
set backspace=indent,eol,start whichwrap+=<,>,[,]
" Vim 的默认寄存器和系统剪贴板共享
set clipboard+=unnamed
" 设置 alt 键不映射到菜单栏
set winaltkeys=no

"Lang & Encoding - 语言和编码
set fileencodings=utf-8,gbk2312,gbk,gb18030,cp936
set encoding=utf-8
set langmenu=zh_CN
let $LANG = 'en_US.UTF-8'
"language messages zh_CN.UTF-8

"GUI - 界面
colorscheme Tomorrow-Night

source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
set cursorline
set hlsearch
set number
" 窗口大小
set lines=35 columns=140
" 分割出来的窗口位于当前窗口下边/右边
set splitbelow
set splitright
"不显示工具/菜单栏
set guioptions-=T
set guioptions-=m
set guioptions-=L
set guioptions-=r
set guioptions-=b
" 使用内置 tab 样式而不是 gui
set guioptions-=e
set nolist
" set listchars=tab:?\ ,eol:?,trail:·,extends:>,precedes:<
set guifont=Inconsolata:h12:cANSI

"Format - 基本的代码格式
set autoindent
set smartindent
set tabstop=4
set expandtab
set softtabstop=4
set foldmethod=indent
syntax on

"Keymap - 通用的快捷键
let mapleader=","

nmap <leader>s :source $VIM/_vimrc<cr>
nmap <leader>e :e $VIM/_vimrc<cr>

map <leader>tn :tabnew<cr>
map <leader>tc :tabclose<cr>
map <leader>th :tabp<cr>
map <leader>tl :tabn<cr>

" 移动分割窗口
nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l

" 正常模式下 alt+j,k,h,l 调整分割窗口大小
nnoremap <M-j> :resize +5<cr>
nnoremap <M-k> :resize -5<cr>
nnoremap <M-h> :vertical resize -5<cr>
nnoremap <M-l> :vertical resize +5<cr>

" 插入模式移动光标 alt + 方向键
inoremap <M-j> <Down>
inoremap <M-k> <Up>
inoremap <M-h> <left>
inoremap <M-l> <Right>

" IDE like delete
inoremap <C-BS> <Esc>bdei

nnoremap vv ^vg_
" 转换当前行为大写
inoremap <C-u> <esc>mzgUiw`za
" 命令模式下的行首尾
cnoremap <C-a> <home>
cnoremap <C-e> <end>

nnoremap <F2> :setlocal number!<cr>
nnoremap <leader>w :set wrap!<cr>

imap <C-v> "+gP
vmap <C-c> "+y
vnoremap <BS> d
vnoremap <C-C> "+y
vnoremap <C-Insert> "+y
imap <C-V>		"+gP
map <S-Insert>		"+gP
cmap <C-V>		<C-R>+
cmap <S-Insert>		<C-R>+

exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']

" 打开当前目录 windows
map <leader>ex :!start explorer %:p:h<CR>

" 打开当前目录CMD
map <leader>cmd :!start<cr>
" 打印当前时间
map <F3> a<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR><Esc>
" 把切换函数列表的功能绑定到 F2 功能键上
map <F2> : Flisttoggle <CR>

" 复制当前文件/路径到剪贴板
nmap ,fn :let @*=substitute(expand("%"), "/", "\\", "g")<CR>
nmap ,fp :let @*=substitute(expand("%:p"), "/", "\\", "g")<CR>

" 设置切换Buffer快捷键"
nnoremap <C-left> :bn<CR>
nnoremap <C-right> :bp<CR>

"Function - vimrc 里面用到的常用方法
" Remove trailing whitespace when writing a buffer, but not for diff files.
" From: Vigil
" @see http://blog.bs2.to/post/EdwardLee/17961
function! RemoveTrailingWhitespace()
    if &ft != "diff"
        let b:curcol = col(".")
        let b:curline = line(".")
        silent! %s/\s\+$//
        silent! %s/\(\s*\n\)\+\%$//
        call cursor(b:curline, b:curcol)
    endif
endfunction
autocmd BufWritePre * call RemoveTrailingWhitespace()

" -----------------------------------------------------------------------------
"  < Vundle 插件管理工具配置 >
" -----------------------------------------------------------------------------
" 用于更方便的管理vim插件，具体用法参考 :h vundle 帮助
" Vundle工具安装方法为在终端输入如下命令
" git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
" 如果想在 windows 安装就必需先安装 "git for window"，可查阅网上资料

set nocompatible                                      "禁用 Vi 兼容模式
filetype off                                          "禁用文件类型侦测
set rtp+=$VIM/vimfiles/bundle/Vundle.vim/
call vundle#rc('$VIM/vimfiles/bundle/')
Bundle 'VundleVim/Vundle.vim'
" sass scss haml等css开发语言支持
Bundle 'tpope/vim-haml'
" less支持
Bundle 'genoma/vim-less'
" 自动补全引号 括号等
Bundle 'Raimondi/delimitMate'
" css3语法高亮
Bundle 'hail2u/vim-css3-syntax'
" html5标签支持
Bundle 'othree/html5.vim'
" html xml自动闭合标签
Bundle 'docunext/closetag.vim'
" 自动高亮匹配标签
Bundle 'gregsexton/MatchTag'
" javascript，html，css，json格式化工具
Bundle 'maksimr/vim-jsbeautify'
" zen coding
Bundle 'mattn/emmet-vim'
" 代码对齐
Bundle 'godlygeek/tabular'
" markdown
Bundle 'plasticboy/vim-markdown'
" 强大的搜索定位
Bundle 'easymotion/vim-easymotion'
" 自动选择括号等符号中的内容
Bundle 'terryma/vim-expand-region'
" 更为强大的重做功能
Bundle 'tpope/vim-repeat'
" 快速给词加环绕符号,例如单引号/双引号/括号/成对标签等
Bundle 'tpope/vim-surround'
" 显示以及去除行尾空格
Bundle 'bronson/vim-trailing-whitespace'
" 代码片段补全 (依赖于Python, 先不安装)
"Bundle 'SirVer/ultisnips'
" 内置了一堆语言的自动补全片段
Bundle 'honza/vim-snippets'
" css的补全
Bundle 'rstacruz/vim-ultisnips-css'
" 更好的js语法 锁进支持
Bundle 'pangloss/vim-javascript'
" 更好的js语法高亮
Bundle 'othree/yajs.vim'
" js各类框架 库的高亮支持
Bundle 'othree/javascript-libraries-syntax.vim'
" 牛逼的基于语法分析的补全
Bundle 'marijnh/tern_for_vim'
" 标记高亮
Bundle 'mbriggs/mark.vim'
" 颜色符号显示对应颜色
Bundle 'gorodinskiy/vim-coloresque'
" 使用 Ctrl+p 搜索文件
Bundle 'kien/ctrlp.vim'
" 基于ctrlp的搜索函数等变量名
Bundle 'tacahiroy/ctrlp-funky'
" 基于ctrlp的文件内容搜索，配合vim－multiple－cursors可以很方便一次修改多个文件的内容
Bundle 'dyng/ctrlsf.vim'
" 注释插件，默认是快捷键是 <leader> c <SPACE>
Bundle 'scrooloose/nerdcommenter'
" SnipMate
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'garbas/vim-snipmate'
Bundle 'tomtom/tlib_vim'
" 新增目錄樹：nerdtree
Bundle 'scrooloose/nerdtree'
" 新增git狀態圖示：nerdtree-git
Bundle 'Xuyuanp/nerdtree-git-plugin'
" ctags标签提取显
Bundle 'majutsushi/tagbar'
" 状态栏增强
Bundle 'bling/vim-airline'
"Bundle 'adoy/vim-php-refactoring-toolbox'

" NERDTree Key
map <F1> :NERDTree <CR>
let g:NERDTreeWinPos = 'right'
let NERDTreeWinSize=30

" NERDcommenter
let g:NERDSpaceDelims = 1

" 配置Ctrl + F12为生产ctags的快捷键
map <C-F12> :!ctags -R .<CR>

" Airline
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = '  '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#right_sep = '  '
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_powerline_fonts = 1
" let g:airline_theme = 'luna'
let g:airline#extensions#whitespace#enabled = 0

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = '|'
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = '|'
let g:airline_symbols.linenr = '|'

" 设置使用markdown插件的类型以及不自动折叠代码
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn} set filetype=markdown nofoldenable

let g:EasyMotion_leader_key = '<Leader>'
let g:ctrlp_working_path_mode = 0
let javascript_enable_domhtmlcss = 1
"let g:syntastic_auto_jump = 1
"let g:syntastic_php_checkers = ['php']
"let g:syntastic_javascript_checkers = ['jshint']

"Plugin - 插件相关（包括和当前插件相关的配置和快捷键等）
"if exists('g:NERDTreeWinPos')
"    autocmd vimenter * NERDTree D:\repo
"endif

filetype plugin indent on
