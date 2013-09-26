class apache2::params {

  case $::operatingsystem {
    /^(Debian|Ubuntu)$/: {
      $apache2_package    = 'apache2-mpm-worker'
      $apache2_service    = 'apache2'
      $apache2_config_dir = '/etc/apache2/'
      $apache2_enmods     = "${apache2_config_dir}/mods-enabled/"
      $apache2_ensites    = "${apache2_config_dir}/sites-enabled/"
      $apache2_avmods     = "${apache2_config_dir}/mods-available/"
      $apache2_avsites    = "${apache2_config_dir}/sites-available/"
    }
    default: {
      fail ("${::operatingsystem} not supported.")
    }
  }
}
