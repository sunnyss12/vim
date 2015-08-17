set number
set helplang=cn
set ai      
set bs=2
set showmatch
set autoread
set autoindent

syntax on
set smartindent

"tab
set tabstop=4
set expandtab
set shiftwidth=4

" line
set cursorline
set hls

set nocompatible              " be iMproved, required
set encoding=utf-8

filetype plugin indent on     " required

autocmd BufRead,BufNewFile *.html.erb setlocal filetype=eruby

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'tpope/vim-rails.git'
Bundle 'git@github.com:scrooloose/nerdtree.git'
Bundle 'git@github.com:Raimondi/delimitMate.git'
Bundle 'hallison/vim-markdown'
Bundle 'git@github.com:kien/ctrlp.vim.git'
Bundle 'msanders/snipmate.vim'
Bundle 'Lokaltog/vim-powerline'
Bundle 'vim-scripts/taglist.vim'

" Powerline
set guifont=PowerlineSymbols\ for\ Powerline
set nocompatible
set laststatus=2
set t_Co=256
let g:Powerline_symbols = 'fancy'
let Powerline_symbols='compatible'

" NEADTree
autocmd vimenter * if !argc() | NERDTree | endif
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

" Ctag F12
if(has("win32") || has("win95") || has("win64") || has("win16"))
    let g:iswindows=1
else
    let g:iswindows=0
endif
autocmd BufEnter * lcd %:p:h

map <F12> :call Do_CsTag()<CR>
"nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>:copen<CR><CR>
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>:copen<CR><CR>
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>:copen<CR><CR>
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>:copen<CR><CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>:copen<CR><CR>

" nmap <C-g> :tag <C-R>=expand("<cword>")<CR><CR>  这是ctrl+]的功能，不需要
nmap <C-n> :tnext<CR><CR>
nmap <C-b> :tp<CR><CR>
set nocst

function Do_CsTag()
    let dir = getcwd()
    if filereadable("tags")
        if(g:iswindows==1)
            let tagsdeleted=delete(dir."\\"."tags")
        else
            let tagsdeleted=delete("./"."tags")
        endif
        if(tagsdeleted!=0)
            echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
            return
        endif
    endif
    if has("cscope")
        silent! execute "cs kill -1"
    endif
    if filereadable("cscope.files")
        if(g:iswindows==1)
            let csfilesdeleted=delete(dir."\\"."cscope.files")
        else
            let csfilesdeleted=delete("./"."cscope.files")
        endif
        if(csfilesdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
            return
        endif
    endif
    if filereadable("cscope.out")
        if(g:iswindows==1)
            let csoutdeleted=delete(dir."\\"."cscope.out")
        else
            let csoutdeleted=delete("./"."cscope.out")
        endif
        if(csoutdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
            return
        endif
    endif
    if(executable('ctags'))
        "silent! execute "!ctags -R --c-types=+p --fields=+S *"
        silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
        set tags=tags
        set tags+=./tags
        set tags+=/usr/include/c++/tags
    endif
    if(executable('cscope') && has("cscope") )
        if(g:iswindows!=1)
            silent! execute "!find . -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.java' -o -name '*.cs' > cscope.files"
        else
            silent! execute "!dir /s/b *.c,*.cpp,*.cc,*.h,*.java,*.cs >> cscope.files"
        endif
        set cscopequickfix=s-,c-,d-,i-,t-,e-
        set csto=0
        set csverb
        silent! execute "!cscope -b"
        execute "normal :"
        if filereadable("cscope.out")
            "execute "cs add cscope.out"
            execute "cs add ".dir."/cscope.out ".dir 
            execute "cs add /usr/include/c++/cscope.out /usr/include/c++"
        endif
    endif
endfunction
if filereadable("tags")
    set tags=tags
    set tags+=./tags
    set tags+=/usr/include/c++/tags
endif
if filereadable("cscope.out")
    let dir = getcwd()
    set cscopequickfix=s-,c-,d-,i-,t-,e-
    set csto=0
    set csverb
    silent! execute "cs add /usr/include/c++/cscope.out /usr/include/c++"
endif



"taglist
let Tlist_Show_One_File = 1            "只显示当前文件的taglist，默认是显示多个
let Tlist_Exit_OnlyWindow = 1          "如果taglist是最后一个窗口，则退出vim
let Tlist_Use_Right_Window = 1         "在右侧窗口中显示taglist
let Tlist_GainFocus_On_ToggleOpen = 1  "打开taglist时，光标保留在taglist窗口
let Tlist_Ctags_Cmd='/usr/local/bin/ctags'  "设置ctags命令的位置
nnoremap <leader>tl : Tlist<CR>        "设置关闭和打开taglist窗口的快捷键
