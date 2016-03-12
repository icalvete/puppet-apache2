class apache2 (

  $fmp_host = $apache2::params::fmp_host,
  $fmp_port = $apache2::params::fmp_port,
  $env      = $apache2::params::env,
  $timeout  = $apache2::params::timeout

) inherits apache2::params {

  $apache26_dists = hiera('apache26_dists')
  $apache26       = member($apache26_dists, $lsbdistcodename)

  anchor {'apache2::begin':
    before => Class['apache2::install']
  }

  class {'apache2::install':
    require => Anchor['apache2::begin']
  }

  class {'apache2::config':
    require => Class['apache2::install'],
  }

  class {'apache2::service':
    subscribe => Class['apache2::config']
  }

  anchor {'apache2::end':
    require => Class['apache2::service']
  }
}
