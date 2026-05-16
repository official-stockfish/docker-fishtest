# docker-fishtest

## Worker

The worker uses an archlinux:latest base image and runs pacman updates in the background to
keep the software stack up to date.
This is useful to get the latest compilers and tools for running the worker.
The container also runs one update check before starting the workers.
The update check runs every 12 hours.

When the updater changes the `gcc` or `python` package, it creates `fish.exit` in each worker directory.
This lets the workers finish their current batch of games and exit cleanly before Docker
starts them again, so the next startup sees fresh compiler metadata.

```
cd worker
cp .env.example .env
```

Update the `.env` file with your credentials

To start a worker, run:

```
docker compose up -d
```

## Server (for development)

To start a dev server, run:

```
cd server
git clone https://github.com/official-stockfish/fishtest
docker compose up -d
```

Copy `.netrc.example` to `.netrc` and update the "login" token with your GitHub personal access token
to increase the rate limit.
