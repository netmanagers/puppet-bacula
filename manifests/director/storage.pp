# Define bacula::director::storage
# 
# Used to create storage resources
# 
define bacula::director::storage (
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

  file { "storage-${name}.conf":
    ensure  => $bacula::manage_file,
    path    => "${bacula::director_configs_dir}/storage-${name}.conf",
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package[$bacula::director_package],
    notify  => $bacula::manage_service_autorestart,
    source  => $manage_file_source,
    content => $manage_file_content,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
  }

}

