Start-Process powershell.exe -ArgumentList ".\run.ps1"
if (Get-Process vlc -ErrorAction SilentlyContinue) {
        Stop-Process -Name "vlc" -Force
    }