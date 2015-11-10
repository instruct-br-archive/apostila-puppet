Instalação
==========
Diversas distribuições empacotam o Puppet, mas as versões empacotadas e a qualidade desses pacotes variam muito, portanto
a melhor maneira de instalá-lo é utilizando os pacotes oficiais da PuppetLabs. Os pacotes oficiais são extensivamente testatos
e extremamente confiáveis.

Existem duas versões do Puppet distribuídas pela PuppetLabs: *Puppet Open Source* e o *Puppet Enterprise*. O Puppet Enterprise
é distribuído gratuitamente para o gerenciamento de até 10 nodes, possui suporte oficial e vem acompanhado de uma versátil
interface web para administração.

Para uma comparação mais detalhada sobre as diferenças entre a versão Open Source e a Enterprise, visite a página http://puppetlabs.com/puppet/enterprise-vs-open-source/.

.. aviso::

  |aviso| **Instalação a partir do código fonte**
  
  O Puppet é um projeto grande e complexo que possui muitas dependências, e instalá-lo a partir do
  código fonte não é recomendado. A própria PuppetLabs não recomenda a instalação a partir do código
  fonte. É muito mais confiável e conveniente utilizar pacotes já homologados e testados.

Debian e Ubuntu
---------------
* Debian 7 Wheezy

* Ubuntu LTS 10.04 e 12.04

1. Baixe e instale o pacote puppetlabs-release-\*.deb para a versão da sua distro em http://apt.puppetlabs.com/, por exemplo Debian Wheezy.

::

  # wget http://apt.puppetlabs.com/puppetlabs-release-wheezy.deb
  # dpkg -i puppetlabs-release-wheezy.deb
  # apt-get update


2. Instale o pacote **puppet**.

::

  # apt-get install puppet


.. dica::

  |dica| **Turbinando o vim**
  
  Para facilitar a edição de código, caso você utilize o editor **vim**, ative o plugin que adiciona o suporte a linguagem do Puppet executando ``vim-addons install puppet`` e não deixe de colocar **syntax on** no seu ``.vimrc``.

Red Hat / CentOS
----------------
* Red Hat 5 e 6
* CentOS 5 e 6
* Fedora 19 e 20

1. Baixe e instale o pacote puppetlabs-release-\*.rpm para a versão da sua distro em http://yum.puppetlabs.com/, por exemplo para RHEL/CentOS 6:

::

  # yum install http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
  # yum update

2. Instale o pacote **puppet**.

::

  # yum install puppet

