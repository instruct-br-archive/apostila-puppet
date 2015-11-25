Instalação
==========
Diversas distribuições empacotam o Puppet, mas as versões empacotadas e a qualidade desses pacotes variam muito, portanto
a melhor maneira de instalá-lo é utilizando os pacotes oficiais da PuppetLabs. Os pacotes oficiais são extensivamente testatos
e extremamente confiáveis.

Existem duas versões do Puppet distribuídas pela PuppetLabs: *Puppet Open Source* e o *Puppet Enterprise*. O Puppet Enterprise
é distribuído gratuitamente para o gerenciamento de até 10 nodes, possui suporte oficial e vem acompanhado de uma versátil
interface web para administração.

Para uma comparação mais detalhada sobre as diferenças entre a versão Open Source e a Enterprise, visite as páginas abaixo:

* https://puppetlabs.com/puppet/enterprise-and-open-source
* https://puppetlabs.com/puppet/faq

.. aviso::

  |aviso| **Instalação a partir do código fonte**
  
  O Puppet é um projeto grande e complexo que possui muitas dependências, e instalá-lo a partir do
  código fonte não é recomendado. A própria Puppet Labs não recomenda a instalação a partir do código
  fonte. É muito mais confiável e conveniente utilizar pacotes já homologados e testados.

Debian e Ubuntu
---------------

1. Adicione o repositório da Puppet Labs:

* Debian 8 (Jessie)

::

  # wget http://apt.puppetlabs.com/puppetlabs-release-pc1-jessie.deb
  # dpkg -i  puppetlabs-release-pc1-jessie.deb
  # apt-get update

* Ubuntu 14.04 LTS (Trusty)

::

  # wget http://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb
  # dpkg -i puppetlabs-release-pc1-trusty.deb
  # apt-get update

Acesse http://apt.puppetlabs.com e localize o pacote adequado para outras versões do Debian ou Ubuntu.

2. Instale o pacote ``puppet-agent``:

::

  # apt-get -y install puppet-agent

3. Torne os comandos do pacote ``puppet-agent`` disponíveis no *path* do sistema:

::

  # echo 'PATH=$PATH:/opt/puppetlabs/puppet/bin' > /etc/profile.d/append-puppetlabs-path.sh

.. dica::

  |dica| **Turbinando o vim**
  
  Para facilitar a edição de código, caso você utilize o editor vim, ative o plugin que adiciona o suporte a linguagem do Puppet executando os comandos abaixo e não deixe de adicionar a linha **syntax on** no seu ``/home/name_user/.vimrc`` ou ``/root/.vimrc``.
  
::

  # apt-get -y install vim vim-addon-manager vim-puppet
  # vim-addons install puppet
  
CentOS
------

1. Adicione o repositório da Puppet Labs:

* CentOS 7

::

  # yum install -y http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm

Acesse http://yum.puppetlabs.com e localize o pacote adequado de outras versões e distribuições da família Red Hat.

2. Instale o pacote ``puppet-agent``:

::

  # yum -y install puppet-agent

3. Torne os comandos do pacote ``puppet-agent`` disponíveis no *path* do sistema:

::

  # echo 'PATH=$PATH:/opt/puppetlabs/puppet/bin' > /etc/profile.d/append-puppetlabs-path.sh

.. dica::

  |dica| **Turbinando o vim**
  
  Para facilitar a edição de código, caso você utilize o editor vim, ative o plugin que adiciona o suporte a linguagem do Puppet executando o comando abaixo e não deixe de adicionar a linha **syntax on** no seu ``/home/name_user/.vimrc`` ou ``/root/.vimrc``.
  
::

  # yum -y install vim vim-puppet
