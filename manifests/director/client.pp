# Define bacula::director::client
#
# Used to create client resources
#
define bacula::director::client (
  $address = '',
  $port = '',
  $password = '',
  $catalog = '',
  $file_retention = '',
  $job_retention = '',
  $auto_prune = true,
  $max_concurrent = '',
  $priority = '',
  $template = 'bacula/director/client.conf.erb'
) {

  include bacula

  if $address == '' {
    fail("\$address parameter required for bacula::director::client define")
  }

  if $catalog == '' {
    fail("\$catalog parameter required for bacula::director::client define")
  }

  $manage_fileset_client_content = $template ? {
    ''      => undef,
    default => template($template),
  }

  file { "client-${name}.conf":
    ensure  => $bacula::manage_file,
    path    => "${bacula::director_configs_dir}/client-${name}.conf",
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package[$bacula::director_package],
    notify  => $bacula::manage_service_autorestart,
    content => $manage_client_file_content,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
  }

}

