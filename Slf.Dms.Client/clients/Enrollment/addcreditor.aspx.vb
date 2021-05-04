Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.Data.SqlClient
Imports System.Data

Partial Class Enrollment_addcreditor
    Inherits System.Web.UI.Page

#Region "Variables"

    Private UserID As Integer
    Private a As Boolean
    Private aID As Integer = 0
    Private crID As Integer = 0

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        Integer.TryParse(Request.QueryString("id"), aID)
        Integer.TryParse(Request.QueryString("crID"), crID)

        'Are we adding a new record?
        If aID > 0 Then
            a = True
        End If

        If Not IsPostBack Then

            LoadStates()
            LoadData(crID)
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

    Private Sub LoadData(Optional ByVal creditorInstanceID As Integer = 0)
        Dim strSQL As String
        Dim cmd As SqlCommand
        Dim rdr As SqlDataReader

        'Setup the call
        If creditorInstanceID <> 0 Then
            strSQL = "SELECT * FROM tblLeadCreditorInstance WHERE leadCreditorInstance = " & creditorInstanceID
            'Load the datareaders if we have an existing client
            cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
            rdr = DatabaseHelper.ExecuteReader(cmd, Data.CommandBehavior.CloseConnection)
            AssignTheCreditorData(rdr)
            rdr.Close()
            cmd.Dispose()
        Else 'we're inserting a new creditor blank all the fields
            ClearAlltextBoxes()
        End If

    End Sub

    Private Sub AssignTheCreditorData(ByVal rdr As SqlDataReader)
        While rdr.Read
            Try

                Me.txtName.Text = rdr.Item("Name").ToString
                Me.txtStreet.Text = rdr.Item("Street").ToString
                Me.txtStreet2.Text = rdr.Item("Street2").ToString
                Me.txtCity.Text = rdr.Item("City").ToString
                Me.cboStateID.SelectedIndex = Me.cboStateID.Items.IndexOf(Me.cboStateID.Items.FindByValue(rdr.Item("StateID")))
                Me.txtZipCode.Text = rdr.Item("ZipCode").ToString
                Me.txtPhoneExtension1.Text = rdr.Item("Ext").ToString
                Me.txtPhoneNumber1.Text = rdr.Item("Phone").ToString
                Me.AccountNumber.Text = rdr.Item("AccountNumber").ToString
                Me.CurrentBalance.Text = rdr.Item("Balance").ToString
            Catch ex As Exception
                Continue While
            End Try
        End While

    End Sub

    Private Sub ClearAlltextBoxes()

        Me.txtName.Text = ""
        Me.txtStreet.Text = ""
        Me.txtStreet2.Text = ""
        Me.txtCity.Text = ""
        Me.cboStateID.SelectedIndex = -1
        Me.txtZipCode.Text = ""
        Me.AccountNumber.Text = ""
        Me.CurrentBalance.Text = ""
        Me.txtPhoneNumber1.Text = ""
        Me.txtPhoneExtension1.Text = ""


    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAddCreditor.Click

        Dim strSQL As String
        Dim cmd As SqlCommand

        Try
            If aID > 0 Or crID > 0 Then 'we have an applicant so we can do this
                If a Then
                    strSQL = "INSERT INTO tblLeadCreditorInstance (LeadApplicantID, CreditorID, Name, Street, Street2, City, StateID, ZipCode, AccountNumber, Balance, Phone,Ext,Created, CreatedBy, Modified, ModifiedBy) "
                    strSQL += "VALUES ("
                    strSQL += aID & ", "
                    If cboCreditor.SelectedIndex = -1 Then
                        strSQL += "-1, '"
                    Else
                        strSQL += cboCreditor.SelectedRow.Cells(7).ToString & ", '"
                    End If

                    strSQL += Me.txtName.Text.ToString.Replace("'", "''") & "', '"
                    strSQL += Me.txtStreet.Text.ToString.Replace("'", "''") & "', '"
                    strSQL += Me.txtStreet2.Text.ToString.Replace("'", "''") & "', '"
                    strSQL += Me.txtCity.Text.ToString.Replace("'", "''") & "', "
                    strSQL += Me.cboStateID.SelectedValue & ", '"
                    strSQL += Me.txtZipCode.Text.ToString & "', '"
                    strSQL += Me.AccountNumber.Text.ToString & "', '"
                    strSQL += Me.CurrentBalance.Text.ToString & "', '"
                    strSQL += Me.txtPhoneNumber1.Text.ToString & "', '"
                    strSQL += Me.txtPhoneExtension1.Text.ToString & "', '"
                    strSQL += Now & "', "
                    strSQL += UserID & ", '"
                    strSQL += Now & "', "
                    strSQL += UserID & ")"
                Else
                    strSQL = "UPDATE tblLeadCreditorInstance SET "
                    strSQL += "Name = '" & Me.txtName.Text.ToString.Replace("'", "''") & "', "
                    strSQL += "Street = '" & Me.txtStreet.Text.ToString.Replace("'", "''") & "', "
                    strSQL += "Street2 = '" & Me.txtStreet2.Text.ToString.Replace("'", "''") & "', "
                    strSQL += "City = '" & Me.txtCity.Text.ToString.Replace("'", "''") & "', "
                    strSQL += "StateID = " & cboStateID.SelectedValue & ", "
                    strSQL += "ZipCode = '" & Me.txtZipCode.Text.ToString & "', "
                    strSQL += "AccountNumber = '" & Me.AccountNumber.Text.ToString & "', "
                    strSQL += "Balance = " & CInt(Me.CurrentBalance.Text) & ", "
                    strSQL += "Phone = '" & Me.txtPhoneNumber1.Text.ToString & "', "
                    strSQL += "Ext = '" & Me.txtPhoneExtension1.Text.ToString & "', "
                    strSQL += "Modified = '" & Now & "', "
                    strSQL += "ModifiedBy = " & UserID
                    strSQL += " WHERE leadCreditorInstance = " & crID
                End If

                cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
                If cmd.Connection.State = ConnectionState.Closed Then cmd.Connection.Open()
                cmd.ExecuteNonQuery()
            Else
                Throw New Exception("No applicant was choosen and therefore not notes can be created.")
            End If

        Catch ex As Exception

        End Try

        ClearAlltextBoxes()

        Page.ClientScript.RegisterStartupScript(Me.GetType, "close", "window.close();", True)
    End Sub

    Protected Sub cboCreditor_SelectedRowChanged(ByVal sender As Object, ByVal e As Infragistics.WebUI.WebCombo.SelectedRowChangedEventArgs) Handles cboCreditor.SelectedRowChanged
        Try

            txtName.Text = e.Row.Cells.FromKey("Name").Value
            txtStreet.Text = e.Row.Cells.FromKey("street").Value
            txtStreet2.Text = e.Row.Cells.FromKey("street2").Value
            txtCity.Text = StrConv(e.Row.Cells.FromKey("city").Value, VbStrConv.ProperCase)
            cboStateID.SelectedIndex = Me.cboStateID.Items.IndexOf(Me.cboStateID.Items.FindByValue(e.Row.Cells.FromKey("stateid").Value))
            txtZipCode.Text = e.Row.Cells.FromKey("zipcode").Value
        Catch ex As Exception
            Exit Sub
        End Try

    End Sub
End Class