Option Explicit On

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Controls
Imports Slf.Dms.Records

Imports System.Collections.Generic
Imports System.Data
Imports System.Reflection
Imports System.IO
Imports System.Text.RegularExpressions
Imports System.Xml


Partial Class bankimport_default
    Inherits PermissionPage

#Region "Variables"

    Private UserID As Integer
    Private BankImportDir As String
    Private ConfigPath As String

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        BankImportDir = "C:\SQLServices\NewBankImport\"
        ConfigPath = BankImportDir + "Slf.Dms.Service.BankImport.exe.config"

        If Not IsPostBack Then
            txtReportTo.Text = GetUsersEmail(UserID)
        End If
    End Sub

    Private Function GetUsersEmail(ByVal id As Integer) As String
        Return DataHelper.Nz_string(DataHelper.FieldLookup("tblUser", "EmailAddress", "UserID = " + id.ToString()))
    End Function

    Protected Sub lnkImportFile_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkImportFile.Click
        ImportFile()
    End Sub

    Private Sub ImportFile()
        Try
            If Not (txtFile.HasFile AndAlso txtFile.FileName.ToLower().EndsWith(".dat")) Then
                Throw New Exception("Please select a valid file!")
            End If

            Dim reportTo As String = txtReportTo.Text

            lblLog.Text = ""

            Dim config As Dictionary(Of String, String) = ParseConfig()
            Dim logPath As String = config("importlogpath")

            lblLog.Text += "Log Path: " + logPath + "<br />"

            Dim fInfo As New FileInfo(txtFile.FileName)
            Dim newFile As String = config("filelocation") + fInfo.Name.ToString()
            Dim execStr As String = BankImportDir + "Slf.Dms.Service.BankImport.exe -batch """ + newFile + """"

            lblLog.Text += "New File: " + newFile + "<br />"

            txtFile.SaveAs(newFile)

            If File.Exists(newFile) Then
                If reportTo.Length > 0 AndAlso IsValidEmailList(reportTo) Then
                    lblLog.Text += "Emailing Log To: " + reportTo + "<br />"
                    ChangeEmail(ConfigPath, reportTo)
                Else
                    Throw New Exception("Please enter a valid E-Mail address!")
                End If

                lblLog.Text += "Executing: " + execStr + "<br /><br />"
                Shell(execStr, AppWinStyle.Hide, True, 300000)

                ChangeEmail(ConfigPath, config("logemailto"))

                lblLog.Text += "Process complete."
            Else
                Throw New Exception("Could not upload file!")
            End If
        Catch ex As Exception
            lblLog.Text += "<br /><br />" + ex.Message.ToString()
        End Try
    End Sub

#Region "Config"
    Private Function ParseConfig() As Dictionary(Of String, String)
        Dim results As New Dictionary(Of String, String)
        Dim config As XmlTextReader

        Try
            config = New XmlTextReader(ConfigPath)
            config.WhiteSpaceHandling = WhiteSpaceHandling.None

            While config.Read()
                Select Case config.NodeType
                    Case XmlNodeType.Element
                        If config.Name.ToString().ToLower() = "add" Then
                            results.Add(config.GetAttribute("key").ToString().ToLower(), config.GetAttribute("value").ToString())
                        End If
                End Select
            End While
        Catch ex As Exception
            Throw New Exception(ex.Message.ToString())
        Finally
            If Not config Is Nothing Then
                config.Close()
            End If
        End Try

        Return results
    End Function

    Private Sub ChangeEmail(ByVal path As String, ByVal newEmail As String)
        Dim config As XmlDocument

        Try
            config = New XmlDocument()
            config.Load(path)

            For Each element As XmlElement In config.DocumentElement
                If element.Name.ToString() = "appSettings" Then
                    For Each node As XmlNode In element.ChildNodes
                        If node.Attributes(0).Value = "logEmailTo" Then
                            node.Attributes(1).Value = newEmail
                        End If
                    Next
                End If
            Next

            config.Save(path)
        Catch ex As Exception
            Throw New Exception(ex.Message.ToString())
        Finally
            If Not config Is Nothing Then
                config = Nothing
            End If
        End Try
    End Sub
#End Region

#Region "IsValidEmailList"
    Private Function IsValidEmailList(ByVal emailList As String) As Boolean
        Dim emailArray() As String = emailList.Split(",")

        For Each email As String In emailArray
            If Not IsValidEmail(email.Trim()) Then
                Return False
            End If
        Next

        Return True
    End Function

    Private Function IsValidEmail(ByVal email As String) As Boolean
        Return Regex.IsMatch(email, "^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$")
    End Function
#End Region

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlBody, c, "Admin-Bank Import")
    End Sub
End Class