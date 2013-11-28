# == Database Related Parameters
#
#####################
#
# [*database_backend*]
#   Currently, one of 'mysql', 'sqlite'
#   Default: mysql
#
# [*database_host*]
#   Host where the database is located.
#   Default: localhost
#
# [*database_port*]
#   Port where the database server listens. In case of MySQL is commonly 3306.
#   Default: empty, so if [*database_backend*] is mysql, it will use sockets.
#
# [*database_name*]
#   Name of the database bacula will use.
#   Default: bacula
#
# [*database_user*]
#   User to connect to the database.
#   Default: bacula'
#
# [*database_password*]
#   Default: empty, which means [*default_password*] will be used.
