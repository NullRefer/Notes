# PSReadLine
Import-Module PSReadLine
# Enable Prediction History
Set-PSReadLineOption -PredictionSource History
# Advanced Autocompletion for arrow keys
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# posh promote
Import-Module oh-my-posh
Import-Module posh-git
Set-PoshPrompt -Theme paradox