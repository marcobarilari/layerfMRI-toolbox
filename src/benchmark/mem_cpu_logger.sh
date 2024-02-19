#!/bin/bash

ACTION=$1
USER=$2
TIMESTAMP=$(date '+%Y%m%d%H%M%S')
LOGFILE="usage_log_${TIMESTAMP}.tsv"
PIDFILE="pid.txt"

function start_logging {
  echo -e "Timestamp\tCPU_Usage_Mean_(%)\tCPU_Usage_SD_(%)\tMemory_Usage_Mean_(%)\tMemory_Usage_SD_(%)\tMemory_Usage_Mean_(GB)\tMemory_Usage_SD_(GB)" >> $LOGFILE
  while true; do
    CPU_USAGE_SAMPLES=()
    MEM_USAGE_SAMPLES=()
    MEM_USAGE_GB_SAMPLES=()
    for i in {1..60}; do
      CPU_USAGE_SAMPLES+=($(ps -u $USER -o %cpu= | awk '{sum+=$1} END {print sum}'))
      MEM_USAGE_SAMPLES+=($(ps -u $USER -o %mem= | awk '{sum+=$1} END {print sum}'))
      MEM_USAGE_GB_SAMPLES+=($(ps -u $USER -o rss= | awk '{sum+=$1} END {print sum / 1024 / 1024}'))
      sleep 1
    done
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    CPU_USAGE_MEAN=$(printf '%s\n' "${CPU_USAGE_SAMPLES[@]}" | awk '{sum+=$1} END {print sum / NR}')
    CPU_USAGE_SD=$(printf '%s\n' "${CPU_USAGE_SAMPLES[@]}" | awk -v mean=$CPU_USAGE_MEAN '{ssd+=($1-mean)*($1-mean);} END {print sqrt(ssd/NR); ssd=0}')
    MEM_USAGE_MEAN=$(printf '%s\n' "${MEM_USAGE_SAMPLES[@]}" | awk '{sum+=$1} END {print sum / NR}')
    MEM_USAGE_SD=$(printf '%s\n' "${MEM_USAGE_SAMPLES[@]}" | awk -v mean=$MEM_USAGE_MEAN '{ssd+=($1-mean)*($1-mean);} END {print sqrt(ssd/NR); ssd=0}')
    MEM_USAGE_GB_MEAN=$(printf '%s\n' "${MEM_USAGE_GB_SAMPLES[@]}" | awk '{sum+=$1} END {print sum / NR}')
    MEM_USAGE_GB_SD=$(printf '%s\n' "${MEM_USAGE_GB_SAMPLES[@]}" | awk -v mean=$MEM_USAGE_GB_MEAN '{ssd+=($1-mean)*($1-mean);} END {print sqrt(ssd/NR); ssd=0}')
    echo -e "$TIMESTAMP\t$CPU_USAGE_MEAN\t$CPU_USAGE_SD\t$MEM_USAGE_MEAN\t$MEM_USAGE_SD\t$MEM_USAGE_GB_MEAN\t$MEM_USAGE_GB_SD" >> $LOGFILE
  done &
  echo $! > $PIDFILE
}

function stop_logging {
  if [ -f $PIDFILE ]; then
    kill -9 $(cat $PIDFILE)
    rm $PIDFILE
  fi
}

if [ "$ACTION" = "start" ]; then
  start_logging
elif [ "$ACTION" = "stop" ]; then
  stop_logging
else
  echo "Invalid action. Use start or stop."
fi