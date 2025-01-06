# 定时更新 dnsmasq 国内白名单
原文详见 [这里](https://liuzhehao.com/fiddling/tailscale/exit-node#自建-dns-解析代理)

## 介绍
结合 github 中的 [dnsmasq-china-list](https://github.com/felixonmars/dnsmasq-china-list) 更新 dnsmasq 国内白名单，同时 main.py 的 python 脚本结合原本 [小火箭的部分国内域名规则](https://github.com/blackmatrix7/ios_rule_script) 进行增强。

## 用法
使用 `crontab -e` 命令配置每6小时定时更新 dnsmasq 国内白名单，访问 github 需要代理，默认使用 clash 的 7890，国内域名默认使用 223.5.5.5 的阿里云 DNS 解析。
```
0 */6 * * * /bin/bash YOUR_update-china-list_SHELL_PATH.sh
```
部分参数解释
- ROOT_PATH: 自建 dns 解析根目录
- CONFIG_PATH: 自建 dns 解析的 dnsmasq 配置文件路径
- DOCKER_COMPOSE_PATH： docker-compose.yml 配置文件路径