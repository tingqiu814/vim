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
curl http://localhost:6470/debug/pprof/profile?seconds=60 --output profile.tar.gz

brew install graphviz
不装不能用web看

go tool pprof -http=:18080 profile.tar.gz


```
