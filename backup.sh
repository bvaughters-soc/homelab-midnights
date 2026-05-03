#!/bin/bash
# Midnights01 Backup Script
# Backs up to WD My Cloud at /mnt/wdmc/midnights01/
# Run via cron — see crontab -e

DATE=$(date +%F)
BACKUP=/mnt/wdmc/midnights01
COMPOSE=~/homelab-midnights

echo "[$DATE] Starting Midnights01 backup..."

# ── Docker Compose ────────────────────────────────────────
cp $COMPOSE/docker-compose.yml $BACKUP/compose/docker-compose-$DATE.yml
echo "[$DATE] Compose file backed up"

# ── Config Files ──────────────────────────────────────────
tar -czf $BACKUP/configs/midnights-config-$DATE.tar.gz $COMPOSE/config/ 2>/dev/null
echo "[$DATE] Config files backed up"

# ── NetBox Database ───────────────────────────────────────
docker exec netbox-db pg_dump -U netbox netbox > $BACKUP/databases/netbox-$DATE.sql
echo "[$DATE] NetBox database backed up"

# ── Cleanup — keep last 7 days ────────────────────────────
find $BACKUP/compose -name "*.yml" -mtime +7 -delete
find $BACKUP/configs -name "*.tar.gz" -mtime +7 -delete
find $BACKUP/databases -name "*.sql" -mtime +7 -delete
echo "[$DATE] Old backups cleaned up"

echo "[$DATE] Midnights01 backup complete"
