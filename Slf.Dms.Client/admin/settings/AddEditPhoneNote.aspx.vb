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

Partial Class admin_settings_AddEditPhoneNote
    Inherits System.Web.UI.Page

#Region "Variables"
    Private UserID As Integer
    Private MatterPhoneEntryID As Integer

    Public Action As String
    Public DocIDs As String
    Public DocNames As String
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        Action = Request.QueryString("a")

        If Action = "e" Then
            MatterPhoneEntryID = DataHelper.Nz_int(Request.QueryString("id"), 0)
        End If

        SetDisplay()

        If Not IsPostBack Then
            LoadMatterPhoneNotes()
            LoadMatterPhoneNoteNames()

            If Action = "e" Then
                PopulateMatterPhoneNoteDetails()
            End If
        End If
    End Sub

    Private Sub SetDisplay()
        Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Cancel();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save Matter Phone Note</a>")

        If Action = "a" Then
            lblTitle.Text = "Add Matter Phone Note"
        Else
            lblTitle.Text = "Edit Matter Phone Note"
        End If

    End Sub

    Private Sub PopulateMatterPhoneNoteDetails()
        Using cmd As New SqlCommand("SELECT dt.MatterPhoneEntryID, dt.PhoneEntry, dt.PhoneEntryDesc, dt.PhoneEntryBody, dt.IsActive, dt.CreatedDatetime, uc.FirstName + ' ' + uc.LastName as CreatedBy, " & _
        "dt.ModifiedDate, ul.FirstName + ' ' + ul.LastName as LastModifiedBy FROM tblMatterPhoneEntry as dt left join tblUser as uc on " & _
        "uc.UserID = dt.CreatedBy left join tblUser as ul on ul.UserID = dt.ModifiedBy WHERE dt.MatterPhoneEntryID = " & MatterPhoneEntryID, _
        ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        lblID.Text = MatterPhoneEntryID
                        txtTypeID.Text = reader("PhoneEntry")
                        txtName.Text = reader("PhoneEntryDesc")
                        txtBody.Text = reader("PhoneEntryBody")
                        chkActive.Checked = DataHelper.Nz_bool(reader("IsActive"))
                        lblCreated.Text = DateTime.Parse(reader("CreatedDatetime")).ToString("g")
                        lblCreatedBy.Text = reader("CreatedBy")
                        lblLastModified.Text = DateTime.Parse(reader("ModifiedDate")).ToString("g")
                        lblLastModifiedBy.Text = reader("LastModifiedBy")
                    End If
                End Using
            End Using
        End Using
    End Sub

    Private Sub LoadMatterPhoneNotes()
        DocIDs = ""

        Using cmd As New SqlCommand("SELECT DISTINCT PhoneEntry FROM tblMatterPhoneEntry" & IIf(Action = "e", " WHERE not MatterPhoneEntryID = " & _
        MatterPhoneEntryID, ""), ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        DocIDs += "," & reader("PhoneEntry")
                    End While
                End Using
            End Using
        End Using

        DocIDs = DocIDs.Remove(0, 1).Replace("'", "\'")
    End Sub

    Private Sub LoadMatterPhoneNoteNames()
        DocNames = ""

        Using cmd As New SqlCommand("SELECT DISTINCT MatterPhoneEntryID, PhoneEntry FROM tblMatterPhoneEntry", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        DocNames += "," & reader("PhoneEntry") & "|" & reader("MatterPhoneEntryID")
                    End While
                End Using
            End Using
        End Using

        DocNames = DocNames.Remove(0, 1).Replace("'", "\'")
    End Sub

    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub

    Private Sub Close()
        Response.Redirect("~/admin/settings/MatterPhoneNotes.aspx")
    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Using cmd As New SqlCommand("", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                If Action = "e" Then
                    cmd.CommandText = "UPDATE tblMatterPhoneEntry SET PhoneEntry = '" & txtTypeID.Text.Replace("'", "''") & "', PhoneEntryDesc = '" & txtName.Text.Replace("'", "''") & "', PhoneEntryBody = '" & txtBody.Text.Replace("'", "''") & "' , IsActive = '" & chkActive.Checked & "', ModifiedDate = getdate(), ModifiedBy = " & UserID & " WHERE MatterPhoneEntryID = " & MatterPhoneEntryID

                    cmd.ExecuteNonQuery()
                Else
                    cmd.CommandText = "INSERT INTO tblMatterPhoneEntry VALUES ('" & txtTypeID.Text.Replace("'", "''") & "', '" & txtName.Text.Replace("'", "''") & "', '" & txtBody.Text.Replace("'", "''") & "' ,1, getdate(), " & UserID & ", getdate(), " & UserID & ") SELECT scope_identity()"

                    MatterPhoneEntryID = cmd.ExecuteScalar()
                End If


            End Using
        End Using

        Close()
    End Sub

    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click
        Close()
    End Sub

End Class