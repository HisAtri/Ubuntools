#!/bin/bash

# 添加仓库
add-apt-repository ppa:deadsnakes/ppa -y
apt update
version="$1"

# 安装Python对应版本
if apt install -y python$version; then
    echo "Python $version 已成功安装。"
else
    echo "无法找到 Python $version 版本。请检查版本号并确保仓库中存在该版本。"
    exit 1
fi

# 获取原有的Python版本
installed_python_version=$(python3 --version 2>&1 | awk '{print $2}')

# 更新Python3的符号链接（使用系统上已安装的最新版本）
update-alternatives --install /usr/bin/python3 python3 /usr/bin/$installed_python_version 1
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 2

# 更新pip
python$version -m ensurepip
python$version -m pip install --upgrade pip

apt install -y aptitude
# 获取所有依赖于旧版Python的包
dependents=$(aptitude search '?reverse-depends(^python3-*, ^python3.*$)' -F '%p')
# 安装
apt install -y $dependents

# 清理APT缓存
apt clean

echo "Python $version 已成功安装并配置。"
echo "此源代码发布于GitHub：https://github.com/HisAtri/Ubuntools"
