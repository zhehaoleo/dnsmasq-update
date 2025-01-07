# 定时更新 dnsmasq 国内白名单
原文详见 [这里](https://liuzhehao.com/fiddling/tailscale/exit-node#自建-dns-解析代理)

## 介绍
update-china-list.sh 为下载 github 中的 [dnsmasq-china-list](https://github.com/felixonmars/dnsmasq-china-list) 更新 dnsmasq 国内白名单，同时结合 main.py 的 python 脚本结合原本 [小火箭的部分国内域名规则](https://github.com/blackmatrix7/ios_rule_script) 进行增强。

## 用法
使用 `crontab -e` 命令配置每6小时定时更新 dnsmasq 国内白名单，访问 github 需要代理，默认使用 clash 的 7890，国内域名默认使用 223.5.5.5 的阿里云 DNS 解析。
```
0 */6 * * * /bin/bash YOUR_SHELL_PATH.sh
```
自建 .env 文件，参数解释
- ENV_PROJECT_DOCKER_COMPOSE_PATH: 项目根目录，项目文件内包含 dnsmasq 和 dnscrypt-proxy 两个目录
- ENV_CHINA_DNS_SERVER: 国内 DNS 解析的公共服务