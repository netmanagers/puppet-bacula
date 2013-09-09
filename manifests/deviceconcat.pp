# This define APPENDS a line entry to a device file
#
define bacula::deviceconcat (
  $device_name = '',
  $mediaType = '',
  $archive_device = '',
  $label_media = '',
  $ramdon_access = '',
  $automatic_mount = '',
  $removable_media = '' ,
  $always_open = '' {

  include concat::setup
  include bacula

  $concat_host_file = "${dnsmasq::addn_hosts_dir}/${order}-${file}"

  if ! defined(Concat["${concat_host_file}"]) {
    concat { "${concat_host_file}":
      mode    => '0644',
      warn    => true,
      owner   => $bacula::config_file_owner,
      group   => $bacula::config_file_group,
      require => Package['bacula'],
    }
  }
}
