# Puppet module: bacula

This is a Puppet module for bacula based on the second generation layout ("NextGen") of Example42 Puppet Modules.

Made by

  * Sebastián Quaino / Netmanagers
  * Javier Bértoli / Netmanagers
  * Dan Schaefer / Schaeferzone

Based on Example42 modules made by Alessandro Franceschi / Lab42

Official site: http://www.netmanagers.com.ar

Official git repository: http://github.com/netmanagers/puppet-bacula

Released under the terms of Apache 2 License.

This module requires functions provided by the Example42 Puppi module (you need it even if you don't
use and install Puppi)

For detailed info about the logic and usage patterns of Example42 modules check the DOCS directory
on Example42 main modules set.


## USAGE - Basic management

* Bacula consist on at least three different applications (a Director, a Storage manager, Clients and
  a Console (CLI, GUI, etc.) to manage these resources. This module provides classes and defines to 
  install and configure them all with a fair degree of customization. Some parameters can be specified
  specifically for each one of these applications while others are common to all the classes and
  defines, for consistency. Please check the *params.pp* and manifests for details.

* Install bacula with default settings: this, by default, will install only the Client daemon
  (bacula-fd) and, following Ex42 modules standard practice, will leave all the default configuration
  as provided by your distribution.

```puppet
class { 'bacula': }
```

  You can choose which part of bacula to install on a host

```puppet
class {'bacula:
  manage_client   => true,
  manage_storage  => false,
  manage_director => true,
  manage_console  => false,
}
```

* Install a specific version of bacula storage package

```puppet
class { 'bacula':
  manage_storage => true,
  version        => '1.0.1',
}
```

  Keep present that the client will **ALWAYS** be installed and managed, unless explicitelly said so
  setting *manage_client* to false

```puppet
class { 'bacula':
  manage_client  => false,
  manage_storage => true,
  version        => '1.0.1',
}
```

* Disable bacula service.

```puppet
class { 'bacula':
  disable => true
}
```

* Remove bacula package

```puppet
class { 'bacula':
  absent => true
}
```

* Enable auditing without without making changes on existing bacula configuration *files*

```puppet
class { 'bacula':
  audit_only => true
}
```

* Module dry-run: Do not make any change on *all* the resources provided by the module

```puppet
class { 'bacula':
  noops => true
}
```


## USAGE - Overrides and Customizations

* For each of bacula applications managed you can override its configuration using \*_ source of
  \*_template variables.

* Use custom source directory for the whole configuration dir

```puppet
class { 'bacula':
  source_dir            => 'puppet:///modules/example42/bacula/conf/',
  source_director_purge => false, # Set to true to purge any existing file not present in $source_dir
}
```

* Use custom sources for config file 

```puppet
class { 'bacula':
  manage_client   => false,
  manage_director => true,
  director_source => [ "puppet:///modules/netmanagers/bacula/bacula-dir.conf-${hostname}",
                       "puppet:///modules/example42/bacula/bacula-dir.conf" ], 
}
```

* Templating in this module is **strongly recommended**, but as it differs from other templatings
  in the final result of bacula's configuration dir structure. As bacula permits you to split
  configuration in different files to improve manageability, we make use of this as soon as you
  specity the use of a template for any of the applications. We also provide templates for all of
  bacula's daemons. Check the templates dir for more details. Remember that you can always provide
  your own if none of these suits your particular case.

  When using templates in this module, the resulting configuration directory ends up like this
  (module's default values considered):

        /etc/bacula/
                bacula-dir.conf       <= Main director config file
                director.d/           <= Director's stanzas
                   catalog-*.conf          - Catalogs
                   fileset-*.conf          - Filesets
                   job-*.conf              - Jobs 
                   jobdef-*.conf           - Jobs 
                   messages-*.conf         - Messages
                   pool-*.conf             - Pools
                   schedule-*.conf         - Schedules
                   storage-*.conf          - Storages
                clients.d/            <= Each client DIRECTOR's entry
                   client1.conf
                   client2.conf
                   clientN.conf
                bacula-sd.conf        <= Main storage config file
                storage.d/            <= Storage's stanzas
                   device-*.conf           - Devices
                bacula-fd.conf        <= Client config file
                bconsole.conf         <= Console config file

  For each possible stanza we provide a define to create them. Please check the manifests headers
  to see the available parameters for each.

* Add a new device to the storage daemon, using the included template and default values:

```puppet
bacula::storage::device { 'new_device':
  media_type     => 'File',
  archive_device => '/some/backup/dir',
}
```

* Automatically include a custom subclass

```puppet
class { 'bacula':
  my_class => 'example42::my_bacula',
}
```


## USAGE - Example42 extensions management 
* Activate puppi (recommended, but disabled by default)

```puppet
class { 'bacula':
  puppi => true,
}
```

* Activate puppi and use a custom puppi_helper template (to be provided separately with a puppi::helper define ) to customize the output of puppi commands 

```puppet
class { 'bacula':
  puppi        => true,
  puppi_helper => 'myhelper', 
}
```

* Activate automatic monitoring (recommended, but disabled by default). This option requires the usage of Example42 monitor and relevant monitor tools modules

```puppet
class { 'bacula':
  monitor      => true,
  monitor_tool => [ 'nagios' , 'monit' , 'munin' ],
}
```

* Activate automatic firewalling. This option requires the usage of Example42 firewall and relevant firewall tools modules

```puppet
class { 'bacula':       
  firewall      => true,
  firewall_tool => 'iptables',
  firewall_src  => '10.42.0.0/24',
  firewall_dst  => $ipaddress_eth0,
}
```


## CONTINUOUS TESTING

Travis {<img src="https://travis-ci.org/netmanagers/puppet-bacula.png?branch=master" alt="Build Status" />}[https://travis-ci.org/netmanagers/puppet-bacula]
