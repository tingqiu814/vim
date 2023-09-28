$ cat Makefile
# 获取当前目录
CURRENT_DIR := $(shell pwd)

# 默认目标，打印帮助信息
.DEFAULT_GOAL := help

# 帮助信息
help:
        @echo "使用方式:"
        @echo "  make build [pf=linux]  构建包，可选择性传递 'pf' 参数以指定平台"
        @echo "  make test              运行测试"
        @echo ""

# 构建目标
build:
        @if [ "$(pf)" = "linux" ]; then \
                echo "构建 Linux 包"; \
                GOOS=linux GOARCH=amd64 go build -o $(CURRENT_DIR)/myapp-linux $(CURRENT_DIR)/path/to/your/package; \
        else \
                echo "构建当前系统包"; \
                go build -o $(CURRENT_DIR)/myapp $(CURRENT_DIR)/path/to/your/package; \
        fi

# 测试目标
test:
        go test ./...

# 清理目标
clean:
        rm -f $(CURRENT_DIR)/myapp $(CURRENT_DIR)/myapp-linux

.PHONY: build test clean help
