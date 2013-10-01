# = Class: bacula
#
# This is the main bacula class
#
#
# == Parameters
#
# [*master_password*]
#   Password to be useed everywhere where bacula requires a password, from the
#   database to all the clients.
#   Accepted values:
#     * Any string you want to use as a password.
#     * 'auto': a random password is generated and stored in
#       $config_dir/master_password
#     * empty: no master_password will be used.
#   If any of {director,console,traymon,client,storage}password is given,
#   it will override this one for that particular password.
#   Default: 'auto'
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
# [*source_director_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#   Can be defined also by the (top scope) variable $bacula_source_director_purge
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
#   Set to true to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $bacula_absent
#
# [*disable*]
#   Set to true to disable service(s) managed by module
#   Can be defined also by the (top scope) variable $bacula_disable
#
# [*disableboot*]
#   Set to true to disable service(s) at boot, without checks if it's running
#   Use this when the service is managed by a tool like a cluster software
#   Can be defined also by the (top scope) variable $bacula_disableboot
#
# [*monitor*]
#   Set to true to enable monitoring of the services provided by the module
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
#   Set to true to enable creation of module data files that are used by puppi
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
#   Set to true to enable firewalling of the services provided by the module
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
#   Set to true to enable modules debugging
#   Can be defined also by the (top scope) variables $bacula_debug and $debug
#
# [*audit_only*]
#   Set to true if you don't intend to override existing configuration files
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
# [* *_package*]
#   The name of bacula packages
#
# [* *_service*]
#   The name of bacula services
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
  $manage_client                  = params_lookup( 'manage_client' ),
  $manage_storage                 = params_lookup( 'manage_storage' ),
  $manage_director                = params_lookup( 'manage_director' ),
  $manage_console                 = params_lookup( 'manage_console' ),
  $working_directory              = params_lookup( 'working_directory' ),
  $pid_directory                  = params_lookup( 'pid_directory' ),
  $heartbeat_interval             = params_lookup( 'heartbeat_interval'),
  $master_password                = params_lookup( 'master_password' ),
  $client_package                 = params_lookup( 'client_package' ),
  $client_config_file             = params_lookup( 'client_config_file' ),
  $client_template                = params_lookup( 'client_template' ),
  $client_password                = params_lookup( 'client_password' ),
  $client_source                  = params_lookup( 'client_source' ),
  $client_service                 = params_lookup( 'client_service' ),
  $client_process                 = params_lookup( 'client_process' ),
  $client_pid_file                = params_lookup( 'client_pid_file' ),
  $client_name                    = params_lookup( 'client_name' ),
  $client_port                    = params_lookup( 'client_port' ),
  $client_max_concurrent          = params_lookup( 'client_max_concurrent' ),
  $client_address                 = params_lookup( 'client_address' ),
  $client_messages_name           = params_lookup( 'client_messages_name' ),
  $storage_package                = params_lookup( 'storage_package' ),
  $storage_config_file            = params_lookup( 'storage_config_file' ),
  $storage_password               = params_lookup( 'storage_password' ),
  $storage_template               = params_lookup( 'storage_template' ),
  $storage_source                 = params_lookup( 'storage_source' ),
  $storage_service                = params_lookup( 'storage_service' ),
  $storage_process                = params_lookup( 'storage_process' ),
  $storage_name                   = params_lookup( 'storage_name' ),
  $storage_address                = params_lookup( 'storage_address' ),
  $storage_port                   = params_lookup( 'storage_port' ),
  $storage_pid_directory          = params_lookup( 'storage_pid_directory' ),
  $storage_max_concurrent         = params_lookup( 'storage_max_concurrent' ),
  $storage_configs_dir            = params_lookup( 'storage_configs_dir' ),
  $director_package               = params_lookup( 'director_package' ),
  $director_config_file           = params_lookup( 'director_config_file' ),
  $director_template              = params_lookup( 'director_template' ),
  $director_source                = params_lookup( 'director_source' ),
  $director_service               = params_lookup( 'director_service' ),
  $director_process               = params_lookup( 'director_process' ),
  $director_name                  = params_lookup( 'director_name' ),
  $director_address               = params_lookup( 'director_address' ),
  $director_port                  = params_lookup( 'director_port' ),
  $director_query_file            = params_lookup( 'director_query_file' ),
  $director_max_concurrent        = params_lookup( 'director_max_concurrent' ),
  $director_password              = params_lookup( 'director_password' ),
  $director_messages              = params_lookup( 'director_messages' ),
  $director_configs_dir           = params_lookup( 'director_configs_dir' ),
  $director_clients_dir           = params_lookup( 'director_clients_dir' ),
  $console_package                = params_lookup( 'console_package' ),
  $console_director_name          = params_lookup( 'console_director_name'),
  $console_password               = params_lookup( 'console_password'),
  $console_director_port          = params_lookup( 'console_director_port'),
  $console_address                = params_lookup( 'console_address'),
  $console_template               = params_lookup( 'console_template' ),
  $console_source                 = params_lookup( 'console_source' ),
  $traymon_name                   = params_lookup( 'traymon_name'),
  $traymon_password               = params_lookup( 'traymon_password'),
  $service_status                 = params_lookup( 'service_status' ),
  $my_class                       = params_lookup( 'my_class' ),
  $log_dir                        = params_lookup( 'log_dir' ),
  $log_file                       = params_lookup( 'log_file' ),
  $protocol                       = params_lookup( 'protocol' ),
  $process_args                   = params_lookup( 'process_args' ),
  $process_user                   = params_lookup( 'process_user' ),
  $source                         = params_lookup( 'source' ),
  $source_dir                     = params_lookup( 'source_dir' ),
  $source_director_purge          = params_lookup( 'source_director_purge' ),
  $service_autorestart            = params_lookup( 'service_autorestart' , 'global' ),
  $config_dir                     = params_lookup( 'config_dir' ),
  $config_file_mode               = params_lookup( 'config_file_mode' ),
  $config_file_owner              = params_lookup( 'config_file_owner' ),
  $config_file_group              = params_lookup( 'config_file_group' ),
  $config_file_init               = params_lookup( 'config_file_init' ),
  $data_dir                       = params_lookup( 'data_dir' ),
  $options                        = params_lookup( 'options' ),
  $version                        = params_lookup( 'version' ),
  $absent                         = params_lookup( 'absent' ),
  $disable                        = params_lookup( 'disable' ),
  $disableboot                    = params_lookup( 'disableboot' ),
  $monitor                        = params_lookup( 'monitor' , 'global' ),
  $monitor_tool                   = params_lookup( 'monitor_tool' , 'global' ),
  $monitor_target                 = params_lookup( 'monitor_target' , 'global' ),
  $puppi                          = params_lookup( 'puppi' , 'global' ),
  $puppi_helper                   = params_lookup( 'puppi_helper' , 'global' ),
  $firewall                       = params_lookup( 'firewall' , 'global' ),
  $firewall_tool                  = params_lookup( 'firewall_tool' , 'global' ),
  $firewall_src                   = params_lookup( 'firewall_src' , 'global' ),
  $firewall_dst                   = params_lookup( 'firewall_dst' , 'global' ),
  $debug                          = params_lookup( 'debug' , 'global' ),
  $audit_only                     = params_lookup( 'audit_only' , 'global' ),
  $noops                          = params_lookup( 'noops' )
  ) inherits bacula::params {

  $bool_source_director_purge=any2bool($source_director_purge)
  $bool_service_autorestart=any2bool($service_autorestart)
  $bool_absent=any2bool($absent)
  $bool_disable=any2bool($disable)
  $bool_disableboot=any2bool($disableboot)
  $bool_monitor=any2bool($monitor)
  $bool_puppi=any2bool($puppi)
  $bool_firewall=any2bool($firewall)
  $bool_debug=any2bool($debug)
  $bool_audit_only=any2bool($audit_only)

  $bool_manage_client=any2bool($manage_client)
  $bool_manage_storage=any2bool($manage_storage)
  $bool_manage_director=any2bool($manage_director)
  $bool_manage_console=any2bool($manage_console)

  ### Definition of some variables used in the module

  ### Set a default password if required
  if $master_password == 'auto' {
    warning('FIXME! $master_password = auto still not implemented ')
    $real_master_password = 'auto'
  } else {
    $real_master_password = $bacula::master_password
  }

  # $traymon_password is not set up anywhere else, so we get a default value
  # for it

  $real_traymon_password = $bacula::traymon_password ? {
    ''      => $bacula::real_master_password,
    default => $bacula::traymon_password,
  }

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

  $manage_file = $bacula::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  ### Bconsole specific checks
  $manage_console_file_content = $bacula::console_template ? {
    ''      => undef,
    default => template($bacula::console_template),
  }

  $manage_console_file_source = $bacula::console_source ? {
    ''        => undef,
    default   => $bacula::console_source,
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

  ### Managed resources
  #### Include related classes

  ### Client configuration
  if $bacula::bool_manage_client == true {
    include bacula::client
  }

  ### Storage configuration
  if $bacula::bool_manage_storage == true {
    include bacula::storage
  }

  ### Director configuration
  if $bacula::bool_manage_director == true {
    include bacula::director
  }

  ### Console configuration
  if $bacula::bool_manage_console == true {
    include bacula::console
  }

  ### Include custom class if $my_class is set
  if $bacula::my_class {
    include $bacula::my_class
  }
}
