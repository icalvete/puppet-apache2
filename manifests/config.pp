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
    ensure  => present,
    path    => "${apache2::params::enconf}/env.conf",
    content => template("${module_name}/env.erb"),
  }

  file {'apache_ports':
    ensure => present,
    path   => "${apache2::params::config_dir}/ports.conf",
    source => "puppet:///modules/${module_name}/ports.conf",
  }

  augeas{'apache_security':
    incl    => "${apache2::params::enconf}/${apache2::params::sec}",
    lens    => 'Httpd.lns',
    changes => [
      "set /files${apache2::params::enconf}/${apache2::params::sec}/directive[1] ServerTokens",
      "set /files${apache2::params::enconf}/${apache2::params::sec}/directive[1]/arg Prod",
      "set /files${apache2::params::enconf}/${apache2::params::sec}/directive[2] ServerSignature",
      "set /files${apache2::params::enconf}/${apache2::params::sec}/directive[2]/arg Off",
    ]
  }

  augeas{'apache_servername':
    incl    => "${apache2::params::config_dir}/apache2.conf",
    lens    => 'Httpd.lns',
    changes => [
      "set /files${apache2::params::config_dir}/apache2.conf/directive[last()+1] ServerName",
      "set /files${apache2::params::config_dir}/apache2.conf/directive[last()]/arg $::hostname",
    ],
    onlyif  => "match directive[. = 'ServerName'] size == 0",
  }

  augeas{'apache_performance':
    incl    => "${apache2::params::config_dir}/apache2.conf",
    lens    => 'Httpd.lns',
    changes => [
      "set /files${apache2::params::config_dir}/apache2.conf/directive[3] Timeout",
      "set /files${apache2::params::config_dir}/apache2.conf/directive[3]/arg 30",
      "set /files${apache2::params::config_dir}/apache2.conf/directive[5] MaxKeepAliveRequests",
      "set /files${apache2::params::config_dir}/apache2.conf/directive[5]/arg 60",
      "set /files${apache2::params::config_dir}/apache2.conf/directive[6] KeepAliveTimeout",
      "set /files${apache2::params::config_dir}/apache2.conf/directive[6]/arg 2",
    ]
  }

  file {'fpm_config':
    ensure  => present,
    path    => "${apache2::params::enconf}/fpm.conf",
    content => template("${module_name}/fpm.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
