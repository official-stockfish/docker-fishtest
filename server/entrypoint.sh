cd /app/fishtest/server

uv sync 

uv run utils/create_indexes.py actions flag_cache pgns runs users 

uv run /app/create_users.py

uv run pserve development.ini --reload