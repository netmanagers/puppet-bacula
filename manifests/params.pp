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

  $is_client         = 'false'

  $is_storage        = 'false'

  $is_director       = 'false'

  $manage_console    = 'false'

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
    default => 'bacula-fd',
  }

  $storage_service = $::operatingsystem ? {
    default => 'bacula-sd',
  }

  $director_service = $::operatingsystem ? {
    default => 'bacula-dir',
  }

  $service_status = $::operatingsystem ? {
    default => true,
  }

  $process = $::operatingsystem ? {
    default => 'bacula',
  }

  $client_process = $::operatingsystem ? {
    default => 'bacula-fd',
  }

  $storage_process = $::operatingsystem ? {
    default => 'bacula-sd',
  }

  $director_process = $::operatingsystem ? {
    default => 'bacula-dir',
  }

  $process_args = $::operatingsystem ? {
    default => '',
  }

  $process_user = $::operatingsystem ? {
    default => 'bacula',
  }

  $client_process_user = $::operatingsystem ? {
    default => 'bacula',
  }

  $storage_process_user = $::operatingsystem ? {
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
  $noops = undef

  ## Bacula client variables
  $fd_director_name           = ''
  $fd_director_password       = ''
  $fd_traymonitor_name        = ''
  $fd_traymonitor_password    = ''
  $fd_traymonitor             = ''
  $fd_name                    = ''
  $fd_port                    = ''
  $fd_WorkingDirectory        = ''
  $fd_PidDirectory            = ''
  $fd_maximun_concurrent_jobs = ''
  $fd_address                 = ''
  $hearbeat_interval          = ''
  $fd_messages_name           = ''

  ## Bacula console variables
  $console_director_name      = ''
  $console_director_password  = ''
  $console_director_port      = ''
  $console_address            = ''

  ## Bacula storage variable
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

  ## Bacula director variable
  $dir_name                   = ''
  $dir_address                = ''
  $dir_port                   = ''
  $dir_query_file             = ''
  $dir_working_directory      = ''
  $dir_pid_directory          = ''
  $dir_max_concurrent_jobs    = ''
  $sd_heartbeat_interval      = ''
  $dir_password               = ''
  $dir_traymonitor_name       = ''
  $dir_traymonitor_password   = ''
  $dir_traymonitor_command    = ''
  $dir_messages               = ''
  $dir_config_directory       = ''
  $dir_client_directory       = ''

}
