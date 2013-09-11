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
    noop    => $bacula::noops,
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
    puppi::ze { 'bacula':
      ensure    => $bacula::manage_file,
      variables => $classvars,
      helper    => $bacula::puppi_helper,
      noop      => $bacula::noops,
    }
  }


  ### Service monitoring, if enabled ( monitor => true )
  if $bacula::bool_monitor == true {
    if $bacula::director_port != '' {
      monitor::port { "bacula_${bacula::protocol}_${bacula::director_port}":
        protocol => $bacula::protocol,
        port     => $bacula::director_port,
        target   => $bacula::monitor_target,
        tool     => $bacula::monitor_tool,
        enable   => $bacula::manage_monitor,
        noop     => $bacula::noops,
      }
    }
    if $bacula::service != '' {
      monitor::process { 'bacula_process':
        process  => $bacula::process,
        service  => $bacula::service,
        pidfile  => $bacula::pid_file,
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
    firewall { "bacula_${bacula::protocol}_${bacula::director_port}":
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
    file { 'debug_bacula':
      ensure  => $bacula::manage_file,
      path    => "${settings::vardir}/debug-bacula",
      mode    => '0640',
      owner   => 'root',
      group   => 'root',
      content => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/ }.to_yaml %>'),
      noop    => $bacula::noops,
    }
  }

}

