FROM centos:centos7

RUN yum-config-manager --add-repo https://nginx-plus-repo.herokuapp.com && \
    rpm --import 'https://nginx.org/keys/nginx_signing.key' && \
    yum install -y nginx-plus nginx-plus-module-lua
    
ADD nginx.conf /etc/nginx/nginx.conf
ADD default.conf /etc/nginx/conf.d/default.conf
ADD conf/rule.conf /etc/nginx/rule.conf
ADD conf/secret.json /etc/nginx/secret.json

ADD index.html /usr/share/auth0/auth0_login/index.html
ADD conf/config.js /usr/share/auth0/auth0_login/config.js

RUN chmod a+r -R /usr/share/auth0/auth0_login
    
EXPOSE 80

CMD nginx -c /etc/nginx/nginx.conf -g 'daemon off;'