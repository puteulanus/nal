FROM centos:centos7 as BUILD

RUN yum-config-manager --add-repo https://nginx-plus-repo.herokuapp.com && \
    rpm --import 'https://nginx.org/keys/nginx_signing.key' && \
    yum install -y nginx-plus gperftools-libs

FROM alpine

ENV LD_LIBRARY_PATH /lib:/usr/lib

# Install glibc
RUN apk --no-cache add ca-certificates wget
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk && \
    apk add glibc-2.28-r0.apk && \
    rm -f glibc-2.28-r0.apk

# Copy Nginx
COPY --from=BUILD /usr/sbin/nginx /usr/sbin/nginx
COPY --from=BUILD /etc/nginx /etc/nginx
COPY --from=BUILD /etc/logrotate.d /etc/logrotate.d
COPY --from=BUILD /usr/share/nginx /usr/share/nginx
RUN mkdir -p /var/cache/nginx /var/lib/nginx/state /var/log/nginx /usr/lib64/nginx/modules

# Copy libs
COPY --from=BUILD /usr/lib64/libpcre.so.1 /usr/lib/libpcre.so.1
COPY --from=BUILD /usr/lib64/libssl.so.10 /usr/lib/libssl.so.10
COPY --from=BUILD /usr/lib64/libcrypto.so.10 /usr/lib/libcrypto.so.10
COPY --from=BUILD /usr/lib64/libz.so.1 /usr/lib/libz.so.1
COPY --from=BUILD /usr/lib64/libprofiler.so.0 /usr/lib/libprofiler.so.0
COPY --from=BUILD /usr/lib64/libgssapi_krb5.so.2 /usr/lib/libgssapi_krb5.so.2
COPY --from=BUILD /usr/lib64/libkrb5.so.3 /usr/lib/libkrb5.so.3
COPY --from=BUILD /usr/lib64/libcom_err.so.2 /usr/lib/libcom_err.so.2
COPY --from=BUILD /usr/lib64/libk5crypto.so.3 /usr/lib/libk5crypto.so.3
COPY --from=BUILD /usr/lib64/libstdc++.so.6 /usr/lib/libstdc++.so.6
COPY --from=BUILD /usr/lib64/libgcc_s.so.1 /usr/lib/libgcc_s.so.1
COPY --from=BUILD /usr/lib64/libkrb5support.so.0 /usr/lib/libkrb5support.so.0
COPY --from=BUILD /usr/lib64/libkeyutils.so.1 /usr/lib/libkeyutils.so.1
COPY --from=BUILD /usr/lib64/libselinux.so.1 /usr/lib/libselinux.so.1

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
