# Backup

Uses the systemd as a scheduler to run a backup script that uses `restic` to backup to local and s3

## Automation

- Copy the file `backup.service` and `backup.timer` to `/etc/systemd/system`
- Enable both services:

```sh
systemctl enable backup.service
systemctl enable backup.timer
```

- Start the timer service

```sh
systemctl start backup.timer
```

## Configuration

To change the recurrency of the backup, update the `OnCalendar` field in `backup.timer`
To change what and where to backup, update `backup.sh` script

## Useful commands

- `systemctl list-timers -all` to list all timed jobs in the system
- `systemctl daemon-reload` to reload all services after a change
