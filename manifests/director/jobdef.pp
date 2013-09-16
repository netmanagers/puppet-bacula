define bacula::director::jobdef (
  $jobdefs_name = '',
  $jobdefs_type = '',
  $jobdefs_client = '',
  $jobdefs_fileset = '',
  $jobdefs_storage = '',
  $jobdefs_pool = '',
  $jobdefs_prefer_mounted_volumes = '',
  $jobdefs_write_bootstrap = '',
  $jobdefs_schedule = '',
  $jobdefs_priority = '',
  $jobdefs_messages = '',
  $manage_file_content = '' {

  include bacula

  $array_jobdefs_storage = is_array($jobdefs_storage) ? {
    false     => $jobdefs_storage ? {
      ''      => [],
      default => [$jobdefs_storage],
    },
    default   => $jobdefs_storage,
  }

   if $jobdefs_type == "Restore" {
     $jobdefs_mode = 'Job',
   if $jobdefs_type == "Backup" {
     $jobdefs_mode = 'JobDefs',

  file { 'jobdefs.conf':
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
