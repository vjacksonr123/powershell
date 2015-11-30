#$vmwareSnapin = Add-PSSnapin "VMware.VimAutomation.Core" -ErrorVariable myErr

Connect-VIServer vcenter.conseco.ad

get-cluster -name 'ALPHA' | get-vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_211' -VLANID 211
#get-cluster -name 'ALPHA' | get-vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_191' -VLANID 191
#get-cluster -name 'ALPHA' | get-vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_192' -VLANID 192
#get-cluster -name 'ALPHA' | get-vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_193' -VLANID 193
#get-cluster -name 'ALPHA' | get-vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_207' -VLANID 207

get-cluster -name 'BETA' | get-vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_211' -VLANID 211
#get-cluster -name 'BETA' | get-vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_191' -VLANID 191
#get-cluster -name 'BETA' | get-vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_192' -VLANID 192
#get-cluster -name 'BETA' | get-vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_193' -VLANID 193
#get-cluster -name 'BETA' | get-vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_207' -VLANID 207

#get-cluster -name 'DELTA' | get-vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_190' -VLANID 190
#get-cluster -name 'DELTA' | get-vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_191' -VLANID 191
#get-cluster -name 'DELTA' | get-vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_192' -VLANID 192
#get-cluster -name 'DELTA' | get-vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_193' -VLANID 193
#get-cluster -name 'DELTA' | get-vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_207' -VLANID 207

#get-cluster -name 'EPSILON' | get-vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_190' -VLANID 190
#get-cluster -name 'EPSILON' | get-vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_191' -VLANID 191
#get-cluster -name 'EPSILON' | get-vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_192' -VLANID 192
#get-cluster -name 'EPSILON' | get-vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_193' -VLANID 193
#get-cluster -name 'EPSILON' | get-vmhost | Get-VirtualSwitch -Name vSwitchFO | New-VirtualPortGroup -Name 'VLAN_207' -VLANID 207

Disconnect-VIServer -Confirm:$false