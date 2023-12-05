#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "请以sudo方式运行该脚本。"
    exit 1
fi

# 判断是否为Ubuntu
os_info=$(lsb_release -si)
if [ "$os_info" != "Ubuntu" ]; then
    echo "请在Ubuntu系统上运行脚本"
    exit 1
fi

src="# "
proposed="# "
sec="security.ubuntu.com"
secp="ports.ubuntu.com"
d="s"
ports=""

# 获取系统代号
code_name="$(lsb_release -c -s)"
# 获取参数个数
num_args=$#
# 获取所有参数列表
args=("$@")

for ((i=0; i<num_args; i++)); do
    # 恢复备份文件
    if [ "${args[i]}" == "rollback" ]; then
        if [ -e "/etc/apt/sources.list.bak" ]; then
            cp -i "/etc/apt/sources.list.bak" "/etc/apt/sources.list"
            echo "已恢复"
        else
            echo "不存在备份文件"
        fi
        exit 1
    fi
    # 启用源码源
    if [ "${args[i]}" == "src" ]; then
        src=""
    fi
    # 启用 proposed
    if [ "${args[i]}" == "proposed" ]; then
        proposed=""
    fi
    # 安全更新使用镜像（不推荐）
    if [ "${args[i]}" == "security" ]; then
        sec="mirrors.tuna.tsinghua.edu.cn"
        secp="mirrors.tuna.tsinghua.edu.cn"
    fi
    # 使用http
    if [ "${args[i]}" == "disable-https" ]; then
        d=""
    fi
    # 启用Ports(针对ARM(arm64, armhf)、PowerPC(ppc64el)、RISC-V(riscv64) 和 S390x 等架构)
    if [ "${args[i]}" == "ports" ]; then
        ports="-ports"
    fi
done

if [ "$ports" == "-ports" ]; then
    re_text="
deb http"$d"://mirrors.tuna.tsinghua.edu.cn/ubuntu"$ports"/ "$code_name" main restricted universe multiverse
"$src"deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu"$ports"/ "$code_name" main restricted universe multiverse
deb http"$d"://mirrors.tuna.tsinghua.edu.cn/ubuntu"$ports"/ "$code_name"-updates main restricted universe multiverse
"$src"deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu"$ports"/ "$code_name"-updates main restricted universe multiverse
deb http"$d"://mirrors.tuna.tsinghua.edu.cn/ubuntu"$ports"/ "$code_name"-backports main restricted universe multiverse
"$src"deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu"$ports"/ "$code_name"-backports main restricted universe multiverse

deb http://"$secp"/ubuntu"$ports"/ "$code_name"-security main restricted universe multiverse
"$src"deb-src http://"$secp"/ubuntu"$ports"/ "$code_name"-security main restricted universe multiverse

# 预发布软件源，不建议启用
"$proposed"deb http"$d"://mirrors.tuna.tsinghua.edu.cn/ubuntu"$ports"/ "$code_name"-proposed main restricted universe multiverse
"$src""$proposed"deb-src http"$d"://mirrors.tuna.tsinghua.edu.cn/ubuntu"$ports"/ "$code_name"-proposed main restricted universe multiverse
"
else
    re_text="
deb http"$d"://mirrors.tuna.tsinghua.edu.cn/ubuntu/ "$code_name" main restricted universe multiverse
"$src"deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ "$code_name" main restricted universe multiverse
deb http"$d"://mirrors.tuna.tsinghua.edu.cn/ubuntu/ "$code_name"-updates main restricted universe multiverse
"$src"deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ "$code_name"-updates main restricted universe multiverse
deb http"$d"://mirrors.tuna.tsinghua.edu.cn/ubuntu/ "$code_name"-backports main restricted universe multiverse
"$src"deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ "$code_name"-backports main restricted universe multiverse

deb http://"$sec"/ubuntu/ "$code_name"-security main restricted universe multiverse
"$src"deb-src http://"$sec"/ubuntu/ "$code_name"-security main restricted universe multiverse

# 预发布软件源，不建议启用
"$proposed"deb http"$d"://mirrors.tuna.tsinghua.edu.cn/ubuntu/ "$code_name"-proposed main restricted universe multiverse
"$src""$proposed"deb-src http"$d"://mirrors.tuna.tsinghua.edu.cn/ubuntu/ "$code_name"-proposed main restricted universe multiverse
"
fi

# 备份源文件
backup_file="/etc/apt/sources.list.bak"
cp /etc/apt/sources.list "$backup_file"
# 应用配置到 /etc/apt/sources.list
echo "$re_text" | sudo tee /etc/apt/sources.list

apt-get update
