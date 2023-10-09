screen命令
```  $ screen -S session名
  screen -ls
  screen -r <id> 恢复
  screen -x <id> 共享screen，这样另一个终端可以同时打开一个id的session，界面共享；
 
  C-a A 重命名session
  C-a c 创建pane
  C-a w list当前pane
  C-a p 上一个pane
  C-a n 下一个
  C-a S 水平分割屏幕
  C-a d 退出当前session detach

  C-a [ 进入翻页模式，vim翻页模式
  无法在session 内切换session
```
