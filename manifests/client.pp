# = Class: bacula::client
#
# This script installs the bacula-client (fd)
#
#
# This class is not to be called directly. See init.pp for details.
#

class bacula::client {

  include bacula

  ### Client specific checks
  $real_client_password = $bacula::client_password ? {
    ''      => $bacula::real_default_password,
    default => $bacula::client_password,
  }

  $manage_client_file_content = $bacula::client_template ? {
    ''      => undef,
    default => template($bacula::client_template),
  }

  $manage_client_file_source = $bacula::client_source ? {
    ''        => undef,
    default   => $bacula::client_source,
  }

  $manage_client_service_autorestart = $bacula::bool_service_autorestart ? {
    true    => Service[$bacula::client_service],
    default => undef,
  }

  ### Managed resources
  package { $bacula::client_package:
    ensure  => $bacula::manage_package,
    noop    => $bacula::noops,
  }

  file { 'bacula-fd.conf':
    ensure  => $bacula::manage_file,
    path    => $bacula::client_config_file,
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package[$bacula::client_package],
    notify  => $manage_client_service_autorestart,
    source  => $manage_client_file_source,
    content => $manage_client_file_content,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
    noop    => $bacula::noops,
  }

  service { $bacula::client_service:
      ensure     => $bacula::manage_service_ensure,
      name       => $bacula::client_service,
      enable     => $bacula::manage_service_enable,
      hasstatus  => $bacula::service_status,
      pattern    => $bacula::client_process,
      require    => Package[$bacula::client_package],
      noop       => $bacula::noops,
    }


  ### Provide puppi data, if enabled ( puppi => true )
  if $bacula::bool_puppi == true {
    $classvars=get_class_args()
    puppi::ze { 'bacula-client':
      ensure    => $bacula::manage_file,
      variables => $classvars,
      helper    => $bacula::puppi_helper,
      noop      => $bacula::noops,
    }
  }

  ### Service monitoring, if enabled ( monitor => true )
  if $bacula::bool_monitor == true {
    if $bacula::client_port != '' {
      monitor::port { "monitor_bacula_client_${bacula::protocol}_${bacula::client_port}":
        protocol => $bacula::protocol,
        port     => $bacula::client_port,
        target   => $bacula::monitor_target,
        tool     => $bacula::monitor_tool,
        enable   => $bacula::manage_monitor,
        noop     => $bacula::noops,
      }
    }
    if $bacula::client_service != '' {
      monitor::process { 'bacula_client_process':
        process  => $bacula::client_process,
        service  => $bacula::client_service,
        pidfile  => $bacula::client_pid_file,
        user     => $bacula::process_user,
        argument => $bacula::process_args,
        tool     => $bacula::monitor_tool,
        enable   => $bacula::manage_monitor,
        noop     => $bacula::noops,
      }
    }
  }


  ### Firewall management, if enabled ( firewall => true )
  if $bacula::bool_firewall == true and $bacula::client_port != '' {
    firewall { "firewall_bacula_client_${bacula::protocol}_${bacula::client_port}":
      source      => $bacula::firewall_src,
      destination => $bacula::firewall_dst,
      protocol    => $bacula::protocol,
      port        => $bacula::client_port,
      action      => 'allow',
      direction   => 'input',
      tool        => $bacula::firewall_tool,
      enable      => $bacula::manage_firewall,
      noop        => $bacula::noops,
    }
  }


  ### Debugging, if enabled ( debug => true )
  if $bacula::bool_debug == true {
    file { 'debug_client_bacula':
      ensure  => $bacula::manage_file,
      path    => "${settings::vardir}/debug-client-bacula",
      mode    => '0640',
      owner   => 'root',
      group   => 'root',
      content => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/ }.to_yaml %>'),
      noop    => $bacula::noops,
    }
  }


}
