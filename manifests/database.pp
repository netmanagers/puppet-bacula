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
    /(?i:Debian|Ubuntu|Mint)/ => 'usr/share/bacula-director',
    default                   => '/usr/libexec/bacula',
  }

  $db_parameters = $bacula::database_backend ? {
    'sqlite'     => '',
    'mysql'      => "--host=${bacula::database_host} --user=${bacula::database_user} --password=${real_db_password} --port=${bacula::database_port} --database=${bacula::database_name}",
    'postgresql' => "--host=${bacula::database_host} --user=${bacula::database_user} --password=${real_db_password} --port=${bacula::database_port} --database=${bacula::database_name}",
  }

  if $bacula::manage_database {
    exec { 'make_db_tables':
      command     => "${script_directory}/create_bacula_database;
                      ${script_directory}/make_bacula_tables ${db_parameters}",
      refreshonly => true,
    }
  }

  if $manage_db {
    case $bacula::database_backend {
      'mysql': {
        mysql::db { $bacula::database_name:
          user     => $bacula::database_user,
          password => $real_db_password,
          host     => $bacula::database_host,
          notify   => $bacula::manage_database ? {
            true  => Exec['make_db_tables'],
            false => undef,
          },
          require  => defined(Class['mysql::client']) ? {
            true  => Class['mysql::client'],
            false => undef,
          },
        }
      }

      'postgresql': {
        mysql::db { $bacula::database_name:
          user     => $bacula::database_user,
          password => $real_db_password,
          host     => $bacula::database_host,
          notify   => $bacula::manage_database ? {
            true  => Exec['make_db_tables'],
            false => undef,
          },
          require  => defined(Class['postgresql']) ? {
            true  => Class['postgresql'],
            false => undef,
          },
        }
      }

      'sqlite': {
        sqlite::db { $bacula::database_name:
          ensure   => present,
          location => "/var/lib/bacula/${bacula::database_name}.db",
          owner    => $bacula::process_owner,
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
