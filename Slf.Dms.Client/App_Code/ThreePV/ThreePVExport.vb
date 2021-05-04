Imports Drg.Util.DataAccess
Imports System.Data
Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://service.lexxiom.com/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class ThreePVExport
    Inherits System.Web.Services.WebService

    <WebMethod()> _
    Public Function ExportVerification(ByVal exportData As String) As String
        Dim result As String = "1"
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        Dim doc As New System.Xml.XmlDocument
        Dim PVN As String
        Dim VDate As String
        Dim Complete As String

        Try
            doc.LoadXml(exportData)

            PVN = doc.DocumentElement.Attributes("verification-number").Value
            VDate = doc.DocumentElement.Attributes("verification-date").Value
            Complete = doc.DocumentElement.Attributes("verification-complete").Value

            'Good request recieved. Should only throw exceptions if one of these attributes does not exist
            result = "0"

            If Complete.ToUpper = "Y" Then
                CompleteVerification(PVN, VDate)
            Else
                Throw New Exception(String.Format("Complete={0}", Complete))
            End If
        Catch ex As Exception
            DatabaseHelper.AddParameter(cmd, "ExportData", exportData)
            DatabaseHelper.AddParameter(cmd, "Exception", ex.Message)
            DatabaseHelper.BuildInsertCommandText(cmd, "tblLeadExportData", "LeadExportDataID", SqlDbType.Int)

            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return result
    End Function

    Private Sub CompleteVerification(ByVal PVN As String, ByVal VDate As String)
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        Dim r As Integer

        DatabaseHelper.AddParameter(cmd, "Completed", Now)
        DatabaseHelper.BuildUpdateCommandText(cmd, "tblLeadVerification", String.Format("substring(PVN,4,{2})='{0}' and VDate='{1}'", PVN, VDate, Len(PVN.Trim)))

        cmd.Connection.Open()
        r = cmd.ExecuteNonQuery
        DatabaseHelper.EnsureConnectionClosed(cmd.Connection)

        If r = 0 Then
            Throw New Exception("PVN not found")
        End If
    End Sub

End Class
