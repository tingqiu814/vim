#!/bin/bash
curDir=$(cd `dirname $0`; pwd)
# set -x

dirs=`ls -F | grep / | sed 's/\///g' | while read folder ; do find $folder -type d ; done; `


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
done
