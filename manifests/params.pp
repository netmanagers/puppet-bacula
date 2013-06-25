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

  $is_client     = 'false',

  $is_storage    = 'false',

  $is_director   = 'false',

  manage_console = 'false',

  $client_package = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'bacula-fd',
    default => 'bacula-client',
  }

  $storage_package = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'bacula-sd-mysql',
    default => 'bacula-storage-mysql',
  }

  $director_package = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'bacula-director-mysql',
    default => 'bacula-director-mysql',
  }

  $console_package = $::operatingsystem ? {
    default => 'bacula-console',
  }

  $client_service = $::operatingsystem ? {
    default => 'bacula',
  }

  $service_status = $::operatingsystem ? {
    default => true,
  }

  $process = $::operatingsystem ? {
    default => 'bacula',
  }

  $process_args = $::operatingsystem ? {
    default => '',
  }

  $process_user = $::operatingsystem ? {
    default => 'bacula',
  }

  $config_dir = $::operatingsystem ? {
    default => '/etc/bacula',
  }

  $config_file = $::operatingsystem ? {
    default => '/etc/bacula/bacula.conf',
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

  $pid_file = $::operatingsystem ? {
    default => '/var/run/bacula.pid',
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

  $port = '42'
  $protocol = 'tcp'

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = ''
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
  $noops = false

}
