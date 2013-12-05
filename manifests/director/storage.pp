# Define bacula::director::storage
#
# Used to create storage resources
#
define bacula::director::storage (
  $device = '',
  $media_type = '',
  $address = '',
  $sd_port = '9103',
  $password = '',
  $max_concurrent = '',
  $allow_compression = 'Yes',
  $source = '',
  $options_hash = {},
  $template = 'bacula/director/storage.conf.erb'
) {

  include bacula

  $manage_director_service_autorestart = $bacula::service_autorestart ? {
    true    => Service[$bacula::director_service],
    default => undef,
  }

  $real_password = $password ? {
    ''      => $bacula::real_default_password,
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

  file { "storage-${name}.conf":
    ensure  => $bacula::manage_file,
    path    => "${bacula::director_configs_dir}/storage-${name}.conf",
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package[$bacula::director_package],
    notify  => $manage_director_service_autorestart,
    source  => $manage_storage_file_source,
    content => $manage_storage_file_content,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
  }

}

