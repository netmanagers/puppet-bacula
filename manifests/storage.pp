# = Class: bacula::storage
#
# This script installs the bacula-storage (sd)
#
#
# This class is not to be called directly. See init.pp for details.
#

class bacula::storage {

  include bacula

  ### Managed resources
  package { $bacula::storage_package:
    ensure  => $bacula::manage_package,
    noop    => $bacula::bool_noops,
  }

  file { 'bacula-sd.conf':
    ensure  => $bacula::manage_file,
    path    => $bacula::storage_config_file,
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package[$bacula::storage_package],
    notify  => $bacula::manage_service_autorestart,
    source  => $bacula::manage_storage_file_source,
    content => $bacula::manage_storage_file_content,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
    noop    => $bacula::bool_noops,
  }

}

