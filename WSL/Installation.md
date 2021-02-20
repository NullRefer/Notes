# Windows Subsystem for Linux

## 1. 什么是 WSL

WSL 是 Windows Subsystem for Linux 的简称, 可以让用户在 Windows 统中运行 Linux 系统环境 - 包括大多数命令行工具、实用工具和应用程序 - 且不会产生传统虚拟机或双启动设置开销.

- 在 Microsoft Store 中选择你偏好的 GNU/Linux 发行版
- 运行常用的命令行软件工具 (例如 `grep`, `sed`, `awk`) 或其他ELF-64二进制文件
- 运行 Bash shell 脚本和 GNU/Linux 命令行应用程序，包括：
  - 工具: vim, emacs, tmux
  - 语言: NodeJS, Javascript, Python, Ruby, C/C++, C#与F#, Rust, GO等
  - 服务: SSHD, MySQL, Apache, lighttpd, MongoDB, PostgreSQL
- 使用自己的 GNU/Linux 分发包管理器安装其他软件
- 使用类似于 Unix 的命令行 shell 调用 Windows 应用程序
- 在 Windows 上调用 GNU/Linux 应用程序

## 2. 什么是 WSL2

WSL 2 是适用于 Linux 的 Windows 子系统体系结构的一个新版本，它支持适用于 Linux 的 Windows 子系统在 Windows 上运行 ELF64 Linux 二进制文件。 它的主要目标是提高文件系统性能，以及添加完全的系统调用兼容性。

这一新的体系结构改变了这些 Linux 二进制文件与Windows 和计算机硬件进行交互的方式，但仍然提供与 WSL 1（当前广泛可用的版本）中相同的用户体验。

单个 Linux 分发版可以在 WSL 1 或 WSL 2 体系结构中运行。 每个分发版可随时升级或降级，并且你可以并行运行 WSL 1 和 WSL 2 分发版。 WSL 2 使用全新的体系结构，该体系结构受益于运行真正的 Linux 内核。

WSL1 和 WSL2 的比较:
|                      功能                      | WSL1  | WSL2  |
| :--------------------------------------------: | :---: | :---: |
|          Windows 和 Linux 之间的集成           |   √   |   √   |
|                   启动时间短                   |   √   |   √   |
|                 占用的资源量少                 |   √   |   √   |
| 可以与当前版本的 VMware 和 VirtualBox 一起运行 |   √   |   √   |
|                    托管 VM                     |   ×   |   √   |
|               完整的 Linux 内核                |   ×   |   √   |
|              完全的系统调用兼容性              |   ×   |   √   |
|              跨 OS 文件系统的性能              |   √   |   ×   |

## 3. WSL 的安装

### 1. 启用 Windows Subsystem for Linux 功能

以管理员方式启动 PowerShell, 然后运行下面的命令:

``` PowerShell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

另一种方式则是转到 控制面板 - 程序 - 打开或关闭Windows功能, 在列表中找到 Windows Subsystem for Linux 一项启用即可

![enable feature](/src/pic/control%20panel%20enable%20feature.png)

### 2. 检查运行 WSL2 的要求

如果要使用 WSL2, 需要Windows 10 1903及以上的版本, 内部版本18362+. 可以通过 `win` + `R` 运行 `winver` 查看系统版本信息.

### 3. 启用虚拟机功能

以管理员方式启动 PowerShell, 然后运行下面的命令:

``` PowerShell
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

### 4. 下载 Linux 内核更新包

下载[适用于 x64 计算机的 WSL2 Linux 内核更新包](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi), 运行并安装

### 5. 将 WSL2 设为默认版本

启动 PowerShell, 然后运行下面的命令:

``` PowerShell
wsl --set-default-version 2
```

### 6. 安装所选的 Linux 分发版

打开 Microsoft Store, 从中搜索个人偏好的 Linux 分发版, 例如 Ubuntu, Debian等. 安装完成后打开即可为当前电脑安装对应的 Linux 分发版.

>第一次打开 Linux 系统时, 系统会要求你输入用户名和密码, 该用户名和密码为普通用户, root的用户密码是随机生成的, 可以在创建完成用户名和密码后, 输入 `sudo passwd` 更改 root 用户的密码, `sudo passwd` 命令第一次提示输入的为当前用户的用户密码.

安装全部完成后, 可以使用最新的 Windows Terminal 集成新的 Tab 以快速启动 WSL.
