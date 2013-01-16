class amsg2 inherits amsg2::params{
  
  package { 'amsg2':
    provider => rpm,
    ensure   => present,
    source   => "${amsg2_rpm_source}",
  }

  exec { 'chown_amsg2_home':
    command => "chown -R ${amsg2_owner}:${amsg2_group} ${amsg2_home_folder}",
    path    => '/bin',
    require => Package['amsg2'],
  }

}