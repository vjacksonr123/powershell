$vmwareSnapin = Add-PSSnapin "VMware.VimAutomation.Core" -ErrorVariable myErr

Connect-VIServer vcenter.conseco.ad

#Get-VM -Name "LXP09" | Move-VM -Datastore (Get-Datastore "ESXNA426")  
#Get-VM -Name "LXWSP03" | Move-VM -Datastore (Get-Datastore "ESXNA426")  
#Get-VM -Name "LXWSP04" | Move-VM -Datastore (Get-Datastore "ESXNA426")  
#Get-VM -Name "NTBIP02" | Move-VM -Datastore (Get-Datastore "ESXNA426")  
#Get-VM -Name "NTBIP03" | Move-VM -Datastore (Get-Datastore "ESXNA426")  
#Get-VM -Name "NTCTXCONSECO4" | Move-VM -Datastore (Get-Datastore "ESXNA426")  
#Get-VM -Name "NTSBP01" | Move-VM -Datastore (Get-Datastore "ESXNA426")  
#Get-VM -Name "NTTOOLSPROD3" | Move-VM -Datastore (Get-Datastore "ESXNA426")  
#Get-VM -Name "NTVASULP01" | Move-VM -Datastore (Get-Datastore "ESXNA426")  
#Get-VM -Name "NTVBRKP01" | Move-VM -Datastore (Get-Datastore "ESXNA426")  
#Get-VM -Name "NTVSUMP01" | Move-VM -Datastore (Get-Datastore "ESXNA426")  
#Get-VM -Name "NTWINGSP02" | Move-VM -Datastore (Get-Datastore "ESXNA426")  
#Get-VM -Name "NTWSDMP02" | Move-VM -Datastore (Get-Datastore "ESXNA426")  
#Get-VM -Name "AUSTINTEST" | Move-VM -Datastore (Get-Datastore "ESXNA423")  
#Get-VM -Name "NTAUTOSYSP01" | Move-VM -Datastore (Get-Datastore "ESXNA423")  
#Get-VM -Name "NTBDVIEW1" | Move-VM -Datastore (Get-Datastore "ESXNA423")  
#Get-VM -Name "NTBIPROD2" | Move-VM -Datastore (Get-Datastore "ESXNA423")  
#Get-VM -Name "NTBIVMPROD" | Move-VM -Datastore (Get-Datastore "ESXNA423")  
#Get-VM -Name "NTCNCWEB01" | Move-VM -Datastore (Get-Datastore "ESXNA423")  
#Get-VM -Name "NTCNCWEB06" | Move-VM -Datastore (Get-Datastore "ESXNA423")  
#Get-VM -Name "NTECORAP01" | Move-VM -Datastore (Get-Datastore "ESXNA423")  
#Get-VM -Name "NTHRPROD" | Move-VM -Datastore (Get-Datastore "ESXNA423")  
#Get-VM -Name "NTIACTXP01" | Move-VM -Datastore (Get-Datastore "ESXNA423")  
#Get-VM -Name "NTSHARE2" | Move-VM -Datastore (Get-Datastore "ESXNA423")  
#Get-VM -Name "NTTOOLS3" | Move-VM -Datastore (Get-Datastore "ESXNA423")  
#Get-VM -Name "NTTRECSCP01" | Move-VM -Datastore (Get-Datastore "ESXNA423")  
#Get-VM -Name "NTWEBSPHEREPROD" | Move-VM -Datastore (Get-Datastore "ESXNA423")  
#Get-VM -Name "XPDPCLASSPROD2" | Move-VM -Datastore (Get-Datastore "ESXNA423")  
#Get-VM -Name "XPDPPROD4" | Move-VM -Datastore (Get-Datastore "ESXNA423")  
#Get-VM -Name "XPDPPROD5" | Move-VM -Datastore (Get-Datastore "ESXNA423")  
#Get-VM -Name "XPIAIMGENHPROD2" | Move-VM -Datastore (Get-Datastore "ESXNA423")  
#Get-VM -Name "BLCDCCMLP01" | Move-VM -Datastore (Get-Datastore "ESXNA422")  
#Get-VM -Name "BLCDCCMLP02" | Move-VM -Datastore (Get-Datastore "ESXNA422")  
#Get-VM -Name "BLCDCCMLP03" | Move-VM -Datastore (Get-Datastore "ESXNA422")  
#Get-VM -Name "BLCDCCMLP04" | Move-VM -Datastore (Get-Datastore "ESXNA422")  
#Get-VM -Name "CPLDCCMLP01" | Move-VM -Datastore (Get-Datastore "ESXNA422")  
#Get-VM -Name "CPLDCCMLP02" | Move-VM -Datastore (Get-Datastore "ESXNA422")  
#Get-VM -Name "CPLDCCMLP03" | Move-VM -Datastore (Get-Datastore "ESXNA422")  
#Get-VM -Name "CPLDCCMLP04" | Move-VM -Datastore (Get-Datastore "ESXNA422")  
#Get-VM -Name "EDA-v0.90" | Move-VM -Datastore (Get-Datastore "ESXNA422")  
#Get-VM -Name "NTACMAPPSPROD" | Move-VM -Datastore (Get-Datastore "ESXNA422")  

Get-VM -Name "NTAUTOSYSP03" | Move-VM -Datastore (Get-Datastore "ESXNA422") -RunAsync  
Get-VM -Name "NTBDVIEW3" | Move-VM -Datastore (Get-Datastore "ESXNA422") -RunAsync 
Get-VM -Name "NTBFWEBUAT01" | Move-VM -Datastore (Get-Datastore "ESXNA422")  
Get-VM -Name "NTDCCMLP03" | Move-VM -Datastore (Get-Datastore "ESXNA422") -RunAsync 
Get-VM -Name "NTDCCMLP04" | Move-VM -Datastore (Get-Datastore "ESXNA422") -RunAsync 
Get-VM -Name "NTEXSPAMWEBP01" | Move-VM -Datastore (Get-Datastore "ESXNA422")  
Get-VM -Name "NTINTRWSPROD2" | Move-VM -Datastore (Get-Datastore "ESXNA422") -RunAsync 
Get-VM -Name "NTTERMSRV1" | Move-VM -Datastore (Get-Datastore "ESXNA422") -RunAsync 
Get-VM -Name "NTTOOLS4" | Move-VM -Datastore (Get-Datastore "ESXNA422")  
Get-VM -Name "NTTOOLSPROD2" | Move-VM -Datastore (Get-Datastore "ESXNA422") -RunAsync 
Get-VM -Name "NTWEBRPT1" | Move-VM -Datastore (Get-Datastore "ESXNA422") -RunAsync 
Get-VM -Name "XPDPPROD6" | Move-VM -Datastore (Get-Datastore "ESXNA422")  
Get-VM -Name "NTCAWYCUAT01" | Move-VM -Datastore (Get-Datastore "ESXNA421") -RunAsync 
Get-VM -Name "NTCNCWEB05" | Move-VM -Datastore (Get-Datastore "ESXNA421") -RunAsync 
Get-VM -Name "NTPOT2PP01" | Move-VM -Datastore (Get-Datastore "ESXNA421")  
Get-VM -Name "NTPRINTP02" | Move-VM -Datastore (Get-Datastore "ESXNA421")  -RunAsync 
Get-VM -Name "NTQUESTPROD2" | Move-VM -Datastore (Get-Datastore "ESXNA421")  -RunAsync 
Get-VM -Name "NTTOOLSPROD4" | Move-VM -Datastore (Get-Datastore "ESXNA421")  
Get-VM -Name "NTLIFEPROPROD" | Move-VM -Datastore (Get-Datastore "ESXNA421")  
Get-VM -Name "NTTRECSA" | Move-VM -Datastore (Get-Datastore "ESXNA421")  -RunAsync 
Get-VM -Name "NTTRECSB" | Move-VM -Datastore (Get-Datastore "ESXNA421")  -RunAsync 
Get-VM -Name "NTTRECSC" | Move-VM -Datastore (Get-Datastore "ESXNA421")  
Get-VM -Name "NTTRECSI" | Move-VM -Datastore (Get-Datastore "ESXNA421")  -RunAsync 
Get-VM -Name "NTTRECSP" | Move-VM -Datastore (Get-Datastore "ESXNA421")  -RunAsync 
Get-VM -Name "NTTRECSS" | Move-VM -Datastore (Get-Datastore "ESXNA421")  
Get-VM -Name "NTWBPROD" | Move-VM -Datastore (Get-Datastore "ESXNA421")  -RunAsync 
Get-VM -Name "NTWEBDPLP01" | Move-VM -Datastore (Get-Datastore "ESXNA421")  -RunAsync 
Get-VM -Name "NTWEBPORTALPRD2" | Move-VM -Datastore (Get-Datastore "ESXNA421")  
Get-VM -Name "NTWEBTRENDSP01" | Move-VM -Datastore (Get-Datastore "ESXNA421")  -RunAsync 
Get-VM -Name "NTAUTOSYSP02" | Move-VM -Datastore (Get-Datastore "ESXNA420")
Get-VM -Name "NTADMINP01" | Move-VM -Datastore (Get-Datastore "ESXNA420")  -RunAsync 
Get-VM -Name "NTBIP04" | Move-VM -Datastore (Get-Datastore "ESXNA420")  
Get-VM -Name "NTBIP05" | Move-VM -Datastore (Get-Datastore "ESXNA420")  
Get-VM -Name "NTBIPROD1" | Move-VM -Datastore (Get-Datastore "ESXNA420")   -RunAsync 
Get-VM -Name "NTBIPROD3" | Move-VM -Datastore (Get-Datastore "ESXNA420")   -RunAsync 
Get-VM -Name "NTBIPROD5" | Move-VM -Datastore (Get-Datastore "ESXNA420")  
Get-VM -Name "NTCNTAPP1PROD" | Move-VM -Datastore (Get-Datastore "ESXNA420")   -RunAsync 
Get-VM -Name "NTCTXCONSECO8" | Move-VM -Datastore (Get-Datastore "ESXNA420")   -RunAsync 
Get-VM -Name "NTTACCP01" | Move-VM -Datastore (Get-Datastore "ESXNA420")  
Get-VM -Name "NTXTRACTP01" | Move-VM -Datastore (Get-Datastore "ESXNA420")  -RunAsync 
Get-VM -Name "vCenter Mobile Access" | Move-VM -Datastore (Get-Datastore "ESXNA420")  -RunAsync 
Get-VM -Name "NTVASNLTCP01" | Move-VM -Datastore (Get-Datastore "ESXNA420")   
Get-VM -Name "BLCSCHED" | Move-VM -Datastore (Get-Datastore "ESXNA412")  -RunAsync
Get-VM -Name "NTCAMRAPROD" | Move-VM -Datastore (Get-Datastore "ESXNA412")  -RunAsync
Get-VM -Name "NTFNICCP01" | Move-VM -Datastore (Get-Datastore "ESXNA412")  
Get-VM -Name "NTHYPPROD" | Move-VM -Datastore (Get-Datastore "ESXNA412")  -RunAsync
Get-VM -Name "NTTRECSCS_PROD" | Move-VM -Datastore (Get-Datastore "ESXNA412")  -RunAsync
Get-VM -Name "NTVASNLTCP02" | Move-VM -Datastore (Get-Datastore "ESXNA412")  
Get-VM -Name "NTWINGSPROD" | Move-VM -Datastore (Get-Datastore "ESXNA412")  -RunAsync
Get-VM -Name "BLCDFS01" | Move-VM -Datastore (Get-Datastore "ESXNA411")  
Get-VM -Name "NTAS2000" | Move-VM -Datastore (Get-Datastore "ESXNA411")  -RunAsync
Get-VM -Name "NTBIP01" | Move-VM -Datastore (Get-Datastore "ESXNA411")  
Get-VM -Name "NTBIPROD4" | Move-VM -Datastore (Get-Datastore "ESXNA411")  -RunAsync
Get-VM -Name "NTCRYSTAL" | Move-VM -Datastore (Get-Datastore "ESXNA411")  -RunAsync
Get-VM -Name "NTDFSP01" | Move-VM -Datastore (Get-Datastore "ESXNA411")  
Get-VM -Name "NTINTRWSPROD1" | Move-VM -Datastore (Get-Datastore "ESXNA411")  
Get-VM -Name "NTKOVISPROD1" | Move-VM -Datastore (Get-Datastore "ESXNA411")  
Get-VM -Name "NTLMSPROD" | Move-VM -Datastore (Get-Datastore "ESXNA411")  
Get-VM -Name "NTPRINTP01" | Move-VM -Datastore (Get-Datastore "ESXNA411")  
Get-VM -Name "NTTRACKERP01" | Move-VM -Datastore (Get-Datastore "ESXNA411")  
Get-VM -Name "NTWSUSP02" | Move-VM -Datastore (Get-Datastore "ESXNA411")  -RunAsync
Get-VM -Name "vSphere Management Assistant" | Move-VM -Datastore (Get-Datastore "ESXNA411")  -RunAsync
Get-VM -Name "XPDPCLASSPROD1" | Move-VM -Datastore (Get-Datastore "ESXNA411")  -RunAsync
Get-VM -Name "XPDPEXTRACPROD2" | Move-VM -Datastore (Get-Datastore "ESXNA411")  -RunAsync
Get-VM -Name "XPDPEXTRACPROD3" | Move-VM -Datastore (Get-Datastore "ESXNA411")  
Get-VM -Name "XPDPPROD3" | Move-VM -Datastore (Get-Datastore "ESXNA411")  
Get-VM -Name "XPDPPROD8" | Move-VM -Datastore (Get-Datastore "ESXNA411")  -RunAsync
Get-VM -Name "XPDPPROD9" | Move-VM -Datastore (Get-Datastore "ESXNA411")  -RunAsync


disconnect-VIServer vcenter.conseco.ad