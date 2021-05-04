Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports System.Data.SqlClient

Imports System.Data

Partial Class Enrollment_addnote
    Inherits System.Web.UI.Page

#Region "Variables"

    Private UserID As Integer
    Private a As Boolean
    Private aID As Integer = 0
    Private nID As Integer = 0
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        Integer.TryParse(Request.QueryString("id"), aID)
        Integer.TryParse(Request.QueryString("nID"), nID)

        'Are we adding a new record?
        If nID = 0 Then
            a = True
        Else
            lnkSave.Text = "Save Note"
        End If

        If Not IsPostBack Then
            LoadData(nID)
        End If

    End Sub

    Private Sub LoadData(Optional ByVal NoteID As Integer = 0)
        Dim strSQL As String
        Dim cmd As SqlCommand
        Dim rdr As SqlDataReader

        Me.cboNoteTypeID.Items.Add(New ListItem("Phone", 1))
        Me.cboNoteTypeID.Items.Add(New ListItem("Email", 2))
        Me.cboNoteTypeID.Items.Add(New ListItem("Mail", 3))
        Me.cboNoteTypeID.Items.Add(New ListItem("Other", 0))

        Me.WebDateTimeEdit1.Value = FormatDateTime(Now, DateFormat.ShortDate)

        'Setup the call
        If NoteID <> 0 Then
            strSQL = "SELECT * FROM tblLeadNotes WHERE LeadNoteID = " & nID
            'Load the datareaders if we have an existing client
            cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
            rdr = DatabaseHelper.ExecuteReader(cmd, Data.CommandBehavior.CloseConnection)
            AssignTheNoteData(rdr)
            rdr.Close()
            cmd.Dispose()
        Else 'we're inserting a new client blank all the fields and clear all the grids and their rows
            ClearAllTextBoxes()
        End If

    End Sub

    Private Sub AssignTheNoteData(ByVal rdr As SqlDataReader)
        While rdr.Read
            Try
                'Note types
                'Dim li As ListItem = cboNoteTypeID.Items.FindByText(rdr.Item("NoteType").ToString)

                'If Not IsNothing(li) Then
                '    li.Selected = True
                'End If

                'If rdr.Item("InBound") Then
                '    radIn.Checked = True
                '    radOut.Checked = False
                'Else
                '    radOut.Checked = True
                '    radIn.Checked = False
                'End If
                cboNoteTypeID.SelectedIndex = CInt(rdr.Item("NoteTypeID").ToString)
                Me.txtNote.Text = rdr.Item("Value")
                Me.WebDateTimeEdit1.Text = rdr.Item("Modified").ToString

            Catch ex As Exception
                Continue While
            End Try
        End While
    End Sub

    Private Sub ClearAllTextBoxes()

        Me.txtNote.Text = ""
        Me.cboNoteTypeID.SelectedIndex = 0
        Me.radDirection.SelectedIndex = 0
        Me.WebDateTimeEdit1.Value = FormatDateTime(Now, DateFormat.ShortDate)

    End Sub


    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Dim strSQL As String
        Dim cmd As SqlCommand

        Try
            If aID > 0 Or nID > 0 Then 'we have an applicant so we can do this
                If a Then
                    strSQL = "INSERT INTO tblLeadNotes (LeadApplicantID, NoteTypeID, Value, Created, CreatedByID, Modified, ModifiedBy) " _
                    & "VALUES (" _
                    & aID & ", '" _
                    & Me.cboNoteTypeID.SelectedItem.Value & "', '" _
                    & Me.txtNote.Text.ToString.Replace("'", "''") & "', '" _
                    & Now & "', " _
                    & UserID & ", '" _
                    & Now & "', " _
                    & UserID & ")"
                Else
                    strSQL = "UPDATE tblLeadNotes SET " _
                    & "Value = '" & Me.txtNote.Text.ToString.Replace("'", "''") & "', " _
                    & "Modified = '" & Now & "', " _
                    & "NoteType = '" & cboNoteTypeID.SelectedItem.Text & "' " _
                    & "WHERE LeadNoteID = " & nID
                End If

                cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
                If cmd.Connection.State = ConnectionState.Closed Then cmd.Connection.Open()
                cmd.ExecuteNonQuery()
                cmd.Connection.Close()
            Else
                Throw New Exception("No applicant was choosen and therefore not notes can be created.")
            End If
        Catch ex As Exception

        End Try

        ClearAllTextBoxes()

        Page.ClientScript.RegisterStartupScript(Me.GetType, "close", "window.close();", True)
    End Sub
End Class