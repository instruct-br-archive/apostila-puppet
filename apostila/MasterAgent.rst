Master / Agent
==============

O Puppet é geralmente (mas nem sempre) usado como *master/agent*. O ciclo de operação nesses casos é o seguinte:

1. Os clientes (chamados de *node*) possuem um agente instalado que permanece em execução e se conecta ao servidor central (chamado tipicamente de *master*) periodicamente (a cada 30 minutos, por padrão).
2. O node solicita a sua configuração, que é compilada e enviada pelo master.
3. Essa configuração é chamada de catálogo.
4. O agente aplica o catálogo no node.
5. O resultado da aplicação do catálogo é reportado ao master opcionalmente, havendo divergências ou não.

Outra maneira comum de implantação do Puppet é a ausência de um agente em execução nos nodes. A aquisição e aplicação do catálogo é agendada na crontab.

Resolução de nomes
------------------
A configuração de nome e domínio do sistema operacional, além da resolução de nomes, é fundamental para o correto funcionamento do Puppet, devido ao uso de certificados SSL para a autenticação de agentes e o servidor master.

Para verificar a configuração de seu sistema, utilize o comando ``hostname``. A saída desse comando nos mostra se o sistema está configurado corretamente.

::

  # hostname
  node1
  
  # hostname --domain
  puppet
  
  # hostname --fqdn
  node1.puppet

.. dica::

  |dica| **Configuração de hostname no Red Hat/CentOS e Debian/Ubuntu**
  
  Para resolução de nomes, configure corretamente o arquivo ``/etc/resolv.conf`` com os parâmetros ``domain`` e ``search`` com o domínio de sua rede.
  
  O arquivo ``/etc/hosts`` deve possuir pelo menos o nome da própria máquina, com seu IP, FQDN e depois o hostname. Exemplo: ``192.168.1.10 node1.puppet node1``.
  
  No Debian, coloque apenas o hostname no arquivo ``/etc/hostname``.
  
  No CentOS, ajuste o valor da variável ``HOSTNAME`` em ``/etc/sysconfig/network``.


Para um bom funcionamento do Puppet é fundamental que sua rede possua resolução de nomes via DNS configurada.
Hostname e domínio de cada sistema operacional devem resolver corretamente para seu respectivo IP, e o IP deve possuir o respectivo reverso.

Segurança e autenticação
------------------------
As conexões entre agente e servidor master são realizadas usando o protocolo SSL e, através de certificados, ambos se validam.
Assim, o agente sabe que está falando com o servidor correto e o servidor master sabe que está falando com um agente conhecido.

Um servidor master do Puppet é um CA (Certificate Authority) e implementa diversas funcionalidades como gerar, assinar, revogar e remover certificados para os agentes.

Os agentes precisam de um certificado assinado pelo master para receber o catálogo com as configurações.

Quando um agente e master são executados pela primeira vez, um certificado é gerado automaticamente pelo Puppet, usando o FQDN do sistema no certificado.

Prática Master/Agent
--------------------

Instalação do master
````````````````````
1. O pacote ``puppetserver`` deverá ser instalado na máquina que atuará como master. Certifique-se de que o hostname está correto.

::

  # hostname --fqdn
  master.puppet
   
Instalando o pacote ``puppetserver`` no CentOS 7/Red Hat 7:

::

  # yum install -y http://yum.puppetlabs.com/el/7/PC1/x86_64/puppetlabs-release-pc1-0.9.2-1.el7.noarch.rpm
  # yum install -y puppetserver tree
  # echo "PATH=/opt/puppetlabs/bin:$PATH" >> /etc/bashrc
  # echo "export PATH" >> /etc/bashrc
  # export PATH=/opt/puppetlabs/bin:$PATH

Instalando o pacote ``puppetserver`` no Debian 8:

::

  # cd /tmp
  # wget http://apt.puppetlabs.com/puppetlabs-release-pc1-jessie.deb
  # dpkg -i  puppetlabs-release-pc1-jessie.deb
  # apt-get update
  # apt-get install -y puppetserver tree
  # echo "PATH=/opt/puppetlabs/bin:$PATH" >> /etc/bash.bashrc
  # echo "export PATH" >> /etc/bash.bashrc
  # export PATH=/opt/puppetlabs/bin:$PATH

Instalando o pacote ``puppetserver`` no Ubuntu 14.04:

::

  # cd /tmp
  # wget http://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb
  # dpkg -i puppetlabs-release-pc1-trusty.deb
  # apt-get update
  # apt-get install -y puppetserver tree
  # echo "PATH=/opt/puppetlabs/bin:$PATH" >> /etc/bash.bashrc
  # echo "export PATH" >> /etc/bash.bashrc
  # export PATH=/opt/puppetlabs/bin:$PATH

Teremos a seguinte estrutura em ``/etc/puppet``:

::

  # tree -F --dirsfirst /etc/puppetlabs/
  /etc/puppetlabs/
  |-- code/
  |   |-- environments/
  |   |   |-- production/
  |   |       |-- hieradata/
  |   |       |-- manifests/
  |   |       |-- modules/
  |   |       |-- environment.conf
  |   |-- modules/
  |   |-- hiera.yaml
  |-- mcollective/
  |   |-- client.cfg
  |   |-- data-help.erb
  |   |-- discovery-help.erb
  |   |-- facts.yaml
  |   |-- metadata-help.erb
  |   |-- rpc-help.erb
  |   |-- server.cfg
  |-- puppet/
  |   |-- ssl/
  |   |-- auth.conf
  |   |-- puppet.conf
  |-- puppetserver/
      |-- conf.d/
      |   |-- ca.conf
      |   |-- global.conf
      |   |-- puppetserver.conf
      |   |-- web-routes.conf
      |   |-- webserver.conf
      |-- bootstrap.cfg
      |-- logback.xml
      |-- request-logging.xml

* Os arquivos e diretórios de configuração mais importantes são:

 * ``auth.conf``: regras de acesso a API REST do Puppet.

 * ``fileserver.conf``: Utilizado para servir arquivos que não estejam em módulos.

 * ``code/environments/production/manifests/``: Armazena a configuração que será compilada e servida para os agentes que executam no ambiente de produção (padrão).

 * ``code/environments/production/modules/``: Armazena módulos com classes, arquivos, plugins e mais configurações para serem usadas nos manifests para o ambiente de produção (padrão).

 * ``puppet.conf``: Principal arquivo de configuração, tanto do master como do agente.


.. dica::

  |dica| **Sobre os arquivos de configuração**
  
  Nas páginas abaixo você encontra mais detalhes sobre os arquivos de configuração do puppet.
  
  https://docs.puppetlabs.com/puppet/latest/reference/config_important_settings.html
  https://docs.puppetlabs.com/puppet/latest/reference/dirs_confdir.html
  https://docs.puppetlabs.com/puppet/latest/reference/config_about_settings.html
  https://docs.puppetlabs.com/puppet/latest/reference/config_file_main.html
  https://docs.puppetlabs.com/references/latest/configuration.html
  https://docs.puppetlabs.com/puppet/latest/reference/config_important_settings.html


.. nota::

  |nota| **Sobre os binários do Puppet**
  
  Os binários e libs do Puppet 4.x ficam, por padrão, dentro do diretório ``/opt/puppetlabs/bin/``.
  Os arquivos de configuração ficam, por padrão, dentro do diretório ``/etc/puppetlabs/``.
  
.. raw:: pdf
 
 PageBreak

2. Configurando o serviço:

Altere as configurações de memória do Java a ser usado pelo Puppet. 

* No CentOS 7 / Red Hat 7 edite o arquivo ``/etc/sysconfig/puppetserver``.

::
  
  JAVA_ARGS="-Xms512m -Xmx512m -XX:MaxPermSize=256m"


* No Debian 8 / Ubuntu 14.04 edite o arquivo ``/etc/default/puppetserver``.

::
  
  JAVA_ARGS="-Xms512m -Xmx512m -XX:MaxPermSize=256m"
 
Com esta configuração, será alocado  512 MB (no máximo) e 256 MB (no mínimo) para  uso exclusivo da JVM (Java Virtual Machine) usada pelo PuppetServer.

3. Iniciando o serviço:

 * No CentOS 7 / Red Hat 7:

::

  # systemctl restart puppetserver

 * No Debian 8 / Ubuntu 14.04:
 
::

  # service puppetserver restart
  
.. nota::

  |nota| **Configurando o Firewall e o NTP**  

  Procure manter a hora do sistema de cada máquina corretamente configurada utilizando NTP, para evitar problemas na assinatura de certificados, entre outros.

  A porta 8140/TCP do servidor Puppet-Master precisa estar acessível para as demais máquinas. 

  Para a execução deste tutorial, o firewall foi parado no CentOS 7 / Red Hat 7 com os comandos abaixo.

::

  # systemctl stop firewalld
  # systemctl disable firewalld


* No CentOS 7 / Red Hat 7:

O log do puppetserver fica (por padrão) em:

* ``/var/log/puppetlabs/puppetserver/puppetserver.log``
* ``/var/log/puppetlabs/puppetserver/puppetserver-daemon.log`` 
* ``/var/log/messages``

* No Debian 8 / Ubuntu 14.04:

O log do puppetserver fica (por padrão) em:

* ``/var/log/puppetlabs/puppetserver/puppetserver.log``
* ``/var/log/puppetlabs/puppetserver/puppetserver-daemon.log`` 
* ``/var/log/syslog``

Instalação do agente em node1
`````````````````````````````
1. Certifique-se de que o nome e domínio do sistema estejam corretos e instale o pacote ``puppet`` na máquina node1:

::

  # hostname --fqdn
  node1.puppet

Instalando o pacote ``puppet-agent`` no CentOS 7/Red Hat 7:

::

  # yum install -y http://yum.puppetlabs.com/el/7/PC1/x86_64/puppetlabs-release-pc1-0.9.2-1.el7.noarch.rpm
  # yum install -y puppet-agent
  # echo "PATH=/opt/puppetlabs/bin:$PATH" >> /etc/bashrc
  # echo "export PATH" >> /etc/bashrc
  # export PATH=/opt/puppetlabs/bin:$PATH

Instalando o pacote ``puppet-agent`` no Debian 8:

::

  # cd /tmp
  # wget http://apt.puppetlabs.com/puppetlabs-release-pc1-jessie.deb
  # dpkg -i  puppetlabs-release-pc1-jessie.deb
  # apt-get update
  # apt-get install -y puppet-agent
  # echo "PATH=/opt/puppetlabs/bin:$PATH" >> /etc/bash.bashrc
  # echo "export PATH" >> /etc/bash.bashrc
  # export PATH=/opt/puppetlabs/bin:$PATH

Instalando o pacote ``puppet-agent`` no Ubuntu 14.04:

::

  # cd /tmp
  # wget http://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb
  # dpkg -i puppetlabs-release-pc1-trusty.deb
  # apt-get update
  # apt-get install -y puppet-agent
  # echo "PATH=/opt/puppetlabs/bin:$PATH" >> /etc/bash.bashrc
  # echo "export PATH" >> /etc/bash.bashrc
  # export PATH=/opt/puppetlabs/bin:$PATH

  
A estrutura do diretório ``/etc/puppetlabs`` é semelhante a do master.

 * No CentOS 7 / Red Hat 7:

O log do puppet-agent fica (por padrão) em:

* ``/var/log/messages``
* ``/var/log/puppetlabs/puppet``

 * No Debian 8 / Ubuntu 14.04:

O log do puppet-agent fica (por padrão) em:

* ``/var/log/syslog``
* ``/var/log/puppetlabs/puppet``

2. Em uma máquina em que o agente está instalado, precisamos configurá-la para que ele saiba quem é o master.

No arquivo ``/etc/puppetlabs/puppet/puppet.conf``, adicione as linhas abaixo.

::

  # /etc/puppetlabs/puppet/puppet.conf
  [main]
  certname = node1.puppet
  server = master.puppet
  environment = production
  # intervalo (em segundos) de atualizacao do catalogo
  runinterval = 300 

.. nota::

  |nota| **Conectividade**
  
  Certifique-se de que o servidor master na porta 8140 TCP está acessível para os nodes.

3. Conecte-se ao master e solicite assinatura de certificado:

::

  # puppet agent -t
  Info: Creating a new SSL key for node1.puppet
  Info: Caching certificate for ca
  Info: Creating a new SSL certificate request for node1.puppet
  Info: Certificate Request fingerprint (SHA256): 6C:7E:E6:3E:EC:A4:15:56: ...

4. No servidor master aparecerá a solicitação de assinatura para a máquina node1.puppet. Assine-a

 * O comando abaixo deve ser executado em **master.puppet**.

::

  master # puppet cert list
    "node1.puppet" (SHA256) 6C:7E:E6:3E:EC:A4:15:56:49:C3:1E:A5:E4:7F:58:B8: ...
  
  master # puppet cert sign node1.puppet
  Signed certificate request for node1.puppet
  Removing file Puppet::SSL::CertificateRequest node1.puppet at \
        '/var/lib/puppet/ssl/ca/requests/node1.puppet.pem'

5. Execute o agente novamente e estaremos prontos para distribuir a configuração.

 * O comando abaixo deve ser executado em **node1.puppet**.

::

  # puppet agent -t
  Info: Caching certificate for node1.puppet
  Info: Caching certificate_revocation_list for ca
  Info: Retrieving plugin
  Info: Caching catalog for node1.puppet
  Info: Applying configuration version '1352824182'
  Info: Creating state file /var/lib/puppet/state/state.yaml
  Finished catalog run in 0.05 seconds

Agora execute os comandos abaixo para iniciar o puppet-agent como serviço e habilitá-lo para ser executado após o boot do sistema operacional.

::
  
  # puppet resource service puppet ensure=running enable=true

.. dica::

  |dica| **Possíveis problemas com certificados SSL**
  
  É importante que os horários do master e dos nodes não tenham grandes diferenças e estejam, de preferência, sincronizados.
  Conexões SSL confiam no relógio e, se estiverem incorretos, então sua conexão pode falhar com um erro indicando que os certificados não são confiáveis. Procure manter os relógios corretamente configurados utilizando NTP.
