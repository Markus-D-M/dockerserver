
# Create folder and file structure
# mariadb
/bin/mkdir -p /root_env/mysql/data /root_env/mysql/secrets
if [ ! -f /root_env/mysql/secrets/mysql_root ]; then
  /bin/dd bs=32 count=1 if=/dev/urandom 2> /dev/null | /bin/base64 > /root_env/mysql/secrets/mysql_root
  echo "[X] creating new mysql root password"
else
  echo "[ ] creating new mysql root password"
fi

if [ ! -f /root_env/mysql/secrets/mysql_postdove ]; then
  /bin/dd bs=32 count=1 if=/dev/urandom 2> /dev/null | /bin/base64 > /root_env/mysql/secrets/mysql_postdove_password
  echo "[X] creating new mysql postdove password"
else
  echo "[ ] creating new mysql postdove password"
fi

if [ ! -f /root_env/mysql/secrets/mysql_nextcloud ]; then
  /bin/dd bs=32 count=1 if=/dev/urandom 2> /dev/null | /bin/base64 > /root_env/mysql/secrets/mysql_nextcloud_password
  echo "[X] creating new mysql nextcloud password"
else
  echo "[ ] creating new mysql nextcloud password"
fi


# amavis
/bin/mkdir -p /root_env/amavis/quarantine

# nextcloud
/bin/mkdir -p /root_env/nextcloud/data
/bin/mkdir -p /root_env/nextcloud/secrets
cp /root_env/mysql/secrets/mysql_nextcloud_password /root_env/nextcloud/secrets/
echo "nextcloud" > /root_env/nextcloud/secrets/mysql_nextcloud_user
echo "nextcloud" > /root_env/nextcloud/secrets/mysql_nextcloud_database



