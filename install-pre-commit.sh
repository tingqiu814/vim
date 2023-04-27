#!/bin/bash

if [ ! -d ".git" ]; then
  echo "请放在项目根目录下执行安装";
  exit 1
fi

cat << "EOF" > .git/hooks/pre-commit
#!/bin/sh

# 变动的go文件加上fmt，imports格式化后提交
echo "###### eeo-cloud pre-commit ######"

STAGE_FILES=$(git diff --cached --name-only --diff-filter=ACM -- "*.go")

for f in $STAGE_FILES; do
  gofmt -w -l $f;
  goimports -w -l $f;
  go vet $f
  git add $f
  if [[ "$?" != "0" ]]; then
    echo "go vet failed in $f"
    exit 1
  fi
done
if [[ "$?" != "0" ]]; then
  exit 1
fi
echo "###### eeo-cloud pre-commit end ######"
EOF

chmod +x .git/hooks/pre-commit

echo "安装完成;"
