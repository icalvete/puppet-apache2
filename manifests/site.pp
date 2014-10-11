define apache2::site (

  $ensure              = 'present',
  $source              = undef,
  $include_from_source = undef,
  $server_alias        = ['server_alias']

) {
  include apache2

  if $server_alias {
    if ! is_array($server_alias) {
      fail('server_alias parameter must be un array')
    }
  }

  if $include_from_source {
    include $include_from_source
  }

  $ensites = $apache2::params::ensites
  $avsites = $apache2::params::avsites

  if $source {
    if $source =~ /(.*)\/([^\/]*\.vhost.conf)(\.erb)?/ {
      $source_path      = $1
      $source_file      = $2
      $source_extension = $3
      $site_name        = $2
    }

    file {"${name}_vhost_conf":
      ensure  => present,
      path    => "${avsites}/${source_file}",
      owner   => 'www-data',
      group   => 'root',
      mode    => '0664',
      content => template($source),
      before  => Exec["active_site_$name"]
    }
  }else{
    $site_name = $name
  }

  case $ensure {
    'present' : {
      exec { "active_site_$name":
        command => "/usr/sbin/a2ensite ${site_name}",
        unless  => "/usr/bin/test -h ${ensites}/${site_name}",
        require => Package[$apache2::params::package],
        notify  => Class['apache2::service'],
      }
    }
    'absent': {
      exec { "deactive_site_$name":
        command => "/usr/sbin/a2dissite ${site_name}",
        onlyif  => "/usr/bin/test -h ${ensites}/${site_name}",
        require => Package[$apache2::params::package],
        notify  => Class['apache2::service'],
      }
    }
    default: { err ( "Unknown ensure value: '$ensure'" ) }
  }
}
