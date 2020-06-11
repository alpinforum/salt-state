#!/bin/bash

echo "# HELP checkrestart_process_count checkrestart count of processes with old libraries"
echo "# TYPE checkrestart_process_count gauge"
COUNT=$(checkrestart -p 2>/dev/null | grep 'processes using old versions of upgraded files' | awk '{ print $2 }')
echo "checkrestart_process_count ${COUNT:-0}"
