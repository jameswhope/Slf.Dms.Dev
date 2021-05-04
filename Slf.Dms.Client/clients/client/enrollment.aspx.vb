Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_enrollment
    Inherits System.Web.UI.Page

#Region "Variables"

    Public QueryString As String
    Private Shadows ClientID As Integer
    Private qs As QueryStringCollection
    Private baseTable As String = "tblEnrollment"

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        qs = LoadQueryString()

        PrepQuerystring()

        If Not qs Is Nothing Then

            ClientID = DataHelper.Nz_int(qs("id"), 0)

            If Not IsPostBack Then

                LoadRecord()
                LoadPrimaryPerson()

                SetRollups()

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

        Dim Views As List(Of String) = CType(Master, clients_client).Views
        Dim CommonTasks As List(Of String) = CType(Master, clients_client).CommonTasks

        Views.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""" & ResolveUrl("~/clients/client/") & QueryString & """><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_objectbrowser.png") & """ align=""absmiddle""/>Show main overview</a>")
        Views.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""" & ResolveUrl("~/clients/client/roadmap.aspx") & QueryString & """><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_flowchart.png") & """ align=""absmiddle""/>Show full roadmap</a>")


    End Sub
    Private Sub LoadRecord()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetEnrollmentForClient")

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                lblNameName.Text = DatabaseHelper.Peel_string(rd, "Name")
                lblPhone.Text = StringHelper.PlaceInMask(DatabaseHelper.Peel_string(rd, "Phone"), "(___) ___-____")
                lblZipCode.Text = DatabaseHelper.Peel_string(rd, "ZipCode")
                lblBehind.Text = DatabaseHelper.Peel_bool(rd, "Behind").ToString()
                lblBehindName.Text = DatabaseHelper.Peel_string(rd, "BehindName")
                lblConcern.Text = DatabaseHelper.Peel_string(rd, "ConcernName")
                lblAgencyName.Text = DatabaseHelper.Peel_string(rd, "AgencyName")
                lblCompanyName.Text = DatabaseHelper.Peel_string(rd, "CompanyName")
                lblFollowUpDate.Text = DatabaseHelper.Peel_datestring(rd, "FollowUpDate", "MM/dd/yyyy hh:mm tt")

                lblTotalUnsecuredDebt.Text = DatabaseHelper.Peel_double(rd, "TotalUnsecuredDebt").ToString("$#,##0.00")
                lblTotalMonthlyPayment.Text = DatabaseHelper.Peel_double(rd, "TotalMonthlyPayment").ToString("$#,##0.00")
                lblEstimatedEndAmount.Text = DatabaseHelper.Peel_double(rd, "EstimatedEndAmount").ToString("$#,##0.00")
                lblEstimatedEndTime.Text = DatabaseHelper.Peel_int(rd, "EstimatedEndTime") & " months"
                lblDepositCommitment.Text = DatabaseHelper.Peel_double(rd, "DepositCommitment").ToString("$#,##0.00")
                lblBalanceAtEnrollment.Text = DatabaseHelper.Peel_double(rd, "BalanceAtEnrollment").ToString("$#,##0.00")
                lblBalanceAtSettlement.Text = DatabaseHelper.Peel_double(rd, "BalanceAtSettlement").ToString("$#,##0.00")

                lblQualified.Text = DatabaseHelper.Peel_bool(rd, "Qualified").ToString()
                lblQualifiedReason.Text = DatabaseHelper.Peel_string(rd, "QualifiedReason")
                lblCommitted.Text = DatabaseHelper.Peel_bool(rd, "Committed").ToString()
                lblCommittedReason.Text = DatabaseHelper.Peel_string(rd, "CommittedReason")

            End If

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadPrimaryPerson()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblPerson WHERE PersonID = @PersonID"

        DatabaseHelper.AddParameter(cmd, "PersonID", ClientHelper.GetDefaultPerson(ClientID))

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                Dim StateID As Integer = DatabaseHelper.Peel_int(rd, "StateID")
                Dim State As String = DataHelper.FieldLookup("tblState", "Name", "StateID = " & StateID)

                lblName.Text = PersonHelper.GetName(DatabaseHelper.Peel_string(rd, "FirstName"), _
                    DatabaseHelper.Peel_string(rd, "LastName"), _
                    DatabaseHelper.Peel_string(rd, "SSN"), _
                    DatabaseHelper.Peel_string(rd, "EmailAddress"))

                lblAddress.Text = PersonHelper.GetAddress(DatabaseHelper.Peel_string(rd, "Street"), _
                    DatabaseHelper.Peel_string(rd, "Street2"), _
                    DatabaseHelper.Peel_string(rd, "City"), State, _
                    DatabaseHelper.Peel_string(rd, "ZipCode")).Replace(vbCrLf, "<br>")

                lblSSN.Text = "SSN: " & StringHelper.PlaceInMask(DatabaseHelper.Peel_string(rd, "SSN"), "___-__-____")

            Else
                lblName.Text = "No Applicant"
                lblAddress.Text = "No Address"
            End If

            lnkStatus.Text = ClientHelper.GetStatus(ClientID, Now)

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Dim NumApplicants As Integer = DataHelper.FieldCount("tblPerson", "PersonID", "ClientID = " & ClientID)

        If NumApplicants > 1 Then
            lnkNumApplicants.InnerText = "(" & NumApplicants & ")"
            lnkNumApplicants.HRef = "~/clients/client/applicants/" & QueryString
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
End Class