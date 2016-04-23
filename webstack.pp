$user_www_directory = "/home/$::ubuntu_user/.www"
$user_www_root = "${user_www_directory}/root"
$user_www_conf = "${user_www_directory}/conf"

class { 'apache':
	user          => $::ubuntu_user,
	group         => $::ubuntu_group,
	docroot       => $user_www_root,
	mpm_module    => 'prefork',
	confd_dir     => '/etc/apache2/conf-enabled',
	manage_user   => false,
	manage_group  => false,
	purge_vhost_dir => false
}
apache::mod { 'rewrite': }
class {'::apache::mod::php':
	php_version   => '7.0'
}

package { 'php7.0':
	ensure => installed
}

$php_extensions = ['php7.0-mcrypt', 'php7.0-intl', 'php7.0-mysql', 'php7.0-sqlite', 'php7.0-mbstring']

package { $php_extensions:
	ensure => installed,
	require => Package['php7.0']
}

package { 'mysql-server':
	ensure => installed
}

debconf_package { 'phpmyadmin':
	ensure => present,
	content => 'phpmyadmin      phpmyadmin/reconfigure-webserver        multiselect     apache2'
}

exec { '/usr/sbin/a2enconf phpmyadmin':
	require => [debconf_package['phpmyadmin'], Class['apache']],
	notify  => Service['apache2']
}

file { $user_www_directory:
	ensure => directory,
	owner  => $ubuntu_user,
	group  => $ubuntu_group
}

file { $user_www_root:
        ensure => directory,
        owner  => $ubuntu_user,
        group  => $ubuntu_group 
}

file { $user_www_conf:
        ensure => directory,
        owner  => $ubuntu_user,
        group  => $ubuntu_group 
}

file { '/var/www/html':
	ensure => link,
	target => $user_www_root,
	require => File[$user_www_root],
       force  => true
}

