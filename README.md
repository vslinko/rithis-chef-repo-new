# Настройка инфраструктуры студии

Первым делом необходимо настроить сервер Chef.

Присоеденитесь к свежезаказанному серверу:

```
$ ssh root@198.211.125.118
```

Добавьте репозиторий Opscode:

```
root@chef:~# echo "deb http://apt.opscode.com/ $(lsb_release -cs)-0.10 main" | sudo tee /etc/apt/sources.list.d/opscode.list
root@chef:~# gpg --keyserver keys.gnupg.net --recv-keys 83EF826A
root@chef:~# gpg --export packages@opscode.com | sudo tee /etc/apt/trusted.gpg.d/opscode-keyring.gpg > /dev/null
root@chef:~# aptitude update
root@chef:~# aptitude install -y opscode-keyring
```

Установите Chef:

```
root@chef:~# aptitude install -y chef chef-server
```

Во время установки нужно будет ввести адрес сервера Chef — введите
`http://chef.rithis.com:4000`. Пароль для AMPQ введите произвольный.

Настройте Knife на сервере:

```
root@chef:~# mkdir -p ~/.chef
root@chef:~# knife configure --initial --defaults --server-url http://chef.rithis.com:4000 --repository ""
```

Создайте своего пользователя на сервере Chef:

```
root@chef:~# knife client create vyacheslav -d -a -f /tmp/vyacheslav.pem
```

Скачайте конфигурацию Chef на свою систему:

```
root@chef:~# exit
$ git clone git://github.com/rithis/rithis-chef-repo.git
$ cd rithis-chef-repo
$ sudo bundle install
$ librarian-chef install
```

Настройте Knife на своей системе:

```
$ mkdir ~/.chef
$ scp root@chef.rithis.com:/tmp/vyacheslav.pem ~/.chef/vyacheslav.pem
$ scp root@chef.rithis.com:/etc/chef/validation.pem ~/.chef/validation.pem
$ knife configure --defaults --server-url http://chef.rithis.com:4000 --validation-key ~/.chef/validation.pem --repository "$(pwd)"
```

Сохраните данные для авторизации к API
[Digital Ocean](https://www.digitalocean.com/api_access):

```
$ echo "knife[:digital_ocean_client_id] = \"Client Key\"" >> ~/.chef/knife.rb
$ echo "knife[:digital_ocean_api_key] = \"API Key\"" >> ~/.chef/knife.rb
```

Загрузите конфигурацию Chef на сервер:

```
$ knife cookbook upload --all
$ knife role from file roles/*
$ knife data bag create users
$ knife data bag create staging_projects
$ knife data bag from file users vyacheslav.json
$ knife data bag from file staging_projects data_bags/staging_projects/*
```

Передайте chef.rithis.com под контроль сервера Chef:

```
$ knife bootstrap chef.rithis.com -x root -r "role[chef-server]"
```

Получите все настройки Digital Ocean:

```
$ UBUNTU=$(knife digital_ocean image list --global | grep "Ubuntu 12.04 x32 Server" | awk '{print $1}')
$ AMSTERDAM=$(knife digital_ocean region list | grep "Amsterdam 1" | awk '{print $1}')
$ SIZE512=$(knife digital_ocean size list | grep "512MB" | awk '{print $1}')
$ SIZE1024=$(knife digital_ocean size list | grep "1GB" | awk '{print $1}')
$ SSHKEYS=$(knife digital_ocean sshkey list | grep "^\d" | awk '{print $1}' | paste -sd "," -)
```

Настройте все оставшиеся сервера:

```
$ bootstrap() { knife digital_ocean droplet create --server-name $1.rithis.com --image $UBUNTU --location $AMSTERDAM --size $2 --ssh-keys $SSHKEYS --bootstrap --run-list "role[$1]" }
$ bootstrap teamcity $SIZE1024
$ bootstrap uptime $SIZE512
$ bootstrap staging $SIZE1024
$ bootstrap youtrack $SIZE512
```
