FROM alpine:3.15

RUN wget -O /etc/apk/keys/nginx_signing.rsa.pub https://cs.nginx.com/static/keys/nginx_signing.rsa.pub && \
    printf "http://nginx.puteulanus.com/plus/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | tee -a /etc/apk/repositories && \
    apk add nginx-plus nginx-plus-module-lua

# Add config
ADD nginx.conf /etc/nginx/nginx.conf
ADD default.conf /etc/nginx/conf.d/default.conf
ADD rule.conf /etc/nginx/rule.conf
RUN touch /etc/nginx/secret.json

# Add login page
ADD index.html /usr/share/auth0/auth0_login/index.html
ADD config.js /usr/share/auth0/auth0_login/config.js
RUN chmod a+r -R /usr/share/auth0/auth0_login

ADD run /root/run

ENV DOMAIN=
ENV CLIENT_ID=
ENV PROXY_URL=http://172.17.0.1:8085/

EXPOSE 80

CMD /root/run
