#!/bin/bash

# === CONFIGURATION ===
DB_HOST="localhost"
DB_USER="root"
DB_NAME="taskapp_dev"

BACKUP_DIR=$(pwd)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${DB_NAME}_${TIMESTAMP}.sql"
LOG_FILE="${BACKUP_DIR}/backup.log"

# Retain only last N backups (set to 0 to disable)
RETENTION=7

# === FUNCTIONS ===

log() {
    echo "$(date +'%F %T') - $1" >> "$LOG_FILE"
}

cleanup_old_backups() {
    if [[ $RETENTION -gt 0 ]]; then
        find "$BACKUP_DIR" -name "${DB_NAME}_*.sql.gz" -type f -mtime +$RETENTION -exec rm -f {} \;
        log "Old backups cleaned (older than $RETENTION days)."
    fi
}

# === MAIN EXECUTION ===

mkdir -p "$BACKUP_DIR"
cd "$BACKUP_DIR" || exit 1

log "Starting backup for database: $DB_NAME"

mysqldump --user="$DB_USER" --host="$DB_HOST" --single-transaction "$DB_NAME" > "$BACKUP_FILE"

if [[ $? -eq 0 ]]; then
    gzip "$BACKUP_FILE"
    log "Backup successful: ${BACKUP_FILE}.gz"
else
    log "ERROR: Backup failed!"
    rm -f "$BACKUP_FILE"
    exit 1
fi

cleanup_old_backups

