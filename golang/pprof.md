```
启动：
  main.go中加
  import _ "net/http/pprof"
...
  go func() {
      log.Println(http.ListenAndServe("localhost:6060", nil))
  }()
...

采样： 
curl http://localhost:6470/debug/pprof/profile?seconds=60 --output porfile.tar.gz
```
