# Ubuntools

Ubuntu Shell toolset

[jsdelivr](https://cdn.jsdelivr.net/gh/HisAtri/Ubuntools@master/)

## HelloWorld

```bash
bash -c "$(curl -fsSL https://cdn.jsdelivr.net/gh/HisAtri/Ubuntools@master/HelloWorld/helloworld.sh)"
```

## Python

### Replace

Force replacement of current Python3 version.

example: install python3.10

```bash
sudo curl -fsSL https://cdn.jsdelivr.net/gh/HisAtri/Ubuntools@dev/python/replace.sh | sudo bash -s 3.10
```

## apt

### Switch the source to Tuna

[TUNA Ubuntu 软件仓库](https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/)

```bash
sudo curl -fsSL https://cdn.jsdelivr.net/gh/HisAtri/Ubuntools@dev/apt/tuna-mirror.sh | sudo bash
```

This script creates a backup that can be restored with the following command

```bash
sudo curl -fsSL https://cdn.jsdelivr.net/gh/HisAtri/Ubuntools@dev/apt/tuna-mirror.sh | sudo bash -s rollback
```

- Enable source code source: `src`
- Enable proposed: `proposed`
- Force security updates to use mirroring: `security`
- Use http instead of https: `disable-https`
- ports: `ports`

For example:

```bash
sudo curl -fsSL https://cdn.jsdelivr.net/gh/HisAtri/Ubuntools@dev/apt/tuna-mirror.sh | sudo bash -s src proprsed disable-https ports
```
