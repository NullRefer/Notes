# Install shadowsocks in server

## 1. Setup google bbr speed up

execute

```sh
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh

lsmod | grep bbr
```

## 2. Install ss

```sh
wget — no-check-certificate -O shadowsocks.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks.sh
chmod +x shadowsocks.sh
./shadowsocks.sh 2>&1 | tee shadowsocks.log
```

input reqired info according to tips, and save the server info when complete

## 3. Enjoy in ss.Android or ss.iOS or ss.Windows
