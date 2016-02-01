#region Script Settings
#<ScriptSettings xmlns="http://tempuri.org/ScriptSettings.xsd">
#  <ScriptPackager>
#    <process>powershell.exe</process>
#    <arguments />
#    <extractdir />
#    <files />
#    <usedefaulticon>true</usedefaulticon>
#    <showinsystray>false</showinsystray>
#    <altcreds>false</altcreds>
#    <efs>true</efs>
#    <ntfs>true</ntfs>
#    <local>false</local>
#    <abortonfail>true</abortonfail>
#    <product />
#    <version>1.0.0.1</version>
#    <versionstring />
#    <comments />
#    <includeinterpreter>false</includeinterpreter>
#    <forcecomregistration>false</forcecomregistration>
#    <consolemode>false</consolemode>
#    <EnableChangelog>false</EnableChangelog>
#    <AutoBackup>false</AutoBackup>
#    <snapinforce>false</snapinforce>
#    <snapinshowprogress>false</snapinshowprogress>
#    <snapinautoadd>0</snapinautoadd>
#    <snapinpermanentpath />
#  </ScriptPackager>
#</ScriptSettings>
#endregion

$VMDSgui = "DeployVMGUI.ps1"
$VMDSfn = "DeployVMfunction.ps1"
$VMDSin = "DeployVMinitialform.ps1"
$VMDSprg = "DeployVMprogress.ps1"

$VMDSincludes = ($VMDSgui, $VMDSfn, $VMDSin, $VMDSprg)

$VMDSincludes | % {
	if (Test-Path $_)
	{
		. ./$_
		Write-Host $_ Loaded
	}
	else
	{
		Write-Host "Essential file missing." -foregroundcolor "red"
		Write-Host "Make sure file '$_' is present in the current directory"
		exit
	}
}
[System.Windows.Forms.Application]::EnableVisualStyles()
#[System.Windows.Forms.Application]::Run($frmVDSstart)
load-VITK
Connect-VIServer -Server "vcenter.conseco.ad"
$cbxVMFolder.DataSource = Get-Folder | Sort-Object -property Name
$cbxVMFolder.SelectedIndex = -1
$cbxVMCluster.DataSource = Get-Cluster | Sort-Object -property Name
$cbxVMCluster.SelectedIndex = -1
$cbxVMHost.Enabled = 0
$cbxVMRPool.Enabled = 0
$cbxVMDatastore.Enabled = 0
[System.Windows.Forms.Application]::Run($frmVMDS)
Disconnect-VIServer -Server $defaultviserver -Confirm:$false