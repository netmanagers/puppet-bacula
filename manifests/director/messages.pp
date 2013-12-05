# Define bacula::director::messages
#
# Used to create messages resources
#
define bacula::director::messages (
  $mail_command = '',
  $mail_host = 'localhost',
  $mail_from = '',
  $mail_to = '',
  $options_hash = {},
  $template = 'bacula/director/messages.conf.erb'
) {

  include bacula

  $manage_director_service_autorestart = $bacula::service_autorestart ? {
    true    => Service[$bacula::director_service],
    default => undef,
  }

  $array_mail_to = is_array($mail_to) ? {
    false     => $mail_to ? {
      ''      => [],
      default => [$mail_to],
    },
    default   => $mail_to,
  }

  $manage_messages_file_content = $template ? {
    ''      => undef,
    default => template($template),
  }

  file { "messages-${name}.conf":
    ensure  => $bacula::manage_file,
    path    => "${bacula::director_configs_dir}/messages-${name}.conf",
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package[$bacula::director_package],
    notify  => $manage_director_service_autorestart,
    content => $manage_messages_file_content,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
  }

}

