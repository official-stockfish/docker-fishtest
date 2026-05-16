#!/bin/bash

set -euo pipefail

/updater.sh --once || true
/updater.sh &

exec gosu worker "$@"
