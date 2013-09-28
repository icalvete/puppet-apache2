define apache2::site (

  $ensure              = 'present',
  $source              = undef,
  $include_from_source = undef

) {
  include apache2

  if $include_from_source {
    include $include_from_source
  }

  $apache2_ensites = $apache2::params::apache2_ensites
  $apache2_avsites = $apache2::params::apache2_avsites

  if $source {
    if $source =~ /(.*)\/([^\/]*\.vhost)(\.erb)?/ {
      $source_path      = $1
      $source_file      = $2
      $source_extension = $3
      $site_name        = $2
    }

    file {"${name}_vhost_conf":
      ensure  => present,
      path    => "${apache2_avsites}/${source_file}",
      owner   => 'www-data',
      group   => 'root',
      mode    => '0664',
      content => template($source)
    }
  }else{
    $site_name = $name
  }

  case $ensure {
    'present' : {
      exec { "active_site_$name":
        command => "/usr/sbin/a2ensite ${site_name}",
        unless  => "/usr/bin/test -h ${apache2_ensites}/${site_name}",
        require => Package[$apache2::params::apache2_package],
        notify  => Class['apache2::service'],
      }
    }
    'absent': {
      exec { "deactive_site_$name":
        command => "/usr/sbin/a2dissite ${site_name}",
        onlyif  => "/usr/bin/test -h ${apache2_ensites}/${site_name}",
        require => Package[$apache2::params::apache2_package],
        notify  => Class['apache2::service'],
      }
    }
    default: { err ( "Unknown ensure value: '$ensure'" ) }
  }
}
