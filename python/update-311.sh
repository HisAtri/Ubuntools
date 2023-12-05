#!/bin/bash

# 添加Python3.11仓库
add-apt-repository ppa:deadsnakes/ppa -y
apt update

# 安装Python3.11
apt install -y python3.11

# 获取系统上安装的Python版本
installed_python_version=$(python3 --version 2>&1 | awk '{print $2}')

# 更新Python3的符号链接（使用系统上已安装的最新版本）
update-alternatives --install /usr/bin/python3 python3 /usr/bin/$installed_python_version 1
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 2

# 更新pip
python3.11 -m ensurepip
python3.11 -m pip install --upgrade pip

# 安装aptitude以便处理可能的依赖关系
apt install -y aptitude

# 获取所有依赖于旧版Python的软件包
dependents=$(aptitude search '?reverse-depends(^python3-*, ^python3.*$)' -F '%p')

# 安装所有依赖于旧版Python的软件包
apt install -y $dependents

# 清理APT缓存
apt clean

echo "Python 3.11 已成功安装并配置。"
