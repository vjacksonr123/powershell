Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.ComponentModel
Imports System.Data.SqlClient

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<System.Web.Services.WebService(Namespace:="http://tempuri.org/")> _
<System.Web.Services.WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<ToolboxItem(False)> _
Public Class Automate
    Inherits System.Web.Services.WebService

    <WebMethod()> _
    Public Function HelloWorld() As String
       Return "Hello World"
    End Function

    <WebMethod()> _
    Public Function DeployVM(ByVal strVMName As String, ByVal strOSVer As String, ByVal strFOIPAddress As String, _
                         ByVal strBOIPAddress As String, ByVal intvCPUs As String, ByVal intRAM As Integer, _
                         ByVal intDiskGB As Integer, ByVal strVMdatastore As String, ByVal strVMFolder As String, _
                         ByVal strVMCluster As String, ByVal strVMResourcePool As String, ByVal strCONumber As String) As String


        'function fnDeployVM([string]$vmname, [string]$OS, [string]$OSver, [string]$vmIPaddress, 
        '[string]$vmBOIPaddress, [string]$vmvcpus, [string]$vmram, [string]$vmdisk, 
        '[string]$vmhost, [string]$vmdatastore, [string]$vmfolder, [string]$vmcluster, 
        '[string]$vmresourcepool, $gui, $deploy, [string]$vmsource, $dr)

        Dim strSQL As String, chCOAction As Char, sqlReturn As String
        chCOAction = "D"
        strSQL = "INSERT INTO CNO_Automate(CONumber,COAction,VMName,OSVer,VMFOIP,VMBOIP,VMVCPUS,VMRAMmb,VMDISKgb,VMdatastore,VMfolder,VMcluster,VMresourcepool,VMsourceVM,VMdrmode)VALUES ('" & strCONumber & "','" & chCOAction & "','" & strVMName & "','" & strOSVer & "','" & strFOIPAddress & "','" & strBOIPAddress & "','" & intvCPUs & "','" & intRAM & "','" & intDiskGB & "','" & strVMdatastore & "','" & strVMFolder & "','" & strVMCluster & "','" & strVMResourcePool & "','""','0')"

        Dim scSqlConnection As New SqlConnection("server=vcenter.conseco.ad;uid=vcadmin;pwd=vcadm6ev;database=vcenter")
        Dim scCommand As New SqlCommand(strSQL, scSqlConnection)
        scSqlConnection.Open()
        sqlReturn = scCommand.ExecuteNonQuery()
        scSqlConnection.Close()

        Return sqlReturn

    End Function

End Class