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

  |dica| **Configuração de hostname no Red Hat/Cent e Debian/Ubuntu**
  
  Para resolução de nomes, configurar corretamente o arquivo ``/etc/resolv.conf`` com os parâmetros ``domain`` e ``search`` com o domínio de sua rede.
  
  O arquivo ``/etc/hosts`` deve possuir pelo menos o nome da própria máquina, com seu IP, FQDN e depois o hostname: ``192.168.1.10 node1.puppet node1``.
  
  No Debian, colocar apenas o hostname no arquivo ``/etc/hostname``.
  
  No CentOS, em ``/etc/sysconfig/network``, ajuste o valor da variável ``HOSTNAME``.


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
1. O pacote ``puppet-server`` deverá estar instalado e certifique-se de que o hostname está correto.

::

  # hostname --fqdn
  master.puppet
   
  # yum install puppet-server

Teremos a seguinte estrutura em ``/etc/puppet``:

::

  # tree -F --dirsfirst /etc/puppet/
  /etc/puppet/
  |-- manifests/
  |-- modules/
  |-- auth.conf
  |-- fileserver.conf
  `-- puppet.conf

* Sendo:

 * ``auth.conf``: regras de acesso a API REST do Puppet.

 * ``fileserver.conf``: Utilizado para servir arquivos que não estejam em módulos.

 * ``manifests/``: Armazena a configuração que será compilada e servida para os agentes.

 * ``modules/``: Armazena módulos com classes, arquivos, plugins e mais configurações para serem usadas nos manifests.

 * ``puppet.conf``: Principal arquivo de configuração, tanto do master como do agente.

.. raw:: pdf
 
 PageBreak

2. Iniciando o serviço:

::

  # service puppetmaster start

Os logs, por padrão, são enviados para o syslog e estão disponíveis no arquivo ``/var/log/messages``:

::

  tail /var/log/messages 
  Nov 13 11:50:57 master puppet-master[2211]: Signed certificate request for ca
  Nov 13 11:50:57 master puppet-master[2211]: Rebuilding inventory file
  Nov 13 11:50:58 master puppet-master[2211]: master.puppet has a waiting certificate request
  Nov 13 11:50:58 master puppet-master[2211]: Signed certificate request for master.puppet
  Nov 13 11:50:58 master puppet-master[2211]: Removing file Puppet::SSL::CertificateRequest \
        master.puppet at '/var/lib/puppet/ssl/ca/requests/master.puppet.pem'
  Nov 13 11:50:58 master puppet-master[2211]: Removing file Puppet::SSL::CertificateRequest \
        master.puppet at '/var/lib/puppet/ssl/certificate_requests/master.puppet.pem'
  Nov 13 11:50:58 master puppet-master[2239]: Starting Puppet master version 3.0.1
  Nov 13 11:50:58 master puppet-master[2239]: Reopening log files

Instalação do agente em node1
`````````````````````````````
1. Certifique-se de que o nome e domínio do sistema estejam corretos e instale o pacote ``puppet`` na máquina node1:

::

  # hostname --fqdn
  node1.puppet
  
  # yum install puppet


A estrutura do diretório ``/etc/puppet`` é a mesma do master, e os logs também são enviados via syslog e estão em ``/var/log/messages``.

2. Em uma máquina em que o agente está instalado, precisamos configurá-la para que ele saiba quem é o master.

No arquivo ``/etc/puppet/puppet.conf``, adicionar o parâmetro ``server`` na seção ``[main]``.

::

  # vim /etc/puppet/puppet.conf
  [main]
      logdir = /var/log/puppet
      rundir = /var/run/puppet
      ssldir = $vardir/ssl
      # parâmetro server
      server = master.puppet

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

.. dica::

  |dica| **Possíveis problemas com certificados SSL**
  
  É importante que os horários do master e dos nodes não tenham grandes diferenças e estejam, de preferência, sincronizados.
  Conexões SSL confiam no relógio e, se estiverem incorretos, então sua conexão pode falhar com um erro indicando que os certificados não são confiáveis. Procure manter os relógios corretamente configurados utilizando NTP.

