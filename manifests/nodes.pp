node default {
  
  $PROXY_USER = 'PROXY_USER_NAME'         #Change PROXY_USER_NAME to username required for proxy
  $PROXY_PASSWORD = 'PROXY_PASSWORD'      #Change PROXY_PASSWORD to password required for proxy
  $PROXY_PROTOCOL = 'http'                #Change to protocol required for proxy
  $PROXY_HOST = 'PROXY_HOST'              #Change to proxy host name or ip
  $PROXY_PORT = '81'                      #Change to proxy port
  $PROXY_URL = "${PROXY_PROTOCOL}://${PROXY_USER}:${PROXY_PASSWORD}@${PROXY_HOST}:${PROXY_PORT}"


#############################
# Commented out packages required for installing using TIBCO provided installers  
#  $bc_package = 'bc'
#  $glibc_i686 = 'glibc.i686'
#  $jdk_6u38_linux_amd64_rpm_source = '/vagrant/modules/ems/files/jdk-6u38-linux-amd64.rpm'
#############################

  $compat_libstdc33 = 'compat-libstdc++-33'
  
  notify { 'proxy_setting':
    message => "Using following settings for PROXY: url=${PROXY_URL}",
  }
  
  file { '/home/vagrant/.bash_profile' :
    path    => '/home/vagrant/.bash_profile',
    content => template('bash_profile.erb'),
  }

  file { '/etc/yum.conf' :
    path    => '/etc/yum.conf',
    content => template('yum.conf.erb'),
  }

  file { '/etc/wgetrc' :
    path    => '/etc/wgetrc',
    content => template('wgetrc.erb'),
  }

  # Install "Desktop" group - mandatory
  $desktop_mandatory_packages = [ 'NetworkManager', 'NetworkManager-gnome', 'alsa-plugins-pulseaudio', 'at-spi',
              'control-center', 'dbus', 'gdm', 'gdm-user-switch-applet', 'gnome-panel', 'gnome-power-manager',
              'gnome-screensaver', 'gnome-session', 'gnome-terminal', 'gvfs-archive', 'gvfs-fuse',
              'gvfs-smb', 'metacity', 'nautilus', 'notification-daemon', 'polkit-gnome', 'xdg-user-dirs-gtk',
              'yelp'  ]
  package { $desktop_mandatory_packages:
    ensure  => present,
    require => File['/etc/yum.conf'],
  }

  # Install "Desktop" group - default
  # Removed 'rhn-setup-gnome' as Centos does not use it          
#  $desktop_default_packages = [ 'control-center-extra', 'eog', 'gdm-plugin-fingerprint', 'gnome-applets',
#             'gnome-media', 'gnome-packagekit', 'gnome-vfs2-smb', 'gok', 'openssh-askpass',
#             'orca', 'pulseaudio-module-gconf', 'pulseaudio-module-x11', 'vino' ]

#  package { $desktop_default_packages:
#    ensure  => present,
#    require => File['/etc/yum.conf'],
#  }

  # Install "Desktop" group - optional
#  $desktop_optional_packages = [ 'sabayon-apply', 'tigervnc-server', 'xguest' ]
#  package { $desktop_optional_packages:
#    ensure  => present,
#    require => File['/etc/yum.conf'],
#  }

  # Install extra convenience packages
  $extra_packages = [ 'subversion', 'gedit', 'man' ]
  package { $extra_packages:
    ensure  => present,
    require => File['/etc/yum.conf'],
  }

  # Install "Internet Browser" group
  $browser_packages = [ 'firefox', 'nspluginwrapper', 'totem-mozplugin' ]
  package { $browser_packages:
    ensure  => present,
    require => File['/etc/yum.conf'],
  }

#  #required by tibco installer
#  package { "${bc_package}":
#    ensure => present,
#    require => File['/etc/yum.conf'],
#  }

#  #required by tibco installer
#  package { "${glibc_i686}":
#    ensure => present,
#    require => File['/etc/yum.conf'],
#  }

#  #required by tibco installer
#  package { 'jdk-6u38-linux-amd64_rpm_source':
#    provider => rpm,
#    ensure   => present,
#    source   => "${jdk_6u38_linux_amd64_rpm_source}",
#  }

  #required by tibco installer, configuration, hsqld
  package { "$compat_libstdc33":
    ensure => present,   
    require => File['/etc/yum.conf'],
  }
  
  # Install amsg2 module 
  include amsg2

}