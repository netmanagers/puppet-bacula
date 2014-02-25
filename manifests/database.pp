# Class: bacula::database
#
# This class enforces database resources needed by all
# bacula components
#
# This class is not to be called individually
#
class bacula::database {

  include bacula

  $real_db_password = $bacula::database_password ? {
    ''      => $bacula::real_default_password,
    default => $bacula::database_password,
  }

  $script_directory = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/usr/share/bacula-director',
    default                   => '/usr/libexec/bacula',
  }

  $db_parameters = $bacula::database_backend ? {
    'sqlite' => '',
    'mysql'  => "--host=${bacula::database_host} --user=${bacula::database_user} --password=${real_db_password} --port=${bacula::database_port} --database=${bacula::database_name}",
  }

  if $bacula::manage_database {
    exec { 'create_db_and_tables':
      command     => "${script_directory}/create_bacula_database;
                      ${script_directory}/make_bacula_tables ${db_parameters}",
      refreshonly => true,
    }

    case $bacula::database_backend {
      'mysql': {
        require mysql::client

        $grant_query = "use mysql
          grant all privileges
            on ${bacula::database_name}.*
            to ${bacula::database_user}@localhost
            ${bacula::database_password};
          grant all privileges
            on ${bacula::database_name}.*
            to ${bacula::database_user}@\"%\"
            ${bacula::database_password};
          flush privileges;"

        $notify_create_db = $bacula::manage_database ? {
          true  => Exec['create_db_and_tables'],
          false => undef,
        }

        $require_classes = defined(Class['mysql::client']) ? {
          true  => Class['mysql::client'],
          false => undef,
        }

        mysql::query { 'grant_bacula_user_privileges':
          mysql_query => $grant_query,
          mysql_db    => undef,
          mysql_host  => $bacula::database_host,
          notify      => $notify_create_db,
          require     => $require_classes,
        }
      }
      'sqlite': {
        sqlite::db { $bacula::database_name:
          ensure   => present,
          location => "/var/lib/bacula/${bacula::database_name}.db",
          owner    => $bacula::process_user,
          group    => $bacula::process_group,
          require  => File['/var/lib/bacula'],
        }
      }
      default: {
        fail "The bacula module does not support managing the ${bacula::database_backend} backend database"
      }
    }
  }
}
