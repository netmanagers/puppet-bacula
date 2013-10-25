# = Class: bacula::director
#
# This script installs the bacula-director (dir)
#
#
# This class is not to be called directly. See init.pp for details.
#

class bacula::director {

  include bacula

  ### Director specific checks

  $real_director_password = $bacula::director_password ? {
    ''      => $bacula::real_default_password,
    default => $bacula::director_password,
  }

  $manage_director_service_autorestart = $bacula::bool_service_autorestart ? {
    true    => Service[$bacula::director_service],
    default => undef,
  }


  ### Managed resources
  package { $bacula::director_package:
    ensure  => $bacula::manage_package,
    noop    => $bacula::noops,
  }

  if $bacula::director_configs_dir != $bacula::config_dir and !defined(File['bacula-director_configs_dir']) {
    file { 'bacula-director_configs_dir':
      ensure  => directory,
      path    => $bacula::director_configs_dir,
      mode    => $bacula::config_file_mode,
      owner   => $bacula::config_file_owner,
      group   => $bacula::config_file_group,
      require => Package[$bacula::director_package],
      audit   => $bacula::manage_audit,
      noop    => $bacula::noops,
    }
  }

  $manage_director_file_content = $bacula::director_template ? {
    ''      => undef,
    default => template($bacula::director_template),
  }

  $manage_director_file_source = $bacula::director_source ? {
    ''        => undef,
    default   => $bacula::director_source,
  }

  if $bacula::director_clients_dir != $bacula::config_dir and !defined(File['bacula-director_clients_dir']) {
    file { 'bacula-director_clients_dir':
      ensure  => directory,
      path    => $bacula::director_clients_dir,
      mode    => $bacula::config_file_mode,
      owner   => $bacula::config_file_owner,
      group   => $bacula::config_file_group,
      require => Package[$bacula::director_package],
      audit   => $bacula::manage_audit,
      noop    => $bacula::noops,
    }
  }

  file { 'bacula-dir.conf':
    ensure  => $bacula::manage_file,
    path    => $bacula::director_config_file,
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package[$bacula::director_package],
    notify  => $manage_director_service_autorestart,
    source  => $manage_director_file_source,
    content => $manage_director_file_content,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
    noop    => $bacula::noops,
  }

  service { $bacula::director_service:
    ensure     => $bacula::manage_service_ensure,
    name       => $bacula::director_service,
    enable     => $bacula::manage_service_enable,
    hasstatus  => $bacula::service_status,
    pattern    => $bacula::director_process,
    require    => Package[$bacula::director_package],
    noop       => $bacula::noops,
  }

  ### Provide puppi data, if enabled ( puppi => true )
  if $bacula::bool_puppi == true {
    $classvars=get_class_args()
    puppi::ze { 'bacula-director':
      ensure    => $bacula::manage_file,
      variables => $classvars,
      helper    => $bacula::puppi_helper,
      noop      => $bacula::noops,
    }
  }

  ### Service monitoring, if enabled ( monitor => true )
  if $bacula::bool_monitor == true {
    if $bacula::director_port != '' {
      monitor::port { "monitor_bacula_director_${bacula::protocol}_${bacula::director_port}":
        protocol => $bacula::protocol,
        port     => $bacula::director_port,
        target   => $bacula::monitor_target,
        tool     => $bacula::monitor_tool,
        enable   => $bacula::manage_monitor,
        noop     => $bacula::noops,
      }
    }
    if $bacula::director_service != '' {
      monitor::process { 'bacula_director_process':
        process  => $bacula::director_process,
        service  => $bacula::director_service,
        pidfile  => $bacula::director_pid_file,
        user     => $bacula::process_user,
        argument => $bacula::process_args,
        tool     => $bacula::monitor_tool,
        enable   => $bacula::manage_monitor,
        noop     => $bacula::noops,
      }
    }
  }


  ### Firewall management, if enabled ( firewall => true )
  if $bacula::bool_firewall == true and $bacula::director_port != '' {
    firewall { "firewall_bacula_client_${bacula::protocol}_${bacula::director_port}":
      source      => $bacula::firewall_src,
      destination => $bacula::firewall_dst,
      protocol    => $bacula::protocol,
      port        => $bacula::director_port,
      action      => 'allow',
      direction   => 'input',
      tool        => $bacula::firewall_tool,
      enable      => $bacula::manage_firewall,
      noop        => $bacula::noops,
    }
  }


  ### Debugging, if enabled ( debug => true )
  if $bacula::bool_debug == true {
    file { 'debug_director_bacula':
      ensure  => $bacula::manage_file,
      path    => "${settings::vardir}/debug-director-bacula",
      mode    => '0640',
      owner   => 'root',
      group   => 'root',
      content => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/ }.to_yaml %>'),
      noop    => $bacula::noops,
    }
  }

}

