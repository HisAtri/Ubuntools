#!/bin/bash

if [ -z "$1" ]; then
    echo "错误：请指定要安装的Python3版本。"
    exit 1
else
    version="$1"
fi

if [ "$EUID" -ne 0 ]; then
    echo "请以sudo方式运行该脚本。"
    exit 1
fi

if [ "$1" -lt "3" ]; then
    echo "请指定Python3版本"
    exit 1
fi

# 安装 software-properties-common，确保 add-apt-repository 命令可用
apt-get install -y software-properties-common

# 添加仓库
add-apt-repository ppa:deadsnakes/ppa -y
apt-get update

# 安装Python对应版本
if apt-get install -y python$version; then
    echo "Python $version 已成功安装。"
else
    echo "无法找到 Python $version 版本。请检查版本号并确保仓库中存在该版本。"
    exit 1
fi

# 切换Python版本
sudo rm /usr/bin/python3
sudo ln -s /usr/bin/python$version /usr/bin/python3
sudo apt-get install python3-apt

apt-get --reinstall install $(dpkg -l | grep '^ii' | grep 'python3' | awk '{print $2}')

# 检查pip是否可用，如果不可用则尝试安装
if command -v pip3 > /dev/null; then
    echo "pip 已安装。"
else
    echo "pip 未安装，尝试安装中..."
    
    # get-pip.py 修复
    wget https://bootstrap.pypa.io/get-pip.py --no-check-certificate
    sudo python get-pip.py
    sudo rm -f get-pip.py
    
    if command -v pip3 > /dev/null; then
        echo "pip 安装成功。"
    else
        echo "pip 安装失败。请手动安装 pip。"
        exit 1
    fi
fi

python3 -V
pip3 -V

echo "Python3 版本替换完成"
echo "GitHub: https://github.com/HisAtri/Ubuntools"
