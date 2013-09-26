class apache2::install {

  package {'apache2-mpm-worker':
    ensure => present
  }

  package {'libapache2-mod-fastcgi':
    ensure => present
  }
}
