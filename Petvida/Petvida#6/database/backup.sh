#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/../../backups"
mkdir -p "$BACKUP_DIR"
DATE="$(date +%Y%m%d)"
OUTPUT="$BACKUP_DIR/petvida_${DATE}.sql"
USER="${MYSQL_USER:-root}"
HOST="${MYSQL_HOST:-localhost}"

if [ -n "${MYSQL_PWD:-}" ]; then
  mysqldump -u"$USER" -p"$MYSQL_PWD" -h"$HOST" petvida > "$OUTPUT"
else
  mysqldump -u"$USER" -h"$HOST" petvida > "$OUTPUT"
fi

echo "Backup criado em: $OUTPUT"
