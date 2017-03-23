class nginx (
  $package  = $nginx::params::package,
  $owner    = $nginx::params::owner,
  $group    = $nginx::params::group,
  $docroot  = $nginx::params::docroot,
  $confdir  = $nginx::params::confdir,
  $blockdir = $nginx::params::blockdir,
  $logdir   = $nginx::params::logdir,
  $service  = $nginx::params::service,
  $user     = $nginx::params::user,
) inherits nginx::params {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0775',
  }

  notify { "User is ${user}": }

  package { 'nginx':
    ensure => present,
    before => [File['/etc/nginx/nginx.conf'],File['/etc/nginx/conf.d/default.conf']],
  }

  file { '/var/www':
    ensure => directory,
    mode   => '0777',
  }

  file { '/var/www/index.html':
    ensure  => file,
    #source => 'puppet:///modules/nginx/index.html',
    content => template('nginx/index.html.erb'),
  }

  file { '/etc/nginx/nginx.conf':
    ensure  => file,
    source  => 'puppet:///modules/nginx/nginx.conf',
    #require => Package['nginx'],
    #notify  => Service['nginx'],
  }

  file { '/etc/nginx/conf.d/default.conf':
    ensure   => file,
    # source => 'puppet:///modules/nginx/default.conf',
    content  => template('nginx/default.conf.erb'),
    #require => Package['nginx'],
    #notify  => Service['nginx'],
  }

  service { 'nginx':
    ensure    => running,
    enable    => true,
    subscribe => [File['/etc/nginx/nginx.conf'],File['/etc/nginx/conf.d/default.conf']],
  }

  file { '/var/www/sesame':
    ensure => directory,
  }

  nginx::vhost { 'www.piggy.com': }

  nginx::vhost { 'www.elmo.com':
    port => '8080',
  }
}
