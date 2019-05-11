# nal
Nginx Auth0 Login

[![](https://images.microbadger.com/badges/image/puteulanus/nal.svg)](https://microbadger.com/images/puteulanus/nal "Get your own image badge on microbadger.com")
[![Build Status](https://travis-ci.com/puteulanus/nal.svg?branch=master)](https://travis-ci.com/puteulanus/nal)


Run with 
```
docker run -d -p 127.0.0.1:8086:80 -e 'PROXY_URL=http://172.17.0.1:8085' \
-e 'DOMAIN=YOUR_DOMAIN' -e 'CLIENT_ID=YOUR_CLIENT_ID' \
-v `pwd`/rule.conf:/etc/nginx/rule.conf puteulanus/nal
```
