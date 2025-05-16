ARG NGINX_VERSION=1.28.0

FROM nginx:${NGINX_VERSION}

EXPOSE 80
EXPOSE 443

# hadolint ignore=DL3008,DL3015
RUN apt-get update \
 && apt-get install -y \
      openssl \
      certbot \
 && openssl req -x509 -nodes -days 36500 -newkey rsa:4096 -keyout /selfsigned.key -out /selfsigned.crt \
      -subj "/O=Petr Knap/CN=petrknap.cz/" \
 && apt-get clean \
 && rm  -rf \
      /var/lib/apt/lists/* \
      /tmp/* \
      /var/tmp/* \
;

COPY *.bash /
RUN chmod +x /*.bash

ENV IGNORE_LETS_ENCRYPT_ALL_ERRORS="false"
ENV IGNORE_LETS_ENCRYPT_OBTAIN_ERRORS="false"
ENV IGNORE_LETS_ENCRYPT_RENEW_ERRORS="true"
ENV RULES='1.example.local>127.0.0.1:8001,2.example.local>127.0.0.1:8002'
ENV PROXY_OPTIONS='\
    proxy_request_buffering off;\
'
ENV PROXY_HEADERS='\
    proxy_set_header Host $host;\
    proxy_set_header X-Forwarded-Host $host:$server_port;\
    proxy_set_header X-Forwarded-Proto $scheme;\
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\
    proxy_set_header Range $http_range;\
    proxy_set_header If-Range $http_if_range;\
    proxy_set_header X-Real-IP $remote_addr;\
'
ENV PROXY_ADDITIONAL_OPTIONS=''
ENV UPSTREAMS='\
#   upstream my-load-balancer {\
#        server 127.0.0.1:8001;\
#        server 127.0.0.1:8002;\
#        sticky cookie srv_id expires=1h domain=.example.com path=/;\
#   } \
'
ENV DEFAULT_SERVER='\
    server_tokens off;\
    return 404;\
'

HEALTHCHECK --interval=15s --timeout=2s --retries=3 CMD curl --fail http://localhost/

CMD ["bash", "/command.bash"]

LABEL org.opencontainers.image.title="Let's Encrypt NGINX reverse proxy" \
      org.opencontainers.image.description="HTTP/HTTPS reverse proxy based on NGINX and Let's Encrypt" \
      org.opencontainers.image.authors="Petr Knap <8299754+petrknap@users.noreply.github.com>" \
      org.opencontainers.image.url="https://github.com/petrknap/letsencrypt-nginx-reverse-proxy/" \
