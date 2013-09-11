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

  ## Bacula client variables
  $fd_name                    = $::fqdn
  $client_port                = '9102'
  $fd_PidDirectory            = ''
  $client_pid_file = $::operatingsystem ? {
    default => '/var/run/bacula-fd.9102.pid',
  }

  $fd_maximum_concurrent_jobs = ''
  $fd_address                 = ''
  $hearbeat_interval          = ''
  $fd_messages_name           = ''

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

  ## Bacula storage variables
  $sd_name                    = ''
  $sd_address                 = ''
  $sd_port                    = ''
  $sd_working_directory       = ''
  $sd_pid_directory           = ''
  $sd_max_concurrent_jobs     = ''
  $sd_heartbeat_interval      = ''
  $sd_director_name           = ''
  $sd_director_password       = ''
  $sd_traymonitor_name        = ''
  $sd_traymonitor_password    = ''
  $sd_traymonitor             = ''
  $sd_messages_name           = ''
  $sd_config_directory        = ''

  $storage_package = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'bacula-sd-mysql',
    default                   => 'bacula-storage-mysql',
  }

  $storage_service = $::operatingsystem ? {
    default => 'bacula-sd',
  }

  $storage_process = $::operatingsystem ? {
    default => 'bacula-sd',
  }

  $storage_process_user = $::operatingsystem ? {
    default => 'bacula',
  }

  ## Bacula director variables
  $dir_name                   = ''
  $dir_address                = ''
  $dir_port                   = ''
  $dir_query_file             = ''
  $dir_working_directory      = ''
  $dir_pid_directory          = ''
  $dir_max_concurrent_jobs    = ''
  $dir_heartbeat_interval     = ''
  $dir_password               = ''
  $dir_traymonitor_name       = ''
  $dir_traymonitor_password   = ''
  $dir_traymonitor_command    = ''
  $dir_messages               = ''
  $dir_config_directory       = ''
  $dir_client_directory       = ''

  $director_package = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'bacula-director-mysql',
    default                   => 'bacula-director-mysql',
  }

  $director_service = $::operatingsystem ? {
    default => 'bacula-dir',
  }

  $director_process = $::operatingsystem ? {
    default => 'bacula-dir',
  }

  ## Bacula console variables
  $console_director_name      = ''
  $console_director_password  = ''
  $console_director_port      = ''
  $console_address            = ''

  $console_package = $::operatingsystem ? {
    default => 'bacula-console',
  }

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

  $config_dir = $::operatingsystem ? {
    default => '/etc/bacula',
  }

  $client_config_file = $::operatingsystem ? {
    default => '/etc/bacula/bacula-fd.conf',
  }

  $storage_config_file = $::operatingsystem ? {
    default => '/etc/bacula/bacula-sd.conf',
  }

  $director_config_file = $::operatingsystem ? {
    default => '/etc/bacula/bacula-dir.conf',
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
  $noops = undef
}
