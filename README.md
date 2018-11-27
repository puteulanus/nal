# nal
Nginx Auth0 Login

Run with 
```
docker -d -p 127.0.0.1:8085 -e 'PROXY_URL=http://172.17.0.1:8085/' \
-v rule.conf:/etc/nginx/rule.conf puteulanus/nal
```
