class apache2::install {

  package {$apache2::params::package:
    ensure => present
  }

  case $facts['os']['distro']['codename'] {
      /^(bionic|focal|jammy)/: {
      file {'get_libapache2-mod-fastcgi':
        ensure => present,
        path   => '/tmp/libapache2-mod-fastcgi_2.4.deb',
        source => "puppet:///modules/${module_name}/libapache2-mod-fastcgi_2.4.deb",
      }
      exec {'install_libapache2-mod-fastcgi':
        command  => '/usr/bin/dpkg -i /tmp/libapache2-mod-fastcgi_2.4.deb; /usr/bin/apt-get -f install',
        provider => 'shell',
        unless   => '/usr/bin/dpkg -l "libapache2-mod-fastcgi" | /bin/grep grep ii',
        require  => File['get_libapache2-mod-fastcgi']
      }

      file {'get_libapache2-mod-wsgi':
        ensure => present,
        path   => '/tmp/libapache2-mod-wsgi.deb',
        source => "puppet:///modules/${module_name}/libapache2-mod-wsgi.deb",
      }
      exec {'install_libapache2-mod-wsgi':
        command  => '/usr/bin/dpkg -i /tmp/libapache2-mod-wsgi.deb; /usr/bin/apt-get -f install',
        provider => 'shell',
        unless   => '/usr/bin/dpkg -l "libapache2-mod-wsgi" | /bin/grep grep ii',
        require  => File['get_libapache2-mod-wsgi']
      }
    }
    default: {
      package {'libapache2-mod-fastcgi':
        ensure => present
      }

      package {'libapache2-mod-wsgi':
        ensure => present
      }
    }
  }
}
