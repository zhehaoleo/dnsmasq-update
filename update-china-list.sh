#!/bin/bash

git pull --rebase origin main

wait

source .env

DOCKER_COMPOSE_PATH=${ENV_PROJECT_DOCKER_COMPOSE_PATH}
ROOT_PATH="${DOCKER_COMPOSE_PATH}/dnsmasq"
CONFIG_PATH="${ROOT_PATH}/dnsmasq.d"
CHINA_DNS_SERVER=${ENV_CHINA_DNS_SERVER}

curl -x http://127.0.0.1:7890 -s https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf | pcregrep -v "[\x80-\xFF]" | tee "${CONFIG_PATH}/accelerated-domains.china.conf" > /dev/null
curl -x http://127.0.0.1:7890 -o "${CONFIG_PATH}/google.china.conf" https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/google.china.conf
curl -x http://127.0.0.1:7890 -o "${CONFIG_PATH}/apple.china.conf" https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/apple.china.conf
curl -x http://127.0.0.1:7890 -o "${CONFIG_PATH}/bogus-nxdomain.china.conf" https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/bogus-nxdomain.china.conf

#curl -x http://127.0.0.1:7890 -o "${CONFIG_PATH}/accelerated-domains.china.conf" https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf

wait

# 判断操作系统类型
if [[ "$(uname)" == "Darwin" ]]; then
    # macOS 上使用 -i '' 语法
    sed -i '' "s|114.114.114.114|${CHINA_DNS_SERVER}|g" "${CONFIG_PATH}/accelerated-domains.china.conf"
    sed -i '' "s|114.114.114.114|${CHINA_DNS_SERVER}|g" "${CONFIG_PATH}/apple.china.conf"
    sed -i '' "s|114.114.114.114|${CHINA_DNS_SERVER}|g" "${CONFIG_PATH}/google.china.conf"
else
    # Linux 或其他系统上使用 -i 语法
    sed -i "s|114.114.114.114|${CHINA_DNS_SERVER}|g" "${CONFIG_PATH}/accelerated-domains.china.conf"
    sed -i "s|114.114.114.114|${CHINA_DNS_SERVER}|g" "${CONFIG_PATH}/apple.china.conf"
    sed -i "s|114.114.114.114|${CHINA_DNS_SERVER}|g" "${CONFIG_PATH}/google.china.conf"
fi

cd "${ROOT_PATH}/dnsmasq-update" || echo "not found path ${ROOT_PATH}/dnsmasq-update"
source .venv/bin/activate
python main.py

mv wechat.conf "${CONFIG_PATH}"
mv shadowrocket-china.conf "${CONFIG_PATH}"

cd "${DOCKER_COMPOSE_PATH}" || echo "not found path ${DOCKER_COMPOSE_PATH}"
# 判断变量 DOCKER_PATH 是否存在
if [ -z "${DOCKER_PATH}" ]; then
  # 如果 DOCKER_PATH 没有定义，使用默认的 docker
  DOCKER_PATH="docker"
fi
${DOCKER_PATH} compose down
${DOCKER_PATH} compose up -d
echo "====== update success ========="
