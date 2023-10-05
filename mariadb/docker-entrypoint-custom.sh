#!/bin/bash

. /usr/local/bin/docker-entrypoint.sh

_custom_main() {
	# if command starts with an option, prepend mysqld
	if [ "${1:0:1}" = '-' ]; then
		set -- mysqld "$@"
	fi

	#ENDOFSUBSTITUTIONS
	# skip setup if they aren't running mysqld or want an option that stops mysqld
	if [ "$1" = 'mariadbd' ] || [ "$1" = 'mysqld' ] && ! _mysql_want_help "$@"; then
		mysql_note "Entrypoint script for MariaDB Server ${MARIADB_VERSION} started."

		mysql_check_config "$@"
		# Load various environment variables
		docker_setup_env "$@"
		docker_create_db_directories

		# If container is started as root user, restart as dedicated mysql user
		if [ "$(id -u)" = "0" ]; then
			mysql_note "Switching to dedicated user 'mysql'"
			exec gosu mysql "${BASH_SOURCE[0]}" "$@"
		fi

		# there's no database, so it needs to be initialized
		if [ -z "$DATABASE_ALREADY_EXISTS" ]; then
			docker_verify_minimum_env

			# check dir permissions to reduce likelihood of half-initialized database
			ls /docker-entrypoint-initdb.d/ > /dev/null

			docker_init_database_dir "$@"

			mysql_note "Starting temporary server"
			docker_temp_server_start "$@"
			mysql_note "Temporary server started."

			docker_setup_db
			docker_process_init_files /docker-entrypoint-initdb.d/*
			# Wait until after /docker-entrypoint-initdb.d is performed before setting
			# root@localhost password to a hash we don't know the password for.
			if [ -n "${MARIADB_ROOT_PASSWORD_HASH}" ]; then
				mysql_note "Setting root@localhost password hash"
				docker_process_sql --dont-use-mysql-root-password --binary-mode <<-EOSQL
					SET @@SESSION.SQL_LOG_BIN=0;
					SET PASSWORD FOR 'root'@'localhost'= '${MARIADB_ROOT_PASSWORD_HASH}';
				EOSQL
			fi

			mysql_note "Stopping temporary server"
			docker_temp_server_stop
			mysql_note "Temporary server stopped"

			echo
			mysql_note "MariaDB init process done. Ready for start up."
			echo
		# MDEV-27636 mariadb_upgrade --check-if-upgrade-is-needed cannot be run offline
		#elif mysql_upgrade --check-if-upgrade-is-needed; then
		elif _check_if_upgrade_is_needed; then
			docker_mariadb_upgrade "$@"
		fi
	fi
	if [ -d "/docker-entrypoint-always.d" ]; then
    mysql_note "Starting temporary server for startup scripts"
    docker_temp_server_start "$@"
    mysql_note "Temporary server started."
    docker_process_init_files /docker-entrypoint-always.d/*
    mysql_note "Stopping temporary server"
    docker_temp_server_stop
    mysql_note "Temporary server stopped"
  fi
	exec "$@"
}

_custom_main "$@"
