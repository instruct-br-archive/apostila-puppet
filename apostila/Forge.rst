Puppet Forge
============
Ao longo da história da computação, programadores desenvolveram diversas técnicas para evitar retrabalho. Estão disponíveis aos programadores bibliotecas de código que implementam diversas funcionalidades prontas para uso. Além disso, ao desenvolver um software, certamente um programador competente concentra rotinas repetidas ou parecidas em bibliotecas que podem ser reutilizadas no seu projeto.

Infelizmente, no mundo da administração de sistemas aproveitar, problemas que já foram resolvidos por outro administrador é muito raro. SysAdmins de diferentes organizações estão resolvendo os mesmos problemas todos os dias. Configurando e instalando servidores web, banco de dados, fazendo ajustes de segurança e etc.

Não seria incrível se os SysAdmins pudessem aproveitar o trabalho uns dos outros? Para isso o Puppet Forge foi criado!

Puppet Forge é um repositório de módulos escritos pela comunidade para o Puppet Open Source e Puppet Enterprise. Nele encontramos diversos módulos prontos para uso, e que com pouquíssimas linhas em um manifest podemos poupar horas e horas de trabalho aproveitando módulos úteis desenvolvidos por SysAdmins ao redor do mundo.

Prática: módulo para sysctl do Puppet Forge
-------------------------------------------
Um dos itens comumente configurados em sistemas operacionais são os parâmetros de kernel, usando o comando ``sysctl``.

Poderíamos criar um módulo para que essas configurações fossem gerenciadas via Puppet, mas felizmente alguém já deve ter resolvido esse problema.

1. Faça uma busca por **sysctl** no repositório do PuppetForge.

::

  # pwd
  /etc/puppet/modules

  # puppet module search sysctl
  Searching https://forge.puppetlabs.com ...
  NAME                      DESCRIPTION                                                 AUTHOR             KEYWORDS                     
  erwbgy-system             Manage Linux system resources and services from hiera c...  @erwbgy            sshd Group sysctl host user  
  kickstandproject-sysctl                                                               @kickstandproject  ubuntu sysctl                
  trlinkin-sysctl           This module adds a sysctl type and provider                 @trlinkin          type linux bsd sysctl mac    
  fiddyspence-sysctl        Puppet module for managing kernel runtime parameters        @fiddyspence       linux kernel sysctl          
  thias-sysctl              Manage sysctl variable values.                              @thias             sysctl CentOS os rhel        
  domcleal-augeasproviders  # Alternative Augeas-based providers for Puppet             @domcleal          sysctl mail sshd nrpe ssh    
  ghoneycutt-sysctl         manage /etc/sysctl.conf                                     @ghoneycutt        sysctl tuning                
  duritong-sysctl           This modules allows you to configure sysctl.                @duritong          sysctl                       

2. Já existem vários módulos para tratar esse problema. Vamos instalar um deles (já testado anteriormente, por isso a escolha):

::

  # pwd
  /etc/puppet/modules
  # puppet module install trlinkin/sysctl
  Preparing to install into /etc/puppet/modules ...
  Downloading from https://forge.puppetlabs.com ...
  Installing -- do not interrupt ...
  /etc/puppet/modules
  |---trlinkin-sysctl (v0.0.1)

3. Usando o módulo, via linha de comando:

::

  # puppet apply -e "sysctl { 'net.ipv4.ip_forward': value => '1', enable=>true }"

4. Ou declarando um valor para um dos nossos nodes, no ``site.pp``:

.. code-block:: ruby

  node 'node1.puppet' {
    sysctl { 'net.ipv4.ip_forward':
      value   => '1',
      enable  => true,
    }
  } 

5. Aplique essa regra no node1, por exemplo:

::

  # puppet agent -t
  Info: Retrieving plugin
  /File[/var/lib/puppet/lib/puppet]/ensure: created
  /File[/var/lib/puppet/lib/puppet/provider]/ensure: created
  /File[/var/lib/puppet/lib/puppet/provider/sysctl]/ensure: created
  /File[/var/lib/puppet/lib/puppet/provider/sysctl/parsed.rb]/ensure: defined \
            content as '{md5}46bedf16cafa5af507d0aef0d9e126b2'
  /File[/var/lib/puppet/lib/puppet/type]/ensure: created
  /File[/var/lib/puppet/lib/puppet/type/sysctl.rb]/ensure: defined content as \
            '{md5}cb94b98fb045257517de45c9616f2844'
  Info: Caching catalog for node1.puppet
  Info: Applying configuration version '1353001737'
  /Stage[main]//Node[node1.puppet]/Sysctl[net.ipv4.ip_forward]/value: value changed '0' to '1'
  /Stage[main]//Node[node1.puppet]/Sysctl[net.ipv4.ip_forward]/enable: modified \
            running value of 'net.ipv4.ip_forward' from '0' to '1'
  Info: FileBucket adding {md5}228c966fd2676164a120f5230fe0b0e1
  Finished catalog run in 0.17 seconds

Prática: módulo para autofsck do Puppet Forge
---------------------------------------------
1. Instale o módulo ``jhoblitt/autofsck``:

::

  # pwd
  /etc/puppet/modules

  # puppet module install jhoblitt/autofsck
  Preparing to install into /etc/puppet/modules ...
  Downloading from https://forge.puppetlabs.com ...
  Installing -- do not interrupt ...
  /etc/puppet/modules
  |-- jhoblitt-autofsck (v1.0.0)
    |-- puppetlabs-stdlib (v3.1.1)

2. Declare o módulo ``autofsck`` na configuração de **node1**:

.. code-block:: ruby

  node 'node1.puppet' {
    include autofsck
  }

3. Execute o agente em **node1**:

::

  # puppet agent -t

