
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
  /bin/dd bs=32 count=1 if=/dev/urandom 2> /dev/null | /bin/base64 > /root_env/mysql/secrets/mysql_postdove
  echo "[X] creating new mysql postdove password"
else
  echo "[ ] creating new mysql postdove password"
fi

# amavis
/bin/mkdir -p /root_env/amavis/quarantine




