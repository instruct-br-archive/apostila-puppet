# Apostila Puppet Básico

Para contribuir basta fazer um fork e submeter seu pull request para nós.

# Instruções para compilar a apostila

* Tenha instalado Vagrant 1.7.4 ou superior.

* Instale a vm box `puppetlabs/debian-6.0.10-64-puppet`.

* Clone o repositório:

```
$ git clone https://github.com/instruct-br/apostila-puppet.git
```

* De dentro do diretório em que está o arquivo `Vagrantfile` execute o comando`vagrant up`.

* Acesse a máquina virtual utilizando `vagrant ssh` e compile a apostila:
```
$ cd /vagrant/apostila
$ ./compila.sh
```

O arquivo `apostila-puppet.pdf` será gerado em `/vagrant/apostila`.


# Instruções para compilar a apostila no Ubuntu 14.04.

* Baixe o Virtualbox na página https://www.virtualbox.org/wiki/Linux_Downloads e instale no Ubuntu.

* Baixe o Vagrant 1.7.4 para Ubuntu 14.04 64 bits no link https://releases.hashicorp.com/vagrant/1.7.4/vagrant_1.7.4_x86_64.deb

OBS.: Mais opções de download do Vagrant estão nesta página: https://www.vagrantup.com/downloads.html

* Instale o pacote que acabou de ser baixado.

```
sudo dpkg -i vagrant_1.7.4_x86_64.deb
```

* Use o comando abaixo para instalar a vm box `puppetlabs/debian-6.0.10-64-puppet`.

```
sudo vagrant box add puppetlabs/debian-6.0.10-64-puppet
```

Ao executar o comando acima será exibido uma mensagem semelhante a esta:

```
    box: URL: https://atlas.hashicorp.com/puppetlabs/debian-6.0.10-64-puppet
This box can work with multiple providers! The providers that it
can work with are listed below. Please review the list and choose
the provider you will be working with.

1) virtualbox
2) vmware_desktop
3) vmware_fusion
```
 
Como o Virtualbox já está instalado, escolha a opção 1. 

Depois disso a instalação da VM seguirá em frente:

```
==> box: Adding box 'puppetlabs/debian-6.0.10-64-puppet' (v1.0.2) for provider: virtualbox
    box: Downloading: https://atlas.hashicorp.com/puppetlabs/boxes/debian-6.0.10-64-puppet/versions/1.0.2/providers/virtualbox.box
==> box: Successfully added box 'puppetlabs/debian-6.0.10-64-puppet' (v1.0.2) for 'virtualbox'!
```

4) Instale o Git com o comando abaixo.

```
sudo apt-get -y install git
```

5)  Execute o comando abaixo para obter o clone do projeto da apostila na sua máquina.

```
git clone https://github.com/instruct-br/apostila-puppet.git
```

O clone será criado no diretório em que você está executando os comandos. Execute o comando pwd para saber qual é.

```
pwd
```

6) Acesse o diretório que os fontes da apostila se encontram.

```
cd apostila-puppet/
```

Devem aparecer os arquivos abaixo.

```
    apostila
    environments
    README.md
    Vagrantfile
```
7) Dentro do diretório `apostila-puppet`, execute o comando abaixo para iniciar a VM.

```
vagrant up
```

Aguarde alguns minutos até o trabalho ser concluído.

Pronto! O ambiente está pronto. Agora é só acessar os arquivos do diretório `apostila-puppet/apostila` e editar com o editor de texto de sua preferência.

8) Estes arquivos tambem estão compartilhados e acessíveis a partir da VM. Quando quiser gerar o PDF dentro da VM, execute a sequência de comandos abaixo.

```
vagrant ssh
cd /vagrant/apostila
chmod +x ./compila.sh
./compila.sh
```

A apostila será gerada e salva em `/vagrant/apostila/apostila-puppet.pdf` e também estará acessível na sua máquina dentro do diretório `apostila-puppet/apostla/apostila-puppet.pdf`. A VM serve apenas para gerar o PDF a partir dos arquivos fontes.

Fonte: https://groups.google.com/forum/#!topic/puppet-users-br/fbri3z0K_5s
