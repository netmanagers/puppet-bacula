# = Class: bacula::client
#
# This script installs the bacula-client (fd)
#
#
# This class is not to be called directly. See init.pp for details.
#

class bacula::client {

  include bacula

  ### Managed resources
  package { $bacula::client_package:
    ensure  => $bacula::manage_package,
    noop    => $bacula::bool_noops,
  }

  file { 'bacula-fd.conf':
    ensure  => $bacula::manage_file,
    path    => $bacula::client_config_file,
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package[$bacula::client_package],
    notify  => $bacula::manage_service_autorestart,
    source  => $bacula::manage_client_file_source,
    content => $bacula::manage_client_file_content,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
    noop    => $bacula::bool_noops,
  }

  service { $bacula::client_service:
      ensure     => $bacula::manage_service_ensure,
      name       => $bacula::client_service,
      enable     => $bacula::manage_service_enable,
      hasstatus  => $bacula::service_status,
      pattern    => $bacula::client_process,
      require    => Package[$bacula::client_package],
      noop       => $bacula::bool_noops,
    }

  ### Service monitoring, if enabled ( monitor => true )
  if $bacula::bool_monitor == true {
    if $bacula::client_service != '' {
      monitor::process { 'bacula-fd-monitor':
      process  => $bacula::client_process,
      service  => $bacula::client_service,
      pidfile  => $bacula::client_pid_file,
      user     => $bacula::process_user,
      argument => $bacula::process_args,
      tool     => $bacula::monitor_tool,
      enable   => $bacula::manage_monitor,
      noop     => $bacula::bool_noops,
      }
    }
  }

}
