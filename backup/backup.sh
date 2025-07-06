#!/bin/bash

# s3 credentials
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""

# restic repository password
export RESTIC_PASSWORD=""

# exporting the PATH is needed for bash to find the restic command
export PATH="/home/luizfelipefb/.asdf/shims:$PATH"

# set local restic repository and perform backup
export RESTIC_REPOSITORY="/mnt/pool/backup"
restic backup /home/luizfelipefb/appdata/
echo -e "-> Backup to local repository completed\n"

# set remote restic repository and perform backup
export RESTIC_REPOSITORY="s3:s3.us-east-1.amazonaws.com/squats-backup"
restic backup /home/luizfelipefb/appdata/
echo "-> Backup to remote repository completed\n"
