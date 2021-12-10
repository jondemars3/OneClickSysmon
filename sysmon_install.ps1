#check if user is running as admin, and if not - present a UAC prompt
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

'One-Click Sysmon'

# download Sysmon from the Microsoft website
$sysmon_source = "https://download.sysinternals.com/files/Sysmon.zip"
$sysmon_zipped = "C:\Sysmon.zip"
$sysmon_unzipped = "C:\Sysmon"
Invoke-WebRequest -Uri $sysmon_source -OutFile $sysmon_zipped
Expand-Archive -LiteralPath $sysmon_zipped -DestinationPath $sysmon_unzipped
Remove-Item $sysmon_zipped

#download Sysmon config from Github
$config_source = "https://github.com/SwiftOnSecurity/sysmon-config/archive/refs/heads/master.zip"
$config_zipped = "C:\Sysmon\sysmonconfig-export.zip"
$config_unzipped = "C:\Sysmon\sysmonconfig"
Invoke-WebRequest -Uri $config_source -OutFile $config_zipped
Expand-Archive -LiteralPath $config_zipped -DestinationPath $config_unzipped
Remove-Item $config_zipped

#extract the files from the subfolder in order to neaten the appearance
$files = Get-ChildItem -Path $config_unzipped\*\*
$files | Move-Item -Destination $config_unzipped
Remove-Item "C:\Sysmon\sysmonconfig\sysmon-config-master"

#start Sysmon
Set-Location -LiteralPath $config_unzipped -PassThru
..\sysmon64.exe -accepteula -i sysmonconfig-export.xml
