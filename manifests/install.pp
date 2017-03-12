class apache2::install {

  package {$apache2::params::package:
    ensure => present
  }

  package {'libapache2-mod-fastcgi':
    ensure => present
  }
}
