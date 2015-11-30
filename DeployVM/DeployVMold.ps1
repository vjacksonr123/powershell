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

#region ScriptForm Designer

#region Constructor

[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

#endregion

#region Post-Constructor Custom Code

#endregion

#region Form Creation
#Warning: It is recommended that changes inside this region be handled using the ScriptForm Designer.
#When working with the ScriptForm designer this region and any changes within may be overwritten.
#~~< Form1 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Form1 = New-Object System.Windows.Forms.Form
$Form1.ClientSize = New-Object System.Drawing.Size(512, 264)
$Form1.Text = "VM Deployment"
#~~< btnDeploy >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$btnDeploy = New-Object System.Windows.Forms.Button
$btnDeploy.Location = New-Object System.Drawing.Point(240, 215)
$btnDeploy.Size = New-Object System.Drawing.Size(260, 23)
$btnDeploy.TabIndex = 8
$btnDeploy.Text = "Deploy VM"
$btnDeploy.UseVisualStyleBackColor = $true
$btnDeploy.add_Click({BtnDeployClick($btnDeploy)})
#~~< gbxVC >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$gbxVC = New-Object System.Windows.Forms.GroupBox
$gbxVC.Location = New-Object System.Drawing.Point(240, 52)
$gbxVC.Size = New-Object System.Drawing.Size(260, 148)
$gbxVC.TabIndex = 7
$gbxVC.TabStop = $false
$gbxVC.Text = "Virtual Center"
#~~< lblVMDatastore >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblVMDatastore = New-Object System.Windows.Forms.Label
$lblVMDatastore.Location = New-Object System.Drawing.Point(6, 120)
$lblVMDatastore.Size = New-Object System.Drawing.Size(105, 13)
$lblVMDatastore.TabIndex = 2
$lblVMDatastore.Text = "VM Datastore:"
#~~< lblVMRPool >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblVMRPool = New-Object System.Windows.Forms.Label
$lblVMRPool.Location = New-Object System.Drawing.Point(6, 93)
$lblVMRPool.Size = New-Object System.Drawing.Size(105, 13)
$lblVMRPool.TabIndex = 2
$lblVMRPool.Text = "VM Resource Pool:"
#~~< lblVMHost >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblVMHost = New-Object System.Windows.Forms.Label
$lblVMHost.Location = New-Object System.Drawing.Point(6, 66)
$lblVMHost.Size = New-Object System.Drawing.Size(105, 13)
$lblVMHost.TabIndex = 2
$lblVMHost.Text = "VM Host:"
#~~< lblVMCluster >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblVMCluster = New-Object System.Windows.Forms.Label
$lblVMCluster.Location = New-Object System.Drawing.Point(6, 40)
$lblVMCluster.Size = New-Object System.Drawing.Size(105, 13)
$lblVMCluster.TabIndex = 2
$lblVMCluster.Text = "VM Cluster:"
#~~< lblVMFolder >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblVMFolder = New-Object System.Windows.Forms.Label
$lblVMFolder.Location = New-Object System.Drawing.Point(6, 16)
$lblVMFolder.Size = New-Object System.Drawing.Size(105, 13)
$lblVMFolder.TabIndex = 2
$lblVMFolder.Text = "VM Folder:"
#~~< cbxVMDatastore >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$cbxVMDatastore = New-Object System.Windows.Forms.ComboBox
$cbxVMDatastore.FormattingEnabled = $true
$cbxVMDatastore.Location = New-Object System.Drawing.Point(117, 117)
$cbxVMDatastore.Size = New-Object System.Drawing.Size(134, 21)
$cbxVMDatastore.TabIndex = 4
$cbxVMDatastore.Text = ""
$cbxVMDatastore.Items.AddRange([System.Object[]](@("W2K3", "WXP")))
#~~< cbxVMRPool >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$cbxVMRPool = New-Object System.Windows.Forms.ComboBox
$cbxVMRPool.FormattingEnabled = $true
$cbxVMRPool.Location = New-Object System.Drawing.Point(117, 90)
$cbxVMRPool.Size = New-Object System.Drawing.Size(134, 21)
$cbxVMRPool.TabIndex = 4
$cbxVMRPool.Text = ""
#~~< cbxVMHost >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$cbxVMHost = New-Object System.Windows.Forms.ComboBox
$cbxVMHost.FormattingEnabled = $true
$cbxVMHost.Location = New-Object System.Drawing.Point(117, 63)
$cbxVMHost.Size = New-Object System.Drawing.Size(134, 21)
$cbxVMHost.TabIndex = 4
$cbxVMHost.Text = ""
$cbxVMHost.add_SelectedIndexChanged({fnVMHostChange($cbxVMHost)})
#~~< cbxVMCluster >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$cbxVMCluster = New-Object System.Windows.Forms.ComboBox
$cbxVMCluster.FormattingEnabled = $true
$cbxVMCluster.Location = New-Object System.Drawing.Point(117, 37)
$cbxVMCluster.Size = New-Object System.Drawing.Size(134, 21)
$cbxVMCluster.TabIndex = 4
$cbxVMCluster.Text = ""
$cbxVMCluster.add_SelectedIndexChanged({fnVMClusterChange($cbxVMCluster)})
#~~< cbxVMFolder >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$cbxVMFolder = New-Object System.Windows.Forms.ComboBox
$cbxVMFolder.FormattingEnabled = $true
$cbxVMFolder.Location = New-Object System.Drawing.Point(117, 13)
$cbxVMFolder.Size = New-Object System.Drawing.Size(134, 21)
$cbxVMFolder.TabIndex = 4
$cbxVMFolder.Text = ""
$gbxVC.Controls.Add($lblVMDatastore)
$gbxVC.Controls.Add($lblVMRPool)
$gbxVC.Controls.Add($lblVMHost)
$gbxVC.Controls.Add($lblVMCluster)
$gbxVC.Controls.Add($lblVMFolder)
$gbxVC.Controls.Add($cbxVMDatastore)
$gbxVC.Controls.Add($cbxVMRPool)
$gbxVC.Controls.Add($cbxVMHost)
$gbxVC.Controls.Add($cbxVMCluster)
$gbxVC.Controls.Add($cbxVMFolder)
#~~< mtxtVMBOIP >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$mtxtVMBOIP = New-Object System.Windows.Forms.MaskedTextBox
$mtxtVMBOIP.Location = New-Object System.Drawing.Point(112, 238)
$mtxtVMBOIP.Mask = "990.990.990.990"
$mtxtVMBOIP.Size = New-Object System.Drawing.Size(102, 20)
$mtxtVMBOIP.TabIndex = 6
#~~< mtxtVMFOIP >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$mtxtVMFOIP = New-Object System.Windows.Forms.MaskedTextBox
$mtxtVMFOIP.Location = New-Object System.Drawing.Point(112, 212)
$mtxtVMFOIP.Mask = "990.990.990.990"
$mtxtVMFOIP.Size = New-Object System.Drawing.Size(102, 20)
$mtxtVMFOIP.TabIndex = 6
#~~< nudDDrive >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$nudDDrive = New-Object System.Windows.Forms.NumericUpDown
$nudDDrive.Location = New-Object System.Drawing.Point(112, 185)
$nudDDrive.Maximum = New-Object System.Decimal([System.Int32[]](@(250, 0, 0, 0)))
$nudDDrive.Minimum = New-Object System.Decimal([System.Int32[]](@(10, 0, 0, 0)))
$nudDDrive.Size = New-Object System.Drawing.Size(102, 20)
$nudDDrive.TabIndex = 5
$nudDDrive.Value = New-Object System.Decimal([System.Int32[]](@(10, 0, 0, 0)))
#~~< lblVMBOIP >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblVMBOIP = New-Object System.Windows.Forms.Label
$lblVMBOIP.Location = New-Object System.Drawing.Point(6, 241)
$lblVMBOIP.Size = New-Object System.Drawing.Size(100, 13)
$lblVMBOIP.TabIndex = 2
$lblVMBOIP.Text = "VM Back Office IP:"
#~~< nudVMvCPUs >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$nudVMvCPUs = New-Object System.Windows.Forms.NumericUpDown
$nudVMvCPUs.Location = New-Object System.Drawing.Point(112, 159)
$nudVMvCPUs.Maximum = New-Object System.Decimal([System.Int32[]](@(4, 0, 0, 0)))
$nudVMvCPUs.Minimum = New-Object System.Decimal([System.Int32[]](@(1, 0, 0, 0)))
$nudVMvCPUs.Size = New-Object System.Drawing.Size(102, 20)
$nudVMvCPUs.TabIndex = 5
$nudVMvCPUs.Value = New-Object System.Decimal([System.Int32[]](@(1, 0, 0, 0)))
#~~< lblVMFOIP >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblVMFOIP = New-Object System.Windows.Forms.Label
$lblVMFOIP.Location = New-Object System.Drawing.Point(6, 215)
$lblVMFOIP.Size = New-Object System.Drawing.Size(100, 13)
$lblVMFOIP.TabIndex = 2
$lblVMFOIP.Text = "VM Front Office IP:"
#~~< lblDDrive >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblDDrive = New-Object System.Windows.Forms.Label
$lblDDrive.Location = New-Object System.Drawing.Point(6, 187)
$lblDDrive.Size = New-Object System.Drawing.Size(100, 13)
$lblDDrive.TabIndex = 2
$lblDDrive.Text = "VM D: Drive (GB)"
#~~< nudVMRAM >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$nudVMRAM = New-Object System.Windows.Forms.NumericUpDown
$nudVMRAM.Increment = New-Object System.Decimal([System.Int32[]](@(1024, 0, 0, 0)))
$nudVMRAM.Location = New-Object System.Drawing.Point(112, 133)
$nudVMRAM.Maximum = New-Object System.Decimal([System.Int32[]](@(4096, 0, 0, 0)))
$nudVMRAM.Minimum = New-Object System.Decimal([System.Int32[]](@(1024, 0, 0, 0)))
$nudVMRAM.Size = New-Object System.Drawing.Size(102, 20)
$nudVMRAM.TabIndex = 5
$nudVMRAM.Value = New-Object System.Decimal([System.Int32[]](@(1024, 0, 0, 0)))
#~~< lblVMvCPUs >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblVMvCPUs = New-Object System.Windows.Forms.Label
$lblVMvCPUs.Location = New-Object System.Drawing.Point(6, 161)
$lblVMvCPUs.Size = New-Object System.Drawing.Size(100, 13)
$lblVMvCPUs.TabIndex = 2
$lblVMvCPUs.Text = "VM vCPU(s)"
#~~< cbxVMTier >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$cbxVMTier = New-Object System.Windows.Forms.ComboBox
$cbxVMTier.FormattingEnabled = $true
$cbxVMTier.Location = New-Object System.Drawing.Point(112, 79)
$cbxVMTier.Size = New-Object System.Drawing.Size(102, 21)
$cbxVMTier.TabIndex = 4
$cbxVMTier.Text = ""
$cbxVMTier.Items.AddRange([System.Object[]](@("Production", "User Acceptace Testing", "System Integ Testing", "User Testing", "Desktop", "Sandbox")))
#~~< cbxOS >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$cbxOS = New-Object System.Windows.Forms.ComboBox
$cbxOS.FormattingEnabled = $true
$cbxOS.Location = New-Object System.Drawing.Point(112, 106)
$cbxOS.Size = New-Object System.Drawing.Size(102, 21)
$cbxOS.TabIndex = 4
$cbxOS.Text = ""
$cbxOS.Items.AddRange([System.Object[]](@("W2K3", "WXP")))
#~~< lblVMTier >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblVMTier = New-Object System.Windows.Forms.Label
$lblVMTier.Location = New-Object System.Drawing.Point(6, 79)
$lblVMTier.Size = New-Object System.Drawing.Size(100, 13)
$lblVMTier.TabIndex = 2
$lblVMTier.Text = "VM Tier:"
#~~< lblVMRAM >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblVMRAM = New-Object System.Windows.Forms.Label
$lblVMRAM.Location = New-Object System.Drawing.Point(6, 135)
$lblVMRAM.Size = New-Object System.Drawing.Size(100, 13)
$lblVMRAM.TabIndex = 2
$lblVMRAM.Text = "VM RAM (MB)"
#~~< lblVMOS >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblVMOS = New-Object System.Windows.Forms.Label
$lblVMOS.Location = New-Object System.Drawing.Point(6, 109)
$lblVMOS.Size = New-Object System.Drawing.Size(100, 13)
$lblVMOS.TabIndex = 2
$lblVMOS.Text = "VM OS:"
#~~< txtVMName >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$txtVMName = New-Object System.Windows.Forms.TextBox
$txtVMName.Location = New-Object System.Drawing.Point(112, 53)
$txtVMName.MaxLength = 16
$txtVMName.Size = New-Object System.Drawing.Size(102, 20)
$txtVMName.TabIndex = 3
$txtVMName.Text = ""
#~~< lblVMName >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblVMName = New-Object System.Windows.Forms.Label
$lblVMName.Location = New-Object System.Drawing.Point(6, 56)
$lblVMName.Size = New-Object System.Drawing.Size(100, 13)
$lblVMName.TabIndex = 2
$lblVMName.Text = "VM Name:"
#~~< lblTItle >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblTItle = New-Object System.Windows.Forms.Label
$lblTItle.Dock = [System.Windows.Forms.DockStyle]::Top
$lblTItle.Font = New-Object System.Drawing.Font("Tahoma", 12.0, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$lblTItle.Location = New-Object System.Drawing.Point(0, 0)
$lblTItle.Size = New-Object System.Drawing.Size(512, 23)
$lblTItle.TabIndex = 1
$lblTItle.Text = "VM Deployment System"
$lblTItle.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$Form1.Controls.Add($btnDeploy)
$Form1.Controls.Add($gbxVC)
$Form1.Controls.Add($mtxtVMBOIP)
$Form1.Controls.Add($mtxtVMFOIP)
$Form1.Controls.Add($nudDDrive)
$Form1.Controls.Add($lblVMBOIP)
$Form1.Controls.Add($nudVMvCPUs)
$Form1.Controls.Add($lblVMFOIP)
$Form1.Controls.Add($lblDDrive)
$Form1.Controls.Add($nudVMRAM)
$Form1.Controls.Add($lblVMvCPUs)
$Form1.Controls.Add($cbxVMTier)
$Form1.Controls.Add($cbxOS)
$Form1.Controls.Add($lblVMTier)
$Form1.Controls.Add($lblVMRAM)
$Form1.Controls.Add($lblVMOS)
$Form1.Controls.Add($txtVMName)
$Form1.Controls.Add($lblVMName)
$Form1.Controls.Add($lblTItle)

#endregion

#region Custom Code

#endregion

#region Event Loop

function Main{
	[System.Windows.Forms.Application]::EnableVisualStyles()
	
}

#endregion

#endregion

#region Event Handlers

function BtnDeployClick($object)
{
				
}

function fnVMClusterChange($object)
{
	$cbxVMHost.DataSource = Get-Cluster -name $cbxVMCluster.SelectedValue | Get-VMHost | Sort-Object -property Name
	$cbxVMHost.SelectedIndex = -1
	$cbxVMHost.Enabled = 1
	$cbxVMRPool.Enabled = 0
	$cbxVMDataStore.Enabled = 0
}

function fnVMHostChange($object)
{
	$cbxVMRPool.DataSource = Get-VMHost -name $cbxVMHost.SelectedValue | Get-ResourcePool | Sort-Object -property Name
	$cbxVMRPool.SelectedIndex = -1
	$cbxVMRPool.Enabled = 1	
	$cbxVMDatastore.DataSource = Get-VMHost -name $cbxVMHost.SelectedValue | Get-Datastore | Sort-Object -property Name
	$cbxVMDatastore.SelectedIndex = -1
	$cbxVMDataStore.Enabled = 1
}

function

Main # This call must remain below all other event functions


$vmwareSnapin = Add-PSSnapin "VMware.VimAutomation.Core" -ErrorVariable myErr
Connect-VIServer -Server "vcenter.conseco.ad"
$cbxVMFolder.DataSource = Get-Folder | Sort-Object -property Name
$cbxVMFolder.SelectedIndex = -1
$cbxVMCluster.DataSource = Get-Cluster | Sort-Object -property Name
$cbxVMCluster.SelectedIndex = -1
$cbxVMHost.Enabled = 0
$cbxVMRPool.Enabled = 0
$cbxVMDatastore.Enabled = 0
[System.Windows.Forms.Application]::Run($Form1)


#endregion
