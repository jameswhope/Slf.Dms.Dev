Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Text
Imports System.Data
Imports System.Collections.Generic

Partial Class tasks_workflows_4
    Inherits System.Web.UI.UserControl

#Region "Variables"

    Private TaskID As Integer
    Private Resolved As Boolean
    Private Shadows ClientID As Integer
    Private qs As QueryStringCollection
    Private baseTable As String = "tblTask"

    Private UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            TaskID = DataHelper.Nz_int(qs("id"), 0)

            ClientID = TaskHelper.GetClients(TaskID)(0)

            If Not IsPostBack Then

                LoadTaskResolutions()
                LoadRecord()

                Dim ResolvedDate As String = DataHelper.FieldLookup("tblTask", "Resolved", "TaskID = " & TaskID)

                Resolved = (Not ResolvedDate Is Nothing AndAlso ResolvedDate.Length > 0)

                LoadApplicants()

                SetAttributes()

            End If

        End If

    End Sub
    Private Sub SetAttributes()

    End Sub
    Private Sub LoadApplicants()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetPersonsForClient")

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

        Dim Applicants As New List(Of Person)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                Applicants.Add(New Person(DatabaseHelper.Peel_int(rd, "PersonID"), _
                    DatabaseHelper.Peel_int(rd, "ClientID"), _
                    DatabaseHelper.Peel_string(rd, "SSN"), _
                    DatabaseHelper.Peel_string(rd, "FirstName"), _
                    DatabaseHelper.Peel_string(rd, "LastName"), _
                    DatabaseHelper.Peel_string(rd, "Gender"), _
                    DatabaseHelper.Peel_ndate(rd, "DateOfBirth"), _
                    DatabaseHelper.Peel_int(rd, "LanguageID"), _
                    DatabaseHelper.Peel_string(rd, "LanguageName"), _
                    DatabaseHelper.Peel_string(rd, "EmailAddress"), _
                    DatabaseHelper.Peel_string(rd, "Street"), _
                    DatabaseHelper.Peel_string(rd, "Street2"), _
                    DatabaseHelper.Peel_string(rd, "City"), _
                    DatabaseHelper.Peel_int(rd, "StateID"), _
                    DatabaseHelper.Peel_string(rd, "StateName"), _
                    DatabaseHelper.Peel_string(rd, "StateAbbreviation"), _
                    DatabaseHelper.Peel_string(rd, "ZipCode"), _
                    DatabaseHelper.Peel_string(rd, "Relationship"), _
                    DatabaseHelper.Peel_bool(rd, "CanAuthorize"), _
                    DatabaseHelper.Peel_bool(rd, "ThirdParty"), _
                    DatabaseHelper.Peel_date(rd, "Created"), _
                    DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                    DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                    DatabaseHelper.Peel_date(rd, "LastModified"), _
                    DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                    DatabaseHelper.Peel_string(rd, "LastModifiedByName")))

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        If Applicants.Count > 0 Then

            rpApplicants.DataSource = Applicants
            rpApplicants.DataBind()

        End If

        rpApplicants.Visible = Applicants.Count > 0
        pnlNoApplicants.Visible = Applicants.Count = 0

    End Sub
    Private Sub LoadRecord()

        lnkClientName.HRef = ResolveUrl("~/clients/client/?id=") & ClientID
        lnkClientName.InnerHtml += ClientHelper.GetDefaultPersonName(ClientID)

        lnkUnderwritingWorksheet.HRef = ResolveUrl("~/clients/client/underwriting.aspx?id=") & ClientID

    End Sub
    Private Sub LoadTaskResolutions()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblTaskResolution"

        cboTaskResolutionID.Items.Clear()

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboTaskResolutionID.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "TaskResolutionID")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""idonly""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function
    Protected Sub rpApplicants_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rpApplicants.ItemDataBound

        Dim lblPhones As Label = CType(e.Item.FindControl("lblPhones"), Label)

        Dim PersonID As Integer = DataHelper.Nz_int(e.Item.DataItem.PersonID)

        Dim Phones As List(Of Phone) = PersonHelper.GetPhones(PersonID)

        If Phones.Count > 0 Then

            lblPhones.Text = "<table style=""table-layout:fixed;width:100%;font-family:tahoma;font-size:11;"" cellpadding=""1"" cellspacing=""0"" border=""0"">"

            For Each Phone As Phone In Phones

                lblPhones.Text += " <tr>" _
                    & "     <td style=""width:75;"">" & Phone.PhoneTypeName & "</td>" _
                    & "     <td style=""width:120;"">" & Phone.NumberFormatted & "</td>" _
                    & " </tr>"

            Next

            lblPhones.Text += "</table>"

        Else
            lblPhones.Text = "<em>&lt;no contact information&gt;</em>"
        End If

    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Save(True)
    End Sub
    Private Sub Save(ByVal Resolving As Boolean)

        ''get associated client
        'Dim ClientID As Integer = TaskHelper.GetClients(TaskID)(0)

        ''check and fix account number
        'If AccountNumberExists(txtSDAAccountNumber.Text, ClientID) Then

        '    CType(Page, tasks_task_resolve).Control_dvError.Style("display") = "inline"
        '    CType(Page, tasks_task_resolve).Control_tdError.InnerHtml = "The Account Number you entered is already in use."

        'Else

        '    'save client info
        '    UpdateClient(ClientID)

        '    'clean up applicant info
        '    DeletePersons()
        '    UpdatePersons()
        '    InsertPersons(ClientID)

        '    'create all accounts
        '    DeleteAccounts()
        '    UpdateAccounts(ClientID)


        '    'get a new account number and update the properties table
        '    If txtSDAAccountNumber.Text.Length > 0 Then
        '        PropertyHelper.Update("AccountNumberValue", GetNextAccountNumber(txtSDAAccountNumber.Text), UserID)
        '    End If

        '    If Resolving Then

        '        If chkCollectSetupFee.Checked Then

        '            Dim Amount As Double = DataHelper.Nz_double(txtSetupFee.Text)

        '            Amount = Amount - (Amount * 2) 'make it negative

        '            'insert setup fee
        '            RegisterHelper.Insert(ClientID, Now, Nothing, Amount, 0, 2)

        '            'run the payment manager
        '            PaymentManager.ExecuteClient(ClientID)

        '        End If

        '    End If

        '    CType(Page, tasks_task_resolve).ReturnToReferrer()

        'End If

    End Sub
End Class