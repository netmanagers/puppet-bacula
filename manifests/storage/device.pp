# Define bacula::storage::device
#
# Used to create devices in the storage manager
#
define bacula::storage::device (
  $media_type      = '',
  $archive_device  = '',
  $label_media     = 'yes',
  $random_access   = 'yes',
  $automatic_mount = 'yes',
  $removable_media = 'no' ,
  $always_open     = false,
  $source          = '',
  $template        = 'bacula/storage/device.conf.erb'
) {

  include bacula

  $manage_device_file_content = $template ? {
    ''      => undef,
    default => template($template),
  }

  $manage_device_file_source = $source ? {
    ''        => undef,
    default   => $source,
  }

  $manage_storage_service_autorestart = $bacula::bool_service_autorestart ? {
    true    => Service[$bacula::storage_service],
    default => undef,
  }

  file { "device-${name}.conf":
    ensure  => $bacula::manage_file,
    path    => "${bacula::storage_configs_dir}/device-${name}.conf",
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package[$bacula::storage_package],
    notify  => $manage_storage_service_autorestart,
    content => $manage_device_file_content,
    source  => $manage_device_file_source,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
  }
}
