# Install QuantumPOS

1. Install Docker
2. Replace GITHUB_TOKEN with your own in the Dockerfile.

3. Open a terminal an run

```console
docker-compose build && docker-compose up -d
```
    Or
```console
sudo docker compose build && sudo docker compose up -d
```

4. Register images on start on startup

```console
sudo docker images
sudo docker run --restart=always -d imageId
```
