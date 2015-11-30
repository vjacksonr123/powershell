function load-VITK(){
	& {
		$ErrorActionPreference = "silentlycontinue"
		$vmwareSnapin = Add-PSSnapin "VMware.VimAutomation.Core" -ErrorVariable myErr
		
		switch -regex ($myErr[0].Exception.ErrorRecord)
		{
			"VMware.VimAutomation.Core is not installed" {
				"VMware.VimAutomation.Core is not installed" | Write-Log
				Write-Host "Please install the VI Toolkit"
				Write-Host "See http://vmware.com/go/powershell"
				"*** Application stopped ***" | Write-Log
				exit
			}
			"No Windows PowerShell snap-in matches criteria vmware.vimautomation.core." {
				"No Windows PowerShell snap-in matches criteria vmware.vimautomation.core." | Write-Log
				Add-PSSnapin "VMware.VimAutomation.Core"
			}
		}
		if ((Get-VIToolkitVersion).Build -lt $VITKMinimumVersion)
		{
			"VITK version incorrect : " + ( Get-VIToolkitVersion ).Build | Write-Log
			Write-Host "Install the latest version of the VI Toolkit" -foregroundcolor "red"
			Write-Host "See http://vmware.com/go/powershell"
			"*** Application stopped ***" | Write-Log
			exit
		}
	}
}

load-VITK

Connect-VIServer vcenter.conseco.ad

$vm = Get-Content "\\ntadminp01\NTADMIN\PowerShell\ResourceAdds.txt"
Shutdown-VMGuest $vm -Confirm:$false

Start-Sleep -Seconds "300"
Set-VM "NTBIUT01" -MemoryMB "3072" -Confirm:$false
Set-VM "NTCLAIMSPROD" -MemoryMB "3072" -Confirm:$false
Set-VM "NTCAOCUT01" -MemoryMB "3072" -Confirm:$false
Set-VM "NTCAOCP01" -MemoryMB "3072" -Confirm:$false

Start-VM $vm


Disconnect-VIServer -Confirm:$false