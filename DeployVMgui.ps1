#region Script Settings
#<ScriptSettings xmlns="http://tempuri.org/ScriptSettings.xsd">
#  <ScriptPackager>
#    <process>powershell.exe</process>
#    <arguments />
#    <extractdir>%TEMP%</extractdir>
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

#region ScriptForm Designer (Created with Admin Script Editor trial edition)

#region Constructor

[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

#endregion

#region Post-Constructor Custom Code

#endregion

#region Form Creation
#Warning: It is recommended that changes inside this region be handled using the ScriptForm Designer.
#When working with the ScriptForm designer this region and any changes within may be overwritten.
#~~< frmDeploy >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$frmDeploy = New-Object System.Windows.Forms.Form
$frmDeploy.ClientSize = New-Object System.Drawing.Size(301, 480)
$frmDeploy.Text = "VMDeploy - Conseco Services,LLC"
#~~< btnDeploy >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$btnDeploy = New-Object System.Windows.Forms.Button
$btnDeploy.Location = New-Object System.Drawing.Point(18, 445)
$btnDeploy.Size = New-Object System.Drawing.Size(264, 23)
$btnDeploy.TabIndex = 11
$btnDeploy.Text = "* Deploy VM *"
$btnDeploy.UseVisualStyleBackColor = $true
$btnDeploy.add_Click({BtnDeployClick($btnDeploy)})
#~~< GroupBox2 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$GroupBox2 = New-Object System.Windows.Forms.GroupBox
$GroupBox2.Location = New-Object System.Drawing.Point(12, 91)
$GroupBox2.Size = New-Object System.Drawing.Size(276, 345)
$GroupBox2.TabIndex = 10
$GroupBox2.TabStop = $false
$GroupBox2.Text = "VM to Deploy"
#~~< ComboBox1 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$ComboBox1 = New-Object System.Windows.Forms.ComboBox
$ComboBox1.FormattingEnabled = $true
$ComboBox1.Location = New-Object System.Drawing.Point(117, 122)
$ComboBox1.Size = New-Object System.Drawing.Size(121, 21)
$ComboBox1.TabIndex = 7
$ComboBox1.Text = ""
$ComboBox1.Items.AddRange([System.Object[]](@("1", "2", "4")))
#~~< Label1 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label1 = New-Object System.Windows.Forms.Label
$Label1.Location = New-Object System.Drawing.Point(6, 16)
$Label1.Size = New-Object System.Drawing.Size(100, 20)
$Label1.TabIndex = 1
$Label1.Text = "VM Name:"
$Label1.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
#~~< cbxPortGroup >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$cbxPortGroup = New-Object System.Windows.Forms.ComboBox
$cbxPortGroup.FormattingEnabled = $true
$cbxPortGroup.Location = New-Object System.Drawing.Point(149, 310)
$cbxPortGroup.Size = New-Object System.Drawing.Size(121, 21)
$cbxPortGroup.TabIndex = 7
$cbxPortGroup.Text = ""
$cbxPortGroup.add_SelectedIndexChanged({CbxPortGroupSelectedIndexChanged($cbxPortGroup)})
#~~< cbxResourcePool >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$cbxResourcePool = New-Object System.Windows.Forms.ComboBox
$cbxResourcePool.FormattingEnabled = $true
$cbxResourcePool.Location = New-Object System.Drawing.Point(149, 283)
$cbxResourcePool.Size = New-Object System.Drawing.Size(121, 21)
$cbxResourcePool.TabIndex = 7
$cbxResourcePool.Text = ""
$cbxResourcePool.add_SelectedIndexChanged({CbxResourcePoolSelectedIndexChanged($cbxResourcePool)})
#~~< cbxDatastore >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$cbxDatastore = New-Object System.Windows.Forms.ComboBox
$cbxDatastore.FormattingEnabled = $true
$cbxDatastore.Location = New-Object System.Drawing.Point(149, 256)
$cbxDatastore.Size = New-Object System.Drawing.Size(121, 21)
$cbxDatastore.TabIndex = 7
$cbxDatastore.Text = ""
$cbxDatastore.add_SelectedIndexChanged({CbxDatastoreSelectedIndexChanged($cbxDatastore)})
#~~< Label15 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label15 = New-Object System.Windows.Forms.Label
$Label15.Location = New-Object System.Drawing.Point(38, 311)
$Label15.Size = New-Object System.Drawing.Size(100, 20)
$Label15.TabIndex = 5
$Label15.Text = "VM Port Group:"
$Label15.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$Label15.add_Click({Label8Click($Label15)})
#~~< TextBox1 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$TextBox1 = New-Object System.Windows.Forms.TextBox
$TextBox1.Location = New-Object System.Drawing.Point(117, 149)
$TextBox1.Size = New-Object System.Drawing.Size(121, 20)
$TextBox1.TabIndex = 0
$TextBox1.Text = ""
#~~< Label8 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label8 = New-Object System.Windows.Forms.Label
$Label8.Location = New-Object System.Drawing.Point(38, 284)
$Label8.Size = New-Object System.Drawing.Size(100, 20)
$Label8.TabIndex = 5
$Label8.Text = "VM Resource Pool:"
$Label8.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$Label8.add_Click({Label8Click($Label8)})
#~~< txtVMName >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$txtVMName = New-Object System.Windows.Forms.TextBox
$txtVMName.Location = New-Object System.Drawing.Point(117, 16)
$txtVMName.Size = New-Object System.Drawing.Size(121, 20)
$txtVMName.TabIndex = 0
$txtVMName.Text = ""
#~~< cbxHost >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$cbxHost = New-Object System.Windows.Forms.ComboBox
$cbxHost.FormattingEnabled = $true
$cbxHost.Location = New-Object System.Drawing.Point(127, 229)
$cbxHost.Size = New-Object System.Drawing.Size(121, 21)
$cbxHost.TabIndex = 7
$cbxHost.Text = ""
$cbxHost.add_SelectedIndexChanged({CbxHostSelectedIndexChanged($cbxHost)})
#~~< Label2 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label2 = New-Object System.Windows.Forms.Label
$Label2.Location = New-Object System.Drawing.Point(6, 42)
$Label2.Size = New-Object System.Drawing.Size(100, 20)
$Label2.TabIndex = 3
$Label2.Text = "VM IP Address:"
$Label2.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
#~~< Label7 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label7 = New-Object System.Windows.Forms.Label
$Label7.Location = New-Object System.Drawing.Point(38, 257)
$Label7.Size = New-Object System.Drawing.Size(100, 20)
$Label7.TabIndex = 5
$Label7.Text = "VM Datastore:"
$Label7.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$Label7.add_Click({Label7Click($Label7)})
#~~< mtbIP >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$mtbIP = New-Object System.Windows.Forms.MaskedTextBox
$mtbIP.Location = New-Object System.Drawing.Point(117, 43)
$mtbIP.Mask = "990.990.990.990"
$mtbIP.Size = New-Object System.Drawing.Size(121, 20)
$mtbIP.TabIndex = 4
#~~< Label6 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label6 = New-Object System.Windows.Forms.Label
$Label6.Location = New-Object System.Drawing.Point(21, 230)
$Label6.Size = New-Object System.Drawing.Size(100, 20)
$Label6.TabIndex = 5
$Label6.Text = "VM Host:"
$Label6.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
#~~< Label3 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label3 = New-Object System.Windows.Forms.Label
$Label3.Location = New-Object System.Drawing.Point(6, 69)
$Label3.Size = New-Object System.Drawing.Size(100, 20)
$Label3.TabIndex = 5
$Label3.Text = "VM IP Gateway:"
$Label3.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
#~~< cbxCluster >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$cbxCluster = New-Object System.Windows.Forms.ComboBox
$cbxCluster.FormattingEnabled = $true
$cbxCluster.Location = New-Object System.Drawing.Point(117, 202)
$cbxCluster.Size = New-Object System.Drawing.Size(121, 21)
$cbxCluster.TabIndex = 7
$cbxCluster.Text = ""
$cbxCluster.add_SelectedIndexChanged({CbxClusterSelectedIndexChanged($cbxCluster)})
#~~< Label14 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label14 = New-Object System.Windows.Forms.Label
$Label14.Location = New-Object System.Drawing.Point(6, 149)
$Label14.Size = New-Object System.Drawing.Size(100, 20)
$Label14.TabIndex = 5
$Label14.Text = "VM Memory (MB)"
$Label14.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$Label14.add_Click({Label11Click($Label14)})
#~~< Label12 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label12 = New-Object System.Windows.Forms.Label
$Label12.Location = New-Object System.Drawing.Point(6, 121)
$Label12.Size = New-Object System.Drawing.Size(100, 20)
$Label12.TabIndex = 5
$Label12.Text = "VM vCPU Count:"
$Label12.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$Label12.add_Click({Label11Click($Label12)})
#~~< cbxFolder >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$cbxFolder = New-Object System.Windows.Forms.ComboBox
$cbxFolder.FormattingEnabled = $true
$cbxFolder.Location = New-Object System.Drawing.Point(117, 175)
$cbxFolder.Size = New-Object System.Drawing.Size(121, 21)
$cbxFolder.TabIndex = 7
$cbxFolder.Text = ""
$cbxFolder.add_SelectedIndexChanged({CbxFolderSelectedIndexChanged($cbxFolder)})
#~~< Label5 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label5 = New-Object System.Windows.Forms.Label
$Label5.Location = New-Object System.Drawing.Point(6, 203)
$Label5.Size = New-Object System.Drawing.Size(100, 20)
$Label5.TabIndex = 5
$Label5.Text = "VM Cluster:"
$Label5.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
#~~< Label11 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label11 = New-Object System.Windows.Forms.Label
$Label11.Location = New-Object System.Drawing.Point(6, 95)
$Label11.Size = New-Object System.Drawing.Size(100, 20)
$Label11.TabIndex = 5
$Label11.Text = "VM BO IP Address:"
$Label11.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$Label11.add_Click({Label11Click($Label11)})
#~~< Label4 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label4 = New-Object System.Windows.Forms.Label
$Label4.Location = New-Object System.Drawing.Point(6, 176)
$Label4.Size = New-Object System.Drawing.Size(100, 20)
$Label4.TabIndex = 5
$Label4.Text = "VM VC Folder:"
$Label4.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
#~~< mtbGateway >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$mtbGateway = New-Object System.Windows.Forms.MaskedTextBox
$mtbGateway.Location = New-Object System.Drawing.Point(117, 69)
$mtbGateway.Mask = "990.990.990.990"
$mtbGateway.Size = New-Object System.Drawing.Size(121, 20)
$mtbGateway.TabIndex = 6
#~~< mtbBOIP >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$mtbBOIP = New-Object System.Windows.Forms.MaskedTextBox
$mtbBOIP.Location = New-Object System.Drawing.Point(117, 95)
$mtbBOIP.Mask = "990.990.990.990"
$mtbBOIP.Size = New-Object System.Drawing.Size(121, 20)
$mtbBOIP.TabIndex = 6
$mtbBOIP.add_MaskInputRejected({MaskedTextBox1MaskInputRejected($mtbBOIP)})
$GroupBox2.Controls.Add($ComboBox1)
$GroupBox2.Controls.Add($Label1)
$GroupBox2.Controls.Add($cbxPortGroup)
$GroupBox2.Controls.Add($cbxResourcePool)
$GroupBox2.Controls.Add($cbxDatastore)
$GroupBox2.Controls.Add($Label15)
$GroupBox2.Controls.Add($TextBox1)
$GroupBox2.Controls.Add($Label8)
$GroupBox2.Controls.Add($txtVMName)
$GroupBox2.Controls.Add($cbxHost)
$GroupBox2.Controls.Add($Label2)
$GroupBox2.Controls.Add($Label7)
$GroupBox2.Controls.Add($mtbIP)
$GroupBox2.Controls.Add($Label6)
$GroupBox2.Controls.Add($Label3)
$GroupBox2.Controls.Add($cbxCluster)
$GroupBox2.Controls.Add($Label14)
$GroupBox2.Controls.Add($Label12)
$GroupBox2.Controls.Add($cbxFolder)
$GroupBox2.Controls.Add($Label5)
$GroupBox2.Controls.Add($Label11)
$GroupBox2.Controls.Add($Label4)
$GroupBox2.Controls.Add($mtbGateway)
$GroupBox2.Controls.Add($mtbBOIP)
#~~< GroupBox1 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$GroupBox1 = New-Object System.Windows.Forms.GroupBox
$GroupBox1.Location = New-Object System.Drawing.Point(12, 12)
$GroupBox1.Size = New-Object System.Drawing.Size(276, 73)
$GroupBox1.TabIndex = 9
$GroupBox1.TabStop = $false
$GroupBox1.Text = "VM Source Template"
#~~< Label10 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label10 = New-Object System.Windows.Forms.Label
$Label10.Location = New-Object System.Drawing.Point(6, 43)
$Label10.Size = New-Object System.Drawing.Size(100, 20)
$Label10.TabIndex = 5
$Label10.Text = "VM OS:"
$Label10.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
#~~< cbxOS >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$cbxOS = New-Object System.Windows.Forms.ComboBox
$cbxOS.FormattingEnabled = $true
$cbxOS.Location = New-Object System.Drawing.Point(117, 42)
$cbxOS.Size = New-Object System.Drawing.Size(121, 21)
$cbxOS.TabIndex = 8
$cbxOS.Text = ""
$cbxOS.Items.AddRange([System.Object[]](@("WXP", "W2K3")))
$cbxOS.add_SelectedIndexChanged({CbxOSSelectedIndexChanged($cbxOS)})
#~~< Label9 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label9 = New-Object System.Windows.Forms.Label
$Label9.Location = New-Object System.Drawing.Point(6, 16)
$Label9.Size = New-Object System.Drawing.Size(100, 20)
$Label9.TabIndex = 5
$Label9.Text = "VM Template:"
$Label9.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
#~~< cbxTemplate >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$cbxTemplate = New-Object System.Windows.Forms.ComboBox
$cbxTemplate.FormattingEnabled = $true
$cbxTemplate.Location = New-Object System.Drawing.Point(117, 15)
$cbxTemplate.Size = New-Object System.Drawing.Size(121, 21)
$cbxTemplate.TabIndex = 7
$cbxTemplate.Text = ""
$cbxTemplate.add_SelectedIndexChanged({CbxTemplateSelectedIndexChanged($cbxTemplate)})
$GroupBox1.Controls.Add($Label10)
$GroupBox1.Controls.Add($cbxOS)
$GroupBox1.Controls.Add($Label9)
$GroupBox1.Controls.Add($cbxTemplate)
$frmDeploy.Controls.Add($btnDeploy)
$frmDeploy.Controls.Add($GroupBox2)
$frmDeploy.Controls.Add($GroupBox1)
$frmDeploy.add_Load({FrmDeployLoad($frmDeploy)})

#endregion

#region Custom Code

#endregion

#region Event Loop

function loadvim
{
	& {
		$ErrorActionPreference = "silentlycontinue"
		$vmwareSnapin = Add-PSSnapin "VMware.VimAutomation.Core" -ErrorVariable myErr
		
		switch -regex ($myErr[0].Exception.ErrorRecord)
		{
			"VMware.VimAutomation.Core is not installed" {
				"VMware.VimAutomation.Core is not installed" | Write-Log
				Write-Host "Please install the VI Toolkit"
				Write-Host "See http://vmware.com/go/powershell"
				"*** Application stopped ***" | Write-Log
				exit
			}
			"No Windows PowerShell snap-in matches criteria vmware.vimautomation.core." {
				"No Windows PowerShell snap-in matches criteria vmware.vimautomation.core." | Write-Log
				Add-PSSnapin "VMware.VimAutomation.Core"
			}
		}
		if ((Get-VIToolkitVersion).Build -lt $VITKMinimumVersion)
		{
			"VITK version incorrect : " + ( Get-VIToolkitVersion ).Build | Write-Log
			Write-Host "Install the latest version of the VI Toolkit" -foregroundcolor "red"
			Write-Host "See http://vmware.com/go/powershell"
			"*** Application stopped ***" | Write-Log
			exit
		}
	}
}
function ClusterChangeUpdate
{
	$Global:VI.VMHost.RemoveAll()
	Get-Cluster -name $cbxCluster.selectedValue | Get-VMHost | Sort-Object -property Name | % {
	$VMHost = $Global:VI.CreateElement("VMHost")
	$VMHost.PSBase.InnerText = $_.Name
	[void]$root.AppendChild($VMHost)
	}		
	
	$cbxHost.DataSource = @($Global:VI.VCInfo.VMHost)
}

function HostChangeUpdate
{
	$Global:VI.Datastore.RemoveAll()
	Get-VMHost -name $cbxHost.SelectedValue | Get-Datastore | where-Object { $_.Type -eq "VMFS" } | Sort-Object -property Name | %	{
		$DS = $Global:VI.CreateElement("Datastore")
		$DS.PSBase.InnerText = $_.Name
		[void]$root.AppendChild($DS)
	}
	$cbxDatastore.DataSource = @($Global:VI.VCInfo.Datastore)	
		
	$Global:VI.ResourcePool.RemoveAll()
	Get-VMHost -name $cbxHost.SelectedValue | Get-ResourcePool | where-Object { $_.Name -ne "Resources" } | Sort-Object -property Name | %	{
		$RP = $Global:VI.CreateElement("ResourcePool")
		$RP.PSBase.InnerText = $_.Name
		[void]$root.AppendChild($RP)
	}
	$cbxResourcePool.DataSource = @($Global:VI.VCInfo.ResourcePool)	
			
	$Global:VI.Network.RemoveAll()
	Get-VMHost -name $cbxHost.SelectedValue | Get-View | where-Object { $_.ConfigManager.NetworkSystem -ne $null } | % { Get-View $_.ConfigManager.NetworkSystem } | 	% { $_.NetworkInfo.PortGroup } | where-Object { $_.Port -eq $null } | 	% { $_.Spec.Name } | Sort-Object -property Name | %	{
		$Net = $Global:VI.CreateElement("Network")
		$Net.PSBase.InnerText = $_
		[void]$root.AppendChild($Net)
	}
	$cbxPortGroup.DataSource = @($Global:VI.VCInfo.Network)
}

function Main
{
	loadvim
	
Connect-VIServer -Server "ntvc.conseco.ad"
	$Global:VI = New-Object xml
	$Global:VI.RemoveAll()
	$root = $Global:VI.CreateElement("VCInfo")
	[void]$Global:VI.AppendChild($root)
		
Get-Cluster | Sort-Object -property Name | % {
	$Clster = $Global:VI.CreateElement("Cluster")
	$Clster.PSBase.InnerText = $_.Name
	[void]$root.AppendChild($Clster)
}		

Get-Template | Sort-Object -property Name | % {
	$TP = $Global:VI.CreateElement("Template")
	$TP.PSBase.InnerText = $_.Name
	[void]$root.AppendChild($TP)
}
	
Get-Folder | Sort-Object -property Name | % {
	$Fldr = $Global:VI.CreateElement("Folder")
	$Fldr.PSBase.InnerText = $_.Name
	[void]$root.AppendChild($Fldr)
}					
	
$cbxTemplate.DataSource = @($Global:VI.VCInfo.Template)
$cbxFolder.DataSource = @($Global:VI.VCInfo.Folder)
$cbxCluster.DataSource = @($Global:VI.VCInfo.Cluster)	
	
ClusterChangeUpdate
	
HostChangeUpdate
	
#Disconnect-VIServer -confirm:$true
	
[System.Windows.Forms.Application]::EnableVisualStyles()
[System.Windows.Forms.Application]::Run($frmDeploy)
}

#endregion

#endregion

#region Event Handlers

function CbxResourcePoolSelectedIndexChanged( $object ){

}

function CbxDatastoreSelectedIndexChanged( $object ){

}

function Label8Click( $object ){

}

function Label7Click( $object ){

}

function Label11Click( $object ){

}

function MaskedTextBox1MaskInputRejected( $object ){

}

function BtnDeployClick( $object ){

}

function CbxPortGroupSelectedIndexChanged( $object ){

}

function CbxHostSelectedIndexChanged( $object ){
HostChangeUpdate
}

function CbxClusterSelectedIndexChanged( $object ){
ClusterChangeUpdate
}

function CbxFolderSelectedIndexChanged( $object ){

}

function CbxOSSelectedIndexChanged( $object ){

}

function CbxTemplateSelectedIndexChanged( $object ){

}

function FrmDeployLoad( $object ){

			
		

				
		
}

Main # This call must remain below all other event functions

#endregion
