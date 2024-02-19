# !bin/bash

# set -e

# . print_process_logfile.sh \
#     $(basename "$0" .sh)

print_process_logfile_2.sh test4 2>&1


text=$1

echo "hi $text"

echo "hello world"