# Install nextcloud in server with Docker

## 1. Pull the images

```sh
docker pull nextcloud
docker pull mariadb
```

## 2. Start mysql

```sh
docker run -d --restart=always --name nextcloud-db -e MYSQL_ROOT_PASSWORD=mysqlroot -e MYSQL_USER=nextcloud -e MYSQL_PASSWORD=nextcloud -e MYSQL_DATABASE=nextcloud-db -p 3306:3306 mariadb
```

Use browser to request server_ip:port

## 3. Start nextcloud

```sh
docker run -d --restart=always --name nextcloud --link nextcloud-db:db -p 8001:80 -v nextcloud:/var/www/html nextcloud
```

## 3. Installation

使用浏览器访问 server_ip:port 进行基本配置后即完成
