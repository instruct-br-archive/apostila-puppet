Environments
============
O Puppet permite que você divida os seus sistemas em diferentes conjuntos de máquinas, chamados *environments*.
Cada environment pode servir um conjunto diferente de módulos. Isso é usado geralmente para gerenciar
versões de módulos, usando-os em sistemas destinados a testes.

O uso de environments introduz uma série de outras possibilidades, como separar um ambiente em DMZ, dividir tarefas
entre administradores de sistemas ou dividir o seu parque por tipo de hardware.

O environment de um node é especificado no arquivo ``puppet.conf``. Sempre que um node faz um pedido de configuração
ao Puppet Master, o environment do node é utilizado para determinar a qual configuração e quais módulos serão forneceidos.
Por padrão, o agente envia ao Puppet Master um environment chamado *production*.

Prática: configurando environments
----------------------------------
Os comandos abaixo são executados no **master.puppet** e no **node2.puppet**

1. No ``/etc/puppet/puppet.conf`` do Puppet Master, acrescente os seguintes blocos:

::

  [production]
      modulepath = $confdir/environments/production/modules/
  [desenv]
      modulepath = $confdir/environments/desenv/modules/

2. Crie uma estrutura básica de environments:

::

  # pwd
  /etc/puppet
  
  # mkdir -p environments/{production,desenv}/
  
  # mv modules/ environments/production/
  
  # cp -a environments/production/modules/ environments/desenv/


3. No ``/etc/puppet/puppet.conf`` do node de teste:

::

  [agent]
  environment = desenv


.. dica::

  |dica| **Enviroment em linha de comando**
  
  Opcionalmente, podemos chamar o agente passando o environment pela linha de comando: ``puppet agent -t --environment desenv``.


4. Vamos modificar a template do módulo ``motd`` no environment **desenv**, apenas acrescentando uma linha ao final:

::

  # pwd
  /etc/puppet
  
  # echo "Puppet versão <%= puppetversion -%>" >> environments/desenv/modules/motd/templates/motd.erb


5. Execute o agente no node de teste (certifique-se que o node está no ``site.pp`` e possui a classe **motd** declarada):

::

  # puppet agent -t


6. Agora temos dois módulos ``motd``, um para cada environment. Uma vez que o módulo no environment **desenv** esteja aprovado, ele pode ser copiado para o environment **production**.

::

  # rsync -a environments/desenv/modules/motd/ environments/production/modules/motd/


7. Nos nodes que são do environment **production**, a nova versão do módulo **motd** será utilizada a partir de agora.

Separando o manifest site.pp
----------------------------
O Puppet pode colocar em environments separados diferentes ``site.pp``. Na prática anterior usamos um mesmo site.pp, mas um conjunto de módulos distinto para cada environment.

Para que cada environment tenha seu próprio ``site.pp``, o bloco de configuração no ``puppet.conf`` do Puppet Master deve ficar assim:

::

  [production]
      modulepath = $confdir/environments/production/modules/
      manifest = $confdir/environments/production/manifests/site.pp
  [desenv]
      modulepath = $confdir/environments/desenv/modules/
      manifest = $confdir/environments/desenv/manifests/site.pp

Podemos usar alguns atalhos no puppet.conf. No exemplo abaixo, no bloco ``[master]``,
as opções ``modulepath`` e ``manifest`` se ajustam de acordo com o environment.

::

  [master]
    modulepath = $confdir/environments/$environment/modules:$confdir/modules
    manifest = $confdir/environments/manifests/site.pp

