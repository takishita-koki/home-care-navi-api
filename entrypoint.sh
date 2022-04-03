#!/bin/bash
set -e

rm -f /railsapp/tmp/pids/server.pid

exec "$@"