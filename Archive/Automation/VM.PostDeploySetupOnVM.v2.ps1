param([string] $BOIPAddr, [string]$VMNIC1MAC, [string]$VMNIC2MAC, [string]$OSVER)


$Shell = New-Object -com shell.application
$NetCons = $Shell.Namespace(0x31)
$NetCons.Items() | 
	where {$_.Name -like '*'} | 
	foreach{$AdapName=$_.Name; get-WmiObject -class Win32_NetworkAdapter | 
			where-Object {$_.NetConnectionID -eq $AdapName} | 
				foreach {$MAC=$_.MacAddress}
					If($MAC -eq $VMNIC1MAC)
					{
						$_.Name="Front Office"
					}
					ElseIf($MAC -eq $VMNIC2MAC)
					{
						$_.Name="Back Office"
					
					#intDNS = objNicConfig.SetDynamicDNSRegistration(False, False)


					}
				}
	
	
$Hostname = ($env:computername).ToLower()
Set-ItemProperty HKLM:\Software\VERITAS\NetBackup\CurrentVersion\Config -name "Clients" -value ($Hostname+"back")
Set-ItemProperty HKLM:\Software\VERITAS\NetBackup\CurrentVersion\Config -name "Client_Name" -value ($Hostname+"back")
Set-ItemProperty HKLM:\Software\VERITAS\NetBackup\CurrentVersion\Config -name "Browser" -value ($Hostname+"back")
Set-ItemProperty HKLM:\Software\VERITAS\NetBackup\CurrentVersion\Config -name "Server" -value "ux14.conseco.com","ux36back","ux37back"

$computer = [ADSI]("WinNT://" + $hostname + ",computer")
$LCLAdmin = $computer.psbase.children.find("administrators")
$LCLPowerUsers = $computer.psbase.children.find("power users")
$LCLRDPUsers = $computer.psbase.children.find("remote desktop users")
$LCLAdmin.Add("WinNT://CONSECO/NTSrv - " + $hostname + " - Administrators")
$LCLAdmin.Add("WinNT://CONSECO/NTSrv - Global - Administrators")
$LCLPowerUsers.Add("WinNT://CONSECO/NTSrv - " + $hostname + " - Power Users")
$LCLRDPUsers.Add("WinNT://CONSECO/NTSrv - " + $hostname + " - RDP Users")
$LCLRDPUsers.Add("WinNT://CONSECO/NT Server RDP Access")

invoke-expression "c:\windows\system32\netsh.exe interface ip set address ""Back Office"" static $BOIPAddr ""255.255.0.0"""
If($OSver -contains "W2K8"){
	invoke-expression "c:\windows\system32\netsh.exe interface ip set dnsservers name=""Back Office"" source=static address=192.168.83.8 register=none"
	invoke-expression "c:\windows\system32\netsh.exe interface ip set dnsservers name=""Back Office"" source=static address=none register=none"
}else{
	invoke-expression "c:\windows\system32\netsh.exe interface ip set dns name=""Back Office"" source=static addr=none register=none"
}
invoke-expression "c:\windows\temp\nvspbind.exe /- ""Back Office"" ms_tcpip"
invoke-expression "c:\windows\temp\nvspbind.exe /d ""Back Office"" ms_tcpip6"
invoke-expression "c:\windows\temp\nvspbind.exe /d ""Back Office"" ms_netbios"
invoke-expression "c:\windows\temp\nvspbind.exe /d ""Back Office"" ms_server"
invoke-expression "c:\windows\temp\nvspbind.exe /d ""Back Office"" ms_pacer"
invoke-expression "c:\windows\temp\nvspbind.exe /d ""Back Office"" ms_wfplwf"
invoke-expression "c:\windows\temp\nvspbind.exe /d ""Back Office"" ms_msclient"
invoke-expression "c:\windows\temp\nvspbind.exe /d ""Back Office"" ms_smb"
invoke-expression "c:\windows\temp\nvspbind.exe /d ""Back Office"" ms_lltdio"
invoke-expression "c:\windows\temp\nvspbind.exe /d ""Back Office"" ms_rspndr"
invoke-expression "c:\windows\temp\nvspbind.exe /d ""Back Office"" ms_pppoe"
invoke-expression "c:\windows\temp\nvspbind.exe /d ""Back Office"" ms_ndisuio"
invoke-expression "c:\windows\temp\nvspbind.exe /d ""Back Office"" ms_wlbs"
invoke-expression "c:\windows\temp\nvspbind.exe /d ""Back Office"" ms_netbt"
