define bacula::director::schedule (
  $name = $title,
  $backup_level = '',
  $template = 'templates/schedule.conf.erb'
) {

  include bacula

  $array_backup_level = is_array($backup_level) ? {
    false     => $backup_level ? {
      ''      => [],
      default => [$backup_level],
    },
    default   => $backup_level,
  }

  file { 'schedule.conf':
    ensure  => $bacula::manage_file,
    path    => $bacula::config_file,
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package['bacula'],
    notify  => $bacula::manage_service_autorestart,
    content => $template,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
  }


}

