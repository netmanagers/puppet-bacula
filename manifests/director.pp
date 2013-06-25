# = Class: bacula::director
#
# This script installs the bacula-director (dir)
#
#
# This class is not to be called directly. See init.pp for details.
#

class bacula::director {

  include bacula

  ### Managed resources
  package { $bacula::director_package:
    ensure  => $bacula::manage_package,
    noop    => $bacula::bool_noops,
  }

  file { 'bacula-dir.conf':
    ensure  => $bacula::manage_file,
    path    => $bacula::director_config_file,
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package[$bacula::director_package],
    notify  => $bacula::manage_service_autorestart,
    source  => $bacula::manage_director_file_source,
    content => $bacula::manage_director_file_content,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
    noop    => $bacula::bool_noops,
  }

}

