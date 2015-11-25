# Apostila Puppet Básico

Para contribuir basta fazer um fork e submeter seu pull request para nós.

# Instruções para compilar a apostila

* Instale o VirtualBox disponibilizado em https://www.virtualbox.org

* Instale o Vagrant dispobilizado em https://www.vagrantup.com/downloads.html

* Instale a box `puppetlabs/debian-6.0.10-64-puppet`.

```
$ vagrant box add puppetlabs/debian-6.0.10-64-puppet
```

* Clone o repositório:

```
$ git clone https://github.com/instruct-br/apostila-puppet.git
```

Acesse o diretório que os fontes da apostila se encontram:

```
cd apostila-puppet/
```

Devem existir os arquivos abaixo:

```
    apostila
    environments
    README.md
    Vagrantfile
```

* De dentro do diretório onde está o arquivo `Vagrantfile` execute o comando`vagrant up`. O ambiente estará pronto em alguns minutos.

* Acesse os arquivos do diretório `apostila-puppet/apostila` e comece a editar.

* Para gerar o PDF é necessário estar dentro da VM. Execute a sequência de comandos abaixo:

```
vagrant ssh
cd /vagrant/apostila
./compila.sh
```

A apostila será gerada e salva em `/vagrant/apostila/apostila-puppet.pdf` e também estará acessível em
sua máquina dentro do diretório `apostila-puppet/apostla/apostila-puppet.pdf`.

A VM é necessária para gerar o PDF a partir dos arquivos fontes.

