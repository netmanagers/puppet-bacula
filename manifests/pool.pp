define bacula::pool (
  $pool_name = '',
  $pool_type = '',
  $maximum_volume_jobs = '',
  $maximum_volume_bytes = '',
  $use_volume_once  = '',
  $recycle = '',
  $action_on_purge = '' ,
  $auto_prune = '',
  $volume_retention = '',
  $label_format = '' ,
  $manage_file_content = '' {

  include bacula

  file { 'pool.conf':
    ensure  => $bacula::manage_file,
    path    => $bacula::config_file,
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package['bacula'],
    notify  => $bacula::manage_service_autorestart,
    source  => $bacula::manage_file_source,
    content => $bacula::manage_file_content,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
  }

}

