# Define bacula::director::catalog
#
# Used to create catalog resources
#
define bacula::director::catalog (
  $db_driver = 'dbi:mysql',
  $db_address = 'localhost',
  $db_port = '',
  $db_name = '',
  $db_user = '',
  $db_password = '',
  $template = 'bacula/director/catalog.conf.erb'
) {

  include bacula

  $manage_catalog_file_content = $template ? {
    ''      => undef,
    default => template($template),
  }

  file { "catalog-${name}.conf":
    ensure  => $bacula::manage_file,
    path    => "${bacula::director_configs_dir}/catalog-${name}.conf",
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package[$bacula::director_package],
    notify  => $bacula::manage_service_autorestart,
    content => $manage_catalog_file_content,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
  }


}

