define apache2::alias (

  $ensure  = 'present',
  $content = undef

) {

  include apache2

  if ! $content {
    fail('$content parameter can\'t be empty')
  }

  case $ensure {
    'present' : {
      file {"${name}_file":
        ensure  => present,
        path    => "/etc/apache2/conf.d/${name}",
        content => $content,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package[$apache2::params::apache2_package],
        notify  => Class['apache2::service'],
      }
    }
    'absent': {
      file {"${name}_file":
        ensure  => present,
        path    => "/etc/apache2/conf.d/${name}",
        content => '',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package[$apache2::params::apache2_package],
        notify  => Class['apache2::service'],
      }
    }
    default: { err ( "Unknown ensure value: '$ensure'" ) }
  }
}
