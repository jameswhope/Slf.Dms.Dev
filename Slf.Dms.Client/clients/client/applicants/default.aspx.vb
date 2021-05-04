Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic
Imports Slf.Dms.Controls

Partial Class clients_client_applicants_default
    Inherits PermissionPage

#Region "Variables"
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

    Public QueryString As String
    Private qs As QueryStringCollection
    Private baseTable As String = "tblClient"

    Private UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then

            SetRollups()

        End If
    End Sub

    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        PrepQuerystring()

        If Not qs Is Nothing Then

            If Not IsPostBack Then

                LoadApplicants()

                lnkClient.InnerText = ClientHelper.GetDefaultPersonName(DataClientID)
                lnkClient.HRef = "~/clients/client/" & QueryString

            End If

        End If

    End Sub
    Private Sub PrepQuerystring()

        'prep querystring for pages that need those variables
        QueryString = New QueryStringBuilder(Request.Url.Query).QueryString

        If QueryString.Length > 0 Then
            QueryString = "?" & QueryString
        End If

    End Sub
    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = Master.CommonTasks
        If Master.UserEdit() Then
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_AddApplicant();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_person_add.png") & """ align=""absmiddle""/>Add new applicant</a>")

            '3.24.09.ug
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_deleteuser.png") & """ align=""absmiddle""/>Cancel Client</a>")

        End If
    End Sub
    Private Sub LoadApplicants()

        Dim rp As Repeater
        Dim pnlNo As Panel
        If tdMain.Visible Then
            rp = rpApplicants
            pnlNo = pnlNoApplicants
        Else
            rp = rpApplicants_agency
            pnlNo = pnlNoApplicants_agency
        End If

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetPersonsForClient")

        DatabaseHelper.AddParameter(cmd, "ClientID", DataClientID)

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
                    DatabaseHelper.Peel_string(rd, "LastModifiedByName"), _
                    DatabaseHelper.Peel_bool(rd, "IsDeceased")))

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        If Applicants.Count > 0 Then

            rp.DataSource = Applicants
            rp.DataBind()

        End If

        rp.Visible = Applicants.Count > 0
        pnlNo.Visible = Applicants.Count = 0

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

        Dim Phones As List(Of Phone) = PersonHelper.GetPhones(e.Item.DataItem.PersonID)

        Dim EmailAddress As String = e.Item.DataItem.EmailAddress

        If Phones.Count > 0 Or EmailAddress.Length > 0 Then

            lblPhones.Text = "<table style=""table-layout:fixed;width:100%;font-family:tahoma;font-size:11;"" cellpadding=""1"" cellspacing=""0"" border=""0"">"

            If EmailAddress.Length > 0 Then

                lblPhones.Text += " <tr>" _
                    & "     <td style=""width:75;"">Email Address</td>" _
                    & "     <td style=""width:120;"">" & EmailAddress & "</td>" _
                    & " </tr>"

            End If

            For Each Phone As Phone In Phones

                lblPhones.Text += " <tr>" _
                    & "     <td style=""width:75;"">" & Phone.PhoneTypeName & "</td>" _
                    & "     <td style=""width:120; nowrap:nowrap;"" >" & Phone.NumberFormatted & "<img align=""absmiddle"" src=" & ResolveUrl("~/images/phone2.png") & " onclick=""make_call('" & Phone.NumberFormatted & "','" & ClientID & "'); return false;""/></td>" _
                    & " </tr>"

            Next

            lblPhones.Text += "</table>"

        Else
            lblPhones.Text = "<em>&lt;no contact information&gt;</em>"
        End If

    End Sub
    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click

        If txtSelected.Value.Length > 0 Then

            'get selected "," delimited PersonID's
            Dim Persons() As String = txtSelected.Value.Split(",")

            'build an actual integer array
            Dim PersonIDs As New List(Of Integer)

            For Each Person As String In Persons
                PersonIDs.Add(DataHelper.Nz_int(Person))
            Next

            'delete array of PersonID's
            PersonHelper.Delete(PersonIDs.ToArray(), UserID)

            'check client's primary
            If Not ClientHelper.HasDefaultPerson(DataClientID) Then 'prime was just deleted 
                ClientHelper.SetNextDefaultPerson(DataClientID, UserID)
            End If

        End If

        'reload same page (of applicants)
        Response.Redirect(Request.Url.AbsoluteUri)

    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(tdAgency, c, "Clients-Client Single Record-Applicants-Agency")
        AddControl(tdMain, c, "Clients-Client Single Record-Applicants-Default")
        AddControl(phDelete, c, "Clients-Client Single Record-Applicants-Default")
        AddControl(phSearch, c, "Client Search")

    End Sub
    Protected Sub lnkCancelClient_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelClient.Click
        Response.Redirect("~/clients/client/cancellation/?id=" & DataClientID)
    End Sub
End Class