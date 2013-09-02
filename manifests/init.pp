# = Class: bacula
#
# This is the main bacula class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, bacula class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $bacula_myclass
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, bacula main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $bacula_source
#
# [*source_dir*]
#   If defined, the whole bacula configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $bacula_source_dir
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#   Can be defined also by the (top scope) variable $bacula_source_dir_purge
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, bacula main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $bacula_template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $bacula_options
#
# [*service_autorestart*]
#   Automatically restarts the bacula service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $bacula_absent
#
# [*disable*]
#   Set to 'true' to disable service(s) managed by module
#   Can be defined also by the (top scope) variable $bacula_disable
#
# [*disableboot*]
#   Set to 'true' to disable service(s) at boot, without checks if it's running
#   Use this when the service is managed by a tool like a cluster software
#   Can be defined also by the (top scope) variable $bacula_disableboot
#
# [*monitor*]
#   Set to 'true' to enable monitoring of the services provided by the module
#   Can be defined also by the (top scope) variables $bacula_monitor
#   and $monitor
#
# [*monitor_tool*]
#   Define which monitor tools (ad defined in Example42 monitor module)
#   you want to use for bacula checks
#   Can be defined also by the (top scope) variables $bacula_monitor_tool
#   and $monitor_tool
#
# [*monitor_target*]
#   The Ip address or hostname to use as a target for monitoring tools.
#   Default is the fact $ipaddress
#   Can be defined also by the (top scope) variables $bacula_monitor_target
#   and $monitor_target
#
# [*puppi*]
#   Set to 'true' to enable creation of module data files that are used by puppi
#   Can be defined also by the (top scope) variables $bacula_puppi and $puppi
#
# [*puppi_helper*]
#   Specify the helper to use for puppi commands. The default for this module
#   is specified in params.pp and is generally a good choice.
#   You can customize the output of puppi commands for this module using another
#   puppi helper. Use the define puppi::helper to create a new custom helper
#   Can be defined also by the (top scope) variables $bacula_puppi_helper
#   and $puppi_helper
#
# [*firewall*]
#   Set to 'true' to enable firewalling of the services provided by the module
#   Can be defined also by the (top scope) variables $bacula_firewall
#   and $firewall
#
# [*firewall_tool*]
#   Define which firewall tool(s) (ad defined in Example42 firewall module)
#   you want to use to open firewall for bacula port(s)
#   Can be defined also by the (top scope) variables $bacula_firewall_tool
#   and $firewall_tool
#
# [*firewall_src*]
#   Define which source ip/net allow for firewalling bacula. Default: 0.0.0.0/0
#   Can be defined also by the (top scope) variables $bacula_firewall_src
#   and $firewall_src
#
# [*firewall_dst*]
#   Define which destination ip to use for firewalling. Default: $ipaddress
#   Can be defined also by the (top scope) variables $bacula_firewall_dst
#   and $firewall_dst
#
# [*debug*]
#   Set to 'true' to enable modules debugging
#   Can be defined also by the (top scope) variables $bacula_debug and $debug
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $bacula_audit_only
#   and $audit_only
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: undef
#
# Default class params - As defined in bacula::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*package*]
#   The name of bacula package
#
# [*service*]
#   The name of bacula service
#
# [*service_status*]
#   If the bacula service init script supports status argument
#
# [*process*]
#   The name of bacula process
#
# [*process_args*]
#   The name of bacula arguments. Used by puppi and monitor.
#   Used only in case the bacula process name is generic (java, ruby...)
#
# [*process_user*]
#   The name of the user bacula runs with. Used by puppi and monitor.
#
# [*config_dir*]
#   Main configuration directory. Used by puppi
#
# [*config_file*]
#   Main configuration file path
#
# [*config_file_mode*]
#   Main configuration file path mode
#
# [*config_file_owner*]
#   Main configuration file path owner
#
# [*config_file_group*]
#   Main configuration file path group
#
# [*config_file_init*]
#   Path of configuration file sourced by init script
#
# [*pid_file*]
#   Path of pid file. Used by monitor
#
# [*data_dir*]
#   Path of application data directory. Used by puppi
#
# [*log_dir*]
#   Base logs directory. Used by puppi
#
# [*log_file*]
#   Log file(s). Used by puppi
#
# [*port*]
#   The listening port, if any, of the service.
#   This is used by monitor, firewall and puppi (optional) components
#   Note: This doesn't necessarily affect the service configuration file
#   Can be defined also by the (top scope) variable $bacula_port
#
# [*protocol*]
#   The protocol used by the the service.
#   This is used by monitor, firewall and puppi (optional) components
#   Can be defined also by the (top scope) variable $bacula_protocol
#
#
# See README for usage patterns.
#
class bacula (
  $my_class                   = params_lookup( 'my_class' ),
  $source                     = params_lookup( 'source' ),
  $source_dir                 = params_lookup( 'source_dir' ),
  $source_dir_purge           = params_lookup( 'source_dir_purge' ),
  $template                   = params_lookup( 'template' ),
  $service_autorestart        = params_lookup( 'service_autorestart' , 'global' ),
  $options                    = params_lookup( 'options' ),
  $version                    = params_lookup( 'version' ),
  $absent                     = params_lookup( 'absent' ),
  $disable                    = params_lookup( 'disable' ),
  $disableboot                = params_lookup( 'disableboot' ),
  $monitor                    = params_lookup( 'monitor' , 'global' ),
  $monitor_tool               = params_lookup( 'monitor_tool' , 'global' ),
  $monitor_target             = params_lookup( 'monitor_target' , 'global' ),
  $puppi                      = params_lookup( 'puppi' , 'global' ),
  $puppi_helper               = params_lookup( 'puppi_helper' , 'global' ),
  $firewall                   = params_lookup( 'firewall' , 'global' ),
  $firewall_tool              = params_lookup( 'firewall_tool' , 'global' ),
  $firewall_src               = params_lookup( 'firewall_src' , 'global' ),
  $firewall_dst               = params_lookup( 'firewall_dst' , 'global' ),
  $debug                      = params_lookup( 'debug' , 'global' ),
  $audit_only                 = params_lookup( 'audit_only' , 'global' ),
  $noops                      = params_lookup( 'noops' ),
  $client_package             = params_lookup( 'client_package' ),
  $storage_package            = params_lookup( 'storage_package' ),
  $director_package           = params_lookup( 'director_package' ),
  $console_package            = params_lookup( 'console_package' ),
  $service                    = params_lookup( 'service' ),
  $client_service             = params_lookup( 'client_service' ),
  $storage_service            = params_lookup( 'storage_service' ),
  $director_service           = params_lookup( 'director_service' ),
  $service_status             = params_lookup( 'service_status' ),
  $process                    = params_lookup( 'process' ),
  $client_process             = params_lookup( 'client_process' ),
  $storage_process            = params_lookup( 'storage_process' ),
  $director_process           = params_lookup( 'director_process' ),
  $process_args               = params_lookup( 'process_args' ),
  $process_user               = params_lookup( 'process_user' ),
  $config_dir                 = params_lookup( 'config_dir' ),
  $client_config_file         = params_lookup( 'client_config_file' ),
  $storage_config_file        = params_lookup( 'storage_config_file' ),
  $director_config_file       = params_lookup( 'director_config_file' ),
  $config_file_mode           = params_lookup( 'config_file_mode' ),
  $config_file_owner          = params_lookup( 'config_file_owner' ),
  $config_file_group          = params_lookup( 'config_file_group' ),
  $config_file_init           = params_lookup( 'config_file_init' ),
  $pid_file                   = params_lookup( 'pid_file' ),
  $data_dir                   = params_lookup( 'data_dir' ),
  $log_dir                    = params_lookup( 'log_dir' ),
  $log_file                   = params_lookup( 'log_file' ),
  $port                       = params_lookup( 'port' ),
  $protocol                   = params_lookup( 'protocol' ),
  $is_client                  = params_lookup( 'is_client' ),
  $is_storage                 = params_lookup( 'is_storage' ),
  $is_director                = params_lookup( 'is_director' ),
  $manage_console             = params_lookup( 'manage_console' ),
  $fd_director_name           = params_lookup( 'fd_director_name' ),
  $fd_director_password       = params_lookup( 'fd_director_password' ),
  $fd_traymonitor_name        = params_lookup( 'fd_traymonitor_name' ),
  $fd_traymonitor_password    = params_lookup( 'fd_traymonitor_password' ),
  $fd_traymonitor             = params_lookup( 'fd_traymonitor' ),
  $fd_name                    = params_lookup( 'fd_name' ),
  $fd_port                    = params_lookup( 'fd_port' ),
  $fd_WorkingDirectory        = params_lookup( 'fd_WorkingDirectory' ),
  $fd_PidDirectory            = params_lookup( 'fd_PidDirectory' ),
  $fd_maximun_concurrent_jobs = params_lookup( 'fd_maximun_concurrent_jobs' ),
  $fd_address                 = params_lookup( 'fd_address' ),
  $fd_hearbeat_interval       = params_lookup( 'fd_hearbeat_interval'),
  $fd_messages_name           = params_lookup( 'fd_messages_name' ),
  $console_director_name      = params_lookup( 'console_director_name'),
  $console_director_password  = params_lookup( 'console_director_password'),
  $console_director_port      = params_lookup( 'console_director_port'),
  $console_address            = params_lookup( 'console_address')
  ) inherits bacula::params {

  $bool_source_dir_purge=any2bool($source_dir_purge)
  $bool_service_autorestart=any2bool($service_autorestart)
  $bool_absent=any2bool($absent)
  $bool_disable=any2bool($disable)
  $bool_disableboot=any2bool($disableboot)
  $bool_monitor=any2bool($monitor)
  $bool_puppi=any2bool($puppi)
  $bool_firewall=any2bool($firewall)
  $bool_debug=any2bool($debug)
  $bool_audit_only=any2bool($audit_only)

  ### Definition of some variables used in the module
  $manage_package = $bacula::bool_absent ? {
    true  => 'absent',
    false => $bacula::version,
  }

  $manage_service_enable = $bacula::bool_disableboot ? {
    true    => false,
    default => $bacula::bool_disable ? {
      true    => false,
      default => $bacula::bool_absent ? {
        true  => false,
        false => true,
      },
    },
  }

  $manage_service_ensure = $bacula::bool_disable ? {
    true    => 'stopped',
    default =>  $bacula::bool_absent ? {
      true    => 'stopped',
      default => 'running',
    },
  }

  $manage_service_autorestart = $bacula::bool_service_autorestart ? {
    true    => Service[bacula],
    false   => undef,
  }

  $manage_file = $bacula::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  if $bacula::bool_absent == true
  or $bacula::bool_disable == true
  or $bacula::bool_disableboot == true {
    $manage_monitor = false
  } else {
    $manage_monitor = true
  }

  if $bacula::bool_absent == true
  or $bacula::bool_disable == true {
    $manage_firewall = false
  } else {
    $manage_firewall = true
  }

  $manage_audit = $bacula::bool_audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $bacula::bool_audit_only ? {
    true  => false,
    false => true,
  }

  $manage_file_source = $bacula::source ? {
    ''        => undef,
    default   => $bacula::source,
  }

  $manage_file_content = $bacula::template ? {
    ''        => undef,
    default   => template($bacula::template),
  }

  ### Managed resources
#  package { $bacula::package:
#    ensure  => $bacula::manage_package,
#    noop    => $bacula::noops,
#  }

#  service { 'bacula':
#    ensure     => $bacula::manage_service_ensure,
#    name       => $bacula::service,
#    enable     => $bacula::manage_service_enable,
#    hasstatus  => $bacula::service_status,
#    pattern    => $bacula::process,
#    require    => Package[$bacula::package],
#    noop       => $bacula::noops,
#  }

#  file { 'bacula.conf':
#    ensure  => $bacula::manage_file,
#    path    => $bacula::config_file,
#    mode    => $bacula::config_file_mode,
#    owner   => $bacula::config_file_owner,
#    group   => $bacula::config_file_group,
#    require => Package[$bacula::package],
#    notify  => $bacula::manage_service_autorestart,
#    source  => $bacula::manage_file_source,
#    content => $bacula::manage_file_content,
#    replace => $bacula::manage_file_replace,
#    audit   => $bacula::manage_audit,
#    noop    => $bacula::noops,
#  }

  # The whole bacula configuration directory can be recursively overriden
#  if $bacula::source_dir {
#    file { 'bacula.dir':
#      ensure  => directory,
#      path    => $bacula::config_dir,
#      require => Package[$bacula::package],
#      notify  => $bacula::manage_service_autorestart,
#      source  => $bacula::source_dir,
#      recurse => true,
#      purge   => $bacula::bool_source_dir_purge,
#      force   => $bacula::bool_source_dir_purge,
#      replace => $bacula::manage_file_replace,
#      audit   => $bacula::manage_audit,
#      noop    => $bacula::noops,
#    }
#  }


  #### Include related classes

  ### Client configuration
  if $bacula::is_client == 'true' {
    include bacula::client
  }

  ### Storage configuration
  if $bacula::is_storage == 'true' {
    include bacula::storage
  }

  ### Director configuration
  if $bacula::is_director == 'true' {
    include bacula::director
  }

  ### Console configuration
  if $bacula::manage_console == 'true' {
    include bacula::console
  }

  ### Include custom class if $my_class is set
  if $bacula::my_class {
    include $bacula::my_class
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
    if $bacula::port != '' {
      monitor::port { "bacula_${bacula::protocol}_${bacula::port}":
        protocol => $bacula::protocol,
        port     => $bacula::port,
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
  if $bacula::bool_firewall == true and $bacula::port != '' {
    firewall { "bacula_${bacula::protocol}_${bacula::port}":
      source      => $bacula::firewall_src,
      destination => $bacula::firewall_dst,
      protocol    => $bacula::protocol,
      port        => $bacula::port,
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
