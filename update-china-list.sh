#!/bin/bash

git pull --rebase origin main

wait

source .env

DOCKER_COMPOSE_PATH=${ENV_PROJECT_DOCKER_COMPOSE_PATH}
ROOT_PATH="${DOCKER_COMPOSE_PATH}/dnsmasq"
CONFIG_PATH=${ROOT_PATH}/dnsmasq.d
CHINA_DNS_SERVER=${ENV_CHINA_DNS_SERVER}

curl -x http://127.0.0.1:7890 -o "${CONFIG_PATH}/accelerated-domains.china.conf" https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf
curl -x http://127.0.0.1:7890 -o "${CONFIG_PATH}/google.china.conf" https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/google.china.conf
curl -x http://127.0.0.1:7890 -o "${CONFIG_PATH}/apple.china.conf" https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/apple.china.conf
curl -x http://127.0.0.1:7890 -o "${CONFIG_PATH}/bogus-nxdomain.china.conf" https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/bogus-nxdomain.china.conf

wait

# linux 用这个
sed -i "s|114.114.114.114|${CHINA_DNS_SERVER}|g" "${CONFIG_PATH}/accelerated-domains.china.conf"
sed -i "s|114.114.114.114|${CHINA_DNS_SERVER}|g" "${CONFIG_PATH}/apple.china.conf"
sed -i "s|114.114.114.114|${CHINA_DNS_SERVER}|g" "${CONFIG_PATH}/google.china.conf"

# macos 用这个，当你使用 -i 选项时，必须指定一个扩展名来表示备份文件。如果你不希望创建备份文件，可以指定一个空字符串 ''。
#sed -i '' "s|114.114.114.114|${CHINA_DNS_SERVER}|g" "${CONFIG_PATH}/accelerated-domains.china.conf"
#sed -i '' "s|114.114.114.114|${CHINA_DNS_SERVER}|g" "${CONFIG_PATH}/apple.china.conf"
#sed -i '' "s|114.114.114.114|${CHINA_DNS_SERVER}|g" "${CONFIG_PATH}/google.china.conf"


cd "${ROOT_PATH}/dnsmasq-update" || echo "not found path ${ROOT_PATH}/dnsmasq-update"
source .venv/bin/activate
python main.py

mv wechat.conf "${CONFIG_PATH}"
mv shadowrocket-china.conf "${CONFIG_PATH}"

cd "${DOCKER_COMPOSE_PATH}" || echo "not found path ${DOCKER_COMPOSE_PATH}"
docker compose down
docker compose up -d
echo "====== update success ========="
