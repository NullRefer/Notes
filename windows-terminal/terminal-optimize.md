# How to setup Powerline in Windows Terminal (for powershell)

0. install powershell core(pwsh)

install pwsh as dotnet global tool, needs .net installed.

```powershell
dotnet tool install --global PowerShell
```

1. install oh-my-posh(for terminal theme) and posh-git(for git)

Install-Module oh-my-posh -Scope CurrentUser (outdated)
Install-Module posh-git -Scope CurrentUser

2. install oh-my-posh in a new way

Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))

3. enable module when powershell startup
   
ps > notepad $PROFILE

```powershell
Import-Module posh-git
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\paradox.omp.json" | Invoke-Expression
```

if powershell does not allow execute unreliable scripts, open powershell as administrator and execute

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

1. install and enable PSReadLine to enhance terminal

firstly install PSReadLine

```powershell
Install-Module PSReadLine -AllowPrerelease -Scope CurrentUser -Force
```

then enable intelliSense, follow script can be place in $PROFILE

```powershell
Set-PSReadLineOption -PredictionSource History
```