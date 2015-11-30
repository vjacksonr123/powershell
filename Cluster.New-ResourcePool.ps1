Connect-VIServer vcenter.conseco.ad

$cluster = Get-Cluster 'Kappa'
New-ResourcePool -Location $cluster -Name '0. VIP' -CpuSharesLevel Custom -NumCpuShares '10000' -MemSharesLevel Custom -NumMemShares '409600'
New-ResourcePool -Location $cluster -Name '1. PROD' -CpuSharesLevel High -MemSharesLevel High
New-ResourcePool -Location $cluster -Name '2. UAT' -CpuSharesLevel Custom -NumCpuShares '6000' -MemSharesLevel Custom -NumMemShares '245760'
New-ResourcePool -Location $cluster -Name '3. SIT' -CpuSharesLevel Normal -MemSharesLevel Normal
New-ResourcePool -Location $cluster -Name '4. UT' -CpuSharesLevel Low -MemSharesLevel Low
New-ResourcePool -Location $cluster -Name '5. Sandbox' -CpuSharesLevel Custom -NumCpuShares '1000' -MemSharesLevel Custom -NumMemShares '40960'
New-ResourcePool -Location $cluster -Name "9. Decom'd" -CpuSharesLevel Custom -NumCpuShares '1' -MemSharesLevel Custom -NumMemShares '1'
 
Disconnect-VIServer -Confirm:$false


