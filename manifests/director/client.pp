# Define bacula::director::client
#
# Used to create client resources
#
define bacula::director::client (
  $address = '',
  $catalog = '',
  $port = '9102',
  $password = '',
  $file_retention = '',
  $job_retention = '',
  $auto_prune = true,
  $max_concurrent = '',
  $options_hash = {},
  $template = 'bacula/director/client.conf.erb'
) {

  include bacula

  $manage_director_service_autorestart = $bacula::service_autorestart ? {
    true    => Service[$bacula::director_service],
    default => undef,
  }

  if $address == '' {
    fail('$address parameter required for bacula::director::client define')
  }

  $real_catalog = $catalog ? {
    ''      => $bacula::default_catalog,
    default => $catalog,
  }

  if $real_catalog == '' {
    fail('$catalog parameter required for bacula::director::client define')
  }

  $real_file_retention = $file_retention ? {
    ''      => $bacula::default_file_retention,
    default => $file_retention,
  }

  $real_job_retention = $job_retention ? {
    ''      => $bacula::default_job_retention,
    default => $job_retention,
  }

  $real_max_concurrent = $max_concurrent ? {
    ''      => $bacula::client_max_concurrent,
    default => $max_concurrent,
  }

  $real_password = $password ? {
    ''      => $bacula::real_default_password,
    default => $password,
  }

  $manage_client_file_content = $template ? {
    ''      => undef,
    default => template($template),
  }

  file { "client-${name}.conf":
    ensure  => $bacula::manage_file,
    path    => "${bacula::director_clients_dir}/${name}.conf",
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package[$bacula::director_package],
    notify  => $manage_director_service_autorestart,
    content => $manage_client_file_content,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
  }

}

