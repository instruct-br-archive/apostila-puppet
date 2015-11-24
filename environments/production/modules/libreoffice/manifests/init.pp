class libreoffice {

  file { '/etc/apt/sources.list.d/backports.list':
    ensure => file,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    content => 'deb http://http.debian.net/debian-backports squeeze-backports main'
  }

  exec { '/usr/bin/apt-get update': }

  exec { '/usr/bin/apt-get install -y -t squeeze-backports libreoffice':
    timeout => 0
  }

}
