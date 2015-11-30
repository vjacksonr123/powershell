Connect-VIServer vcenter.conseco.ad

get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'Heartbeat' -VLANID 750
#get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'iSCSI' -VLANID 600
#get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_190' -VLANID 190
#get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_191' -VLANID 191
#get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_192' -VLANID 192
#get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_193' -VLANID 193
#get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_196' -VLANID 196
#get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_197' -VLANID 197
#get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_198' -VLANID 198
#get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_199' -VLANID 199
#get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_200' -VLANID 200
#get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_201' -VLANID 201
#get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_202' -VLANID 202
#get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_203' -VLANID 203
#get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_204' -VLANID 204
#get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_205' -VLANID 205
#get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_206' -VLANID 206
#get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_207' -VLANID 207
#get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_210' -VLANID 210
#get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_211' -VLANID 211
#get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_220' -VLANID 220
#get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_28' -VLANID 28
#get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_83' -VLANID 83
#get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_94' -VLANID 94
#get-cluster -name 'Delta' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_999' -VLANID 999


Disconnect-VIServer -Confirm:$false


#get-cluster -name 'EPSILON' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_83' -VLANID 83
#get-cluster -name 'EPSILON' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_94' -VLANID 94
#get-cluster -name 'EPSILON' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_196' -VLANID 196
#get-cluster -name 'EPSILON' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_197' -VLANID 197
#get-cluster -name 'EPSILON' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_198' -VLANID 198
#get-cluster -name 'EPSILON' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_199' -VLANID 199
#get-cluster -name 'EPSILON' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_201'
#get-cluster -name 'EPSILON' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_206' -VLANID 206
#get-cluster -name 'EPSILON' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_210' -VLANID 210
#get-cluster -name 'EPSILON' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'VLAN_999' -VLANID 999
#get-cluster -name 'EPSILON' | get-vmhost | Get-VirtualSwitch -Name vSwitch0 | New-VirtualPortGroup -Name 'iSCSI' -VLANID 600
#

