#! /bin/bash

/usr/bin/mysql -uroot -p"$(cat /run/secrets/mysql_root)" <  /docker-entrypoint-initdb.d/default_shema.sql

echo "Update postdove password";
/usr/bin/mysql -uroot -p"$(cat /run/secrets/mysql_root)" -e "ALTER USER postdove@'%' IDENTIFIED BY '$(cat /run/secrets/mysql_postdove_password)'"

echo "Update nextcloud password";
/usr/bin/mysql -uroot -p"$(cat /run/secrets/mysql_root)" -e "ALTER USER nextcloud@'%' IDENTIFIED BY '$(cat /run/secrets/mysql_nextcloud_password)'"
