$ cat multiclone.sh
#!/bin/bash
curDir=$(cd `dirname $0`; pwd)

# 定义帮助信息
usage() {
  echo "Usage: $0 -a <action> -t <target>"
  echo "  -a, --action   update/clone"
  echo "  -t, --target     Specify the target of action"
  echo "  -h, --help     Display this help message"
  exit 1
}

# 解析参数
while [[ $# -gt 0 ]]; do
  case "$1" in
    -a|--action)
      ACTION="$2"
      shift 2
      ;;
    -t|--target)
      TARGET="$2"
      shift 2
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "Invalid argument: $1"
      usage
      ;;
  esac
done

# 检查必填参数
if [[ -z "$ACTION" ]]; then
  echo "Missing required argument: -a, --action"
  usage
fi

if [[ -z "$TARGET" ]]; then
  echo "Missing required argument: -t, --target"
  usage
fi

# 检查参数是否合法
if [[ "$ACTION" != "update" && "$ACTION" != "clone" ]]; then
  echo "Invalid argument for -a, --action: $ACTION"
  usage
fi

echo "Performing action $ACTION of target $TARGET"

# update run 方法定义
run(){
        set -ex
        echo "参数$1"
        if [[ "$1" == "all" ]]; then
                proList=$(cat project_list.txt)
        else
                # classin_demo3_rpc
                proList="/eeoWeb/$1"
        fi

        for tmp in $proList; do
                # git@gl.eeo.im:eeoWeb/eeo_lms_answer_sheet_service_go.git
                v="git@gl.eeo.im:"$tmp".git"
                # subDir=${tmp:8}
                git clone $v && cd ${tmp:8} && git remote add upstream $v && cd ..;
        done
}

update(){
        set -ex
        echo "参数$1"
        if [[ "$1" == "all" ]]; then
                proList=$(cat project_list.txt)
        else
                proList="/eeoWeb/$1"
        fi

        for tmp in $proList; do
                cd ${tmp:8} && git pull upstream master && cd ..;
        done
}


if [[ "$ACTION" == "clone" ]]; then
        run $TARGET
elif [[ "$ACTION" == "update" ]]; then
        update $TARGET
fi
