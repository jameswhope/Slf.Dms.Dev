Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_applicants_applicant
    Inherits EntityPage

#Region "Variables"
    Public ReadOnly Property UserEdit() As Boolean
        Get
            Return Permission.UserEdit(Master.IsMy) And Master.UserEdit
        End Get
    End Property
    Public ReadOnly Property DataClientID() As Integer
        Get
            Return Master.DataClientID
        End Get
    End Property
    Public Shadows ReadOnly Property ClientID() As Integer
        Get
            Return DataClientID
        End Get
    End Property

    Private Action As String
    Private PersonID As Integer
    Private qs As QueryStringCollection

    Private UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            PersonID = DataHelper.Nz_int(qs("pid"), 0)
            Action = DataHelper.Nz_string(qs("a"))

            If Not IsPostBack Then
                HandleAction()
            End If

        End If

        'Me.cboStateID.Attributes.Add("onChange", "NotStates();") 'jhope 10/21/2009

    End Sub
    Private Sub HandleAction()

        LoadLanguages()
        LoadStates()
        LoadPhoneTypes(cboPhoneType, 0)

        SetAttributes()

        Dim CommonTasks As List(Of String) = Master.CommonTasks

        'add applicant tasks
        If UserEdit() Then
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save this applicant</a>")
        End If

        Select Case Action
            Case "a"    'add

                lblPerson.Text = "Add New Applicant"

                trInfoBox.Visible = False

            Case Else   'edit
                If Permission.UserDelete(Master.IsMy) And Master.UserEdit Then
                    'add delete task
                    CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_DeleteConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_delete.png") & """ align=""absmiddle""/>Delete this applicant</a>")
                End If
                LoadRecord()
                LoadPhones()

                lblPerson.Text = PersonHelper.GetName(PersonID)

        End Select


        'check if client has a primary
        If ClientHelper.HasDefaultPerson(DataClientID) Then

            'check if this person is that primary
            If ClientHelper.GetDefaultPerson(DataClientID) = PersonID Then

                'don't show co-applicant information / this is the primary
                pnlCoapplicantInformation.Visible = False
                lnkSetPrimary.Visible = False

            Else 'has primary, but not this person

                'show co-applicant information / this is not the primary
                pnlCoapplicantInformation.Visible = True

                If Permission.UserEdit(Master.IsMy) Then
                    lnkSetPrimary.Visible = True

                    'add 'make primary' task
                    CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_SetAsPrimary();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_person.png") & """ align=""absmiddle""/>Set as primary</a>")
                End If

                LoadPrimaryAddress()

            End If

        Else 'no primary

            'don't show co-applicant information / this is or will be the primary
            pnlCoapplicantInformation.Visible = False
            lnkSetPrimary.Visible = False

        End If

        'add normal tasks
        If UserEdit Then
            CommonTasks.Add("<hr size=""1""/>")
        End If

        lnkClient.InnerText = ClientHelper.GetDefaultPersonName(DataClientID)
        lnkClient.HRef = "~/clients/client/?id=" & DataClientID
        lnkPersons.HRef = "~/clients/client/applicants/?id=" & DataClientID

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
    Private Sub LoadLanguages()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblLanguage ORDER BY [Default] DESC, [Name]"

        cboLanguageID.Items.Clear()

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboLanguageID.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "LanguageID")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadRecord()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblPerson WHERE PersonID = @PersonID"

        DatabaseHelper.AddParameter(cmd, "PersonID", PersonID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                txtSSN.Text = DatabaseHelper.Peel_string(rd, "SSN")
                txtFirstName.Text = DatabaseHelper.Peel_string(rd, "FirstName")
                txtLastName.Text = DatabaseHelper.Peel_string(rd, "LastName")
                txtDateOfBirth.Text = DatabaseHelper.Peel_datestring(rd, "DateOfBirth")
                ListHelper.SetSelected(cboGender, DatabaseHelper.Peel_string(rd, "Gender"))
                ListHelper.SetSelected(cboLanguageID, DatabaseHelper.Peel_int(rd, "LanguageID"))
                txtEmailAddress.Text = DatabaseHelper.Peel_string(rd, "EmailAddress")

                If DatabaseHelper.Peel_bool(rd, "IsDeceased") = True Then
                    rblDeceased.SelectedIndex = 1
                Else
                    rblDeceased.SelectedIndex = 0
                End If


                txtStreet.Text = DatabaseHelper.Peel_string(rd, "Street")
                txtStreet2.Text = DatabaseHelper.Peel_string(rd, "Street2")
                txtCity.Text = DatabaseHelper.Peel_string(rd, "City")
                ListHelper.SetSelected(cboStateID, DatabaseHelper.Peel_int(rd, "StateID"))
                txtZipCode.Text = DatabaseHelper.Peel_string(rd, "ZipCode")

                chkThirdParty.Checked = DatabaseHelper.Peel_bool(rd, "ThirdParty")

                If Not DatabaseHelper.Peel_string(rd, "Relationship") = "Prime" Then
                    optRelationship.SelectedValue = DatabaseHelper.Peel_string(rd, "Relationship")
                End If

                Dim DisplayInfoBox As Boolean = DataHelper.FieldCount("tblUserInfoBox", "UserInfoBoxID", _
                    "UserID = " & UserID & " AND InfoBoxID = " & 6) = 0

                If DisplayInfoBox And DatabaseHelper.Peel_string(rd, "WebZipCode").Length > 0 Then

                    lblWebAreaCode.Text = DatabaseHelper.Peel_string(rd, "WebAreaCode")

                    Dim WebTimeZoneID As Integer = DatabaseHelper.Peel_int(rd, "WebTimeZoneID")

                    lblWebTimeZone.Text = DataHelper.FieldLookup("tblTimeZone", "Name", "TimeZoneID = " & WebTimeZoneID)

                    lblLocalTime.Text = TimeZoneHelper.GetLocalTime(PersonID).ToString("M/d/yyyy hh:mm tt")

                Else
                    trInfoBox.Visible = False
                End If

            End If

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadPrimaryAddress()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblPerson WHERE PersonID = @PersonID"

        DatabaseHelper.AddParameter(cmd, "PersonID", ClientHelper.GetDefaultPerson(DataClientID))

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                lblStreet.Text = DatabaseHelper.Peel_string(rd, "Street")
                lblStreet2.Text = DatabaseHelper.Peel_string(rd, "Street2")
                lblCity.Text = DatabaseHelper.Peel_string(rd, "City")
                lblState.Text = DatabaseHelper.Peel_int(rd, "StateID")
                lblZipCode.Text = DatabaseHelper.Peel_string(rd, "ZipCode")

            End If

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadPhones()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetPhonesForPerson")

        DatabaseHelper.AddParameter(cmd, "PersonID", PersonID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            Dim Phone As String = String.Empty

            While rd.Read()

                Dim PhoneTypeID As Integer = DatabaseHelper.Peel_int(rd, "PhoneTypeID")
                Dim AreaCode As String = DatabaseHelper.Peel_string(rd, "AreaCode")
                Dim Number As String = DatabaseHelper.Peel_string(rd, "Number")
                Dim Extension As String = DatabaseHelper.Peel_string(rd, "Extension")

                Dim row As New HtmlTableRow()

                Dim cellDelete As New HtmlTableCell()
                Dim cellPhoneType As New HtmlTableCell()
                Dim cellPhoneNumber As New HtmlTableCell()
                Dim cellPhoneNumberExt As New HtmlTableCell()

                cellDelete.InnerHtml = "<a href=""#"" onclick=""Record_DeletePhone(this);return false;""><img src=""" & ResolveUrl("~/images/16x16_delete.png") & """ border=""0"" align=""absmiddle""/></a>"
                cellPhoneType.Controls.Add(GetNewPhoneTypeDDL(PhoneTypeID))
                cellPhoneNumber.NoWrap = True
                Dim imask As AssistedSolutions.WebControls.InputMask = GetNewPhoneNumberIM(AreaCode & Number)
                imask.Width = New Unit("90%")
                cellPhoneNumber.Controls.Add(imask)
                Dim imgPhone As New HtmlImage
                imgPhone.Src = ResolveUrl("~/images/phone2.png")
                imgPhone.Attributes.Add("onclick", String.Format("make_call('{0}','{1}');", AreaCode & Number, ClientID))
                imgPhone.Style.Add("cursor", "hand")
                cellPhoneNumber.Controls.Add(imgPhone)
                cellPhoneNumberExt.Controls.Add(GetNewPhoneNumberExtTXT(Extension))

                cellDelete.Attributes("class") = "listItem2"
                cellDelete.Style("width") = "16"
                cellPhoneType.Attributes("class") = "listItem2"
                cellPhoneNumber.Attributes("class") = "listItem2"
                cellPhoneNumberExt.Attributes("class") = "listItem2"

                row.Cells.Add(cellDelete)
                row.Cells.Add(cellPhoneType)
                row.Cells.Add(cellPhoneNumber)
                row.Cells.Add(cellPhoneNumberExt)

                tblPhones.Rows.Add(row)

            End While

            txtPhones.Value = Phone

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Function GetNewPhoneTypeDDL(ByVal PhoneTypeID As Integer) As DropDownList

        GetNewPhoneTypeDDL = New DropDownList

        GetNewPhoneTypeDDL.CssClass = "entry"

        LoadPhoneTypes(GetNewPhoneTypeDDL, PhoneTypeID)

    End Function
    Private Function GetNewPhoneNumberIM(ByVal Value As String) As AssistedSolutions.WebControls.InputMask

        GetNewPhoneNumberIM = New AssistedSolutions.WebControls.InputMask

        GetNewPhoneNumberIM.CssClass = "entry"
        GetNewPhoneNumberIM.Mask = "(nnn) nnn-nnnn"
        GetNewPhoneNumberIM.Text = Value

    End Function
    Private Function GetNewPhoneNumberExtTXT(ByVal Value As String) As TextBox

        GetNewPhoneNumberExtTXT = New AssistedSolutions.WebControls.InputMask

        GetNewPhoneNumberExtTXT.CssClass = "entry"
        GetNewPhoneNumberExtTXT.Text = Value

    End Function
    Private Sub LoadPhoneTypes(ByRef cboPhoneType As DropDownList, ByVal SelectedPhoneTypeID As Integer)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblPhoneType ORDER BY [Name]"

        cboPhoneType.Items.Clear()

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboPhoneType.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "PhoneTypeID")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        ListHelper.SetSelected(cboPhoneType, SelectedPhoneTypeID)

    End Sub
    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""clients_client_applicants_applicant_default""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function
    Private Sub Close()
        Response.Redirect("~/clients/client/applicants/?id=" & DataClientID)
    End Sub
    Private Function InsertOrUpdatePerson() As Integer

        Dim id As Integer = ListHelper.GetSelected(cboStateID)

        'If id = "1" Or id = "34" Or id = "42" Then
        '    Response.Write("<script>alert('We can not take new clients from AL, NC or SC any longer. This client will not be saved.');</script>")
        '    Return 0
        'End If

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "SSN", DataHelper.Zn(txtSSN.TextUnMasked))
        DatabaseHelper.AddParameter(cmd, "FirstName", txtFirstName.Text)
        DatabaseHelper.AddParameter(cmd, "LastName", txtLastName.Text)

        If cboGender.SelectedValue Is Nothing OrElse cboGender.SelectedValue.Length = 0 Then

            Dim Gender As String = NameHelper.GetGender(txtFirstName.Text)

            If Gender.Length > 0 Then
                DatabaseHelper.AddParameter(cmd, "Gender", Gender.Substring(0, 1).ToUpper())
            Else
                DatabaseHelper.AddParameter(cmd, "Gender", DBNull.Value)
            End If

        Else
            DatabaseHelper.AddParameter(cmd, "Gender", cboGender.SelectedValue)
        End If

        DatabaseHelper.AddParameter(cmd, "DateOfBirth", DataHelper.Zn(txtDateOfBirth.Text))
        DatabaseHelper.AddParameter(cmd, "LanguageID", ListHelper.GetSelected(cboLanguageID))
        DatabaseHelper.AddParameter(cmd, "EmailAddress", DataHelper.Zn(txtEmailAddress.Text))

        DatabaseHelper.AddParameter(cmd, "Street", txtStreet.Text)
        DatabaseHelper.AddParameter(cmd, "Street2", DataHelper.Zn(txtStreet2.Text))
        DatabaseHelper.AddParameter(cmd, "City", txtCity.Text)
        DatabaseHelper.AddParameter(cmd, "StateID", ListHelper.GetSelected(cboStateID))
        DatabaseHelper.AddParameter(cmd, "ZipCode", txtZipCode.Text)
        DatabaseHelper.AddParameter(cmd, "IsDeceased", rblDeceased.SelectedItem.Value)

        DatabaseHelper.AddParameter(cmd, "CanAuthorize", True)

        'try-retrieve the web service info
        If txtZipCode.Text.Trim.Length >= 5 Then

            Dim WebInfo As AddressHelper.AddressInfo = AddressHelper.GetInfoForZip(txtZipCode.Text.Trim.Substring(0, 5))

            If Not WebInfo Is Nothing AndAlso WebInfo.ZipCode.Length > 0 Then

                DatabaseHelper.AddParameter(cmd, "WebCity", WebInfo.City)
                DatabaseHelper.AddParameter(cmd, "WebStateID", WebInfo.StateID)
                DatabaseHelper.AddParameter(cmd, "WebZipCode", WebInfo.ZipCode)
                DatabaseHelper.AddParameter(cmd, "WebAreaCode", WebInfo.AreaCode)
                DatabaseHelper.AddParameter(cmd, "WebTimeZoneID", WebInfo.TimeZoneID)

            End If

        End If

        If pnlCoapplicantInformation.Visible Then 'is NOT primary

            DatabaseHelper.AddParameter(cmd, "Relationship", optRelationship.SelectedValue)
            DatabaseHelper.AddParameter(cmd, "ThirdParty", chkThirdParty.Checked)

        Else 'IS the primary

            DatabaseHelper.AddParameter(cmd, "Relationship", "Prime")
            DatabaseHelper.AddParameter(cmd, "ThirdParty", False)

        End If

        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

        If Action = "a" Then 'add

            DatabaseHelper.AddParameter(cmd, "ClientID", DataClientID)

            DatabaseHelper.AddParameter(cmd, "Created", Now)
            DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)

            DatabaseHelper.BuildInsertCommandText(cmd, "tblPerson", "PersonID", SqlDbType.Int)

            Try
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()
            Finally
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Try

        Else 'edit
            DataHelper.AuditedUpdate(cmd, "tblPerson", PersonID, UserID)
        End If



        If Action = "a" Then 'add
            PersonID = DataHelper.Nz_int(cmd.Parameters("@PersonID").Value)
        End If

        Return PersonID

    End Function
    Private Sub InsertPhones()

        If txtPhones.Value.Length > 0 Then

            Dim Phones() As String = txtPhones.Value.Split("|")

            For Each Phone As String In Phones

                Dim Parts() As String = Phone.Split(",")

                Dim Number As String = StringHelper.ApplyFilter(Parts(1), StringHelper.Filter.NumericOnly)

                Dim PhoneID As Integer = InsertPhone(Integer.Parse(Parts(0)), Number.Substring(0, 3), Number.Substring(3), Parts(2))

                InsertPersonPhone(PhoneID)

            Next

        End If

    End Sub
    Private Function InsertPhone(ByVal PhoneTypeID As Integer, ByVal AreaCode As String, ByVal Number As String, ByVal Extension As String) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "PhoneTypeID", PhoneTypeID)
        DatabaseHelper.AddParameter(cmd, "AreaCode", AreaCode)
        DatabaseHelper.AddParameter(cmd, "Number", Number)
        DatabaseHelper.AddParameter(cmd, "Extension", DataHelper.Zn(Extension))

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblPhone", "PhoneID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@PhoneID").Value)

    End Function
    Private Function InsertPersonPhone(ByVal PhoneID As Integer) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "PersonID", PersonID)
        DatabaseHelper.AddParameter(cmd, "PhoneID", PhoneID)

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblPersonPhone", "PersonPhoneID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@PersonPhoneID").Value)

    End Function
    Private Sub DeletePhones()

        'run through each and delete phone
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblPersonPhone WHERE PersonID = @PersonID"

        DatabaseHelper.AddParameter(cmd, "PersonID", PersonID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                DataHelper.Delete("tblPhone", "PhoneID = " & DatabaseHelper.Peel_int(rd, "PhoneID"))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        'then remove all personphone records
        DataHelper.Delete("tblPersonPhone", "PersonID = " & PersonID)

    End Sub
    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        Save()

        If Action = "a" Then 'new record was just added

            If Not ClientHelper.HasDefaultPerson(DataClientID) Then
                ClientHelper.UpdateField(DataClientID, "PrimaryPersonID", PersonID, UserID)
            End If

        End If

        Close()

    End Sub
    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click

        'delete applicant
        PersonHelper.Delete(PersonID, UserID)

        'check client's primary
        If Not ClientHelper.HasDefaultPerson(DataClientID) Then 'prime was just deleted 
            ClientHelper.SetNextDefaultPerson(DataClientID, UserID)
        End If

        'drop back to applicants
        Close()

    End Sub
    Protected Sub lnkSetAsPrimary_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSetAsPrimary.Click

        'save record, just in case changes were made
        Save()

        'flip this person to be primary
        PersonHelper.SetAsPrimary(PersonID, DataClientID, UserID)

        'drop back to applicants
        Close()

    End Sub
    Private Sub Save()

        'save record
        InsertOrUpdatePerson()

        'remove all phones
        DeletePhones()

        're-add all phones
        InsertPhones()

    End Sub
    Protected Sub lnkCloseInformation_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCloseInformation.Click

        'insert flag record
        UserInfoBoxHelper.Insert(6, UserID)

        'reload
        Response.Redirect(Request.Url.AbsoluteUri)

    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))

    End Sub

    Public Overrides ReadOnly Property BaseQueryString() As String
        Get
            Return "pid"
        End Get
    End Property

    Public Overrides ReadOnly Property BaseTable() As String
        Get
            Return "tblPerson"
        End Get
    End Property

End Class