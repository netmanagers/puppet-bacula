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

 service { $bacula::storage_service:
      ensure     => $bacula::manage_service_ensure,
      name       => $bacula::storage_service,
      enable     => $bacula::manage_service_enable,
      hasstatus  => $bacula::service_status,
      pattern    => $bacula::storage_process,
      require    => Package[$bacula::storage_package],
      noop       => $bacula::bool_noops,
    }

  ### Service monitoring, if enabled ( monitor => true )
  if $bacula::bool_monitor == true {
    if $bacula::storage_service != '' {
      monitor::process { 'bacula-sd-monitor':
      process  => $bacula::storage_process,
      service  => $bacula::storage_service,
      pidfile  => $bacula::storage_pid_file,
      user     => $bacula::process_user,
      argument => $bacula::process_args,
      tool     => $bacula::monitor_tool,
      enable   => $bacula::manage_monitor,
      noop     => $bacula::bool_noops,
      }
    }
  }


}

