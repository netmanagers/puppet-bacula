# Define bacula::director::schedule
#
# Used to create schedules
#
define bacula::director::schedule (
  $run_spec = '',
  $options_hash = {},
  $template = 'bacula/director/schedule.conf.erb'
) {

  include bacula

  $array_run_spec = is_array($run_spec) ? {
    false     => $run_spec ? {
      ''      => [],
      default => [$run_spec],
    },
    default   => $run_spec,
  }

  $manage_schedule_file_content = $template ? {
    ''      => undef,
    default => template($template),
  }

  file { "schedule-${name}.conf":
    ensure  => $bacula::manage_file,
    path    => "${bacula::director_configs_dir}/schedule-${name}.conf",
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package[$bacula::director_package],
    notify  => $bacula::manage_service_autorestart,
    content => $manage_schedule_file_content,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
  }


}

