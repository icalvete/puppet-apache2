class apache2 (

  $fpm_host    = $apache2::params::fpm_host,
  $fpm_port    = $apache2::params::fpm_port,
  $fpm_timeout = undef,
  $env         = pick($::env, $apache2::params::env),
  $timeout     = $apache2::params::timeout,
  $php         = $apache2::params::php,
  $hhvm        = $apache2::params::hhvm,

) inherits apache2::params {

  #  if has_key($facts, 'ec2_metadata') {
  #  $instance_id = $facts['ec2_metadata']['instance-id']
  #} else {
    $instance_id = $facts['ipaddress']
  #}

  $apache26_dists = lookup(
    'apache26_dists',
    Array,
    'first',
    ['saucy', 'trusty', 'xenial', 'bionic', 'focal']
  )

  #$apache26 = member($apache26_dists, $facts['os']['distro']['codename'])
  $apache26 = true

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
