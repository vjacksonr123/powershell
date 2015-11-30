connect-viserver ntvcenterp01.conseco.ad
$myCol = @()
ForEach ($VM in (Get-VM))
{	
If($VM.Name -notlike 'LX*')
{
	$MyDetails = "" | select-Object Name, HAL, NumvCPU, Mismatch   
	$MYDetails.Name = $VM.Name
	$Hal = Get-WmiObject -ComputerName $VM.Name -Query "SELECT * FROM Win32_PnPEntity where ClassGuid = '{4D36E966-E325-11CE-BFC1-08002BE10318}'" | Select Name   
	$MYDetails.HAL = $Hal.Name
	$MYDetails.NumvCPU = $VM.NumCPU
	If($VM.NumCPU -eq 1 -and $Hal.Name -like "*multi*")
	{
		Write-Host "VM HAL Mismatch - "$VM.Name" - vCPUs: "$VM.NumCPU" - HAL: "$Hal.Name
		$MyDetails.Mismatch = $true
	}
	Else
	{
		$MyDetails.Mismatch = $false
	}
	$myCol += $MYDetails
}
}
$mycol | select-object | export-csv c:\fromxplpt\procs.csv