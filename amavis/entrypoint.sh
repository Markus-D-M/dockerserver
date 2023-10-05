#!/bin/ash

rsyslogd

freshclam
sa-update --nogpg -v


clamd
spamd -d -C /etc/mail/spamassassin

amavisd

while true
do
  sleep 1
done

