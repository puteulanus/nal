# nal
Nginx Auth0 Login

Run with 
```
docker run -d -p 127.0.0.1:8086:80 -e 'PROXY_URL=http://172.17.0.1:8085/' \
-e 'DOMAIN=YOUR_DOMAIN' -e 'CLIENT_ID=YOUR_CLIENT_ID' \
-v rule.conf:/etc/nginx/rule.conf puteulanus/nal
```
