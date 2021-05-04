Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data
Imports System.Data.SqlClient

Partial Class Enrollment_addcoap
    Inherits System.Web.UI.Page

#Region "Variables"

    Private UserID As Integer
    Private a As Boolean
    Private aID As Integer = 0
    Private cID As Integer = 0

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        Integer.TryParse(Request.QueryString("id"), aID)
        Integer.TryParse(Request.QueryString("cID"), cID)

        'Are we adding a new record?
        If aID > 0 Then
            a = True
        End If

        If Not IsPostBack Then

            LoadStates()
            LoadData(cID)
            SetAttributes()

        End If

    End Sub

    Private Sub SetAttributes()
        txtZipCode.Attributes("onblur") = "javascript:txtZipCode_OnBlur(this);"
    End Sub

    Private Sub LoadStates()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblState ORDER BY [Abbreviation]"

        cboStateID.Items.Clear()
        cboStateID.Items.Add(New ListItem(String.Empty, 0))

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboStateID.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Abbreviation"), DatabaseHelper.Peel_int(rd, "StateID")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub

    Private Sub LoadData(Optional ByVal coappID As Integer = 0)
        Dim strSQL As String
        Dim cmd As SqlCommand
        Dim rdr As SqlDataReader

        'Setup the call
        If coappID <> 0 Then
            strSQL = "SELECT * FROM tblLeadCoApplicant WHERE LeadCoApplicantID = " & coappID
            'Load the datareaders if we have an existing client
            cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
            rdr = DatabaseHelper.ExecuteReader(cmd, Data.CommandBehavior.CloseConnection)
            AssignTheBankData(rdr)
            rdr.Close()
            cmd.Dispose()
        Else 'we're inserting a new creditor blank all the fields
            ClearAlltextBoxes()
        End If

    End Sub

    Private Sub AssignTheBankData(ByVal rdr As SqlDataReader)
        While rdr.Read
            Try

                Me.txtFirst.Text = rdr.Item("FirstName").ToString
                Me.txtLast.Text = rdr.Item("LastName").ToString
                Me.txtAddress.Text = rdr.Item("Address").ToString
                Me.txtCity.Text = rdr.Item("City").ToString
                Me.cboStateID.SelectedIndex = Me.cboStateID.Items.IndexOf(Me.cboStateID.Items.FindByValue(rdr.Item("StateID")))
                Me.txtZipCode.Text = rdr.Item("ZipCode").ToString
                Me.txtPhoneNumber2.Text = rdr.Item("BusPhone").ToString
                Me.txtPhoneNumber1.Text = rdr.Item("HomePhone").ToString
                Me.txtPhoneNumber3.Text = rdr.Item("CellPhone").ToString
                Me.txtPhoneNumber4.Text = rdr.Item("FaxNumber").ToString
                Me.txtSSN.Text = rdr.Item("SSN").ToString
                Me.txtDOB.Text = FormatDateTime(rdr.Item("DOB").ToString, DateFormat.ShortDate)
                Me.txtEmailAddress.Text = rdr.Item("Email").ToString
                Me.chkCanAuth.Checked = Boolean.Parse(rdr.Item("AuthorizationPower").ToString)

                Dim li As ListItem = ddlRelationship.Items.FindByText(rdr.Item("Relationship").ToString)
                If Not li Is Nothing Then li.Selected = True

            Catch ex As Exception
                Continue While
            End Try
        End While

    End Sub

    Private Sub ClearAlltextBoxes()

        Me.txtFirst.Text = ""
        Me.txtLast.Text = ""
        Me.txtAddress.Text = ""
        Me.txtCity.Text = ""
        Me.cboStateID.SelectedIndex = -1
        Me.txtZipCode.Text = ""
        Me.txtPhoneNumber1.Text = ""
        Me.txtPhoneNumber2.Text = ""
        Me.txtPhoneNumber3.Text = ""
        Me.txtPhoneNumber4.Text = ""
        Me.txtSSN.Text = ""
        Me.txtDOB.Text = ""
        Me.txtEmailAddress.Text = ""
        Me.chkCanAuth.Checked = False
        Me.ddlRelationship.SelectedIndex = 0

   End Sub

    Protected Sub lnkAddBank_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAddBank.Click

        Dim strSQL As String
        Dim cmd As SqlCommand

        Try
            If aID > 0 Or cID > 0 Then 'we have an applicant so we can do this
                If a Then
                    strSQL = "INSERT INTO tblleadcoapplicant (LeadApplicantID, FirstName, LastName ,[full name],Address, City, StateID, ZipCode, "
                    strSQL += "HomePhone, BusPhone, CellPhone, FaxNumber, AuthorizationPower, SSN,EMail,DOB,"
                    strSQL += "Created, CreatedByID, LastModified, LastModifiedByID, Relationship) "
                    strSQL += "VALUES ("
                    strSQL += aID & ", '"
                    strSQL += Me.txtFirst.Text.ToString & "', '"
                    strSQL += Me.txtLast.Text.ToString & "', '"
                    strSQL += Me.txtFirst.Text.ToString & Space(1) & Me.txtLast.Text.ToString & "', '"
                    strSQL += Me.txtAddress.Text.ToString & "', '"
                    strSQL += Me.txtCity.Text.ToString & "', "
                    strSQL += Me.cboStateID.SelectedValue & ", '"
                    strSQL += Me.txtZipCode.Text.ToString & "', '"
                    strSQL += Me.txtPhoneNumber1.Text.ToString & "', '"
                    strSQL += Me.txtPhoneNumber2.Text.ToString & "', '"
                    strSQL += Me.txtPhoneNumber3.Text.ToString & "', '"
                    strSQL += Me.txtPhoneNumber4.Text.ToString & "', "
                    strSQL += IIf(chkCanAuth.Checked = True, 1, 0) & ", "
                    strSQL += "'" & Me.txtSSN.Text.ToString & "', "
                    strSQL += "'" & Me.txtEmailAddress.Text.ToString & "', "
                    strSQL += "'" & Me.txtDOB.Text.ToString & "', "
                    strSQL += "'" & Now & "', "
                    strSQL += UserID & ", '"
                    strSQL += Now & "', "
                    strSQL += UserID & ", '"
                    strSQL += ddlRelationship.SelectedItem.Text & "')"
                Else
                    strSQL = "UPDATE tblleadcoapplicant SET "
                    strSQL += "FirstName = '" & Me.txtFirst.Text.ToString & "', "
                    strSQL += "LastName = '" & Me.txtLast.Text.ToString & "', "
                    strSQL += "[Full Name] = '" & Me.txtFirst.Text.ToString & Space(1) & Me.txtLast.Text.ToString & "', "
                    strSQL += "Address = '" & Me.txtAddress.Text.ToString & "', "
                    strSQL += "City = '" & Me.txtCity.Text.ToString & "', "
                    strSQL += "StateID = " & cboStateID.SelectedValue & ", "
                    strSQL += "ZipCode = '" & Me.txtZipCode.Text.ToString & "', "
                    strSQL += "HomePhone = '" & Me.txtPhoneNumber1.Text.ToString & "', "
                    strSQL += "BusPhone = '" & Me.txtPhoneNumber2.Text.ToString & "', "
                    strSQL += "CellPhone = '" & Me.txtPhoneNumber3.Text.ToString & "', "
                    strSQL += "FaxNumber = '" & Me.txtPhoneNumber4.Text.ToString & "', "
                    strSQL += "LastModified = '" & Now & "', "
                    strSQL += "LastModifiedByID = " & UserID
                    strSQL += ",SSN = '" & txtSSN.Text.ToString & "'"
                    strSQL += ",Email = '" & txtEmailAddress.Text.ToString & "' "
                    strSQL += ",DOB = '" & txtDOB.Text.ToString & "' "
                    strSQL += ",AuthorizationPower = " & IIf(chkCanAuth.Checked = True, 1, 0) & " "
                    strSQL += ",Relationship = '" & ddlRelationship.SelectedItem.Text & "' "
                    strSQL += "WHERE LeadCoApplicantID = " & cID
                End If

                cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
                If cmd.Connection.State = ConnectionState.Closed Then cmd.Connection.Open()
                cmd.ExecuteNonQuery()
            Else
                Throw New Exception("No applicant was choosen and therefore not Co-applicants can be created.")
            End If

        Catch ex As Exception

        End Try

        ClearAlltextBoxes()

        Page.ClientScript.RegisterStartupScript(Me.GetType, "close", "window.close();", True)

    End Sub
End Class