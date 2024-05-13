# Docker Containers 

## Buildx 

```bash
docker buildx build \
--build-arg DEV=1 \
--platform linux/amd64,linux/arm64 \
-t cr.azat.host/aahome:dev \
--push \
.
```