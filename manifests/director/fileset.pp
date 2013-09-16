define bacula::director::fileset (
  $filesets_name = '',
  $filesets_signature = '',
  $filesets_compression = '',
  $filesets_onefs = '',
  $filesets_fstype = '',
  $filesets_include = '',
  $filesets_exclude = '',
  $manage_file_content = '' {

  include bacula

  $array_filesets_fstype = is_array($filesets_fstype) ? {
    false     => $filesets_fstype ? {
      ''      => [],
      default => [$filesets_fstype],
    },
    default   => $filesets_fstype,
  }

  $array_filesets_include = is_array($filesets_include) ? {
    false     => $filesets_include ? {
      ''      => [],
      default => [$filesets_include],
    },
    default   => $filesets_include,
  }

  $array_filesets_exclude = is_array($filesets_exclude) ? {
    false     => $filesets_exclude ? {
      ''      => [],
      default => [$filesets_exclude],
    },
    default   => $filesets_exclude,
  }

  file { 'filesets.conf':
    ensure  => $bacula::manage_file,
    path    => $bacula::config_file,
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package['bacula'],
    notify  => $bacula::manage_service_autorestart,
    source  => $bacula::manage_file_source,
    content => $manage_file_content,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
  }

}

