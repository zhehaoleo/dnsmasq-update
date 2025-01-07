import requests

# Enhanced rules列表
enhancedRules = [
    {
        "name": "wechat.conf",
        "url": "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/QuantumultX/WeChat/WeChat.list"
    },
    {
        "name": "shadowrocket-china.conf",
        "url": "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/QuantumultX/China/China.list"
    }
]

prefix = ['HOST', 'HOST-SUFFIX']
dest = '114.114.114.114'

def process_and_save_rules(rules_url, output_file):
    """
    从URL获取规则文件，处理并保存到本地文件
    """
    # 配置代理
    proxies = {
        "http": "http://127.0.0.1:7890",  # 替换为你的 HTTP 代理地址和端口
        "https": "http://127.0.0.1:7890", # 替换为你的 HTTPS 代理地址和端口
    }
    try:
        # 从 URL 获取内容
        response = requests.get(rules_url, proxies=proxies)
        if response.status_code == 200:
            rules = response.text.splitlines()  # 按行分割内容

            # 打开输出文件并写入格式化内容
            with open(output_file, "w") as outfile:
                for line in rules:
                    line = line.strip()
                    if line.startswith(tuple(prefix)):
                        parts = line.split(",")
                        domain = parts[1]
                        outfile.write(f"server=/{domain}/{dest}\n")
                    # 跳过其他规则类型，例如 USER-AGENT 或 IP-ASN
                print(f"Formatted rules saved to {output_file}")
        else:
            print(f"Failed to fetch rules from {rules_url}. HTTP Status: {response.status_code}")
    except Exception as e:
        print(f"An error occurred while processing {rules_url}: {e}")

# 遍历 enhancedRules 列表，处理每个规则
for rule in enhancedRules:
    name = rule.get("name")
    url = rule.get("url")
    if name and url:
        process_and_save_rules(url, name)
    else:
        print(f"Invalid rule entry: {rule}")