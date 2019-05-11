FROM centos:centos7 as BUILD

RUN yum-config-manager --add-repo https://nginx-plus-repo.herokuapp.com && \
    rpm --import 'https://nginx.org/keys/nginx_signing.key' && \
    yum install -y nginx-plus nginx-plus-module-lua gperftools-libs
RUN mkdir /root/lib64 && \
    ldd /usr/sbin/nginx | grep -o '/lib64/[^ ]*' | tee lst && \
    cp $(cat lst) /root/lib64/ && \
    cd /root/lib64/ && \
    rm -rf libc.so* libpthread.so*

FROM alpine

ENV LD_LIBRARY_PATH=/usr/glibc-compat/lib;/lib:/usr/lib

# Install glibc
RUN apk --no-cache add ca-certificates curl
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk && \
    apk add glibc-2.29-r0.apk && \
    rm -f glibc-2.29-r0.apk

# Copy Nginx
COPY --from=BUILD /usr/sbin/nginx /usr/sbin/nginx
COPY --from=BUILD /etc/nginx /etc/nginx
COPY --from=BUILD /usr/lib64/nginx/modules /usr/lib64/nginx/modules
COPY --from=BUILD /etc/logrotate.d /etc/logrotate.d
COPY --from=BUILD /usr/share/nginx /usr/share/nginx
RUN mkdir -p /var/cache/nginx /var/lib/nginx/state /var/log/nginx

# Copy libs
COPY --from=BUILD /root/lib64 /usr/lib/

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
