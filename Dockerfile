FROM centos:centos7

RUN yum-config-manager --add-repo https://nginx-plus-repo.herokuapp.com && \
    rpm --import 'https://nginx.org/keys/nginx_signing.key' && \
    yum install -y nginx-plus nginx-plus-module-lua gperftools-libs

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
