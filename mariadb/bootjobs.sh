#! /bin/bash

echo "Update postdove password";
/usr/bin/mysql -uroot -p"$(cat /run/secrets/mysql_root)" -e "ALTER USER postdove@'%' IDENTIFIED BY '$(cat /run/secrets/mysql_postdove)'"
