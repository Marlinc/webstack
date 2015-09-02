package { 'apache2':
	ensure => installed
}
package { 'php5':
	ensure => installed
}

$php_extensions = ['php5-mcrypt', 'php5-intl']

package { $php_extensions:
	ensure => installed,
	require => Package['php5']
}

package { 'mysql-server':
	ensure => installed
}

$user_www_directory = "/home/$::ubuntu_user/.www"
$user_www_root = "${user_www_directory}/root"
$user_www_conf = "${user_www_directory}/conf"

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
	require => File[$user_www_root]
}

