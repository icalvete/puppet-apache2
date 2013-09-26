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

  file {"auth_basic_${location}_${user}":
    ensure  => $ensure,
    path    => "/etc/apache2/conf.d/auth_basic_${location}_${user}",
    content => template("${module_name}/auth_basic.erb"),
    mode    => '0664',
    notify  => Class['apache2::service'],
  }
}
