Instalação
==========
Diversas distribuições empacotam o Puppet, mas as versões empacotadas e a qualidade desses pacotes variam muito, portanto
a melhor maneira de instalá-lo é utilizando os pacotes oficiais da PuppetLabs. Os pacotes oficiais são extensivamente testatos
e extremamente confiáveis.

Existem duas versões do Puppet distribuídas pela PuppetLabs: *Puppet Open Source* e o *Puppet Enterprise*. O Puppet Enterprise
é distribuído gratuitamente para o gerenciamento de até 10 nodes, possui suporte oficial e vem acompanhado de uma versátil
interface web para administração.

Para uma comparação mais detalhada sobre as diferenças entre a versão Open Source e a Enterprise, visite as páginas: https://puppetlabs.com/puppet/enterprise-and-open-source e https://puppetlabs.com/puppet/faq .

.. aviso::

  |aviso| **Instalação a partir do código fonte**
  
  O Puppet é um projeto grande e complexo que possui muitas dependências, e instalá-lo a partir do
  código fonte não é recomendado. A própria PuppetLabs não recomenda a instalação a partir do código
  fonte. É muito mais confiável e conveniente utilizar pacotes já homologados e testados.

Debian e Ubuntu
---------------

1. Adicionando o repositório da PuppetLabs:

* Debian 8.x (Jessie)

::

  # cd /tmp
  # wget http://apt.puppetlabs.com/puppetlabs-release-pc1-jessie.deb
  # dpkg -i  puppetlabs-release-pc1-jessie.deb
  # apt-get update

* Ubuntu 14.04.x LTS (Trusty)

::

  # cd /tmp
  # wget http://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb
  # dpkg -i puppetlabs-release-pc1-trusty.deb
  # apt-get update

Para instalar o repositório em outras versões do Debian ou Ubuntu, acesse a página http://apt.puppetlabs.com/ e baixe o pacote puppetlabs-release-pc1-SOBRENOME_DISTRO.deb. Por exemplo, o sobrenome do Debian 7 é Wheezy. Logo, o pacote seria puppetlabs-release-pc1-wheezy.deb.

2. Instale o pacote **puppet-agent**.

::

  # apt-get -y install puppet-agent
  # echo "PATH=/opt/puppetlabs/bin:$PATH" >> /etc/bash.bashrc
  # echo "export PATH" >> /etc/bash.bashrc
  # export PATH=/opt/puppetlabs/bin:$PATH

.. dica::

  |dica| **Turbinando o vim**
  
  Para facilitar a edição de código, caso você utilize o editor vim, ative o plugin que adiciona o suporte a linguagem do Puppet executando os comandos abaixo e não deixe de adicionar a linha **syntax on** no seu ``/home/name_user/.vimrc ou /root/.vimrc``.
  
::

  # apt-get -y install vim vim-addon-manager vim-puppet
  # vim-addons install puppet
  
Red Hat e CentOS
----------------

1. Adicionando o repositório da PuppetLabs:

* Red Hat 7.x / CentOS 7.x

::

  # yum install -y http://yum.puppetlabs.com/el/7/PC1/x86_64/puppetlabs-release-pc1-0.9.2-1.el7.noarch.rpm

Para instalar o repositório em outras versões do Red Hat ou CentOS, acesse a página http://yum.puppetlabs.com/el/ e localize o pacote adequado para a sua distro, para instalar conforme o exemplo mostrado acima.

2. Instale o pacote **puppet-agent**.

::

  # yum -y install puppet-agent
  # echo "PATH=/opt/puppetlabs/bin:$PATH" >> /etc/bashrc
  # echo "export PATH" >> /etc/bashrc
  # export PATH=/opt/puppetlabs/bin:$PATH

.. dica::

  |dica| **Turbinando o vim**
  
  Para facilitar a edição de código, caso você utilize o editor vim, ative o plugin que adiciona o suporte a linguagem do Puppet executando os comandos abaixo e não deixe de adicionar a linha **syntax on** no seu ``/home/name_user/.vimrc ou /root/.vimrc``.
  
::

  # yum -y install vim vim-puppet
