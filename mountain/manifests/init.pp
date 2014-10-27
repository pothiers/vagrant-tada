# Intended for mountain top provisioning

include augeas

# epel is not needed by the puppet redis module but it's nice to have it
# already configured in the box
include epel

package { 'emacs' : }

user { 'testuser' :
  ensure     => 'present',
  managehome => true,
  password   => '$1$4jJ0.K0P$eyUInImhwKruYp4G/v2Wm1',
  }

user { 'cache' :
  ensure     => 'present',
  managehome => true,
  password   =>  md5('cache'),
  }


class { 'redis':
  version        => '2.8.13',
  redis_password => 'test',
}


yumrepo { 'ius':
  descr      => 'ius - stable',
  baseurl    => 'http://dl.iuscommunity.org/pub/ius/stable/CentOS/6/x86_64/',
  enabled    => 1,
  gpgcheck   => 0,
  priority   => 1,
  mirrorlist => absent,
} -> Package<| provider == 'yum' |>

class { 'python':
  version    => '34u',
  pip        => false,
  dev        => true,
  virtualenv => true,
} ->
package { 'python34u-pip': } ->
file { '/usr/bin/pip':
  ensure => 'link',
  target => '/usr/bin/pip3.4',
} ->
package { 'graphviz-devel': } ->
python::requirements { '/vagrant/requirements.txt': } ->

# Get from github now. But its in PyPI for when things stabalize!!!
python::pip {'daflsim':
  pkgname => 'daflsim',
  url     => 'https://github.com/pothiers/daflsim/archive/master.zip',
}

