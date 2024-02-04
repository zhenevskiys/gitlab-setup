#!/bin/bash
my_ip=$(ip -j addr show dev ens18 | jq -r '.[0].addr_info | map(select(.family == "inet"))[0].local')
gitlab_hostname="$1"

echo "create dirs \n"
sudo mkdir -p /opt/gitlab
sudo mkdir -p /opt/gitlab/config
sudo mkdir -p /opt/gitlab/logs
sudo mkdir -p /opt/gitlab/data
sudo mkdir -p /opt/gitlab-runner
sudo mkdir -p /opt/gitlab-runner/config
sudo mkdir -p /opt/gitlab-runner/data

echo "\n"
echo "create certs \n"
mkdir -p ssl && cd ssl
openssl genrsa -out ca.key 4096
openssl req -new -x509 -days 3650 -key ca.key -out ca.crt
openssl req -newkey rsa:4096 -nodes -keyout gitlab.key -out gitlab.csr
openssl x509 -req -extfile <(printf "subjectAltName=DNS:gitlab,DNS:$gitlab_hostname") -days 3650 -in gitlab.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out gitlab.crt
ls -al
echo "\n"

echo "copy certs \n"
cd -
sudo cp -r ssl /opt/gitlab/
sudo ls -al /opt/gitlab/ssl

echo "\n"
echo "replace docker-compose.yml"
sed -i "s/__IP__/$my_ip/g" docker-compose.yml
sed -i "s/__HOSTNAME__/$gitlab_hostname/g" docker-compose.yml
cat docker-compose.yml

echo "\n"
echo "run docker compose"
docker compose up -d