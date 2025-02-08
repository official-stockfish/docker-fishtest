# docker-fishtest

## Server

To start a dev server, run:

```
cd server
git clone https://github.com/official-stockfish/fishtest
docker compose up -d
```

## Worker

```
cd worker
cp .env.example .env
```

Update the `.env` file with your credentials

To start a worker, run:

```
docker compose up -d
```
