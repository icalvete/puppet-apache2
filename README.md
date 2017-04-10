# puppet-apache2

Puppet manifest to install and configure apache2

 [![Build Status](https://secure.travis-ci.org/icalvete/puppet-apache2.png)](http://travis-ci.org/icalvete/puppet-apache2)

# Actions

* apache2 server
* enable/disable modules
* enable/disable vhosts
* set alias
* set auth basic for locations

## Requires:

* Only works on Ubuntu
* [hiera](http://docs.puppetlabs.com/hiera/1/index.html)
* [augeas](http://projects.puppetlabs.com/projects/1/wiki/puppet_augeas)
* https://github.com/icalvete/puppet-common but really only need:
  + common::add_env define.

* For auth basic https://github.com/icalvete/puppet-htpasswd

## TODO:

* Some values must be parametriced
* Documentation

## Authors:
		 
Israel Calvete Talavera <icalvete@gmail.com>
