# = Class: bacula::console
#
# This script installs the bacula-manage_console
#
#
# This class is not to be called directly. See init.pp for details.
#

class bacula::console {

  include bacula

  $real_console_password = $bacula::console_password ? {
    ''      => $bacula::real_default_password,
    default => $bacula::console_password,
  }

  $manage_console_file_content = $bacula::console_template ? {
    ''      => undef,
    default => template($bacula::console_template),
  }

  $manage_console_file_source = $bacula::console_source ? {
    ''        => undef,
    default   => $bacula::console_source,
  }

  ### Managed resources
  package { $bacula::console_package:
    ensure  => $bacula::manage_package,
    noop    => $bacula::noops,
  }

  file { 'bconsole.conf':
    ensure  => $bacula::manage_file,
    path    => $bacula::console_config_file,
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package[$bacula::console_package],
    source  => $manage_console_file_source,
    content => $manage_console_file_content,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
    noop    => $bacula::noops,
  }


}

