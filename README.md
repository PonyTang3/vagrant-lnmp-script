# LNMP
Vagrant box for PHP projects

基于Vagrant的了lnmp开发环境

## 包含

本脚本使用ubuntu官方仓库进行软件安装，软件具体版本由官方仓库的更新情况决定

- Ubuntu 16.04 LTS
- Nginx 1.10
- MySQL 5.7
- PHP 7.0.8
- Redis 3.0.6
- Memcached 1.4.25
- Phpmyadmin 4.5.4
- Composer 1.2.1

## 需求

- [Virtualbox](https://www.virtualbox.org/wiki/Downloads) latest
- [Vagrant](https://www.vagrantup.com/downloads.html) latest

## 使用
###安装Virtualbox、Vagrant
推荐使用最新版本，如果遇到Virtualbox报错，请尝试将Virtualbox的兼容性更改为`Vista`，并勾选`以管理员身份运行`

### 添加基础box


1、网络添加

- `vagrant box add boxcutter/ubuntu1604`

`boxcutter/ubuntu1604` 可以替换为其他版本的基础box。本脚本暂基于ubuntu16.04发行版，所以请选择ubuntu16.04版本box

国内使用，网络速度极慢，请挂载VPN下载

box查找地址：[Atlas](https://atlas.hashicorp.com/boxes/search?utf8=%E2%9C%93&sort=&provider=&q=)

2、本地添加（向本人所要，或自行下载）

- `vagrant box add ubuntu16.04 d:/qqdownload/virtualbox.box`

`ubuntu16.04` 为box命名，可以随意更改

### 使用脚本安装虚拟机

在本脚本所在根目录运行

- `vagrant up` 整个安装过程大概15分钟，具体时间由个人电脑配置及网络情况决定

脚本安装完毕，可以使用以下命令进入虚拟机

- `vagrant ssh` 或者使用其他第三方工具登录管理，账号密码默认均为vagrant

vagrant相关命令
```
vagrant up #启动虚拟机

vagrant suspend #休眠

vagrant destroy #删除虚拟机
```

更多vagrant相关命令，请使用`vagrant -h`命令查看

##脚本相关说明

###Vagrant配置文件 Vagrantfile
```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  # 设置基础box，名字为添加box时设置的名称 the base box is ubuntu 16.04 LTS
  config.vm.box = "ubuntu16.04"

  # 检查box更新 need to check update
  config.vm.box_check_update = true

  # 设置使用私有ip访问虚拟机，默认为127.0.0.1
  # config.vm.network :private_network, ip: "192.168.33.10"

  # 将虚拟机端口映射到本地，可更改 forward guest 80 to host 8080
  config.vm.network "forwarded_port", guest: 80, host: 80 #web
  config.vm.network "forwarded_port", guest: 3306, host: 3306 #mysql


  # 设置共享目录，将脚本所在根目录关连到虚拟机下的/vagrant目录 Use 777 for the default mount folder. which works for Ubuntu and Mac, windows always got 777
  config.vm.synced_folder ".", "/vagrant", :nfs => true, \
    :disabled => false, \
    :mount_options  => ['dmode=777,fmode=777']

  # 设置虚拟机基本配置
  config.vm.provider "virtualbox" do |vb|
     # 是否显示虚拟机GUI　Don't show the GUI unless you have some bug
     vb.gui = false
     # 设置虚拟机内存 Customize the amount of memory on the VM:
     vb.memory = "1024"
     # 设置虚拟机名称 Config the name
     vb.name = "tang3-lnmp"
  end

  # 设置安装虚拟机时执行的预处理命令
  config.vm.provision "shell", inline: <<-SHELL
     cd /vagrant/scripts
     ./mirror.sh #更换ubuntu仓库为国内源
     ./tool.sh #基础工具安装
     ./nginx.sh #nginx安装脚本
     ./redis.sh #redis安装脚本
     ./memcached.sh #memcached安装脚本
     ./mysql.sh #mysql安装脚本
     ./php.sh #php安装脚本
     ./phpmyadmin.sh #phpmyadmin安装脚本
     ./composer.sh #composer安装脚本
  SHELL
end
```

###mysql

mysql的`root`账号密码为`vagrant`，仅能在localhost下登录

远程登录账号为`homestead`，密码为`secret`

默认已创建名为`homestead`的数据库

###php

脚本默认安装php模块如下，具体情况请使用`phpinfo()`函数进行查看
```
php7.0-common php7.0-cli php7.0-fpm php7.0-mysql
php7.0-sqlite php7.0-curl php7.0-gd php7.0-gmp php7.0-mcrypt
php-redis php-imagick php7.0-intl php7.0-json php-memcached
```

###nginx
####默认网站应用
本脚本默认创建两个网站应用，一个域名为mysql.lk，一个域名为vagrant.lk，请在本地host文件将两个域名指向127.0.0.1

- mysql.lk

phpmyadmin网站应用

- vagrant.lk

默认项目开发目录，根目录默认指向本脚本目录下的`www`文件夹，可以在安装脚本前到scripts目录下的vagrant.lk.conf自定义

####自定义网站应用
1、创建网站的nginx配置,并保存到本脚本目录下的随意文件夹
```
# FIXME: this configuration is not secure
server {
    listen 80; #监听端口
    server_name laravel.dev; #自定义域名
    set $root_path '/vagrant/laravel/public'; #网站根目录
    root $root_path;
    index index.php index.html;

    #rewrite url
    try_files $uri $uri/ @rewrite;

    location @rewrite {
        rewrite ^/(.*)$ /index.php?_url=/$1;
    }

    #将php文件交由php-fpm处理
    location ~ \.php($|/) {
        fastcgi_split_path_info ^(.+\.php)(.*)$;
        # With php7.0-fpm:
        fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
        fastcgi_index index.php;
        include /etc/nginx/fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }

    location ~* ^/(css|img|js|flv|swf|download)/(.+)$ {
        root $root_path;
    }

    location ~ /\.ht {
        deny all;
    }
}
```
2、将配置文件复制到虚拟机的nginx配置文件夹下
```
sudo cp /vargant/temp/laravel.dev.conf /etc/nginx/conf.d/
```
3、检查配置，并重启nginx
```
sudo nginx -t

sudo systemctl restart nginx
```
4、更改本地host文件，将域名laravel.dev指向127.0.0.1
```
#C:\Windows\System32\drivers\etc\hosts

127.0.0.1  laravel.dev
```

###composer

composer已更改仓库为国内源
