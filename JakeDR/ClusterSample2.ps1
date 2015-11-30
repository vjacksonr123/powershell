$Clusters = @('NTSQLPCL','NTS5PCL','NTEXPCL','NTLPS5PCL')

ForEach($strCluster in $Clusters){
	$CLUClusters = gwmi MSCluster_Cluster -namespace root\MSCluster -ComputerName $strCluster
	$CLUResourceGroups = gwmi MSCluster_ResourceGroup -namespace root\MSCluster -ComputerName $strCluster 
	$CLUResources = gwmi MSCluster_Resource -namespace root\MSCluster -ComputerName $strCluster 
	$CLUResourceGroupToResouce = gwmi MSCluster_ResourceGroupToResource -namespace root\MSCluster -ComputerName $strCluster 
	
	Write-Host "**** CLUSTER: $strCluster ****"
	ForEach ($RG in $CLUResourceGroups)
	{
		Write-Host "** Resource Group:" $RG.Name "(" $RG.Description ")"
		ForEach ($RG2R in $CLUResourceGroupToResouce)
		{
			$RGa = $RG2R.GroupComponent.Replace("MSCluster_ResourceGroup.Name=","").Replace('"','')
			$R = $RG2R.PartComponent.Replace("MSCluster_Resource.Name=","").Replace('"','')
			If($RGa -eq $RG.Name) {
				ForEach($Resource in $CLUResources)
				{
					If($Resource.Name -eq $R){
						Write-Host "*** Resource:" $Resource.Name "(" $Resource.Type ") - Group:" $RG.Name
						ForEach($RP in $Resource.PrivateProperties){
							If($Resource.Type -eq "Physical Disk"){
								Write-Host "MPVolGuids:" $RP.MPVolGuids
								Write-Host "Signature:" $RP.Signature 
							}ElseIf($Resource.Type -eq "Network Name"){
								Write-Host "Network Name:" $RP.Name
								Write-Host "Require DNS:" $RP.RequireDNS
								Write-Host "Require Kerberos:" $RP.Requirekerberos
							}ElseIf($Resource.Type -eq "IP Address"){
								Write-Host "IP Address:" $RP.Address
								Write-Host "Subnet Mask:" $RP.SubnetMask
								Write-Host "Enable NetBIOS:" $RP.EnableNetBIOS
								Write-Host "NIC:" $RP.Network
							}ElseIf($Resource.Type -eq "File Share"){
								Write-Host "Path:" $RP.Path
								Write-Host "ShareName:" $RP.ShareName
								Write-Host "Share SubDirectories:" $RP.ShareSubDirs
							}Else{
								Write-Host "Unfiltered Resource " $Resource.Type
								$RP
							}
							
						}
					}
				}
				Write-Host "*** `n"
			}
			
		}
		Write-Host "** `n`n`n"
	}
}