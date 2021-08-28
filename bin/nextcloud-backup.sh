#!/bin/bash

# Make arguments passed to script available globally
args=("$@")

LOG_PATH="/var/log/nextcloud-backup"
mkdir -p $LOG_PATH

LOG_FILE="$LOG_PATH/$(date +%Y%m).log"

# Redirect all script output to log file
# 1. Redirect file descriptor 3 to stdout and 4 to stderr
exec 3>&1 4>&2
# 2. When script exits with signal 0 1 2 3 15, restore file descriptors
trap 'exec 2>&4 1>&3' 0 1 2 3 15
# 3. Redirect stdout to log file, then redirect stderr to stdout.
#    Note that order matters, stdout must be redirected before stderr is redirected to stdout.
exec 1>>$LOG_FILE 2>&1
# From this point on, to print to console but not to log, redirect output to &3.
echo "Script outputs are redirected to $LOG_FILE" >&3


echo_usage()
{
  echo "Usage: nextcloud-backup --daily|--weekly|--monthly [--dryrun]" >&3 
  echo "Usage: nextcloud-backup --daily|--weekly|--monthly [--dryrun]"
}

echo_illegal_arg()
{
  echo "Illegal argument: first argument must be one of '--daily', '--weekly', '--monthly'" >&3
  echo "Illegal argument: first argument must be one of '--daily', '--weekly', '--monthly'"
}

log()
{
  echo "[$(date --iso-8601=ns)] [$1]:  $2"
}

INFO()
{
  log "INFO" "$1"
}

DEBUG()
{
  log "DEBUG" "$1"
}

ERROR()
{
  log "ERROR" "$1"
}

DRYRUN()
{
  DEBUG "Dryrun: '$1'"
}

is_dryrun()
{
  if [ "${args[1]}" = "--dryrun" ]; then
    true
  else
    false
  fi
}

is_mounted()
{
  # space after $1 is to get exact match
  if grep -qs "$1 " /proc/mounts; then
    DEBUG "$1 is mounted"
    true
  else
    DEBUG "$1 is not mounted"
    false
  fi
}

quit()
{
  INFO "Aborting."
  exit 1
}


INFO "Enter the main program"

HDD_MOUNT="/media/ext_hdd1"
DEVICE="/dev/sda1"
BACKUP_ROOT_DIR="$HDD_MOUNT/backup"

# Validate arguments
if [[ $# -lt 1 ]]; then
  echo "Illegal number of parameters" >&3
  echo_usage
  quit
fi

if [ "${args[0]}" = "--daily" ] || [ "${args[0]}" = "--weekly" ] || [ "${args[0]}" = "--monthly" ]; then
  DEBUG "Script was ran with ${args[0]}"
else
  echo_illegal_arg
  echo_usage
  quit
fi

INFO "Check if external hard drive $HDD_MOUNT is mounted"
if ! is_mounted $HDD_MOUNT; then
    DEBUG "Trying to mount $DEVICE to $HDD_MOUNT."
    if sudo mount -t ntfs $DEVICE $HDD_MOUNT; then
      DEBUG "Successfully mounted $DEVICE to $HDD_MOUNT."
    else
      ERROR "Failed to mount $DEVICE to $HDD_MOUNT."
      quit
    fi
fi

# Map directories to backup filename prefix at destination
declare -A BACKUP_DIRS=(["/home/kcskou"]="snowpea-home-kcskou-dirbkp" \
                        ["/var/www/nextcloud"]="nextcloud-dirbkp" \
                        ["$LOG_PATH"]="nextcloud-backup-script-log")

backup_dirs()
{
  INFO "${#BACKUP_DIRS[@]} directories to backup: ${!BACKUP_DIRS[*]}"
  local freq="${args[0]}"
  for bkp_dir in "${!BACKUP_DIRS[@]}";
  do
    local prefix=${BACKUP_DIRS[$bkp_dir]}
    local daily_dst="$BACKUP_ROOT_DIR/$prefix-daily"
    local weekly_dst="$BACKUP_ROOT_DIR/$prefix-weekly.tar.bz2"
    local monthly_dst="$BACKUP_ROOT_DIR/$prefix-monthly.tar.bz2"
    INFO "Start $freq backup for $bkp_dir"
    if [ "$freq" = "--daily" ]; then
      DEBUG "$bkp_dir => $daily_dst"
      if is_dryrun; then
        DRYRUN "rsync -Aaxhi --delete --stats $bkp_dir $daily_dst | grep -v \"^[\.]\""
      else
        rsync -Aaxhi --delete --stats $bkp_dir $daily_dst | grep -v "^[\.]"
      fi
    elif [ "$freq" = "--weekly" ]; then
      DEBUG "$daily_dst => $weekly_dst"
      if is_dryrun; then
        DRYRUN "tar -cjf $weekly_dst $daily_dst"
      else
        tar -cjf $weekly_dst $daily_dst
      fi
    elif [ "$freq" = "--monthly" ]; then
      DEBUG "$daily_dst => $monthly_dst"
      if is_dryrun; then
        DRYRUN "tar -cjf $monthly_dst $daily_dst"
      else
        tar -cjf $monthly_dst $daily_dst 
      fi
    else
      echo_illegal_arg
      quit
    fi
    INFO "End $freq backup for $bkp_dir"
  done
}


backup_db()
{
  local freq="${args[0]}"
  local daily_dst="$BACKUP_ROOT_DIR/nextcloud-sqlbkp-daily.bak"
  local weekly_dst="$BACKUP_ROOT_DIR/nextcloud-sqlbkp-weekly.bak"
  local monthly_dst="$BACKUP_ROOT_DIR/nextcloud-sqlbkp-monthly.bak"
  INFO "Start $freq backup for nextcloud database"
  if [ "$freq" = "--daily" ]; then
    DEBUG "mysqldump => $daily_dst"
    if is_dryrun; then
      DRYRUN "mysqldump --single-transaction nextcloud > $daily_dst"
    else
      mysqldump --single-transaction nextcloud > $daily_dst
    fi
  elif [ "$freq" = "--weekly" ]; then
    DEBUG "$daily_dst => $weekly_dst"
    if is_dryrun; then
      DRYRUN "cp $daily_dst $weekly_dst"
    else
      cp $daily_dst $weekly_dst
    fi
  elif [ "$freq" = "--monthly" ]; then
    DEBUG "$daily_dst => $monthly_dst"
    if is_dryrun; then
      DRYRUN "cp $daily_dst $monthly_dst"
    else
      cp $daily_dst $monthly_dst
    fi
  else
    echo_illegal_arg
    quit
  fi
  INFO "End $freq backup for nextcloud database"
}


backup_dirs
backup_db
