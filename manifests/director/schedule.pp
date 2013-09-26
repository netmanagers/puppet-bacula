# Define bacula::director::schedule
# 
# Used to create schedules
# 
define bacula::director::schedule (
  $backup_level = '',
  $template = 'bacula/schedule.conf.erb'
) {

  include bacula

  $array_backup_level = is_array($backup_level) ? {
    false     => $backup_level ? {
      ''      => [],
      default => [$backup_level],
    },
    default   => $backup_level,
  }

  file { "schedule-${name}.conf":
    ensure  => $bacula::manage_file,
    path    => "${bacula::director_configs_dir}/schedule-${name}.conf",
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package[$bacula::director_package],
    notify  => $bacula::manage_service_autorestart,
    content => $template,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
  }


}

