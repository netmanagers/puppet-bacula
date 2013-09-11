# = Class: bacula::console
#
# This script installs the bacula-install_console
#
#
# This class is not to be called directly. See init.pp for details.
#

class bacula::console {

  include bacula

  ### Managed resources
  package { $bacula::install_console_package:
    ensure  => $bacula::manage_package,
    noop    => $bacula::noops,
  }


}

