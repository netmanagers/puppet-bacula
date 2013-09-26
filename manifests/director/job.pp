# Define bacula::director::job
#
# Used to create job resources
#
define bacula::director::job (
  $type = '',
  $client = '',
  $fileset = '',
  $jobdefs_storage = '',
  $pool = '',
  $prefer_mounted_volumes = '',
  $write_bootstrap = '',
  $job_schedule = '',
  $priority = '',
  $messages = '',
  $where = '',
  $use_as_def = false,
  $jobdef = '',
  $template = 'bacula/job.conf.erb'
) {

  include bacula

  $array_jobdefs_storage = is_array($jobdefs_storage) ? {
    false     => $jobdefs_storage ? {
      ''      => [],
      default => [$jobdefs_storage],
    },
    default   => $jobdefs_storage,
  }

  $job_name =  $use_as_def  ==  true ? {
    true =>  "jobdef-${name}.conf",
    false => "job-${client}-${name}.conf"
  }

  file { "job-${name}.conf":
    ensure  => $bacula::manage_file,
    path    => "${bacula::director_configs_dir}/job-${name}.conf",
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
