# Define bacula::director::pool
#
# Used to create pool resources
#
define bacula::director::pool (
  $type = 'Backup',
  $maximum_volume_jobs = '1',
  $maximum_volume_bytes = '1G',
  $use_volume_once  = true,
  $recycle = true,
  $action_on_purge = 'truncate' ,
  $auto_prune = true,
  $volume_retention = '1 month',
  $label_format = 'Volume-' ,
  $template = 'bacula/pool.conf.erb'
) {

  include bacula

  $manage_pool_file_content = $template ? {
    ''      => undef,
    default => template($template),
  }

  file { "pool-${name}.conf":
    ensure  => $bacula::manage_file,
    path    => "${bacula::director_configs_dir}/pool-${name}.conf",
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package[$bacula::director_package],
    notify  => $bacula::manage_service_autorestart,
    content => $manage_pool_file_content,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
  }

}

