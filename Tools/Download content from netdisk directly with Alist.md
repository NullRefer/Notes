# Download content from netdisk directly with Alist

In order to download files from netdisk like baidu, ali, xunlei etc..., but without downloading their apps. Alist can help this.

## what is alist

[A file list program that supports multiple storage, and supports web browsing and webdav, powered by gin and Solidjs.](https://alist.nn.ci/guide/)

In short, use local downloader to download files in your netdisk directly.


## install alist with docker

Run scripts to start alist, replace `/path/to/host` with an actual directory in you pc.

```sh
docker run -d --restart=unless-stopped -v /path/to/host:/opt/alist/data -p 5244:5244 -e PUID=0 -e PGID=0 -e UMASK=022 --name="alist" xhofe/alist:latest
```

After container is running, run scripts to setup password of admin, 

```sh
docker exec -it alist ./alist admin set NEW_PASSWORD
```


## setup your alist

Open browser and go to http://localhost:5444, enter the password you set in last step. 

Click `manage`, you will see the configuration page. Click `storage` and add a new storage. After add the selected driver and configured properly, go to `home` to see the folders that you have in the driver.

### baidu

traditional configuration for baidu netdisk:

- mount path: /baidu
- refresh token: get your refresh token below
>go to [Baidu Refresh Token Callback](https://alist.nn.ci/tool/baidu/callback.html?code=f3a8ac997e130c1df4e94f95808df869) to get refresh token.

### xunlei

traditional configuration for xunlei netdisk:

- mount path: /thunder
- use account: phone number
- password: password of xunlei account
- captcha: after enter your phone number(without +86) and password, click save and reenter configuration, the captcha will show. Add +86 before phone number and click save
