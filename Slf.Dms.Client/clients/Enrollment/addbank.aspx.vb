Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.Data.SqlClient
Imports System.Data

Partial Class Enrollment_addbank
    Inherits System.Web.UI.Page

#Region "Variables"

    Private UserID As Integer
    Private a As Boolean
    Private aID As Integer = 0
    Private bID As Integer = 0
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        Integer.TryParse(Request.QueryString("id"), aID)
        Integer.TryParse(Request.QueryString("bID"), bID)

        'Are we adding a new record?
        If aID > 0 And bID = 0 Then
            a = True
        End If

        If Not IsPostBack Then
            LoadStates()
            LoadData(bID)
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

    Private Sub LoadData(Optional ByVal bankID As Integer = 0)
        Dim strSQL As String
        Dim cmd As SqlCommand
        Dim rdr As SqlDataReader

        'Setup the call
        If bankID <> 0 Then
            strSQL = "SELECT * FROM tblLeadBanks WHERE LeadBankID = " & bankID
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
                Me.txtName.Text = rdr.Item("BankName").ToString
                Me.txtStreet.Text = rdr.Item("Street").ToString
                Me.txtStreet2.Text = rdr.Item("Street2").ToString
                Me.txtCity.Text = rdr.Item("City").ToString
                Me.cboStateID.SelectedIndex = Me.cboStateID.Items.IndexOf(Me.cboStateID.Items.FindByValue(rdr.Item("StateID")))
                Me.txtZipCode.Text = rdr.Item("ZipCode").ToString
                Me.txtPhoneExtension1.Text = rdr.Item("Extension").ToString
                Me.txtPhoneNumber1.Text = rdr.Item("PhoneNumber").ToString
                Me.AccountNumber.Text = rdr.Item("AccountNumber").ToString
                Me.RoutingNumber.Text = rdr.Item("RoutingNumber").ToString
                radAcctType.SelectedIndex = System.Math.Abs(CInt(rdr.Item("Checking")))
                If rdr.Item("ACH") Then
                    radDepositTypeList.SelectedIndex = 0
                Else
                    radDepositTypeList.SelectedIndex = 1
                End If
                EnableValidators()
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
        Me.RoutingNumber.Text = ""
        Me.txtPhoneNumber1.Text = ""
        Me.txtPhoneExtension1.Text = ""
        radAcctType.SelectedIndex = -1
        EnableValidators()

    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAddBank.Click
        Dim objClient As New WCFClient.Store
        Dim strSQL As String
        Dim cmd As SqlCommand
        lblInvalidRouting.Text = ""
        lblInvalidAccType.Text = ""
        Try
            If aID > 0 Or bID > 0 Then 'we have an applicant so we can do this
                If radDepositTypeList.SelectedIndex = 0 AndAlso Not objClient.RoutingIsValid(RoutingNumber.Text, Nothing) Then
                    lblInvalidRouting.Text = "Invalid routing number."
                    Return
                End If

                If radAcctType.SelectedIndex < 0 Then
                    lblInvalidAccType.Text = "The account type is required."
                    Return
                End If

                If a Then
                    strSQL = "INSERT INTO tblLeadBanks (LeadApplicantID, bankid, BankName, Street, Street2, City, StateID, ZipCode, AccountNumber, RoutingNumber, PhoneNumber, Extension, Checking, Created, CreatedByID, LastModified, LastModifiedByID, ACH) "
                    strSQL += "VALUES ("
                    strSQL += aID & ",-1, '"
                    strSQL += Me.txtName.Text.ToString & "', '"
                    strSQL += Me.txtStreet.Text.ToString & "', '"
                    strSQL += Me.txtStreet2.Text.ToString & "', '"
                    strSQL += Me.txtCity.Text.ToString & "', "
                    strSQL += Me.cboStateID.SelectedValue & ", '"
                    strSQL += Me.txtZipCode.Text.ToString & "', '"
                    strSQL += Me.AccountNumber.Text.ToString & "', '"
                    strSQL += Me.RoutingNumber.Text.ToString & "', '"
                    strSQL += Me.txtPhoneNumber1.Text.ToString & "', '"
                    strSQL += Me.txtPhoneExtension1.Text.ToString & "', "
                    strSQL += radAcctType.SelectedIndex & ", '"
                    strSQL += Now & "', "
                    strSQL += UserID & ", '"
                    strSQL += Now & "', "
                    strSQL += UserID & ", "
                    strSQL += IIf(radDepositTypeList.SelectedIndex = 0, 1, 0) & ")"
                Else
                    strSQL = "UPDATE tblLeadBanks SET "
                    strSQL += "BankName = '" & Me.txtName.Text.ToString & "', "
                    strSQL += "Street = '" & Me.txtStreet.Text.ToString & "', "
                    strSQL += "Street2 = '" & Me.txtStreet2.Text.ToString & "', "
                    strSQL += "City = '" & Me.txtCity.Text.ToString & "', "
                    strSQL += "StateID = " & cboStateID.SelectedValue & ", "
                    strSQL += "ZipCode = '" & Me.txtZipCode.Text.ToString & "', "
                    strSQL += "AccountNumber = '" & Me.AccountNumber.Text.ToString & "', "
                    strSQL += "RoutingNumber = '" & Me.RoutingNumber.Text.ToString & "', "
                    strSQL += "PhoneNumber = '" & Me.txtPhoneNumber1.Text.ToString & "', "
                    strSQL += "Extension = '" & Me.txtPhoneExtension1.Text.ToString & "', "
                    strSQL += "Checking = " & radAcctType.SelectedIndex & ", "
                    strSQL += "LastModified = '" & Now & "', "
                    strSQL += "LastModifiedByID = " & UserID & ","
                    strSQL += "ACH = " & IIf(radDepositTypeList.SelectedIndex = 0, 1, 0)
                    strSQL += " WHERE LeadBankID = " & bID
                End If

                cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
                If cmd.Connection.State = ConnectionState.Closed Then cmd.Connection.Open()
                cmd.ExecuteNonQuery()

                ClearAlltextBoxes()

                Page.ClientScript.RegisterStartupScript(Me.GetType, "close", "window.close();", True)
            Else
                Throw New Exception("No applicant was choosen and therefore not notes can be created.")
            End If
        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try
    End Sub

    Protected Sub radDepositTypeList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles radDepositTypeList.SelectedIndexChanged
        EnableValidators()
    End Sub

    Private Sub EnableValidators()
        Me.RequiredFieldValidator1.Enabled = (radDepositTypeList.SelectedIndex = 0)
        Me.RequiredFieldValidator2.Enabled = (radDepositTypeList.SelectedIndex = 0)
    End Sub
End Class