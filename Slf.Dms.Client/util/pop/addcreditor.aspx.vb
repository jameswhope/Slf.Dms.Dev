Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data

Partial Class util_pop_addcreditor
    Inherits System.Web.UI.Page

#Region "Variables"

    Private UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Not IsPostBack Then

            LoadStates()
            LoadPhoneTypes()

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
    Private Sub LoadPhoneTypes()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblPhoneType ORDER BY [Name]"

        cboPhoneTypeID1.Items.Clear()
        cboPhoneTypeID2.Items.Clear()
        cboPhoneTypeID3.Items.Clear()

        cboPhoneTypeID1.Items.Add(New ListItem(String.Empty, 0))
        cboPhoneTypeID2.Items.Add(New ListItem(String.Empty, 0))
        cboPhoneTypeID3.Items.Add(New ListItem(String.Empty, 0))

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                cboPhoneTypeID1.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "PhoneTypeID")))
                cboPhoneTypeID2.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "PhoneTypeID")))
                cboPhoneTypeID3.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "PhoneTypeID")))

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        cboPhoneTypeID1.Items.FindByText("Business").Selected = True    'business
        cboPhoneTypeID2.Items.FindByText("Business").Selected = True    'business
        cboPhoneTypeID3.Items.FindByText("Business").Selected = True    'business

    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        Dim FixIt As String = txtName.Text

        If FixIt.Contains("&nbsp;") Then
            FixIt.Replace("&nbsp;", "")
            txtName.Text = FixIt
        End If

        ' insert creditor
        Dim CreditorID As Integer = CreditorHelper.InsertCreditor(txtName.Text, txtStreet.Text, _
            txtStreet2.Text, txtCity.Text, cboStateID.SelectedValue, txtZipCode.Text, UserID, -1)

        'save phone numbers
        Dim PhoneType1 As Integer = DataHelper.Nz_int(cboPhoneTypeID1.SelectedValue)
        Dim PhoneNumber1 As String = StringHelper.ApplyFilter(txtPhoneNumber1.Text, StringHelper.Filter.NumericOnly)
        Dim PhoneExtension1 As String = txtPhoneExtension1.Text

        Dim PhoneType2 As String = DataHelper.Nz_int(cboPhoneTypeID2.SelectedValue)
        Dim PhoneNumber2 As String = StringHelper.ApplyFilter(txtPhoneNumber2.Text, StringHelper.Filter.NumericOnly)
        Dim PhoneExtension2 As String = txtPhoneExtension2.Text

        Dim PhoneType3 As String = DataHelper.Nz_int(cboPhoneTypeID3.SelectedValue)
        Dim PhoneNumber3 As String = StringHelper.ApplyFilter(txtPhoneNumber3.Text, StringHelper.Filter.NumericOnly)
        Dim PhoneExtension3 As String = txtPhoneExtension3.Text

        If PhoneNumber1.Length > 0 Then

            Dim PhoneID As Integer = PhoneHelper.InsertPhone(PhoneType1, PhoneNumber1.Substring(0, 3), _
                PhoneNumber1.Substring(3), PhoneExtension1, UserID)

            CreditorHelper.InsertCreditorPhone(CreditorID, PhoneID, UserID)

        End If

        If PhoneNumber2.Length > 0 Then

            Dim PhoneID As Integer = PhoneHelper.InsertPhone(PhoneType2, PhoneNumber2.Substring(0, 3), _
                PhoneNumber2.Substring(3), PhoneExtension2, UserID)

            CreditorHelper.InsertCreditorPhone(CreditorID, PhoneID, UserID)

        End If

        If PhoneNumber3.Length > 0 Then

            Dim PhoneID As Integer = PhoneHelper.InsertPhone(PhoneType3, PhoneNumber3.Substring(0, 3), _
                PhoneNumber3.Substring(3), PhoneExtension3, UserID)

            CreditorHelper.InsertCreditorPhone(CreditorID, PhoneID, UserID)

        End If

        'flip the main panel off
        pnlMain.Visible = False
        pnlMessage.Visible = True

        Dim Name As String = txtName.Text

        If cboStateID.SelectedItem.Text.Length > 0 Then
            If txtCity.Text.Length > 0 Then
                Name += " - " & txtCity.Text & ", " & cboStateID.SelectedItem.Text
            Else
                Name += " - " & cboStateID.Text
            End If
        Else
            If txtCity.Text.Length > 0 Then
                Name += " - " & txtCity.Text
            End If
        End If

        ltrJScript.Text = "<script type=""text/javascript"">Record_Propagate(" _
            & CreditorID & ",""" & Name & """);window.close();</script>"

    End Sub
End Class