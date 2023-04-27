#!/bin/bash
# 脚本功能：
# 遍历目录go test
# 遍历目录执行go vet
curDir=$(cd `dirname $0`; pwd)
cd $curDir
#set -x

dirs=`ls -F | grep / | sed 's/\///g' | while read folder ; do find $folder -type d ; done; `

PASS=true
echo "######### run go test #########"
for dir in $dirs; do 
	# set +e
	cd $curDir
	cd $dir
	# pwd
	hasTestFile=$(ls | grep _test.go)
	if [ "" != "$hasTestFile" ]; then 
		# set -e
		go test .
	fi
	if [[ "$?" == "0" ]]; then
	  PASS=FALSE
	fi
done

echo "######### run vet #########"
cd $curDir
go vet
for dir in $dirs; do 
	# set +e
	cd $curDir
	cd $dir
	# pwd
	hasGoFile=$(ls | grep .go$)
	if [ "" != "$hasGoFile" ]; then 
		# set -e
		go vet 
	fi
	if [[ "$?" == "0" ]]; then
	  PASS=FALSE
	fi
done

if [[ "$PASS" == "FALSE" ]]; then
  exit 1
fi
exit 0
