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
#~~< frmVMDS >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$frmVMDS = New-Object System.Windows.Forms.Form
$frmVMDS.ClientSize = New-Object System.Drawing.Size(550, 298)
$frmVMDS.Text = "VM Deployment"
#~~< gbxInfo >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$gbxInfo = New-Object System.Windows.Forms.GroupBox
$gbxInfo.Location = New-Object System.Drawing.Point(12, 26)
$gbxInfo.Size = New-Object System.Drawing.Size(526, 52)
$gbxInfo.TabIndex = 10
$gbxInfo.TabStop = $false
$gbxInfo.Text = "Virtual Machine Information"
#~~< txtVMName >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$txtVMName = New-Object System.Windows.Forms.TextBox
$txtVMName.Location = New-Object System.Drawing.Point(73, 19)
$txtVMName.MaxLength = 16
$txtVMName.Size = New-Object System.Drawing.Size(152, 20)
$txtVMName.TabIndex = 3
$txtVMName.Text = ""
#~~< lblVMName >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblVMName = New-Object System.Windows.Forms.Label
$lblVMName.Location = New-Object System.Drawing.Point(12, 22)
$lblVMName.Size = New-Object System.Drawing.Size(64, 13)
$lblVMName.TabIndex = 2
$lblVMName.Text = "VM Name:"
#~~< lblVMTier >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblVMTier = New-Object System.Windows.Forms.Label
$lblVMTier.Location = New-Object System.Drawing.Point(231, 19)
$lblVMTier.Size = New-Object System.Drawing.Size(54, 13)
$lblVMTier.TabIndex = 2
$lblVMTier.Text = "VM Tier:"
#~~< cbxVMTier >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$cbxVMTier = New-Object System.Windows.Forms.ComboBox
$cbxVMTier.FormattingEnabled = $true
$cbxVMTier.Location = New-Object System.Drawing.Point(291, 19)
$cbxVMTier.Size = New-Object System.Drawing.Size(225, 21)
$cbxVMTier.TabIndex = 4
$cbxVMTier.Text = ""
$cbxVMTier.Items.AddRange([System.Object[]](@("Production", "User Acceptace Testing", "System Integ Testing", "User Testing", "Desktop", "Sandbox")))
$gbxInfo.Controls.Add($txtVMName)
$gbxInfo.Controls.Add($lblVMName)
$gbxInfo.Controls.Add($lblVMTier)
$gbxInfo.Controls.Add($cbxVMTier)
#~~< GroupBox1 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$GroupBox1 = New-Object System.Windows.Forms.GroupBox
$GroupBox1.Location = New-Object System.Drawing.Point(12, 84)
$GroupBox1.Size = New-Object System.Drawing.Size(260, 207)
$GroupBox1.TabIndex = 9
$GroupBox1.TabStop = $false
$GroupBox1.Text = "Virtual Machine Specs"
#~~< mtxtVMBOIP >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$mtxtVMBOIP = New-Object System.Windows.Forms.MaskedTextBox
$mtxtVMBOIP.Location = New-Object System.Drawing.Point(117, 175)
$mtxtVMBOIP.Mask = "990.990.990.990"
$mtxtVMBOIP.Size = New-Object System.Drawing.Size(137, 20)
$mtxtVMBOIP.TabIndex = 6
#~~< Label1 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Label1 = New-Object System.Windows.Forms.Label
$Label1.Location = New-Object System.Drawing.Point(11, 46)
$Label1.Size = New-Object System.Drawing.Size(100, 13)
$Label1.TabIndex = 2
$Label1.Text = "VM OS Version:"
#~~< lblVMOS >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblVMOS = New-Object System.Windows.Forms.Label
$lblVMOS.Location = New-Object System.Drawing.Point(11, 19)
$lblVMOS.Size = New-Object System.Drawing.Size(100, 13)
$lblVMOS.TabIndex = 2
$lblVMOS.Text = "VM OS:"
#~~< lblVMRAM >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblVMRAM = New-Object System.Windows.Forms.Label
$lblVMRAM.Location = New-Object System.Drawing.Point(11, 72)
$lblVMRAM.Size = New-Object System.Drawing.Size(100, 13)
$lblVMRAM.TabIndex = 2
$lblVMRAM.Text = "VM RAM (MB)"
#~~< cbxVMOSVer >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$cbxVMOSVer = New-Object System.Windows.Forms.ComboBox
$cbxVMOSVer.FormattingEnabled = $true
$cbxVMOSVer.Location = New-Object System.Drawing.Point(117, 43)
$cbxVMOSVer.Size = New-Object System.Drawing.Size(137, 21)
$cbxVMOSVer.TabIndex = 4
$cbxVMOSVer.Items.AddRange([System.Object[]](@("W2K3R2_Standard_x86", "W2K3R2-SP2-STD-X86", "W2K3R2-SP2-ENT-X86", "W2K3-SP1-ENT-X86", "W2K3-SP1-STD-X86", "W2K3-SP2-ENT-X64", "W2K3-SP2-ENT-X86", "W2K3-SP2-STD-X86", "W2K8-SP1-STD-X64", "W2K-SP4-STD-X86")))
#~~< cbxVMOS >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$cbxVMOS = New-Object System.Windows.Forms.ComboBox
$cbxVMOS.FormattingEnabled = $true
$cbxVMOS.Location = New-Object System.Drawing.Point(117, 16)
$cbxVMOS.Size = New-Object System.Drawing.Size(137, 21)
$cbxVMOS.TabIndex = 4
$cbxVMOS.Items.AddRange([System.Object[]](@("SRV", "DESK")))
#~~< mtxtVMFOIP >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$mtxtVMFOIP = New-Object System.Windows.Forms.MaskedTextBox
$mtxtVMFOIP.Location = New-Object System.Drawing.Point(117, 149)
$mtxtVMFOIP.Mask = "990.990.990.990"
$mtxtVMFOIP.Size = New-Object System.Drawing.Size(137, 20)
$mtxtVMFOIP.TabIndex = 6
#~~< lblVMvCPUs >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblVMvCPUs = New-Object System.Windows.Forms.Label
$lblVMvCPUs.Location = New-Object System.Drawing.Point(11, 98)
$lblVMvCPUs.Size = New-Object System.Drawing.Size(100, 13)
$lblVMvCPUs.TabIndex = 2
$lblVMvCPUs.Text = "VM vCPU(s)"
#~~< nudVMDDrive >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$nudVMDDrive = New-Object System.Windows.Forms.NumericUpDown
$nudVMDDrive.Location = New-Object System.Drawing.Point(117, 122)
$nudVMDDrive.Maximum = 250
$nudVMDDrive.Minimum = 10
$nudVMDDrive.Size = New-Object System.Drawing.Size(137, 20)
$nudVMDDrive.TabIndex = 5
$nudVMDDrive.Value = 10
#~~< nudVMRAM >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$nudVMRAM = New-Object System.Windows.Forms.NumericUpDown
$nudVMRAM.Increment = 1024
$nudVMRAM.Location = New-Object System.Drawing.Point(117, 70)
$nudVMRAM.Maximum = 4096
$nudVMRAM.Minimum = 1024
$nudVMRAM.Size = New-Object System.Drawing.Size(137, 20)
$nudVMRAM.TabIndex = 5
$nudVMRAM.Value = 1024
#~~< lblVMBOIP >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblVMBOIP = New-Object System.Windows.Forms.Label
$lblVMBOIP.Location = New-Object System.Drawing.Point(11, 178)
$lblVMBOIP.Size = New-Object System.Drawing.Size(100, 13)
$lblVMBOIP.TabIndex = 2
$lblVMBOIP.Text = "VM Back Office IP:"
#~~< lblDDrive >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblDDrive = New-Object System.Windows.Forms.Label
$lblDDrive.Location = New-Object System.Drawing.Point(11, 124)
$lblDDrive.Size = New-Object System.Drawing.Size(100, 13)
$lblDDrive.TabIndex = 2
$lblDDrive.Text = "VM D: Drive (GB)"
#~~< nudVMvCPUs >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$nudVMvCPUs = New-Object System.Windows.Forms.NumericUpDown
$nudVMvCPUs.Location = New-Object System.Drawing.Point(117, 96)
$nudVMvCPUs.Maximum = 4
$nudVMvCPUs.Minimum = 1
$nudVMvCPUs.Size = New-Object System.Drawing.Size(137, 20)
$nudVMvCPUs.TabIndex = 5
$nudVMvCPUs.Value = 1
#~~< lblVMFOIP >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblVMFOIP = New-Object System.Windows.Forms.Label
$lblVMFOIP.Location = New-Object System.Drawing.Point(11, 152)
$lblVMFOIP.Size = New-Object System.Drawing.Size(100, 13)
$lblVMFOIP.TabIndex = 2
$lblVMFOIP.Text = "VM Front Office IP:"
$GroupBox1.Controls.Add($mtxtVMBOIP)
$GroupBox1.Controls.Add($Label1)
$GroupBox1.Controls.Add($lblVMOS)
$GroupBox1.Controls.Add($lblVMRAM)
$GroupBox1.Controls.Add($cbxVMOSVer)
$GroupBox1.Controls.Add($cbxVMOS)
$GroupBox1.Controls.Add($mtxtVMFOIP)
$GroupBox1.Controls.Add($lblVMvCPUs)
$GroupBox1.Controls.Add($nudVMDDrive)
$GroupBox1.Controls.Add($nudVMRAM)
$GroupBox1.Controls.Add($lblVMBOIP)
$GroupBox1.Controls.Add($lblDDrive)
$GroupBox1.Controls.Add($nudVMvCPUs)
$GroupBox1.Controls.Add($lblVMFOIP)
#~~< btnDeploy >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$btnDeploy = New-Object System.Windows.Forms.Button
$btnDeploy.Location = New-Object System.Drawing.Point(278, 238)
$btnDeploy.Size = New-Object System.Drawing.Size(260, 53)
$btnDeploy.TabIndex = 8
$btnDeploy.Text = "Deploy VM"
$btnDeploy.UseVisualStyleBackColor = $true
$btnDeploy.add_Click({BtnDeployClick($btnDeploy)})
#~~< gbxVC >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$gbxVC = New-Object System.Windows.Forms.GroupBox
$gbxVC.Location = New-Object System.Drawing.Point(278, 84)
$gbxVC.Size = New-Object System.Drawing.Size(260, 148)
$gbxVC.TabIndex = 7
$gbxVC.TabStop = $false
$gbxVC.Text = "Virtual Center Config"
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
#~~< lblTItle >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblTItle = New-Object System.Windows.Forms.Label
$lblTItle.Dock = [System.Windows.Forms.DockStyle]::Top
$lblTItle.Font = New-Object System.Drawing.Font("Tahoma", 12.0, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$lblTItle.Location = New-Object System.Drawing.Point(0, 0)
$lblTItle.Size = New-Object System.Drawing.Size(550, 23)
$lblTItle.TabIndex = 1
$lblTItle.Text = "VM Deployment System"
$lblTItle.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$frmVMDS.Controls.Add($gbxInfo)
$frmVMDS.Controls.Add($GroupBox1)
$frmVMDS.Controls.Add($btnDeploy)
$frmVMDS.Controls.Add($gbxVC)
$frmVMDS.Controls.Add($lblTItle)

#endregion

#region Custom Code

#endregion

#region Event Loop

#endregion

#endregion

#region Event Handlers

function BtnDeployClick( $object ){
fnDeployVMgui($object)
}

function fnVMHostChange( $object ){
fnVMHostChange1($object)
}

function fnVMClusterChange( $object ){
fnVMClusterChange1($object)
}

