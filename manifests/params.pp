class apache2::params {

  $fpm_host    = '127.0.0.1'
  $fpm_port    = '9000'
  $environment = hiera('environment')

  case $::osfamily {

    /^Debian$/: {
      $package    = 'apache2-mpm-worker'
      $service    = 'apache2'
      $config_dir = '/etc/apache2'
      $enmods     = "${config_dir}/mods-enabled"
      $ensites    = "${config_dir}/sites-enabled"
      $avmods     = "${config_dir}/mods-available"
      $avsites    = "${config_dir}/sites-available"

      case $::operatingsystemrelease {

        /^(12.04|12.10|13.04)$/: {
          $enconf = "${config_dir}/conf.d"
          $sec    = 'security'
        }
        default: {
          $enconf = "${config_dir}/conf-enabled"
          $sec    = 'security.conf'
        }
      }
    }
    default: {
      fail ("${::operatingsystem} not supported.")
    }
  }
}
