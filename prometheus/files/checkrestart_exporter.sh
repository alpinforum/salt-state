#!/bin/bash
FILENAME="/var/prometheus/checkrestart.prom"

COUNT=$(checkrestart -p 2>/dev/null | head -n1 | awk '{ print $2 }')
cat - <<EOF > $FILENAME
# HELP checkrestart_process_count checkrestart count of processes with old libraries
# TYPE checkrestart_process_count gauge
checkrestart_process_count ${COUNT:-0}
EOF
