Option Explicit On

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Data.SqlClient
Imports System.Reflection
Imports System.Collections.Generic

Partial Class admin_settings_singledocument
    Inherits System.Web.UI.Page

#Region "Variables"
    Private UserID As Integer
    Private DocumentTypeID As Integer

    Public Action As String
    Public DocIDs As String
    Public DocNames As String
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        Action = Request.QueryString("a")

        If Action = "e" Then
            DocumentTypeID = DataHelper.Nz_int(Request.QueryString("id"), 0)
        End If

        SetDisplay()

        If Not IsPostBack Then
            LoadFolders()
            LoadAssociations()
            LoadDocumentTypes()
            LoadDocumentNames()

            If Action = "e" Then
                LoadDocument()
            End If
        End If
    End Sub

    Private Sub SetDisplay()
        Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Cancel();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save this Document</a>")

        If Not Action = "a" Then
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Delete();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_delete.png") & """ align=""absmiddle""/>Delete this Document</a>")
        End If
    End Sub

    Private Sub LoadDocument()
        Using cmd As New SqlCommand("SELECT dt.TypeID, dt.DisplayName, dt.DocFolder, dt.Created, uc.FirstName + ' ' + uc.LastName as CreatedBy, " & _
        "dt.LastModified, ul.FirstName + ' ' + ul.LastName as LastModifiedBy FROM tblDocumentType as dt left join tblUser as uc on " & _
        "uc.UserID = dt.CreatedBy left join tblUser as ul on ul.UserID = dt.LastModifiedBy WHERE dt.DocumentTypeID = " & DocumentTypeID, _
        ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        lblID.Text = DocumentTypeID
                        txtTypeID.Text = reader("TypeID")
                        txtName.Text = reader("DisplayName")
                        ddlDocFolder.SelectedValue = ddlDocFolder.Items.FindByText(reader("DocFolder")).Value
                        lblCreated.Text = DateTime.Parse(reader("Created")).ToString("g")
                        lblCreatedBy.Text = reader("CreatedBy")
                        lblLastModified.Text = DateTime.Parse(reader("LastModified")).ToString("g")
                        lblLastModifiedBy.Text = reader("LastModifiedBy")
                    End If
                End Using
            End Using
        End Using
    End Sub

    Private Sub LoadFolders()
        Using cmd As New SqlCommand("SELECT DocFolderID, Name FROM tblDocFolder", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        ddlDocFolder.Items.Add(New ListItem(reader("Name"), reader("DocFolderID")))
                    End While
                End Using
            End Using
        End Using
    End Sub

    Private Sub LoadDocumentTypes()
        DocIDs = ""

        Using cmd As New SqlCommand("SELECT DISTINCT TypeID FROM tblDocumentType" & IIf(Action = "e", " WHERE not DocumentTypeID = " & _
        DocumentTypeID, ""), ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        DocIDs += "," & reader("TypeID")
                    End While
                End Using
            End Using
        End Using

        DocIDs = DocIDs.Remove(0, 1)
    End Sub

    Private Sub LoadDocumentNames()
        DocNames = ""

        Using cmd As New SqlCommand("SELECT DISTINCT DocumentTypeID, DisplayName FROM tblDocumentType", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        DocNames += "," & reader("DisplayName") & "|" & reader("DocumentTypeID")
                    End While
                End Using
            End Using
        End Using

        DocNames = DocNames.Remove(0, 1).Replace("'", "\'")
    End Sub

    Private Sub LoadAssociations()
        Using cmd As New SqlCommand("SELECT srt.ScanRelationTypeID, srt.DisplayName, srt.DocFolderIDs, " & _
        "(CASE WHEN rel.Checked > 0 THEN 'checked=""checked""' ELSE '' END) as Checked FROM tblScanRelationType as srt left join " & _
        "(SELECT RelationType, count(*) as Checked FROM tblScanRelation WHERE DocumentTypeID = " & DocumentTypeID & _
        " GROUP BY RelationType) as rel on rel.RelationType = srt.RelationType ORDER BY DocFolderIDs, DisplayName", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    rptAssociations.DataSource = reader
                    rptAssociations.DataBind()
                End Using
            End Using
        End Using
    End Sub

    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub

    Private Sub Close()
        Response.Redirect("~/admin/settings/documents.aspx")
    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Using cmd As New SqlCommand("", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                If Action = "e" Then
                    cmd.CommandText = "UPDATE tblDocumentType SET TypeID = '" & txtTypeID.Text & "', DisplayName = '" & txtName.Text.Replace("'", "''") & "', DocFolder = '" & ddlDocFolder.SelectedItem.Text & "', LastModified = getdate(), LastModifiedBy = " & UserID & " WHERE DocumentTypeID = " & DocumentTypeID

                    cmd.ExecuteNonQuery()
                Else
                    cmd.CommandText = "INSERT INTO tblDocumentType VALUES ('" & txtTypeID.Text & "', '" & txtName.Text.Replace("'", "''") & "', '" & txtName.Text.Replace("'", "''") & "', '" & ddlDocFolder.SelectedItem.Text & "', getdate(), " & UserID & ", getdate(), " & UserID & ") SELECT scope_identity()"

                    DocumentTypeID = cmd.ExecuteScalar()
                End If

                If hdnAssociations.Value.Trim().Length > 0 Then
                    cmd.CommandText = "INSERT INTO tblScanRelation SELECT srt.RelationType, " & DocumentTypeID & " FROM tblScanRelationType as srt left join (SELECT RelationType, DocumentTypeID, count(*) as Num FROM tblScanRelation GROUP BY RelationType, DocumentTypeID) as rel on rel.RelationType = srt.RelationType and rel.DocumentTypeID = " & DocumentTypeID & " WHERE rel.Num is null and srt.ScanRelationTypeID in (" & hdnAssociations.Value & ")"

                    cmd.ExecuteNonQuery()

                    cmd.CommandText = "DELETE tblScanRelation WHERE ScanRelationID in (SELECT rel.ScanRelationID FROM tblScanRelation as rel inner join tblScanRelationType as srt on srt.RelationType = rel.RelationType WHERE srt.ScanRelationTypeID not in (" & hdnAssociations.Value & ") and rel.DocumentTypeID = " & DocumentTypeID & ")"

                    cmd.ExecuteNonQuery()
                Else
                    cmd.CommandText = "DELETE tblScanRelation WHERE DocumentTypeID = " & DocumentTypeID

                    cmd.ExecuteNonQuery()
                End If
            End Using
        End Using

        Close()
    End Sub

    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click
        Using cmd As New SqlCommand("DELETE tblDocumentType WHERE DocumentTypeID = " & DocumentTypeID, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()

                cmd.CommandText = "DELETE tblScanRelation WHERE DocumentTypeID = " & DocumentTypeID

                cmd.ExecuteNonQuery()
            End Using
        End Using

        Close()
    End Sub
End Class