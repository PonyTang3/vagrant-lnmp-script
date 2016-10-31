# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  # 设置基础box，名字为添加box时设置的名称 the base box is ubuntu 16.04 LTS
  config.vm.box = "tang3"

  # 检查box更新 need to check update
  config.vm.box_check_update = true

  # 设置使用私有ip访问虚拟机，默认为127.0.0.1
  # config.vm.network :private_network, ip: "192.168.33.10"

  # 将虚拟机端口映射到本地 forward guest 80 to host 8080
  config.vm.network "forwarded_port", guest: 80, host: 80
  config.vm.network "forwarded_port", guest: 3306, host: 3306


  # 设置共享目录 Use 777 for the default mount folder. which works for Ubuntu and Mac, windows always got 777
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
     ./mirror.sh
     ./tool.sh
     ./nginx.sh
     ./redis.sh
     ./memcached.sh
     ./mysql.sh
     ./php.sh
     ./phpmyadmin.sh
     ./composer.sh
  SHELL
end
