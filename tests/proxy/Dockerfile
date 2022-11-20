FROM nginx:alpine

COPY conf.d/ /etc/nginx/conf.d/
COPY certs/ /certs/

EXPOSE 80
EXPOSE 443

CMD ["/bin/sh", "-c", "exec nginx -g 'daemon off;';"]
WORKDIR /usr/share/nginx/html