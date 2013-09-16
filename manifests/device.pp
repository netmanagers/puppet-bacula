# This define APPENDS a line entry to a device file
#
define bacula::device (
  $device_name = '',
  $mediaType = '',
  $archive_device = '',
  $label_media = '',
  $ramdon_access = '',
  $automatic_mount = '',
  $removable_media = '' ,
  $always_open = '',
  $manage_file_content = ''{

  include bacula

file { 'device.conf':
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
