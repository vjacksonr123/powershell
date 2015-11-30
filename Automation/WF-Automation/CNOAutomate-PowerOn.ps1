param([string] $CNOAutomateID)
# CONSECO - Windows Server Administration 
# * Workflow Automation - Extends the Non-System Disk *
# ** Last Modified: 2010/02/25 @ 16:19 by LANJ6P (Pawlak, Jakub P)
# ******************************************************************

. \\ntadminp01\ntadmin\PowerShell\Automation\WF-Automation\CNOAutomateFN.ps1

load-VITK
Connect-VIServer vcenter.conseco.ad
PowerOn $CNOAutomateID
Disconnect-VIServer vcenter.conseco.ad -confirm:$false
Get-Host