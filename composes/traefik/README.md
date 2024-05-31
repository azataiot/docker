# Traefik on Docker

## Create docker network `traefik-public`

```bash
docker network create traefik-public
```

## Create acme.json file

```bash
mkdir certificates
touch certificates/acme.json
chmod 600 certificates/acme.json
```

## Create other folders

```bash
mkdir -p logs
mkdir -p conf
```



