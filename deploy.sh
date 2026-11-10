#!/bin/bash
set -e

cd /opt/05-pmng

docker build -t backend:v1.0 ./service
docker build -t frontend:v1.0 ./client

docker network create pmng-net 2>/dev/null || true

docker rm -f pmng-persistance pmng-servicios pmng-cliente 2>/dev/null || true

docker run -d \
  --name pmng-persistance \
  --network pmng-net \
  --network-alias pmng-mysql \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=people-dev \
  mysql:8.0

echo "Waiting for mysql..."
until docker exec pmng-persistance mysqladmin ping -h localhost -uroot -proot --silent 2>/dev/null; do
  sleep 3
done

docker run -d \
  --name pmng-servicios \
  --network pmng-net \
  --network-alias pmng-back \
  -p 8089:8080 \
  backend:v1.0

docker run -d \
  --name pmng-cliente \
  --network pmng-net \
  --network-alias frontend \
  -p 5173:80 \
  frontend:v1.0

docker ps
