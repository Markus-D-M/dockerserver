FROM mariadb:lts-jammy

# support for boot scripts
COPY docker-entrypoint-custom.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint-custom.sh"]

CMD ["mysqld"]


COPY default_shema.sql /docker-entrypoint-initdb.d
COPY bootjobs.sh /docker-entrypoint-always.d/

