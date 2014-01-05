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
        path    => "${apache2::params::enconf}/${name}.conf",
        content => $content,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package[$apache2::params::package],
        notify  => Class['apache2::service'],
      }
    }
    'absent': {
      file {"${name}_file":
        ensure  => present,
        path    => "${apache2::params::enconf}/${name}.conf",
        content => '',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package[$apache2::params::package],
        notify  => Class['apache2::service'],
      }
    }
    default: { err ( "Unknown ensure value: '$ensure'" ) }
  }
}
