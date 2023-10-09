redis-cli <host> -p <port>
> auth <passwd>

> keys <x:*>
> del <akey>
报错 (error) MOVED 12940
查问题是分到不同节点上

查看key被分到哪个槽
> cluster keyslot <key>
(integer) 12940
查看所有nodes下的槽范围
> cluster nodes
10.0.13.165:52001@62001 master - 0 1696823651000 53 connected 10924-16383
10.0.13.167:52001@62001 master - 0 1696823653483 52 connected 0-5461
10.0.13.162:52001@62001 master - 0 1696823651475 51 connected 5462-10923

查看这个槽中的所有键： CLUSTER GETKEYSINSLOT
> cluster getkeysinslot <槽> <前n个>
集群redis
