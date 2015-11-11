Nodes
=====
O Puppet começa a compilação da configuração de um catálogo pelo arquivo ``/etc/puppetlabs/code/environments/production/manifests/site.pp``. O ``site.pp`` é o ponto de entrada do master para identificar a configuração que será enviada a um agente.

Para saber qual configuração deve ser enviada a um agente, precisamos declarar o hostname do agente, utilizando a diretiva ``node``. Diretivas ``node`` casam sempre com o nome do agente. Por padrão, o nome do agente é o valor de ``certname`` presente no certificado de um agente (por padrão, o FQDN).

Declarando nodes
----------------
Sintaxe para se declarar um node a partir do master:

.. code-block:: ruby

  # vim /etc/puppetlabs/code/environments/production/manifests/site.pp
  
  node 'node1.puppet' {
    package {'nano':
      ensure => 'present',
    }
  }
  
  node 'node2.puppet' {
    package {'vim':
      ensure => 'present',
    }
  }

No exemplo acima, o agente que se identificar como ``node1.puppet`` receberá a ordem de instalar o pacote ``nano``, enquanto  ``node2.puppet`` deverá instalar o pacote ``vim``.

.. nota::

  |nota| No Puppet 4.2 não é possível modularizar o arquivo ``site.pp`` usando a diretiva ``import``.
 
.. nota::

  |nota| **Classificação de nodes**
  
  O Puppet fornece um recurso chamado *External Node Classifier* (ENC), que tem a finalidade de delegar o registro de nodes para uma entidade externa, evitando a configuração de longos manifests. Esse recurso será visto mais adiante. A documentação oficial está na página: https://docs.puppetlabs.com/guides/external_nodes.html

Nomes
-----
A diretiva *node* casa com agentes por nome. O nome de um node é um identificador único que por padrão é valor de **certname**, ou seja o FQDN.

É possível casar nomes de nodes usando expressões regulares:

.. code-block:: ruby

  # www1, www13, www999
  node /^www\d+$/ {
  
  }
  
  # foo.dominio.com.br ou bar.dominio.com.br
  node /^(foo|bar)\.dominio\.com\.br$/ {
  
  }

Também podemos aproveitar uma configuração em comum usando uma lista de nomes na declaração de um node.

.. code-block:: ruby

  node 'www1.dominio.com.br', 'www2.dominio.com.br', 'www3.dominio.com.br' {
  
  }

O node default
--------------
Caso o Puppet Master não encontre nenhuma declaração de ``node`` explícita para um agente, em última instância pode-se criar um node simplesmente chamado ``default``, que casará apenas para os agentes que não encontraram uma definição de ``node``.

.. code-block:: ruby

  node default {
  
  }

Herança
-------

A partir do Puppet 4.0 não é possível utilizar o mecanismo de herança para a declaração de nodes através da diretiva ``inherits``. Sendo assim, o código abaixo não é mais suportado a partir do Puppet 4.0:

.. code-block:: ruby

  node 'base' {
    package {'nano':
      ensure => 'present',
    }  
  }
  
  node 'www1.dominio.com.br' inherits 'base' {
    package {'vim':
      ensure => 'present',
    }
  }

Prática
-------

1. Declare a máquina **node1.puppet** no ``site.pp`` do master.

2. Declare o pacote ``nano`` como instalado para **node1.puppet**.

3. Execute ``puppet agent -t`` no node1, certifique-se de que o ``nano`` foi instalado.

.. dica::

  |dica| **Simulando a configuração**

  Para simularmos as alterações que serão ou não feitas, usamos ``puppet agent -t --noop``.
