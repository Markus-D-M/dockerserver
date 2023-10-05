create database if not exists mailserver;

create table mailserver.alias
(
    id    int auto_increment primary key,
    alias tinytext null,
    user  tinytext null
)
    engine = INNODB;

create table mailserver.user
(
    id       int auto_increment primary key,
    name     tinytext null,
    mail     int      null,
    home     tinytext null,
    passhash tinytext null
)
    engine = INNODB;

CREATE USER IF NOT EXISTS 'postdove'@'%';

grant select on table mailserver.user to 'postdove'@'%';
grant select on table mailserver.alias to 'postdove'@'%';


