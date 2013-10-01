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

  $real_password = $password ? {
    ''      => $bacula::real_master_password,
    default => $password,
  } 

  $manage_storage_file_content = $template ? {
    ''      => undef,
    default => template($template),
  }

  $manage_storage_file_source = $source ? {
    ''        => undef,
    default   => $source,
  }

  $manage_storage_service_autorestart = $bacula::bool_service_autorestart ? {
    true    => Service[$bacula::storage_service],
    default => undef,
  }

  file { "storage-${name}.conf":
    ensure  => $bacula::manage_file,
    path    => "${bacula::director_configs_dir}/storage-${name}.conf",
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package[$bacula::director_package],
    notify  => $manage_storage_service_autorestart,
    source  => $manage_storage_file_source,
    content => $manage_storage_file_content,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
  }

}

