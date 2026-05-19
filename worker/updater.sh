#!/usr/bin/env bash

set -euo pipefail

UPDATE_INTERVAL_SECONDS=43200

run_update() {
    local signal_workers=${1:-1}

    if ! update_output=$(apk upgrade --available 2>&1); then
        printf '%s\n' "$update_output"
        return 1
    fi

    printf '%s\n' "$update_output"

    if echo "$update_output" | grep -Eiq '^(Upgrading|Installing|Reinstalling) (gcc|python3)( |-)'; then
        if [ "$signal_workers" -eq 0 ]; then
            echo "gcc/python changed during startup update"
            return 0
        fi

        echo "gcc/python changed, asking workers to exit after their current batch"

        for worker_dir in /home/worker/worker*/worker; do
            if [ -d "$worker_dir" ]; then
                touch "$worker_dir/fish.exit"
            fi
        done

        return 10
    fi

    return 0
}

if [ "${1:-}" = "--once" ]; then
    run_update 0 || true
    exit 0
fi

while true; do
    if run_update; then
        sleep "$UPDATE_INTERVAL_SECONDS"
    else
        update_status=$?

        if [ "$update_status" -eq 10 ]; then
            exit 0
        fi

        sleep "$UPDATE_INTERVAL_SECONDS"
    fi
done