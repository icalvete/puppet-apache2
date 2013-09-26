class apache2 () inherits apache2::params {

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
