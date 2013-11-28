# == General Parameters and Defaults
#
# These parameters control the general behaviour of bacula's packages
#####################
#
# [*manage_client*]    #   Default: true
# [*manage_storage*]   #   Default: false
# [*manage_director*]  #   Default: false
# [*manage_console*]   #   Default: false
# [*manage_database*]  #   Default: false
#   Select which part of a bacula installation you want to manage in this host.
#   By default, the module just installs *bacula-client*, so in its simplest invocation
#   you can use it to install all your clients.
#   All bacula daemons can be installed on any given host.
#
# [*heartbeat_interval*]
#   Keepalive interval used in various parts of bacula
#   Default: 1 minute
#
# [*working_directory*]
#   Directory where bacula stores its files.
#   As some versions of bacula use /var/spool/bacula and others /var/lib/bacula, we
#   Create [*working_directory*] and make sure /var/lib/bacula is a symlink to it.
#   Default: /var/spool/bacula
#
#
#
#####################
# Defaults values
# These defaults set values that usually are required in multiple bacula's resources.
# Specifying them as defaults here, let you simplify your configurations, yet allowing
# to override them as needed.
#####################
#
# [*default_catalog*]
#   Catalog where to store bacula's records.
#   Default: bacula
#
# [*default_messages*]
#   Resource where messages will be directed to if no other specified.
#   Default: standard
#
# [*default_file_retention*]
#   Default file retention, if no other specified for a given resource.
#   Default: 60 days (bacula's default)
#
# [*default_job_retention*]
#   Default job retention if no other specified for a given resource.
#   Default: 180 days (bacula's default)
#
# [*default_jobdef*]
#   A jobdef declaration to be used as a default to create jobs, if no other specified.
#   Default: empty
#
# [*default_archive_device*]
#   When specifying multiple storage devices, a default archive device to be used
#   when no other specified.
#
# [*password_salt*]
#   Uses a salt with FQDN_RAND when generating the main password.
#   If you do not use this, the password can be reverse engineered very easily.
#   Example: $password_salt = 'smeg'
#
# [*default_password*]
#   Password to be useed everywhere where bacula requires a password, from the
#   database to all the clients and no specific password was declared.
#   Accepted values:
#     * Any string you want to use as a password.
#     * 'auto': a random password is generated and stored in
#       $config_dir/default_password
#     * empty: no default_password will be used.
#   If any of {director,console,traymon,client,storage}_password is given,
#   it will override this one for that particular password.
#   Default: 'auto'
