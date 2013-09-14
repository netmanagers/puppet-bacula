define bacula::director::storages (
  $name = '',
  $device = '' ,
  $media_type = '',
  $address = '',
  $sd_port = '' ,
  $password = '',
  $max_concurrent = '',
  $source = '',
  $template = ''
) {

  include bacula

  $manage_file_content = $template ? {
    '' => undef,
    default => template($template),
  }

  file { 'storages.conf':
    ensure  => $bacula::manage_file,
    path    => $bacula::config_file,
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package['bacula'],
    notify  => $bacula::manage_service_autorestart,
    source  => $manage_file_source,
    content => $manage_file_content,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
  }

}

