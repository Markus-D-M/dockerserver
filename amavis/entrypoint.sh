#!/bin/ash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color


rsyslogd

# intial spamassassin rules
echo -e "Updating spamassassin rules" | logger
sa-update --nogpg -v --updatedir=/var/lib/spamassassin/rules > /dev/null && echo "Rules updated" | logger || echo "No update required" | logger

# initial clamav databases
echo -e "Updating ClamAV databases" | logger
freshclam > /dev/null 2>&1 || echo "Rules updated" | logger && echo "Rules not updated" | logger

# start daemons
echo -e "Starting ClamAV" | logger
clamd
echo -e "Starting ClamAV update daemon" | logger
freshclam -d
echo -e "Starting Amavis" | logger
amavisd

sleep 3
echo "Container ready" | logger

while true
do
  sleep $(expr 12 \* 3600)
  # update spamassasssin rules and restart amavisd if needed
  sa-update --nogpg -v --updatedir=/var/lib/spamassassin/rules > /dev/null && amavisd reload
done

