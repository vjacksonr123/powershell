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
#~~< frmVMDSp >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$frmVMDSp = New-Object System.Windows.Forms.Form
$frmVMDSp.ClientSize = New-Object System.Drawing.Size(292, 99)
$frmVMDSp.Text = "VM Deployment System"
#~~< lblMsg >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblMsg = New-Object System.Windows.Forms.Label
$lblMsg.Location = New-Object System.Drawing.Point(0, 23)
$lblMsg.Size = New-Object System.Drawing.Size(292, 23)
$lblMsg.TabIndex = 4
$lblMsg.Text = "Please Wait.. Deploying VM"
$lblMsg.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
#~~< prgb1 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$prgb1 = New-Object System.Windows.Forms.ProgressBar
$prgb1.Location = New-Object System.Drawing.Point(12, 64)
$prgb1.Size = New-Object System.Drawing.Size(267, 23)
$prgb1.Style = [System.Windows.Forms.ProgressBarStyle]::Continuous
$prgb1.TabIndex = 3
$prgb1.Text = ""
#~~< lblTItle >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblTItle = New-Object System.Windows.Forms.Label
$lblTItle.Dock = [System.Windows.Forms.DockStyle]::Top
$lblTItle.Font = New-Object System.Drawing.Font("Tahoma", 12.0, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$lblTItle.Location = New-Object System.Drawing.Point(0, 0)
$lblTItle.Size = New-Object System.Drawing.Size(292, 23)
$lblTItle.TabIndex = 2
$lblTItle.Text = "VM Deployment System"
$lblTItle.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$frmVMDSp.Controls.Add($lblMsg)
$frmVMDSp.Controls.Add($prgb1)
$frmVMDSp.Controls.Add($lblTItle)

#endregion

#region Custom Code

#endregion

#region Event Loop

#endregion

#endregion

#region Event Handlers


#endregion
