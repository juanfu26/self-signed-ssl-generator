FROM nginx:latest

WORKDIR /work

ENTRYPOINT ["sh", "./docker-entrypoint.sh"]