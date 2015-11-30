Connect-VIServer view4vc.conseco.ad
Write-Host "WARNING: Automatic update of VMware tools is not fully supported for non-Windows OSs. Manual intervention might be required."
ForEach ($Line in Get-Content "H:\VMware\view4vc-update-tools.txt") { Get-VM -Name $Line | Update-Tools -NoReboot }



Get-con
#Get-VIServer -Server view4vc.conseco.ad
#
#$ToolsCurrent = 8290
#
#Get-VM | %{$vm = $_; Get-View $_.ID} | `
#  %{if($_.config.tools.toolsVersion -eq 0 -or $_.config.tools.toolsVersion -lt $ToolsCurrent) {Update-Tools -VM $vm -NoReboot} }



#
#Get-VIServer -Server view4vc.conseco.ad
#
#$ToolsCurrent = 8290
#
#Get-Content target-vms.txt | %{Get-VM -Name $_} | %{$vm = $_; Get-View $_.ID} | `
#  %{if($_.config.tools.toolsVersion -eq 0 -or $_.config.tools.toolsVersion -lt $ToolsCurrent) {Update-Tools -VM $vm -NoReboot} }
