Puppet no Windows
=================
O suporte a Windows no Puppet vem melhorando a cada nova versão. Mas não é possível hospedar o Puppet Master no Windows, sendo suportado somente o agente.

Praticamente onde é possível criar compatibilidade, os resources do Puppet suportam Windows normalmente. Em alguns casos são necessários certos cuidados devido a  diferenças semânticas entre sistemas Unix-like e Windows.

Prática: Instalação
-------------------
Essa prática é realizada usando o **master.puppet** e uma nova máquina com o Windows 7 instalado, que será chamada de **win7.puppet**.

.. nota::

  |nota| **Download do Puppet para Windows**

  O instalador do Puppet para Windows está disponível na página abaixo:
  https://downloads.puppetlabs.com/windows/
  
  Nas páginas abaixo você encontra a documentação completa para usar o Puppet no Windows.
  
  http://docs.puppetlabs.com/windows/
  
  http://docs.puppetlabs.com/guides/install_puppet/install_windows.html


1. Faça login na máquina **win7.puppet**. Baixe o instalador do Puppet-Agent na seguinte URL. 

Se 32 bits: https://downloads.puppetlabs.com/windows/puppet-agent-1.3.0-x86.msi
Se 64 bits: https://downloads.puppetlabs.com/windows/puppet-agent-1.3.0-x64.msi

2. Instale o pacote. Depois de aceitar a licença do Puppet, aparecerá a tela de Configuração, abaixo, perguntando qual é o servidor master, preencha com **master.puppet**.

.. image:: images/windows-puppet-install.png
  :scale: 80%

3. (Opcional) É possível fazer a instalação de maneira automatizada:

::

  msiexec /qn /i nome_pacote_puppet.msi PUPPET_MASTER_SERVER=master.puppet


4. Pare o serviço **Puppet**, pois realizaremos manualmente nossas atividades:

::

  sc stop puppet

.. raw:: pdf

  PageBreak

5. Após a instalação, como o serviço **Puppet**  estava em execução, um certificado já foi solicitado ao master. Como de praxe, assine o certificado:

::

  # puppet cert list
    "win7.puppet" (SHA256) EE:58:97:E3:6F:64:15:DF:68:A4:21:DA:A3:E2:81:43:3F: ...
  
  # puppet cert sign win7.puppet
  Signed certificate request for win7.puppet
  Removing file Puppet::SSL::CertificateRequest win7.puppet at \
            '/var/lib/puppet/ssl/ca/requests/win7.puppet.pem'

6. Abra um prompt de comando como Administrador, conforme ilustra a figura abaixo:

.. image:: images/windows-run-as-admin.png

7. Execute o agente da mesma maneira que no Linux.

::

  puppet agent -t

.. nota::

  |nota| **Privilégios**
  
  No Windows, o Puppet precisa de privilégios elevados para funcionar corretamente, afinal ele precisa configurar o sistema.
  
  O serviço do Puppet é executado com privilégio **LocalSystem**, ou seja, sempre com privilégios elevados.
  
  Quando usar a linha de comando, é sempre necessário utilizar o Puppet com privilégios elevados.


Prática: resources para Windows
-------------------------------
Essa prática é realizada usando o **master.puppet** e **win7.puppet**.

1. Na máquina win7.puppet já temos baixado um pacote MSI que usaremos de exemplo para realizar a instalação. Declarar o seguinte no ``site.pp``:

::

  package {'7-Zip 9.20':
    ensure => 'installed',
    source => 'c:\Users\Puppet\Downloads\7z920.msi',
    install_options => ['/q', { 'INSTALLDIR' => 'C:\Program Files\7-Zip' } ],
  }

2. Aplique o agente (lembre-se de usar um prompt com privilégios elevados)

::

  puppet agent -t


.. dica::

  |dica| **Título do resource package**
  
  O título do resource package precisa ser igual a propriedade *DisplayName* utilizada no registro do Windows para instalação de um pacote MSI. Caso o título seja diferente, o Puppet executará a instalação em todas as execuções.

3. Veja que o 7-Zip foi instalado:

.. image:: images/windows-7zip.png

.. raw:: pdf

  PageBreak

4. Agora vamos configurar um serviço. Declare o seguinte no ``site.pp``:

::

  service {'Audiosrv':
    ensure => 'stopped',
    enable => false,
  }


5. Note que o serviço está em execução (terminal com privilégio regular):

::

  C:\Users\Puppet> sc query audiosrv
   
  SERVICE_NAME: audiosrv
          TYPE               : 20  WIN32_SHARE_PROCESS
          STATE              : 4  RUNNING
                                  (STOPPABLE, NOT_PAUSABLE, IGNORES_SHUTDOWN)
          WIN32_EXIT_CODE    : 0  (0x0)
          SERVICE_EXIT_CODE  : 0  (0x0)
          CHECKPOINT         : 0x0
          WAIT_HINT          : 0x0

6. Aplique o agente (lembre-se de usar um prompt com privilégios elevados)

::

  puppet agent -t


7. Veja que o serviço Windows Audio foi parado e desativado.

::

  C:\Users\Puppet>sc query audiosrv
   
  SERVICE_NAME: audiosrv
          TYPE               : 20  WIN32_SHARE_PROCESS
          STATE              : 1  STOPPED
          WIN32_EXIT_CODE    : 0  (0x0)
          SERVICE_EXIT_CODE  : 0  (0x0)
          CHECKPOINT         : 0x0
          WAIT_HINT          : 0x0


Para mais detalhes sobre as diferenças na declaração dos resources no Windows: http://docs.puppetlabs.com/windows/writing.html

.. raw:: pdf

  PageBreak

Prática: manipulando o registro
-------------------------------
Essa prática é realizada usando o **master.puppet** e **win7.puppet**.

1. Instalando o módulo **puppetlabs-registry** no Puppet Master:

::

  # cd /etc/puppetlabs/code/environments/production/modules
  # puppet module install puppetlabs/registry
  Notice: Preparing to install into /etc/puppetlabs/code/environments/production/modules ...
  Notice: Downloading from https://forgeapi.puppetlabs.com ...
  Notice: Installing -- do not interrupt ...
  /etc/puppetlabs/code/environments/desenv/modules
  |--| puppetlabs-registry (v1.1.2)
  |--- puppetlabs-stdlib (v4.9.0)


2. Execute o agente no Windows para instalação do módulo **puppetlabs-registry** (lembre-se de abrir o terminal do Puppet como *Administrator*):

::

  # puppet agent -t

3. Declare uma chave de registro no nosso manifest:

::

  node 'win7.puppet' {
    registry::value { 'Adware':
      key   => 'HKLM\Software\Microsoft\Windows\CurrentVersion\Run',
      value => 'Adware',
      data  => 'c:\adware\adware.exe'
    }
  }


4. Execute o agente no Windows para que a chave no registro seja criada (lembre-se de abrir o terminal do Puppet como *Administrator*):

::

  # puppet agent -t


5. A chave foi criada.

.. image:: images/windows-regedit.png
  :scale: 80%
