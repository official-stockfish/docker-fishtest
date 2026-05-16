#!/bin/bash

set -euo pipefail

UPDATE_INTERVAL_SECONDS=43200

while true; do
    if ! update_output=$(pacman -Syu --noconfirm 2>&1); then
        printf '%s\n' "$update_output"
        sleep "$UPDATE_INTERVAL_SECONDS"
        continue
    fi

    printf '%s\n' "$update_output"

    if [[ "$update_output" == *") installing gcc "* ||
          "$update_output" == *") upgrading gcc "* ||
          "$update_output" == *") reinstalling gcc "* ||
          "$update_output" == *") installing python "* ||
          "$update_output" == *") upgrading python "* ||
          "$update_output" == *") reinstalling python "* ]]; then
        echo "gcc/python changed, asking workers to exit after their current batch"

        for worker_dir in /home/worker/worker*/worker; do
            if [ -d "$worker_dir" ]; then
                touch "$worker_dir/fish.exit"
            fi
        done

        exit 0
    fi

    sleep "$UPDATE_INTERVAL_SECONDS"
done
