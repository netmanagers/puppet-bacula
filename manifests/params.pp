# Class: bacula::params
#
# This class defines default parameters used by the main module class bacula
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to bacula class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class bacula::params {

  ### Application related parameters

  $install_client   = true
  $install_storage  = false
  $install_director = false
  $install_console  = false

  ## Common variables
  $config_dir = $::operatingsystem ? {
    default => '/etc/bacula',
  }

  $pid_directory = $::operatingsystem ? {
    default => '/var/run',
  }
  $heartbeat_interval = '1 minute'
  $working_directory  = $::operatingsystem ? {
    default => '/var/spool/bacula'
  }

  ## Bacula client variables
  $client_name     = "${::fqdn}-fd"
  $client_port     = '9102'
  $client_address  = $::ipaddress
  $client_max_concurrent = '10'

  $client_config_file = $::operatingsystem ? {
    default => "${bacula::params::config_dir}/bacula-fd.conf",
  }

  $client_template = ''
  $client_source = ''

  $client_pid_file = $::operatingsystem ? {
    default => "${bacula::params::pid_directory}/bacula-fd.${bacula::params::client_port}.pid",
  }

  $client_package = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'bacula-fd',
    default                   => 'bacula-client',
  }

  $client_service = $::operatingsystem ? {
    default => 'bacula-fd',
  }

  $client_process = $::operatingsystem ? {
    default => 'bacula-fd',
  }

  ## Bacula director variables
  $director_name              = "${::fqdn}-dir"
  $director_port              = '9101'
  $director_address           = $::ipaddress
  $director_max_concurrent    = '30'
  $director_password          = ''
  $director_configs_dir = "${bacula::params::config_dir}/director.d"
  $director_clients_dir = "${bacula::params::config_dir}/clients.d"

  $director_package = $::operatingsystem ? {
    default                   => 'bacula-director-mysql',
  }

  $director_config_file = $::operatingsystem ? {
    default => '/etc/bacula/bacula-dir.conf',
  }

  $director_template = ''
  $director_source = ''

  $director_service = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'bacula-director',
    default => 'bacula-dir',
  }

  $director_process = $::operatingsystem ? {
    default => 'bacula-dir',
  }

  ## Bacula storage variables
  $storage_name                    = "${::fqdn}-sd"
  $storage_address                 = $::ipaddress
  $storage_port                    = '9103'
  $storage_max_concurrent          = '30'
  $storage_password                = ''
  $storage_messages_name           = ''
  $storage_configs_dir = "${bacula::params::config_dir}/storage.d"

  $storage_config_file = $::operatingsystem ? {
    default => '/etc/bacula/bacula-sd.conf',
  }

  $storage_package = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'bacula-sd-mysql',
    default                   => 'bacula-storage-mysql',
  }

  $storage_template = ''
  $storage_source = ''

  $storage_service = $::operatingsystem ? {
    default => 'bacula-sd',
  }

  $storage_process = $::operatingsystem ? {
    default => 'bacula-sd',
  }

  $storage_process_user = $::operatingsystem ? {
    default => 'bacula',
  }

  ## Tray Monitor
  $traymon_name     = "${::fqdn}-mon"
  $traymon_password = ''
  $traymon_command = 'status, .status'

  ## Bacula console variables
  $console_address            = ''

  $console_package = $::operatingsystem ? {
    default => 'bacula-console',
  }

  $console_template = ''
  $console_source = ''

  $service_status = $::operatingsystem ? {
    default => true,
  }

  $process_args = $::operatingsystem ? {
    default => '',
  }

  $process_user = $::operatingsystem ? {
    default => 'bacula',
  }

  $director_process_user = $::operatingsystem ? {
    default => 'bacula',
  }

  $console_config_file = $::operatingsystem ? {
    default => '/etc/bacula/bconsole.conf',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_init = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/default/bacula',
    default                   => '/etc/sysconfig/bacula',
  }

  $data_dir = $::operatingsystem ? {
    default => '/etc/bacula',
  }

  $log_dir = $::operatingsystem ? {
    default => '/var/log/bacula',
  }

  $log_file = $::operatingsystem ? {
    default => '/var/log/bacula/bacula.log',
  }

  $protocol = 'tcp'

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_director_purge = false
  $options = ''
  $service_autorestart = true
  $version = 'present'
  $absent = false
  $disable = false
  $disableboot = false

  ### General module variables that can have a site or per module default
  $monitor = false
  $monitor_tool = ''
  $monitor_target = $::ipaddress
  $firewall = false
  $firewall_tool = ''
  $firewall_src = '0.0.0.0/0'
  $firewall_dst = $::ipaddress
  $puppi = false
  $puppi_helper = 'standard'
  $debug = false
  $audit_only = false
  $noops = undef
}
