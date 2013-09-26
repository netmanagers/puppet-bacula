# Define bacula::director::messages
# 
# Used to create messages resources
# 
define bacula::director::messages (
  $mail_command = '' ,
  $mail_host = '',
  $mail_from= '',
  $mail_to = '',
  $template = 'bacula/messages.conf.erb'
) {

  include bacula

  file { "messages-${name}.conf":
    ensure  => $bacula::manage_file,
    path    => "${bacula::director_configs_dir}/messages-${name}.conf",
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

