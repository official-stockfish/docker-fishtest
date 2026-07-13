# docker-fishtest

## Worker

The worker uses an `alpine:edge` base image and runs `apk` updates in the background to
keep the software stack up to date.
This is useful to get the latest compilers and tools for running the worker.
The container also runs one update check before starting the workers.
The update check runs every 12 hours.

When the updater changes the `gcc` or `python3` package, it creates `fish.exit` in each worker directory.
This lets the workers finish their current batch of games and exit cleanly before Docker
starts them again, so the next startup sees fresh compiler metadata.

By default, the worker pulls a pre-built image from GitHub Container Registry.

```
cd worker
cp .env.example .env
```

Update the `.env` file with your credentials and `NUMBER_OF_CORES` to the desired concurrency, NUM_WORKERS should probably be left untouched.

To start a worker, run:

```
docker compose up -d
```

If you want to build the image yourself run the following

```
docker compose -f compose.yml -f compose.build.yml up -d --build
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
