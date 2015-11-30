$strComputerName = 'NTS5P04'
$CLUClusters = gwmi MSCluster_Cluster -namespace root\MSCluster -ComputerName $strComputerName
$strCluster = $CLUCluster.Name
$CLUGroups = gwmi MSCluster_ClusterToResourceGroup -Namespace root\MSCluster -ComputerName $strComputerName












Write-Host "Cluster: " $strCluster
Write-Host "Groups: " $CLUGroups