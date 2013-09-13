define bacula::director_storages (
  $director_storages_name = '',
  $director_storages_device = '' ,
  $director_storages_media_type = '',
  $director_storages_address = '',
  $director_storages_sd_port = '' ,
  $director_storages_password = '',
  $max_concurrent = '',
  $manage_file_content = '' {

  include bacula

  file { 'storages.conf':
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

