#### Startup
$Name = "NTSCCMCPLP01"
$BOIP = "10.141.3.74"
$OSver = "W2K8-R2-SP0-ENT-X64"
####



## Start Run ##
Connect-VIServer vcenter.conseco.ad
$VM = Get-VM $Name
$NICs = Get-NetworkAdapter $VM
$VMNIC1MAC = $NICs[0].MacAddress
$VMNIC2MAC = $NICs[1].MacAddress

#Move Computer Object
move-qadobject ("CONSECO\" + $VM +"$") -NewParentContainer 'CONSECO.AD/Windows Servers'	  
$OSverX = "XP"
		If($OSver -contains "W2K8-R2"){
			If($OSver -contains "X64") { $OSverX = "X64" }
			If($OSver -contains "X86") { $OSverX = "X86" }
		}
		
Copy-VMGuestFile -Source "\\NTADMINP01\NTADMIN\POWERSHELL\AUTOMATION\VM.PostDeploySetupOnVM.ps1" -Destination c:\windows\temp\ -VM $VM -LocalToGuest -HostUser root -HostPassword "delta347#" -GuestUser "conseco\synt_service_account" -GuestPassword "autoup"
Copy-VMGuestFile -Source "\\NTADMINP01\SOFTWARE\Microsoft\NVSPBIND\$OSverX\nvspbind.exe" -Destination c:\windows\temp\ -VM $VM -LocalToGuest -HostUser root -HostPassword "delta347#" -GuestUser "conseco\synt_service_account" -GuestPassword "autoup"


Invoke-VMScript -VM $VM -HostUser root -HostPassword "delta347#" -GuestUser 'CONSECO\SyNT_Service_Account' -GuestPassword 'autoup' -ScriptType Powershell  -ScriptText "Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force" 
Write-Host "MAC1: $VMNIC1MAC"
Write-Host "MAC2: $VMNIC2MAC"
Write-Host "c:\windows\temp\VM.PostDeploySetupOnVM.ps1 $BOIP $VMNIC1MAC $VMNIC2MAC"
Invoke-VMScript -VM $VM -HostUser root -HostPassword "delta347#" -GuestUser 'CONSECO\SyNT_Service_Account' -GuestPassword 'autoup' -ScriptType Powershell  -ScriptText "c:\windows\temp\VM.PostDeploySetupOnVM.ps1 $BOIP $VMNIC1MAC $VMNIC2MAC"




