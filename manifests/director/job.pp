# Define bacula::director::job
#
# Used to create job/jobdef resources
#
# Valid parameters are:
#
# $client      - Name of the client where to run the job.
#                REQUIRED if you want to set up a job.
#                If not given, the definition sets up a JOBDEF
# $use_as_def  - If true, creates a jobdef instead of a job.
#                Default: false
# $type        - One of Backup, Restore, Verify or Admin
# $storage     - Where the job will be run. Can be an array
define bacula::director::job (
  $client = '',
  $type = 'Backup',
  $fileset = '',
  $storage = '',
  $pool = '',
  $prefer_mounted_volumes = '',
  $write_bootstrap = '',
  $job_schedule = '',
  $priority = '',
  $messages = '',
  $where = '',
  $use_as_def = false,
  $jobdef = '',
  $client_run_before_job = '',
  $run_before_job = '',
  $template = 'bacula/director/job.conf.erb'
) {

  include bacula

  if $use_as_def  ==  true or $client == '' {
    $job_name = "jobdef-${name}"
  } else {
    $job_name = "job-${client}-${name}"
  }

  $array_storages = is_array($storage) ? {
    false     => $storage ? {
      ''      => [],
      default => [$storage],
    },
    default   => $storage,
  }

  $manage_job_file_content = $template ? {
    ''      => undef,
    default => template($template),
  }

  file { "${job_name}.conf":
    ensure  => $bacula::manage_file,
    path    => "${bacula::director_configs_dir}/${job_name}.conf",
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package[$bacula::director_package],
    notify  => $bacula::manage_service_autorestart,
    content => $manage_job_file_content,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
  }

}
