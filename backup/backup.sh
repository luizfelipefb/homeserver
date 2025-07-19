#!/bin/bash

# export .env variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export $(grep -v '^#' "$SCRIPT_DIR/.env" | xargs)

# exporting the PATH is needed for bash to find the restic command
export PATH="/home/luizfelipefb/.asdf/shims:$PATH"

# set local restic repository and perform backup
echo -e "\n-> Starting backup to local repository"
export RESTIC_REPOSITORY="/mnt/pool/backup"
restic backup /home/luizfelipefb/appdata/ /home/luizfelipefb/backup/
echo -e "\n-> Applying retention policy to local repository"
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --keep-yearly 3 --prune

# set remote restic repository and perform backup
echo -e "\n-> Starting backup to remote repository"
export RESTIC_REPOSITORY="s3:s3.us-east-1.amazonaws.com/squats-backup"
restic backup /home/luizfelipefb/appdata/ /home/luizfelipefb/backup/
echo -e "\n-> Applying retention policy to local repository"
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --keep-yearly 3 --prune
