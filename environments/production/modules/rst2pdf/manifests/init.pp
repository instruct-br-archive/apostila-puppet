class rst2pdf {

  include rst2pdf::packages

  package { 'rst2pdf':
    ensure   => '0.93',
    provider => 'pip',
  }

  file {'/usr/share/pyshared/docutils/parsers/rst/languages/pt_br.py':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/rst2pdf/pt_br.py',
  }

}
