# Install GITLAB (self-hosted with self-signed certificates)

## Requirements

- jq

```bash
sudo apt install jq -y
```
- docker

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

- docker-compose

```bash
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL https://github.com/docker/compose/releases/download/v2.24.5/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
```

## Steps

```bash
chmod +x helper.sh
# run helper.sh, example
./helper.sh git.lab.com

# up docker compose
docker compose up -d

# show and change root password
sudo cat /opt/gitlab/config/initial_root_password

# register runner (gitlab admin web -> runners -> new install runner)
docker exec gitlab-runner update-ca-certificates
docker exec -ti gitlab-runner gitlab-runner register \
  --non-interactive \
  --url "https://git.lab.com/ci" \
  --token "glrt-j5yREMFkeAXQEiuwVCdU" \
  --description "docker-runner" \
  --executor "docker" \
  --docker-image alpine:latest 
```

