# Define bacula::storage::device
#
# Used to create devices in the storage manager
#
define bacula::storage::device (
  $device_type     = 'File',
  $media_type      = '',
  $archive_device  = '',
  $label_media     = 'yes',
  $random_access   = 'yes',
  $automatic_mount = 'yes',
  $removable_media = 'no' ,
  $always_open     = false,
  $source          = '',
  $options_hash    = {},
  $template        = 'bacula/storage/device.conf.erb'
) {

  include bacula

  $manage_storage_service_autorestart = $bacula::service_autorestart ? {
    true    => Service[$bacula::storage_service],
    default => undef,
  }


  $real_archive_device = $archive_device ? {
    ''      => $bacula::default_archive_device,
    default => $archive_device,
  }

  if $real_archive_device == '' {
    fail('$archive_device parameter required for bacula::storage::device define')
  }

  if  $device_type == 'File' and
      !defined(File[$real_archive_device]) {
    # Puppet lacks recursive dir creation, and we might use subdirs as storage
    exec { 'mkdir_archive_dir':
      path    => [ '/bin', '/usr/bin' ],
      command => "mkdir -p ${real_archive_device}",
      unless  => "test -d ${real_archive_device}",
    } ->
    file { $real_archive_device:
      ensure  => directory,
      mode    => '0750',
      owner   => $bacula::storage_device_owner,
      group   => $bacula::storage_device_group,
      require => Package[$bacula::storage_package],
      notify  => $manage_storage_service_autorestart,
      audit   => $bacula::manage_audit,
      noop    => $bacula::noops,
    }
  }

  $manage_device_file_content = $template ? {
    ''      => undef,
    default => template($template),
  }

  $manage_device_file_source = $source ? {
    ''        => undef,
    default   => $source,
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
