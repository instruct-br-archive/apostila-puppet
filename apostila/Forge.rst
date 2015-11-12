Puppet Forge
============
Ao longo da história da computação, programadores desenvolveram diversas técnicas para evitar retrabalho. Estão disponíveis aos programadores bibliotecas de código que implementam diversas funcionalidades prontas para uso. Além disso, ao desenvolver um software, certamente um programador competente concentra rotinas repetidas ou parecidas em bibliotecas que podem ser reutilizadas no seu projeto.

Infelizmente, no mundo da administração de sistemas, aproveitar soluções de problemas que já foram resolvidos por outro administrador é muito raro. SysAdmins de diferentes organizações estão resolvendo os mesmos problemas todos os dias. Configurando e instalando servidores web, banco de dados, fazendo ajustes de segurança e etc.

Não seria incrível se os SysAdmins pudessem aproveitar o trabalho uns dos outros? Para isso o Puppet Forge foi criado!

Puppet Forge é um repositório de módulos escritos pela comunidade para o Puppet Open Source e Puppet Enterprise. Nele encontramos diversos módulos prontos para uso, e que com pouquíssimas linhas em um manifest podemos poupar horas e horas de trabalho aproveitando módulos úteis desenvolvidos por SysAdmins ao redor do mundo.

Prática: módulo para sysctl do Puppet Forge
-------------------------------------------
Um dos itens comumente configurados em sistemas operacionais são os parâmetros de kernel, usando o comando ``sysctl``.

Poderíamos criar um módulo para que essas configurações fossem gerenciadas via Puppet, mas felizmente alguém já deve ter resolvido esse problema.

1. Faça uma busca por **sysctl** no repositório do PuppetForge.

::

  # cd /etc/puppetlabs/code/environments/production/modules

  # puppet module search sysctl
  Notice: Searching https://forgeapi.puppetlabs.com ...
  NAME                                 DESCRIPTION                                               AUTHOR             KEYWORDS                    
  duritong-sysctl                      This modules allows you to configure sysctl.              @duritong          sysctl                      
  ULHPC-sysctl                         Configure and manage sysctl                               @ULHPC             os sysctl kernel parameters 
  halyard-sysctl                       Sysctl module                                             @halyard           os sysctl                   
  fiddyspence-sysctl                   sysctl type and provider                                  @fiddyspence       sysctl kernel parameters    
  thias-sysctl                         Sysctl module                                             @thias             os sysctl                   
  example42-sysctl                     Puppet module for sysctl                                  @example42         sysctl example42            
  trlinkin-sysctl                      Control Sysctl entries on UNIX systems.                   @trlinkin          os sysctl type mac linux bsd
  kickstandproject-sysctl              UNKNOWN                                                   @kickstandproject  ubuntu sysctl               
  a2labs-sysctl                        Configure sysctl settings on Ubuntu                       @a2labs                                        
  a2tar-sysctl                         Puppet sysctl editor for ubuntu                           @a2tar             ubuntu sysctl               
  Flameeyes-sysctl                     Cross-distributions sysctl handling                       @Flameeyes         ubuntu sysctl centos gentoo 
  eliasp-sysctl                        Cross-distributions sysctl handling                       @eliasp            ubuntu centos gentoo        
  lgbarn-sysctl                        Module to control sysctl entries                          @lgbarn                                        
  herculesteam-augeasproviders_sysctl  Augeas-based sysctl type and provider for Puppet          @herculesteam      sysctl augeas types         
  greatboy-bs_sysctl                   A puppet module which manage /etc/sysctl.conf file.       @greatboy                                      
  thias-tuned                          Tuned adaptive system tuning daemon module                @thias             sysctl tuned                
  domcleal-augeasproviders             Alternative Augeas-based providers for Puppet             @domcleal          mail ssh sysctl nrpe sshd   
  ffollonier-wrappers                  Puppet Module for wrapping defined types from several...  @ffollonier        nginx sysctl php jboss      
  erwbgy-system                        Manage Linux system resources and services from hiera...  @erwbgy            ntp sysctl rhel cron sshd                      

2. Já existem vários módulos para tratar esse problema. Vamos instalar um deles (já testado anteriormente, por isso a escolha):

::

  # puppet module install trlinkin/sysctl
  Notice: Preparing to install into /etc/puppetlabs/code/environments/production/modules ...
  Notice: Downloading from https://forgeapi.puppetlabs.com ...
  Notice: Installing -- do not interrupt ...
  /etc/puppetlabs/code/environments/desenv/modules
  |--- trlinkin-sysctl (v0.0.2)

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

  # cd /etc/puppetlabs/code/environments/production/modules
  # puppet module install jhoblitt/autofsck
  Notice: Preparing to install into /etc/puppetlabs/code/environments/production/modules ...
  Notice: Downloading from https://forgeapi.puppetlabs.com ...
  Notice: Installing -- do not interrupt ...
  /etc/puppetlabs/code/environments/desenv/modules
  |--| jhoblitt-autofsck (v1.1.0)
  |--- puppetlabs-stdlib (v4.9.0)

2. Declare o módulo ``autofsck`` na configuração de **node1**:

.. code-block:: ruby

  node 'node1.puppet' {
    include autofsck
  }

3. Execute o agente em **node1**:

::

  # puppet agent -t
