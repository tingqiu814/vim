vim插件-hellowolrd

```
$ cat helloworld.vim
function! Helloworld()
        echo "hello, world"
endfunction
command! -nargs=0 Helloworld call Helloworld()
```
在vim中 :source %加载文件
:Helloworld 就可以调用函数输出了；
- 变量与获取输出： 
:let a=5
:echo a

- 参数设置
if !exists('g:leetcode_categories')
    let g:leetcode_categories = ['algorithms']
endif
