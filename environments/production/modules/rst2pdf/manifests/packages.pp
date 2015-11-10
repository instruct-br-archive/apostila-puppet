class rst2pdf::packages {

  package { 'vim':
    ensure => installed,
  }

  package { 'python-setuptools':
    ensure => '0.6.14-4',
  }

  package { 'liblcms1':
    ensure => '1.18.dfsg-1.2+b3',
  }

  package { 'python-pygments':
    ensure => '1.3.1+dfsg-1',
  }

  package { 'python-reportlab':
    ensure => '2.4-4',
  }

  package { 'python-imaging':
    ensure => '1.1.7-2',
  }

  package { 'libxslt1.1':
    ensure => '1.1.26-6+squeeze3',
  }

  package { 'python-lxml':
    ensure => '2.2.8-2',
  }

  package { 'python-renderpm':
    ensure => '2.4-4',
  }

  package { 'python-docutils':
    ensure => '0.7-2',
  }

  package { 'python-chardet':
    ensure => '2.0.1-1',
  }

  package { 'python-simplejson':
    ensure => '2.1.1-1',
  }

  package { 'libjpeg62':
    ensure => '6b1-1',
  }

  package { 'wwwconfig-common':
    ensure => '0.2.1',
  }

  package { 'libart-2.0-2':
    ensure => '2.3.21-1',
  }

  package { 'libpaper-utils':
    ensure => '1.1.24',
  }

  package { 'python-roman':
    ensure => '0.7-2',
  }

  package { 'python-pkg-resources':
    ensure => '0.6.14-4',
  }

  package { 'libjs-jquery':
    ensure => '1.4.2-2',
  }

  package { 'javascript-common':
    ensure => '7',
  }

  package { 'libpaper1':
    ensure => '1.1.24',
  }

  package { 'python-reportlab-accel':
    ensure => '2.4-4',
  }

  package { 'python-pip':
    ensure => '0.7.2-1',
  }
}
