# Define bacula::director::fileset
#
# Used to create filesets resources
#
define bacula::director::fileset (
  $signature = '',
  $compression = '',
  $onefs = '',
  $fstype = '',
  $include = '',
  $exclude = '',
  $template = 'bacula/fileset.conf.erb'
) {

  include bacula

  $array_filesets_fstype = is_array($fstype) ? {
    false     => $fstype ? {
      ''      => [],
      default => [$fstype],
    },
    default   => $fstype,
  }

  $array_filesets_include = is_array($include) ? {
    false     => $include ? {
      ''      => [],
      default => [$include],
    },
    default   => $include,
  }

  $array_filesets_exclude = is_array($exclude) ? {
    false     => $exclude ? {
      ''      => [],
      default => [$exclude],
    },
    default   => $exclude,
  }

  file { "fileset-${name}.conf":
    ensure  => $bacula::manage_file,
    path    => "${bacula::director_configs_dir}/fileset-${name}.conf",
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package[$bacula::director_package],
    notify  => $bacula::manage_service_autorestart,
    content => template($template),
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
  }

}

