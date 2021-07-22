# Respberry Config

## 1. Static addr
其中: `routers` 与`domain_name_servers` 不能添加/24 掩码
```shell
# file: /etc/dhcpcd.config
interface eth0
static ip_address=8.8.8.11/24
static routers=8.8.8.254
static domain_name_servers=8.8.8.254
```

## 2. Open ssh-service
```shell
sudo raspi-config
reboot
```

## 3. reset password
默认用户名: pi
默认密码:respberry
```shell
sudo passwd root
sudo passwd pi
```

## 4. apt
```shell
# file: /etc/apt/sources.list
deb http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ buster main non-free contrib rpi
deb-src http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ buster main non-free contrib rpi
```
```shell
# file: /etc/apt/sources.list.d/raspi.list
deb http://mirrors.tuna.tsinghua.edu.cn/raspberrypi/ buster main ui
```
shell -> `sudo apt-get update`

## 5. pip
```shell
$ sudo apt-get install python3-pip
$ pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple/
```
