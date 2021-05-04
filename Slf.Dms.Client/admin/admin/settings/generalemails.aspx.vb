Option Explicit On

Imports Drg.Util.DataAccess

Imports System
Imports System.Collections.Generic
Imports System.Data.SqlClient

Partial Class admin_settings_generalemails
    Inherits PermissionPage

#Region "Variables"
    Public UserID As Integer
    Public SortImage As String
    Public SortImagePath As String
#End Region

#Region "Structures"
    Public Structure MatterEmailTemplate
        Public EmailConfigID As Integer
        Public MailSubject As String
        Public MailPurpose As String
        Public MailType As String
        Public LawfirmName As String

        Public Sub New(ByVal _EmailConfigID As Integer, ByVal _MailType As String, ByVal _MailSubject As String, ByVal _MailPurpose As String, ByVal _LawfirmName As String)
            Me.EmailConfigID = _EmailConfigID
            Me.MailType = _MailType
            Me.MailSubject = _MailSubject
            Me.MailPurpose = _MailPurpose
            Me.LawfirmName = _LawfirmName
        End Sub
    End Structure
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = CInt(Page.User.Identity.Name)

        SetDisplay()

        If Not IsPostBack Then
            Session("SortField") = "MailSubject"
            Session("SortOrder") = "ASC"
            LoadEmailTemplates(GetSortString())
        End If
    End Sub

    Private Sub SetDisplay()
        lblTitle.Text = "Email Templates"

        Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""" & ResolveUrl("~/admin/settings/references") & """><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_book.png") & """ align=""absmiddle""/>References</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""AddTemplate();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_file_new.png") & """ align=""absmiddle""/>Add new Template</a>")
    End Sub

    Public Sub LoadEmailTemplates(Optional ByVal SortString As String = "")
        Dim emails As New List(Of MatterEmailTemplate)

        Using cmd As New SqlCommand("SELECT [Name], EmailConfigID, MailSubject, MailPurpose, Case MType When 'M' Then 'Matter' When 'G' Then 'General' End as MType  FROM tblEmailConfiguration LEFT OUTER JOIN tblCompany on lawfirmId=CompanyID" & SortString, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        emails.Add(New MatterEmailTemplate(Integer.Parse(reader("EmailConfigID")), reader("MType"), reader("MailSubject"), reader("MailPurpose"), DataHelper.Nz_string(reader("Name"))))
                    End While
                End Using
            End Using
        End Using

        rptMatterEmails.DataSource = emails
        rptMatterEmails.DataBind()
    End Sub

    Protected Sub lnkDeleteDoc_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteDoc.Click
        Using cmd As New SqlCommand("DELETE tblEmailConfiguration WHERE EmailConfigID in (" & txtSelected.Value & ")", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()

            End Using
        End Using

        LoadEmailTemplates(GetSortString())
    End Sub

    Protected Sub lnkResort_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkResort.Click
        LoadEmailTemplates(GetSortString(txtSortField.Value))
    End Sub

    Private Function GetSortString(Optional ByVal NewSortField As String = "") As String
        If Session("SortField") = NewSortField Then
            If Session("SortOrder") = "ASC" Then
                Session("SortOrder") = "DESC"
            Else
                Session("SortOrder") = "ASC"
            End If
        Else
            Session("SortOrder") = "ASC"
        End If

        If NewSortField.Length > 0 Then
            Session("SortField") = NewSortField
        End If

        SortImage = "imgSort_" & Session("SortField")
        SortImagePath = ResolveUrl("~/images/sort-" & Session("SortOrder") & ".png")

        Return " ORDER BY " & Session("SortField") & " " & Session("SortOrder")
    End Function

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
    End Sub
End Class