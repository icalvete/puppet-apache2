class apache2::config {

  apache2::module {'actions':
    ensure => present
  }

  apache2::module {'fastcgi':
    ensure => present
  }

  apache2::module {'alias':
    ensure => present
  }

  file {'apache_env':
    ensure => present,
    path   => "${apache2::params::apache2_config_dir}/conf.d/env",
    source => "puppet:///modules/${module_name}/apache_env",
  }

  file {'apache_ports':
    ensure => present,
    path   => "${apache2::params::apache2_config_dir}/ports.conf",
    source => "puppet:///modules/${module_name}/ports.conf",
  }

  augeas{'apache_security':
    incl    => '/etc/apache2/conf.d/security',
    lens    => 'Httpd.lns',
    changes => [
      'set /files/etc/apache2/conf.d/security/directive[1] ServerTokens',
      'set /files/etc/apache2/conf.d/security/directive[1]/arg Prod',
      'set /files/etc/apache2/conf.d/security/directive[2] ServerSignature',
      'set /files/etc/apache2/conf.d/security/directive[2]/arg Off',
    ]
  }

  augeas{'apache_servername':
    incl    => '/etc/apache2/apache2.conf',
    lens    => 'Httpd.lns',
    changes => [
      "set /files/etc/apache2/apache2.conf/directive[last()+1] ServerName",
      "set /files/etc/apache2/apache2.conf/directive[last()]/arg $::fqdn",
    ],
    onlyif => "match directive[. = 'ServerName'] size == 0",
  }

  augeas{'apache_performance':
    incl    => '/etc/apache2/apache2.conf',
    lens    => 'Httpd.lns',
    changes => [
      'set /files/etc/apache2/apache2.conf/directive[3] Timeout',
      'set /files/etc/apache2/apache2.conf/directive[3]/arg 30',
      'set /files/etc/apache2/apache2.conf/directive[5] MaxKeepAliveRequests',
      'set /files/etc/apache2/apache2.conf/directive[5]/arg 60',
      'set /files/etc/apache2/apache2.conf/directive[6] KeepAliveTimeout',
      'set /files/etc/apache2/apache2.conf/directive[6]/arg 2',
    ]
  }

  file {'fpm_config':
    ensure  => present,
    path    => '/etc/apache2/conf.d/fpm',
    content => template("${module_name}/fpm.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
