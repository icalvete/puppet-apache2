class apache2::service {

  service { $apache2::params::apache2_service:
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
  }
}
