Add-PSSnapin "VMware.VimAutomation.Core" -ErrorVariable myErr

$info  = new-object -com outlook.application
$objNamespace = $info.GetNameSpace("MAPI")
$fld = $objNamespace.GetDefaultFolder(6)
$deleted = $objNamespace.GetDefaultFolder(3)
#$colItems  = $fld.Items | where {$_.SenderEmailAddress -eq "/O=CONSECO/OU=CARMEL/CN=RECIPIENTS/CN=CDPDVG"}
$colItems  = $fld.Items | where {$_.SenderEmailAddress -eq "/O=CONSECO/OU=CARMEL/CN=RECIPIENTS/CN=LANJ6P"}
ForEach($Item in $colItems)
{
	If ($Item.Body -like "*1reboot2*")
	{
		 Connect-VIServer -Server "vcenter.conseco.ad"
		 Stop-VM -VM "XPVDI-1" -Confirm:$false
		 Start-VM -VM "XPVDI-1" 
		 $Item.Move($deleted)
	}
	
	
}