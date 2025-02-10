# docker-fishtest

## Server

To start a dev server, run:

```
cd server
git clone https://github.com/official-stockfish/fishtest
docker compose up -d
```

Copy `.netrc.example` to `.netrc` and update the "login" token with your GitHub personal access token
to increase the rate limit.

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
