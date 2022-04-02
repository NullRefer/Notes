# How to setup Powerline in Windows Terminal (for powershell)

0. install powershell core(pwsh)

install pwsh as dotnet global tool, needs .net installed.

```powershell
dotnet tool install --global PowerShell
```

1. install oh-my-posh(for terminal theme) and posh-git(for git)

Install-Module oh-my-posh -Scope CurrentUser
Install-Module posh-git -Scope CurrentUser

2. enable module when powershell startup
   
ps > notepad $PROFILE

```powershell
Import-Module oh-my-posh
Import-Module posh-git
Set-PoshPrompt -Theme paradox
```

if powershell does not allow execute unreliable scripts, open powershell as administrator and execute

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

3. install and enable PSReadLine to enhance terminal

firstly install PSReadLine

```powershell
Install-Module PSReadLine -AllowPrerelease -Scope CurrentUser -Force
```

then enable intelliSense, follow script can be place in $PROFILE

```powershell
Set-PSReadLineOption -PredictionSource History
```