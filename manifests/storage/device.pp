# This define APPENDS a line entry to a device file
#
define bacula::storage::device (
  $name = $title,
  $media_type = '',
  $archive_device = '',
  $label_media = 'yes',
  $random_access = 'yes',
  $automatic_mount = 'yes',
  $removable_media = 'no' ,
  $always_open = 'false',
  $template = 'templates/device.conf.erb'
) { 

  include bacula

  file { "device-${name}.conf":
    ensure  => $bacula::manage_file,
    path    => "${storage_configs_dir}/device-${name}.conf",
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package[$bacula::storage_package],
    notify  => $bacula::manage_service_autorestart,
    content => $template,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
  }
}
