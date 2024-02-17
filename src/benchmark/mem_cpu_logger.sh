#!/bin/bash

ACTION=$1
USER=$2
LOGFILE="/mnt/HD_jupiter/marcobarilari/sandbox/sandbox_layerfMRI-pipeline/code/lib/layerfMRI-toolbox/src/benchmark/usage_segmentation-layers_v0.1.0-beta.tsv"
PID=""

function start_logging {
  echo -e "Timestamp\tCPU Usage (%)\tMemory Usage (%)\tMemory Usage (GB)" >> $LOGFILE
  while true; do
    TIMESTAMP=$(date '+%Y-%m-%d_%H:%M:%S')
    CPU_USAGE=$(ps -u $USER -o %cpu= | awk '{sum+=$1} END {print sum}')
    MEM_USAGE=$(ps -u $USER -o %mem= | awk '{sum+=$1} END {print sum}')
    MEM_USAGE_GB=$(ps -u $USER -o rss= | awk '{sum+=$1} END {print sum / 1024 / 1024}')
    echo -e "$TIMESTAMP\t$CPU_USAGE\t$MEM_USAGE\t$MEM_USAGE_GB" >> $LOGFILE
    sleep 120
  done &
  PID=$!
}

function stop_logging {
  kill -9 $PID
}

if [ "$ACTION" = "start" ]; then
  start_logging
elif [ "$ACTION" = "stop" ]; then
  stop_logging
else
  echo "Invalid action. Use start or stop."
fi