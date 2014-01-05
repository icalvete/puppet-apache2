define apache2::auth_basic (

  $ensure   = 'present',
  $location = undef,
  $user     = undef

) {

  include apache2

  if ! $location {
    fail('apache2::auth_basic needs location parameter.')
  }

  if ! $user {
    fail('apache2::auth_basic needs user parameter.')
  }

  case $ensure {
    'present' : {
      file {"auth_basic_${location}_${user}":
        ensure  => $ensure,
        path    => "${apache2::params::config_dir}/${apache2::params::enconf}/auth_basic_${location}_${user}",
        content => template("${module_name}/auth_basic.erb"),
        mode    => '0664',
        notify  => Class['apache2::service'],
      }
    }
    'absent': {
      file {"auth_basic_${location}_${user}":
        ensure  => $ensure,
        path    => "${apache2::params::config_dir}/${apache2::params::enconf}/auth_basic_${location}_${user}",
        content => '',
        mode    => '0664',
        notify  => Class['apache2::service'],
      }
    }
    default: { err ( "Unknown ensure value: '$ensure'" ) }
  }
}
