Connect-VIServer vcenter.conseco.ad

#$$vmhost = get-vmhost -Name "esxzeta01.conseco.com"
$vmhost = get-vmhost -Name "esxbeta10.conseco.com"

Add-VMHostNtpServer -VMHost $vmhost -NtpServer 'ldapcml.conseco.ad'
$NTPService = Get-VmHostService -VMHost $vmhost | Where-Object {$_.key -eq "ntpd"}
Restart-VMHostService -HostService $NTPService

#
#$vmhost | New-VirtualSwitch -Name "vSwitchISCSI" -NumPorts 256
#$vmhost | Get-VirtualSwitch -name "vSwitchISCSI" | Set-VirtualSwitch -Nic vmnic2
#$vmhost | Get-VirtualSwitch -name "vSwitchISCSI" | Set-VirtualSwitch -Nic vmnic6

#$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_2' -VLANID 2			#OK
#$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_3' 		#OK
#$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'iSCSI' -VLANID 600			#OK
#$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'Heartbeat' -VLANID 750		#OK


#	$vmhost | New-VirtualSwitch -Name "vSwitchDMZ" -NumPorts 256
#	$vmhost | Get-VirtualSwitch -name "vSwitchDMZ" | Set-VirtualSwitch -Nic vmnic3


$vmhost | New-VirtualSwitch -Name "vSwitchBO" -NumPorts 256
$vmhost | Get-VirtualSwitch -name "vSwitchBO" | Set-VirtualSwitch -Nic vmnic2
$vmhost | Get-VirtualSwitch -name "vSwitchBO" | Set-VirtualSwitch -Nic vmnic4

$vmhost | Get-VirtualSwitch -Name vSwitchBO | New-VirtualPortGroup -Name 'VLAN_10' -VLANID 10

$vmhost | New-VirtualSwitch -Name "vSwitchFO" -NumPorts 256
$vmhost | Get-VirtualSwitch -name "vSwitchFO" | Set-VirtualSwitch -Nic vmnic1
$vmhost | Get-VirtualSwitch -name "vSwitchFO" | Set-VirtualSwitch -Nic vmnic5
$vmhost | Get-VirtualSwitch -name "vSwitchFO" | Set-VirtualSwitch -Nic vmnic6

$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_190' -VLANID 190
$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_191' -VLANID 191
$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_192' -VLANID 192
$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_193' -VLANID 193
$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_196' -VLANID 196		#OK
$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_197' -VLANID 197		#OK
$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_198' -VLANID 198		#OK
$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_199' -VLANID 199		#OK
$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_200' -VLANID 200		#OK
$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_201'					#OK
$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_202' -VLANID 202		#OK
$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_203' -VLANID 203		#OK
$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_204' -VLANID 204		#OK
$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_205' -VLANID 205		#OK
$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_206' -VLANID 206		#OK
$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_207' -VLANID 207
$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_210' -VLANID 210		#OK
$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_28' -VLANID 83			#OK
$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_83' -VLANID 83			#OK
$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_94' -VLANID 94			#OK
$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_999' -VLANID 999		#OK
$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'iSCSI' -VLANID 600			#OK
$vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'Heartbeat' -VLANID 750		#OK
###
###$vmhost | Get-VirtualSwitch -Name vSwitchBO | New-VirtualPortGroup -Name 'VLAN_10' -VLANID 10

#	$vmhost | Get-VirtualSwitch -Name vSwitchDMZ | New-VirtualPortGroup -Name 'DMZ Vendor'


