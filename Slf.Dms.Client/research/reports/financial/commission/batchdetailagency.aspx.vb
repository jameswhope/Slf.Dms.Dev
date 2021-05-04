Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Collections.Generic
Imports LocalHelper

Partial Class research_reports_financial_commission_batchdetail
    Inherits PermissionPage

    Structure CommissionBatchEntry
        Public ClientID As Integer
        Public Name As String
        Public Amount As Single
    End Structure

#Region "Variables"

    Private UserID As Integer
    Private CommBatchIDs As String
    Private CompanyID As Integer
    Private CommRecID As String
    Private ClientID As Integer
    Private qs As QueryStringCollection

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        Dim Company As String

        qs = LoadQueryString()

        If Not qs Is Nothing Then
            CommBatchIDs = qs("commissionbatchids")
            Company = qs("company")
            CommRecID = qs("commrecid")

            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection
                    cmd.CommandText = "SELECT CompanyID FROM tblCompany WHERE lower(ShortCoName) = '" + Company.ToLower() + "'"
                    cmd.Connection.Open()
                    CompanyID = CInt(cmd.ExecuteScalar())
                End Using
            End Using

            If Not IsPostBack Then

                Requery()

            End If
        End If
    End Sub
    Private Sub Requery()
        Dim tempEntry As CommissionBatchEntry
        Dim CommissionBatch As New List(Of CommissionBatchEntry)
        Dim totalComm As Single = 0
        Dim login_name As String
        Dim ClientCreatedDateFrom As String
        Dim ClientCreatedDateTo As String

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_ReportGetCommissionBatchTransfers")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "CommBatchIDs", CommBatchIDs)
                DatabaseHelper.AddParameter(cmd, "CompanyID", CompanyID)
                DatabaseHelper.AddParameter(cmd, "CommRecID", CommRecID)

                login_name = Drg.Util.DataHelpers.UserHelper.GetLoginName(UserID)
                Select Case login_name
                    Case "debtchoice"
                        'sees clients added through 12/31/2007
                        ClientCreatedDateFrom = "1/1/1900"
                        ClientCreatedDateTo = "12/31/2007"
                    Case "debtchoice08"
                        'see clients added from 1/1/2008 to present
                        ClientCreatedDateFrom = "1/1/2008"
                        ClientCreatedDateTo = "12/31/2050"
                    Case Else
                        'sees all clients
                        ClientCreatedDateFrom = "1/1/1900"
                        ClientCreatedDateTo = "12/31/2050"
                End Select

                DatabaseHelper.AddParameter(cmd, "ClientCreatedDateFrom", ClientCreatedDateFrom)
                DatabaseHelper.AddParameter(cmd, "ClientCreatedDateTo", ClientCreatedDateTo)


                Session("rptcmd_report_commission_batchpayments") = cmd

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        tempEntry = New CommissionBatchEntry
                        tempEntry.ClientID = DatabaseHelper.Peel_int(rd, "ClientID")
                        tempEntry.Name = DatabaseHelper.Peel_string(rd, "ClientName")
                        tempEntry.Amount = DatabaseHelper.Peel_float(rd, "Amount")

                        If tempEntry.Name.Length > 25 Then
                            tempEntry.Name = tempEntry.Name.Substring(0, 22).Trim() + "..."
                        End If

                        totalComm += tempEntry.Amount

                        CommissionBatch.Add(tempEntry)

                    End While
                End Using
            End Using
        End Using

        tdTotal.InnerHtml = "Total For Recipient: " + totalComm.ToString("c")
        rpBatch.DataSource = CommissionBatch
        rpBatch.DataBind()
        tbBatch.Visible = True

        Session("xls_batchdetail_list_detail") = PrepForExport(CommissionBatch)
    End Sub

    Public Function PrepForExport(ByVal batch As List(Of CommissionBatchEntry)) As String
        Dim result As String = "<html><body><table class=""fixedlist"" cellspacing=""0"" cellpadding=""0"">" + _
        "<thead>" + _
        "<tr>" + _
        "<th nowrap align=""left"">Client ID&nbsp;&nbsp;&nbsp;&nbsp;</th>" + _
        "<th nowrap align=""left"">Name</th>" + _
        "<th nowrap align=""right"">Amount&nbsp;&nbsp;&nbsp;</th>" + _
        "</tr>" + _
        "</thead>" + _
        "<tbody>"

        For Each b As CommissionBatchEntry In batch
            result += "<tr>"
            result += "<td nowrap=""true"" align=""left"" valign=""middle"">" + b.ClientID.ToString() + "</td>"
            result += "<td nowrap=""true"" align=""left"" valign=""middle"">" + b.Name.ToString() + "</td>"
            result += "<td align=""right"">" + b.Amount.ToString("c") + "&nbsp;&nbsp;&nbsp;</td>"
            result += "</tr>"
        Next

        result += "</tbody></table></body></html>"

        Return result
    End Function

    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""idonly""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlBody, c, "Research-Reports-Financial-Commission-Batch Details")
    End Sub
End Class
