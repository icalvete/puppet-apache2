class apache2::service {

  service { $apache2::params::service:
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
  }
}
