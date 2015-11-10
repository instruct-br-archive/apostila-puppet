Variáveis, fatos e condições
============================

Variáveis
---------
A linguagem declarativa do Puppet pode usar variáveis, como no exemplo abaixo:

.. code-block:: ruby

  $dns1 = '8.8.8.8'
  $dns2 = '8.8.4.4'
  $arquivo = '/etc/resolv.conf'
  $conteudo = "nameserver ${dns1}\nnameserver ${dns2}"
  
  file {$arquivo:
    ensure => 'present',
    content => $conteudo,
  }


Mais alguns detalhes sobre variáveis:

* Variáveis começam com o símbolo de cifrão (``$``)
* Variáveis podem ser usadas para dar nomes em resources e em atributos
* Para interpolar variáveis, a string deve estar entre aspas duplas e a variável deve estar entre chaves: ``${var}``
* Variáveis do topo do escopo (algo como global) podem ser acessadas assim: ``$::variavel_global``
* Uma variável só pode ter seu valor atribuído uma vez

Fatos
-----
Antes de gerar a configuração, o Puppet executa o ``facter``.

O ``facter`` é uma ferramenta fundamental do ecossistema do Puppet, que gera uma lista de variáveis chamadas de fatos, que contém diversas informações sobre o sistema operacional.

Exemplo de saída da execução do comando ``facter``:

::

  # facter
  architecture => amd64
  augeasversion => 0.10.0
  boardmanufacturer => Dell Inc.
  boardserialnumber => .C75L6M1.
  facterversion => 1.6.14
  hardwareisa => unknown
  hardwaremodel => x86_64
  hostname => inspiron
  id => root
  interfaces => eth0,lo,vboxnet0
  ipaddress => 192.168.56.1
  ipaddress_lo => 127.0.0.1
  ipaddress_vboxnet0 => 192.168.56.1
  is_virtual => false
  kernel => Linux
  kernelmajversion => 3.2
  kernelrelease => 3.2.0-0.bpo.3-amd64
  kernelversion => 3.2.0
  lsbdistcodename => squeeze
  lsbdistdescription => Debian GNU/Linux 6.0.6 (squeeze)
  lsbdistid => Debian
  lsbdistrelease => 6.0.6
  lsbmajdistrelease => 6
  macaddress => 00:26:b9:25:76:ef
  macaddress_eth0 => 00:26:b9:25:76:ef
  macaddress_vboxnet0 => 0a:00:27:00:00:00
  manufacturer => Dell Inc.
  memoryfree => 1.70 GB
  memorysize => 3.68 GB
  memorytotal => 3.68 GB
  netmask => 255.255.255.0
  netmask_lo => 255.0.0.0
  netmask_vboxnet0 => 255.255.255.0
  network_lo => 127.0.0.0
  network_vboxnet0 => 192.168.56.0
  operatingsystem => Debian
  operatingsystemrelease => 6.0.6
  osfamily => Debian
  path => /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
  physicalprocessorcount => 1
  processor0 => Intel(R) Core(TM) i3 CPU       M 330  @ 2.13GHz
  processor1 => Intel(R) Core(TM) i3 CPU       M 330  @ 2.13GHz
  processor2 => Intel(R) Core(TM) i3 CPU       M 330  @ 2.13GHz
  processor3 => Intel(R) Core(TM) i3 CPU       M 330  @ 2.13GHz
  processorcount => 4
  productname => Inspiron 1564
  ps => ps -ef
  puppetversion => 3.0.1
  rubysitedir => /usr/local/lib/site_ruby/1.8
  rubyversion => 1.8.7
  selinux => false
  serialnumber => C75L6M1
  sshdsakey => AAAAB3NzaC1kc3MAAACBAJ6Lw5zcJfTkBm6Yp00a8X5XBkYLJtaf ...
  sshrsakey => AAAAB3NzaC1yc2EAAAADAQABAAABAQDAErKQ92ShklNso4oBUNH6 ...
  swapfree => 0.00 kB
  swapsize => 0.00 kB
  timezone => BRST
  type => Portable
  uniqueid => 007f0101
  uptime => 34 days
  uptime_days => 34
  uptime_hours => 826
  uptime_seconds => 2973926
  virtual => physical

Todas essas variáveis estão disponíveis para uso dentro de qualquer manifest e dizemos que estão no escopo de topo (*top scope*).

O exemplo abaixo usa algumas das variáveis geradas pelo ``facter``:

.. code-block:: ruby

  notify {'kernel':
    message => "O sistema operacional é ${kernel} e versão ${kernelversion}"
  }
  
  notify {'distro':
    message => "A distribuição é ${operatingsystem} e versão ${operatingsystemrelease}"
  }

E teremos a seguinte saída:

::

  # puppet apply a.pp
  O sistema operacional é Linux e versão 2.6.18
  /Stage[main]//Notify[kernel]/message: defined 'message' as 'Nosso sistema operacional \
                é Linux e versão 2.6.18'
  A distribuição é CentOS e versão 5.8
  /Stage[main]//Notify[distro]/message: defined 'message' as 'A distribuição é CentOS e \
                versão 5.8'
  Finished catalog run in 0.05 seconds

.. nota::

  |nota| **Sistemas operacionais diferentes**
  
  Alguns fatos podem variar de um sistema operacional para outro. Além disso, é possível estender as variáveis do ``facter``.

.. Prática: facter
.. ```````````````
.. 1. Execute o facter:
.. 
.. ::
.. 
..   # facter
.. 
.. 2. Veja que é possível extrair fatos específicos:
.. 
.. ::
.. 
..   # facter ipaddress
..   
..   # facter ipaddress_eth0
.. 
.. 3. É possível extrair os fatos em formatos como YAML e JSON.
.. 
.. ::
.. 
..   # facter --json
..   
..   # facter --yaml

Condicionais
------------
A linguagem declarativa do Puppet possui mecanismos de condição que funcionam de maneira parecida em relação às linguagens de programação. Mas existem algumas diferenças.

if
``

Exemplo de um bloco de condição ``if``:

.. code-block:: ruby

  if expressao {
    bloco de codigo
  }
  elsif expressao {
    bloco de codigo
  }
  else {
    bloco de codigo
  }


O ``else`` e o ``elsif`` são opcionais.

.. raw:: pdf

 PageBreak

Outro exemplo, usando uma variável do ``facter``:

.. code-block:: ruby

  if $is_virtual == 'true' {
    notify {'Estamos em uma maquina virtual': }
  }
  else {
    notify {'Estamos em uma maquina real': }
  }

Os blocos podem conter qualquer qualquer tipo de definição de configuração, mais alguns exemplos:

.. code-block:: ruby

  if $osfamily == 'RedHat' {
    service {'sshd':
      ensure => 'running',
      enable => 'true',
    }
  }
  elsif $osfamily == 'Debian' {
    service {'ssh':
      ensure => 'running',
      enable => 'true',
    }
  }

.. aviso::

  |aviso| **True e False para o Puppet.**
  
  Quando usamos variáveis que vêm do ``facter``, sempre são strings.
  
  Mesmo que seja retornado *false*, por exemplo, no fato $is_virtual, é diferente do tipo booleano ``false``.
  
  Portanto, um código como o abaixo sempre cairá no primeiro bloco, pois a variável é uma string.
  
  ``if $is_virtual { ... } else { ... }``
  
Expressões
``````````

Comparação
**********

* ``==`` (igualdade, sendo que comparação de strings é **case-insensitive**)
* ``!=`` (diferente)
* ``<`` (menor que)
* ``>`` (maior que)
* ``<=`` (menor ou igual)
* ``>=`` (maior ou igual)
* ``=~`` (casamento de regex)
* ``!~`` (não casamento de regex)
* ``in`` (contém, sendo que comparação de strings é **case-sensitive**)

Exemplo do operador ``in``:

.. code-block:: ruby

      'bat' in 'batata' # TRUE
      'Bat' in 'batata' # FALSE
      'bat' in ['bat', 'ate', 'logo'] # TRUE
      'bat' in { 'bat' => 'feira', 'ate' => 'fruta'} # TRUE
      'bat' in { 'feira' => 'bat', 'fruta' => 'ate' } # FALSE

Operadores booleanos
********************
* ``and``
* ``or``
* ``!`` (negação)

Case
````

Além do ``if``, o Puppet fornece a diretiva ``case``.

.. code-block:: ruby

  case $operatingsystem {
    centos: { $apache = "httpd" }
    redhat: { $apache = "httpd" }
    debian: { $apache = "apache2" }
    ubuntu: { $apache = "apache2" }
    # fail é uma função
    default: { fail("sistema operacional desconhecido") }
  }
  package {'apache':
    name   => $apache,
    ensure => 'latest',
  }


Ao invés de testar uma única condição, o ``case`` testa a variável em diversos valores. O valor ``default`` é especial, e é auto-explicativo.

O ``case`` pode tentar casar com strings, expressões regulares ou uma lista de ambos.

O casamento de strings é *case-insensitive* como o operador de comparação ``==``.

Expressões regulares devem ser escritas entre barras e são *case sensitive*.

O exemplo anterior, reescrito:

.. code-block:: ruby

  case $operatingsystem {
    centos, redhat: { $apache = "httpd" }
    debian, ubuntu: { $apache = "apache2" }
    default: { fail("sistema operacional desconhecido") }
  }

Exemplo usando uma expressão regular:

.. code-block:: ruby

  case $ipaddress_eth0 {
    /^127[\d.]+$/: { 
      notify {'erro': 
        message => "Configuração estranha!",
      } 
    }
  }

Selectors
`````````

Ao invés de escolher a partir de um bloco, um ``selector`` escolhe seu valor a partir de um grupo de valores. ``Selectors`` são usados para atribuir valor a variáveis.


.. code-block:: ruby

  $apache = $operatingsystem ? {
    centos          => 'httpd',
    redhat          => 'httpd',
    /Ubuntu|Debian/ => 'apache2',
    default         => undef,
  }


O ponto de interrogação assinala ``$operatingsystem`` como o pivô do ``selector``, e o valor final que é atribuído a ``$apache`` é determinado pelo valor corresponde de ``$operatingsystem``.

Pode parecer um pouco estranho, mas há muitas situações em que é a forma mais concisa de se obter um valor.

Prática: melhor uso de variáveis
--------------------------------

Reescreva o código do exemplo usando uma variável para armazenar o nome do serviço e usando somente um resource ``service`` no seu código.

.. code-block:: ruby

  package {'ntp':
    ensure => 'installed',
  }

  if $osfamily == 'RedHat' {
    service {'ntpd':
      ensure => 'running',
      enable => 'true',
    }
  }
  elsif $osfamily == 'Debian' {
    service {'ntp':
      ensure => 'running',
      enable => 'true',
    }
  }

