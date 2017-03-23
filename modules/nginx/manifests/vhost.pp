define nginx::vhost (
  $port = '80',
  $docroot = '/var/www/sesame',
) {
  
  # /var/www/sesame/www.piggy.com'
  file { "${docroot}/${title}":
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0777',
  }

  # /var/www/sesame/www.piggy.com/index.html
  file { "${docroot}/${title}/index.html":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0777',
    content => template('nginx/index.html.erb')
  }

}
