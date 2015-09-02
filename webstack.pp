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
}

package { 'php5':
	ensure => installed
}

$php_extensions = ['php5-mcrypt', 'php5-intl', 'php5-mysql', 'php5-sqlite']

package { $php_extensions:
	ensure => installed,
	require => Package['php5']
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

