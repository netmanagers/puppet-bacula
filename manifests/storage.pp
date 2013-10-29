# = Class: bacula::storage
#
# This script installs the bacula-storage (sd)
#
#
# This class is not to be called directly. See init.pp for details.
#

class bacula::storage {

  include bacula

  ### Storage specific checks
  $real_storage_password = $bacula::storage_password ? {
    ''      => $bacula::real_default_password,
    default => $bacula::storage_password,
  }

  $manage_storage_file_content = $bacula::storage_template ? {
    ''      => undef,
    default => template($bacula::storage_template),
  }

  $manage_storage_file_source = $bacula::storage_source ? {
    ''        => undef,
    default   => $bacula::storage_source,
  }

  $manage_storage_service_autorestart = $bacula::bool_service_autorestart ? {
    true    => Service[$bacula::storage_service],
    default => undef,
  }

  ### Managed resources
  package { $bacula::storage_package:
    ensure  => $bacula::manage_package,
    noop    => $bacula::noops,
  }

  if  $bacula::storage_configs_dir != $bacula::config_dir and
      !defined(File['bacula-storage_configs_dir']) {
    file { 'bacula-storage_configs_dir':
      ensure  => directory,
      path    => $bacula::storage_configs_dir,
      mode    => $bacula::config_file_mode,
      owner   => $bacula::config_file_owner,
      group   => $bacula::config_file_group,
      require => Package[$bacula::storage_package],
      audit   => $bacula::manage_audit,
      noop    => $bacula::noops,
    }
  }

  file { 'bacula-sd.conf':
    ensure  => $bacula::manage_file,
    path    => $bacula::storage_config_file,
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package[$bacula::storage_package],
    notify  => $manage_storage_service_autorestart,
    source  => $manage_storage_file_source,
    content => $manage_storage_file_content,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
    noop    => $bacula::noops,
  }

  service { $bacula::storage_service:
    ensure     => $bacula::manage_service_ensure,
    name       => $bacula::storage_service,
    enable     => $bacula::manage_service_enable,
    hasstatus  => $bacula::service_status,
    pattern    => $bacula::storage_process,
    require    => Package[$bacula::storage_package],
    noop       => $bacula::noops,
  }

  ### Provide puppi data, if enabled ( puppi => true )
  if $bacula::bool_puppi == true {
    $classvars=get_class_args()
    puppi::ze { 'bacula-storage':
      ensure    => $bacula::manage_file,
      variables => $classvars,
      helper    => $bacula::puppi_helper,
      noop      => $bacula::noops,
    }
  }


  ### Service monitoring, if enabled ( monitor => true )
  if $bacula::bool_monitor == true {
    if $bacula::storage_port != '' {
      monitor::port { "monitor_bacula_storage_${bacula::protocol}_${bacula::storage_port}":
        protocol => $bacula::protocol,
        port     => $bacula::storage_port,
        target   => $bacula::monitor_target,
        tool     => $bacula::monitor_tool,
        enable   => $bacula::manage_monitor,
        noop     => $bacula::noops,
      }
    }
    if $bacula::storage_service != '' {
      monitor::process { 'bacula_storage_process':
        process  => $bacula::storage_process,
        service  => $bacula::storage_service,
        pidfile  => $bacula::storage_pid_file,
        user     => $bacula::process_user,
        argument => $bacula::process_args,
        tool     => $bacula::monitor_tool,
        enable   => $bacula::manage_monitor,
        noop     => $bacula::noops,
      }
    }
  }


  ### Firewall management, if enabled ( firewall => true )
  if $bacula::bool_firewall == true and $bacula::storage_port != '' {
    firewall { "firewall_bacula_storage_${bacula::protocol}_${bacula::storage_port}":
      source      => $bacula::firewall_src,
      destination => $bacula::firewall_dst,
      protocol    => $bacula::protocol,
      port        => $bacula::storage_port,
      action      => 'allow',
      direction   => 'input',
      tool        => $bacula::firewall_tool,
      enable      => $bacula::manage_firewall,
      noop        => $bacula::noops,
    }
  }


  ### Debugging, if enabled ( debug => true )
  if $bacula::bool_debug == true {
    file { 'debug_storage_bacula':
      ensure  => $bacula::manage_file,
      path    => "${settings::vardir}/debug-storage-bacula",
      mode    => '0640',
      owner   => 'root',
      group   => 'root',
      content => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/ }.to_yaml %>'),
      noop    => $bacula::noops,
    }
  }

}

