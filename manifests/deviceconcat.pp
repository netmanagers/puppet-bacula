# This define APPENDS a line entry to a device file
#
define bacula::deviceconcat (
  $mediaType = '',
  $archive_device = '',
  $label_media = '',
  $ramdon_access = '',
  $automatic_mount = '' ) {

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

  concat::fragment { "dnsmasq_addn_hosts_${name}":
    target  => $concat_host_file,
    content => inline_template("<%= real_ip %> <%= names * ' ' %>\n"),
    order   => $order,
    ensure  => $ensure,
    notify  => Service['dnsmasq'],
  }
}
