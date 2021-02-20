# 在 WSL 中安装 NextCloud 搭建个人网盘

## 1. 安装 WSL2

安装过程请参考官方连接 - [适用于 Linux 的 Windows 子系统安装指南 (Windows 10)](https://docs.microsoft.com/zh-cn/windows/wsl/install-win10#manual-installation-steps)

本教程的 Linux 分发包为 Ubuntu 20.04 LTS

## 2. 安装 LAMP 包

LAMP 是指一组通常一起使用来运行动态网站或者服务器的自由软件名称首字母缩写：

- Linux
- Apache
- MariaDB or MySQL
- PHP

安装和启动 Apache

```Linux
sudo apt install -y apache2 apache2-utils
sudo service apache2 start
```

安装和启动 MariaDB

```Linux
sudo apt install mariadb-server mariadb-client
sudo service mysql start
```

安装 MySQL, 安装过程中会有几次询问, 除了让你改 root 密码, 其他问题都是 Y

```Linux
sudo mysql_secure_installation
```

安装 PHP

```Linux
sudo apt install php7.4 libapache2-mod-php7.4 php7.4-mysql php-common php7.4-cli php7.4-common php7.4-json php7.4-opcache php7.4-readline
```

运行 PHP 模块然后重启 Apache

```Linux
sudo a2enmod php7.4
sudo service apache2 restart
```

## 3. 下载并安装 NextCloud

可以使用 `wget` 命令下载, 不过由于 NextCloud 的下载速度较慢, 建议在 Windows 端找别人上传好的文件, 然后切回 Linux 用 cp 命令拷贝到 Linux 中.

下载完成后是一个压缩包, 一般文件夹名为 **nextcloud-[version].zip**, 执行 `sudo apt install unzip` 安装解压程序, 将上述压缩文件进行解压, 例:

```Linux
sudo unzip ~/nextcloud-20.0.6.zip -d ~/nextcloud
```

这样便把压缩包解压到了 `~/nextcloud` 文件夹下了, 然后将其拷贝到 `/var/www/nextcloud` (其实也可以在上一步直接解压到这个文件夹)

```Linux
sudo cp -r ~/nextcloud /var/www/nextcloud
```

将文件夹属主的权限更改一下

```Linux
sudo chown www-data:www-data /var/www/nextcloud -R
```

## 4. 配置过程

首先, 启动 MySQL 数据库同时创建数据库实例

下面各行命令的含义在行头进行了标注:

```Linux
# 进入 mysql 控制台
sudo mysql

# 创建 nextcloud 数据库
mysql> CREATE DATABASE nextcloud;

# 创建用户 ncuser 密码为 ncpassword
mysql> CREATE USER ncuser@localhost IDENTIFIED by 'ncpassword';

# 为用户 ncuser 赋予权限, 即完全控制 nextcloud, 具体可查看 MySQL 的 GRANT 函数
GRANT ALL PRIVILEGES on nextcloud.* to ncuser@localhost IDENTIFIED by ‘ncpassword’;

# 刷新退出
FLUSH PRIVILEGES;
exit;
```

配置 nextcloud 的配置文件: 使用 vim 创建一个新的文件 `/etc/apache2/sites-available/nextcloud.conf`, 然后将配置内容粘贴进文件中

```Linux
sudo vim /etc/apache2/sites-available/nextcloud.conf
```

配置文件内容:

```xml
<VirtualHost *:80>
DocumentRoot /var/www/nextcloud
ServerName localhost

   Alias /nextcloud "/var/www/nextcloud"

   ErrorLog ${APACHE_LOG_DIR}/nextcloud.error
   CustomLog ${APACHE_LOG_DIR}/nextcloud.access combined

   <Directory /var/www/nextcloud/>
       Require all granted
       Options FollowSymlinks MultiViews
       AllowOverride All

      <IfModule mod_dav.c>
          Dav off
      </IfModule>

   SetEnv HOME /var/www/nextcloud
   SetEnv HTTP_HOME /var/www/nextcloud
   Satisfy Any

  </Directory>

</VirtualHost>
```

启用配置并重启 Apache 服务

```Linux
sudo a2ensite nextcloud.conf
sudo a2enmod rewrite headers env dir mime setenvif ssl
sudo service apache2 restart
```

安装 PHP 插件

```Linux
sudo apt install php-imagick php7.4-common php7.4-mysql php7.4-fpm php7.4-gd php7.4-json php7.4-curl php7.4-zip php7.4-xml php7.4-mbstring php7.4-bz2 php7.4-intl php7.4-bcmath php7.4-gmp
```

重启 Apache 服务

```Linux
sudo service apache2 reload
```

到这一步便可切换到 Windows 端, 在浏览器中输入 `localhost/nextcloud` 进入 nextcloud 的 web 端配置界面, 首次配置需要创建管理员用户名和密码, 在数据存储选择 MySQL/MariaDB 然后用户名和密码填写第一步时创建的用户密码, 端口号填一个未被占用的即可, 例如 localhost:3333

## 5. 配置 nextcloud 文件的存储路径 (Optional)

通常情况下, nextcloud 中上传的用户数据均存放在 `/var/www/nextcloud/data`, 而 wsl 的文件都是在 C 盘, 为了不影响 C 盘后续的使用, 这里给出如何将数据存储位置改成其他盘的方式. (很容易遇到文件夹权限问题)

首先, 打开 nextcloud 的配置文件, 将 `config.php` 中 'datadirectory' 改为自己需要的文件夹, 这里改为 '/mnt/d/nextcloud_data'

```Linux
sudo vim /var/www/nextcloud/config/config.php
# 找到 'datadirectory' => '/var/www/nextcloud/data'一行
```

更改数据文件夹的权限, 不过实际上我改了权限后重新启动服务也没法正常使用 nextcloud, 通过搜索解决方案发现是 Windows 的文件夹的权限不好处理, 因此采用另一种处理方式

```Linux
sudo chmod 0770 /mnt/d/nextcloud_data
sudo chown -R www-data:www-data /mnt/g/data
```

另一种处理方式(推荐): 在 nextcloud 的配置文件中加上一项配置, 不让 nextcloud 检查权限即可

```Linux
sudo vim /var/www/nextcloud/config/config.php
# 添加一行: 'check_data_directory_permissions' => false,
```

在重启 Apache 服务后, 打开 nextcloud 可能会提示 .ocdata 文件的问题, 需要在 wsl 中创建一下

```Linux
cd /mnt/d/nextcloud_data
touch .ocdata
```

至此, nextcloud 的安装配置就基本完成了.

GO AND EXPLORE NEXTCLOUD FOR YOURSELF!
