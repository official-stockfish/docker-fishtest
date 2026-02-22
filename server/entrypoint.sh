cd /app/fishtest/server

uv sync 

uv run utils/create_indexes.py actions flag_cache pgns runs users 

uv run /app/create_users.py

uv run uvicorn fishtest.app:app --host 0.0.0.0 --port 6542 --proxy-headers --forwarded-allow-ips=127.0.0.1 --limit-concurrency 10 --backlog 100 --log-level warning --workers 1 --reload