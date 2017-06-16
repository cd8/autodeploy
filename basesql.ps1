#setup sql to accept sql auth
param([string]$Password)

Invoke-WebRequest https://raw.githubusercontent.com/cd8/autodeploy/master/Reset-SqlAdmin.psm1 -outfile C:\tmp\Reset-SqlAdmin.psm1
import-module C:\tmp\Reset-SqlAdmin.psm1
Reset-SqlAdmin -SqlServer . -Password $Password

# Firewall
netsh advfirewall firewall add rule name="tcp" dir=in action=allow protocol=TCP localport=1433
