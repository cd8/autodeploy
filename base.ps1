<#
    .SYNOPSIS
        Downloads and configures .Net Core Music Store application sample across IIS and Azure SQL DB.
#>

# Param (
#     [string]$user,
#     [string]$password,
#     [string]$sqlserver
# )

# Firewall
#netsh advfirewall firewall add rule name="http" dir=in action=allow protocol=TCP localport=80

# Folders
New-Item -ItemType Directory c:\tmp

# Install iis
Install-WindowsFeature -Name Web-Default-Doc,Web-Dir-Browsing,Web-Http-Errors,Web-Static-Content,Web-Http-Logging,Web-Stat-Compression,Web-Filtering,Web-Windows-Auth,Web-Net-Ext,Web-Net-Ext45,Web-Asp-Net,Web-Asp-Net45,Web-ISAPI-Ext,Web-ISAPI-Filter,Web-WebSockets,Web-Mgmt-Console,Web-Scripting-Tools,Web-Mgmt-Service,NET-Framework-Core,NET-HTTP-Activation,NET-Framework-45-Core,NET-Framework-45-ASPNET,NET-WCF-HTTP-Activation45,NET-WCF-TCP-PortSharing45,WAS-Process-Model,WAS-NET-Environment,WAS-Config-APIs

 
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WebManagement\Server -Name WindowsAuthenticationEnabled -Value 1 -PropertyType DWORD -Force
Stop-Service wmsvc
Set-Service wmsvc -startuptype "automatic"
Start-Service wmsvc
 

# Install dot.net core sdk
# Invoke-WebRequest http://go.microsoft.com/fwlink/?LinkID=615460 -outfile c:\temp\vc_redistx64.exe
# Start-Process c:\temp\vc_redistx64.exe -ArgumentList '/quiet' -Wait
# Invoke-WebRequest https://go.microsoft.com/fwlink/?LinkID=809122 -outfile c:\temp\DotNetCore.1.0.0-SDK.Preview2-x64.exe
# Start-Process c:\temp\DotNetCore.1.0.0-SDK.Preview2-x64.exe -ArgumentList '/quiet' -Wait
# Invoke-WebRequest https://go.microsoft.com/fwlink/?LinkId=817246 -outfile c:\temp\DotNetCore.WindowsHosting.exe
# Start-Process c:\temp\DotNetCore.WindowsHosting.exe -ArgumentList '/quiet' -Wait
Invoke-WebRequest http://download.microsoft.com/download/0/1/D/01DC28EA-638C-4A22-A57B-4CEF97755C6C/WebDeploy_amd64_en-US.msi -outfile c:\tmp\WebDeploy_amd64_en-US.msi
Start-Process c:\tmp\WebDeploy_amd64_en-US.msi /passive ADDLOCAL=ALL /norestart /l* C:\tmp\WebDeploy_amd64_en.txt -Wait

Invoke-WebRequest http://go.microsoft.com/fwlink/?LinkID=239644 -outfile c:\tmp\SQLSysClrTypes.msi
Start-Process c:\tmp\SQLSysClrTypes.msi /passive ADDLOCAL=ALL /norestart /l* C:\tmp\SQLSysClrTypesLog.txt -Wait

Invoke-WebRequest http://go.microsoft.com/fwlink/?LinkID=239659 -outfile c:\tmp\SharedManagementObjects.msi
Start-Process c:\tmp\SharedManagementObjects.msi /passive ADDLOCAL=ALL /norestart /l* C:\tmp\SharedManagementObjects.txt -Wait



# Download music app
# Invoke-WebRequest  https://github.com/Microsoft/dotnet-core-sample-templates/raw/master/dotnet-core-music-windows/music-app/music-store-azure-demo-pub.zip -OutFile c:\temp\musicstore.zip
# Expand-Archive C:\temp\musicstore.zip c:\music

# Azure SQL connection sting in environment variable
# [Environment]::SetEnvironmentVariable("Data:DefaultConnection:ConnectionString", "Server=$sqlserver;Database=MusicStore;Integrated Security=False;User Id=$user;Password=$password;MultipleActiveResultSets=True;Connect Timeout=30",[EnvironmentVariableTarget]::Machine)

# Pre-create database
# $env:Data:DefaultConnection:ConnectionString = "Server=$sqlserver;Database=MusicStore;Integrated Security=False;User Id=$user;Password=$password;MultipleActiveResultSets=True;Connect Timeout=30"
# Start-Process 'C:\Program Files\dotnet\dotnet.exe' -ArgumentList 'c:\music\MusicStore.dll'

# Configure iis
Remove-WebSite -Name "Default Web Site"
Set-ItemProperty IIS:\AppPools\DefaultAppPool\ managedRuntimeVersion ""
# New-Website -Name "MusicStore" -Port 80 -PhysicalPath C:\music\ -ApplicationPool DefaultAppPool
# & iisreset
