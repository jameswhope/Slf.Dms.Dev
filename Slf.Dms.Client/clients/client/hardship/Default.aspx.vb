Imports System.Collections.Generic
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.Data
Imports Drg.Util.Helpers
Imports GridViewHelper
Imports System.IO
Imports System.Text
Imports System.Drawing
Imports System.Drawing.Printing
Imports Slf.Dms.Controls
Imports SharedFunctions
Imports GrapeCity.ActiveReports.Export.Pdf

Partial Class Clients_Hardsip
    Inherits PermissionPage

#Region "Variables"
    Private UserID As Integer
    Private UserTypeID As Integer
    Public DataClientID As Integer
    Public QueryString As String
    Private qs As QueryStringCollection
#End Region
#Region "Events"
    Protected Sub Clients_client_cancellation_Default_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        Session("UserID") = UserID
        UserTypeID = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserTypeId", "UserId=" & UserID))
        DataClientID = Request.QueryString("id")
        Session("DataClientID") = DataClientID

        qs = LoadQueryString()
        PrepQuerystring()

        If Not IsPostBack Then
            LoadPrimaryPerson()
            LoadGeneralInfo()

            '4.6.09.ug
            'register common tasks hrefs dummy buttons with script manager
            Dim sm As ScriptManager = ScriptManager.GetCurrent(Me)
            sm.RegisterAsyncPostBackControl(lnkSave)
            sm.RegisterAsyncPostBackControl(lnkCancel)

            SetupPermissions()

            hardshipControl1.CreatedBy = UserID
            hardshipControl1.DataClientID = DataClientID
            hardshipControl1.LoadHardshipData()
        End If

        SetRollups()


    End Sub
    Protected Sub lnkCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancel.Click
        Response.Redirect("~/clients/client/?id=" & DataClientID)
    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        '4.6.09.ug
        'call formview crud actions
        hardshipControl1.SaveHardshipData()

    End Sub

#End Region
#Region "Utilities"
    Private Sub PrepQuerystring()

        'prep querystring for pages that need those variables
        QueryString = New QueryStringBuilder(Request.Url.Query).QueryString

        If QueryString.Length > 0 Then
            QueryString = "?" & QueryString
        End If

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
    Private Sub LoadPrimaryPerson()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblPerson WHERE PersonID = @PersonID"

        DatabaseHelper.AddParameter(cmd, "PersonID", ClientHelper.GetDefaultPerson(DataClientID))

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                Dim SSN As String = DatabaseHelper.Peel_string(rd, "SSN")

                Dim StateID As Integer = DatabaseHelper.Peel_int(rd, "StateID")

                Dim State As String = DataHelper.FieldLookup("tblState", "Name", "StateID = " & StateID)
                Dim AccountNumber As String = DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " & DataClientID)

                Dim DOB As String = DatabaseHelper.Peel_date(rd, "DateOfBirth")

                lnkName.Text = PersonHelper.GetName(DatabaseHelper.Peel_string(rd, "FirstName"), _
                 DatabaseHelper.Peel_string(rd, "LastName"), _
                 DatabaseHelper.Peel_string(rd, "SSN"), _
                 DatabaseHelper.Peel_string(rd, "EmailAddress"))

                lblAddress.Text = PersonHelper.GetAddress(DatabaseHelper.Peel_string(rd, "Street"), _
                 DatabaseHelper.Peel_string(rd, "Street2"), _
                 DatabaseHelper.Peel_string(rd, "City"), State, _
                 DatabaseHelper.Peel_string(rd, "ZipCode")).Replace(vbCrLf, "<br>")

                If SSN.Length > 0 Then
                    lblSSN.Text = "SSN: " & StringHelper.PlaceInMask(SSN, "___-__-____", "_", StringHelper.Filter.NumericOnly) & "<br>"
                End If

                If AccountNumber.Length > 0 Then
                    lblAccountNumber.Text = AccountNumber & "<br>"
                End If

                If DOB.Length > 0 Then
                    lblClientDOB.Text = "Client DOB : " & DOB '& "<br>"
                End If

            Else
                lnkName.Text = "No Applicant"
                lblAddress.Text = "No Address"
            End If

            lnkStatus.Text = ClientHelper.GetStatus(DataClientID)
            lnkStatus_ro.Text = lnkStatus.Text

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Dim NumApplicants As Integer = DataHelper.FieldCount("tblPerson", "PersonID", "ClientID = " & DataClientID)

        If NumApplicants > 1 Then
            lnkNumApplicants.InnerText = "(" & NumApplicants & ")"
            lnkNumApplicants.HRef = "~/clients/client/applicants/" & QueryString
        End If

    End Sub
    Private Sub LoadGeneralInfo()
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.CommandText = "SELECT * FROM tblClient WHERE ClientID = @ClientID"

            DatabaseHelper.AddParameter(cmd, "ClientID", DataClientID)

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleRow)

                    If rd.Read Then

                        Dim AgencyId As Integer = DatabaseHelper.Peel_int(rd, "AgencyId")
                        Dim CompanyId As Integer = DatabaseHelper.Peel_int(rd, "CompanyId")

                        lblCompany.Text = DataHelper.FieldLookup("tblCompany", "Name", "CompanyId=" & CompanyId)

                    End If
                End Using
            End Using
        End Using

        Dim LeadNumber As String = DataHelper.Nz_string(DataHelper.FieldLookup("tblAgencyExtraFields01", "LeadNumber", "ClientId=" & DataClientID))
        If Not String.IsNullOrEmpty(LeadNumber) Then lblLeadNumber.Text = "Lead Number: " & LeadNumber & "<br>"
    End Sub
    Private Sub SetRollups()
        Dim CommonTasks As List(Of String) = Master.CommonTasks
        If Master.UserEdit Then
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Hardship_Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save Form</a>")
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Hardship_Cancel();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_close.png") & """ align=""absmiddle""/>Exit</a>")
        End If

    End Sub
#End Region
#Region "Permission Stuff"
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(Me.hardshipControl1, c, "Clients-Hardship Worksheet")
    End Sub
    Private Sub SetupPermissions()
        'Dim functionId As Integer = DataHelper.Nz_string(DataHelper.FieldLookup("tblFunction", "FunctionID", "FullName='Clients-Hardship Worksheet'"))
        'Dim p As PermissionHelper.Permission = PermissionHelper.GetPermission(Context, Me.GetType.Name, functionId, UserID)
        'If (Not p Is Nothing AndAlso p.CanDo(PermissionHelper.PermissionType.View)) Then
        '    'show
        '    hardshipControl1.Visible = True
        '    Dim CommonTasks As List(Of String) = Master.CommonTasks
        '    CommonTasks.Remove("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Hardship_Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save Form</a>")
        '    CommonTasks.Remove("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Hardship_Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_print.png") & """ align=""absmiddle""/>Print Form</a>")
        'Else
        '    'hide
        '    hardshipControl1.Visible = False
        'End If


    End Sub
#End Region
End Class


