markdown 时序图
```mermaid
sequenceDiagram
	participant A as 端
  participant B as B服务
	participant C as c服务
	participant D as D服务
	participant E as E服务
	participant F as F服务
	participant G as 队列
	participant H as H服务
	

	A ->> +C: 请求缩略图
	A-->> A: 失败重试3次
OPT 重试还是失败
	A-->> C: NAS
end
	C ->> -A: 文件地址
	

	A ->> +B: 请求上传接口
	B ->> +D: 请求写file文件表
	OPT 配置类型需要转换
	D ->> +E: 根据类型请求转换服务
	E ->> -D: 根据类型请求转换服务
	end
	
	D ->> -B: 返回fileID
	B ->> -A: 返回fileID

	A ->> +H: 上传文件
	H ->> +F: 送审
	F ->> -H: 收到送审请求，待异步通知
	H ->> -A: 响应

	E ->> B: 转换成功失败通知旧的cloud_space改file转换状态

	F ->> G: 审核结果
	G ->> +D: 审核结果通知；
	# 更新file表；移除违规文件原文件；移除万象缩略图；
	D-->>D: 更新file表审核状态
	OPT 审核违规
	D ->> +C: 移除违规源文件； 移除万象缩略图；
	C ->> -D: 响应；
	end 
	G ->> H: 通知违规撤回
	H ->> A: 通知服务端->消息撤回
  ```
