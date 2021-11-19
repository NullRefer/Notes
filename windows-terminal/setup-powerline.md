# How to setup Powerline in Windows Terminal (for powershell)

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