$vmwareSnapin = Add-PSSnapin "VMware.VimAutomation.Core" -ErrorVariable myErr

Connect-VIServer viewvc.conseco.ad

Get-VM -Name "XPCSC001" | Move-VM -Datastore (Get-Datastore "ESXNA410") -RunASync
Get-VM -Name "XPCSC002" | Move-VM -Datastore (Get-Datastore "ESXNA410")
Get-VM -Name "XPCSC003" | Move-VM -Datastore (Get-Datastore "ESXNA410") -RunASync
Get-VM -Name "XPCSC004" | Move-VM -Datastore (Get-Datastore "ESXNA410")
Get-VM -Name "XPCSC005" | Move-VM -Datastore (Get-Datastore "ESXNA410") -RunASync
Get-VM -Name "XPCSC006" | Move-VM -Datastore (Get-Datastore "ESXNA410")
Get-VM -Name "XPCSC007" | Move-VM -Datastore (Get-Datastore "ESXNA410") -RunASync
Get-VM -Name "XPCSC008" | Move-VM -Datastore (Get-Datastore "ESXNA410")
Get-VM -Name "XPCSC009" | Move-VM -Datastore (Get-Datastore "ESXNA410") -RunASync
Get-VM -Name "XPCSC010" | Move-VM -Datastore (Get-Datastore "ESXNA410")
Get-VM -Name "XPCSC011" | Move-VM -Datastore (Get-Datastore "ESXNA410") -RunASync
Get-VM -Name "XPCSC012" | Move-VM -Datastore (Get-Datastore "ESXNA410")
Get-VM -Name "XPCSC013" | Move-VM -Datastore (Get-Datastore "ESXNA410") -RunASync
Get-VM -Name "XPCSC014" | Move-VM -Datastore (Get-Datastore "ESXNA410")
Get-VM -Name "XPCSC015" | Move-VM -Datastore (Get-Datastore "ESXNA410") -RunASync
Get-VM -Name "XPCSC016" | Move-VM -Datastore (Get-Datastore "ESXNA410")
Get-VM -Name "XPCSC017" | Move-VM -Datastore (Get-Datastore "ESXNA410") -RunASync
Get-VM -Name "XPCSC018" | Move-VM -Datastore (Get-Datastore "ESXNA410")
Get-VM -Name "XPCSC019" | Move-VM -Datastore (Get-Datastore "ESXNA410") -RunASync
Get-VM -Name "XPCSC020" | Move-VM -Datastore (Get-Datastore "ESXNA410")
Get-VM -Name "XPCSC021" | Move-VM -Datastore (Get-Datastore "ESXNA410") -RunASync
Get-VM -Name "XPCSC022" | Move-VM -Datastore (Get-Datastore "ESXNA410")
Get-VM -Name "XPCSC023" | Move-VM -Datastore (Get-Datastore "ESXNA410") -RunASync
Get-VM -Name "XPCSC024" | Move-VM -Datastore (Get-Datastore "ESXNA410")
Get-VM -Name "XPCSC025" | Move-VM -Datastore (Get-Datastore "ESXNA410") -RunASync
Get-VM -Name "XPCSC026" | Move-VM -Datastore (Get-Datastore "ESXNA410")
Get-VM -Name "XPCSC027" | Move-VM -Datastore (Get-Datastore "ESXNA410") -RunASync
Get-VM -Name "XPCSC028" | Move-VM -Datastore (Get-Datastore "ESXNA410")
Get-VM -Name "XPCSC029" | Move-VM -Datastore (Get-Datastore "ESXNA410") -RunASync
Get-VM -Name "XPCSC030" | Move-VM -Datastore (Get-Datastore "ESXNA410")
Get-VM -Name "XPCSC031" | Move-VM -Datastore (Get-Datastore "ESXNA410") -RunASync



disconnect-VIServer viewvc.conseco.ad