define bacula::messages (
  $messages_name = '',
  $mail_command = '' ,
  $mail_host = '',
  $mail_from= '',
  $mail_to = '' {

  include bacula

  file { 'messages.conf':
    ensure  => $bacula::manage_file,
    path    => $bacula::config_file,
    mode    => $bacula::config_file_mode,
    owner   => $bacula::config_file_owner,
    group   => $bacula::config_file_group,
    require => Package['bacula'],
    notify  => $bacula::manage_service_autorestart,
    source  => $bacula::manage_file_source,
    content => $bacula::manage_file_content,
    replace => $bacula::manage_file_replace,
    audit   => $bacula::manage_audit,
  }

}

