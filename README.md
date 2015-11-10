# Apostila Puppet Básico

Para contribuir basta fazer um fork e submeter seu pull request para nós.

# Instruções para compilar a apostila

* Tenha instalado Vagrant 1.7.4 ou superior.

* Instale a box `puppetlabs/debian-6.0.10-64-puppet`.

* Clone o repositório:

```
$ git clone https://github.com/instruct-br/apostila-puppet.git
```

* De dentro do diretório onde está o `Vagrantfile` execute `vagrant up`.

* Acesse a máquina virtual utilizando `vagrant ssh` e compile a apostila:
```
$ cd /vagrant/apostila
$ ./compila.sh
```

O arquivo `apostila-puppet.pdf` gerá gerado em `/vagrant/apostila`.

