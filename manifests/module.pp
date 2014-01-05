define apache2::module (

  $ensure  = 'present',
  $package = undef

) {

  include apache2

  if $package {
    package { $package:
      ensure => 'present',
      before => Exec["active_module_$name"]
    }
  }

  case $ensure {
    'present' : {
      exec { "active_module_$name":
        command => "/usr/sbin/a2enmod $name",
        unless  => "/usr/sbin/apachectl -t -D DUMP_MODULES | grep $name",
        require => Package[$apache2::params::package],
        notify  => Class['apache2::service'],
      }
    }
    'absent': {
      exec { "deactive_module_$name":
        command => "/usr/sbin/a2dismod $name",
        onlyif  => "/usr/sbin/apachectl -t -D DUMP_MODULES | grep $name",
        require => Package[$apache2::params::package],
        notify  => Class['apache2::service'],
      }
    }
    default: { err ( "Unknown ensure value: '$ensure'" ) }
  }
}
