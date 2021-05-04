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

Partial Class research_reports_financial_servicefees_agencyold
    Inherits PermissionPage


#Region "Variables"

    Private CommRecId As Integer
    Private CommRecTypeId As Integer
    Private AllCommScenIds As String

    Private UserID As Integer
    Private qs As QueryStringCollection

    Private Const PageSize As Integer = 20
    Dim pager As PagerWrapper

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        pager = New PagerWrapper(lnkFirst, lnkPrev, lnkNext, lnkLast, imgFirst, imgPrev, imgNext, imgLast, txtPageNumber, lblPageCount, Context, "p")
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        Integer.TryParse(DataHelper.FieldLookup("tblUser", "CommRecId", "UserId=" & UserID), CommRecId)
        Integer.TryParse(DataHelper.FieldLookup("tblCommRec", "CommRecTypeId", "CommRecId=" & CommRecId), CommRecTypeId)
        LoadAgencies()

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            If Not IsPostBack Then

                LoadValues(GetControls(), Me)
                LoadQuickPickDates()


                Requery()

                SetAttributes()

            End If

        End If


    End Sub

    Private Sub SetAttributes()
        ddlQuickPickDate.Attributes("onchange") = "SetDates(this);"
    End Sub

    Private Sub LoadAgencies()
        Dim lstAllCommScenIds As New List(Of String)
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT tblAgency.Name, tblCommScen.CommScenId FROM tblUser INNER JOIN tblCommStruct ON tblCommStruct.CommRecId=tblUser.CommRecId INNER JOIN tblCommScen ON tblCommStruct.CommScenId=tblCommScen.CommScenId INNER JOIN tblAgency ON tblCommScen.AgencyId=tblAgency.AgencyId WHERE tblUser.UserId=@UserId"
                DatabaseHelper.AddParameter(cmd, "UserId", UserID)
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim iCommScenId As Integer = DatabaseHelper.Peel_int(rd, "CommScenId")
                        Dim AgencyName As String = DatabaseHelper.Peel_string(rd, "Name")
                        lstAllCommScenIds.Add(iCommScenId)
                    End While
                End Using
            End Using
        End Using

        AllCommScenIds = String.Join(",", lstAllCommScenIds.ToArray())

        If String.IsNullOrEmpty(AllCommScenIds) Then
            AllCommScenIds = "-1"
        End If
    End Sub
    Private Sub LoadQuickPickDates()
        ddlQuickPickDate.Items.Clear()

        ddlQuickPickDate.Items.Add(New ListItem("Today", Now.ToString("MM/dd/yy") & "," & Now.ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Week", RoundDate(Now, -1, DateUnit.Week).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Week).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Year", RoundDate(Now, -1, DateUnit.Year).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Year).ToString("MM/dd/yy")))

        ddlQuickPickDate.Items.Add(New ListItem("Yesterday", Now.AddDays(-1).ToString("MM/dd/yy") & "," & Now.AddDays(-1).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Week", RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("MM/dd/yy") & "," & RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("MM/dd/yy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Year", RoundDate(Now.AddYears(-1), -1, DateUnit.Year).ToString("MM/dd/yy") & "," & RoundDate(Now.AddYears(-1), 1, DateUnit.Year).ToString("MM/dd/yy")))

        ddlQuickPickDate.Items.Add(New ListItem("Custom", "Custom"))

        Dim SelectedIndex As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblQuerySetting", "Value", _
                  "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = 'ddlQuickPickDate'"), 0)

        ddlQuickPickDate.SelectedIndex = SelectedIndex
        If Not ddlQuickPickDate.Items(SelectedIndex).Value = "Custom" Then
            Dim parts As String() = ddlQuickPickDate.Items(SelectedIndex).Value.Split(",")
            txtTransDate1.Text = parts(0)
            txtTransDate2.Text = parts(1)
        End If


    End Sub

    Private Function GetControls() As Dictionary(Of String, Control)

        Dim c As New Dictionary(Of String, Control)

        c.Add(txtTransDate1.ID, txtTransDate1)
        c.Add(txtTransDate2.ID, txtTransDate2)

        Return c

    End Function
    Private Function GetPeriod() As String
        If txtTransDate1.Text.Length > 0 And txtTransDate2.Text.Length > 0 Then
            Return DateTime.Parse(txtTransDate1.Text).ToString("MMMM dd yyyy") + " thru " + DateTime.Parse(txtTransDate2.Text).ToString("MMMM dd yyyy")
        ElseIf txtTransDate1.Text.Length > 0 Then
            Return "From " & DateTime.Parse(txtTransDate1.Text).ToString("MMMM dd yyyy")
        ElseIf txtTransDate2.Text.Length > 0 Then
            Return "Thru " & DateTime.Parse(txtTransDate2.Text).ToString("MMMM dd yyyy")
        Else
            Return "All Time"
        End If
    End Function
    Private Function RequiresPayments() As Boolean
        Dim result As Integer
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand
            Using cmd.Connection
                cmd.CommandText = "SELECT Case When 1 IN (SELECT CommRecTypeId FROM tblCommRec WHERE CommRecId in (SELECT ParentCommRecId FROM tblCommStruct WHERE CommRecId=" & CommRecId & " AND CommScenId in (" & AllCommScenIds & "))) Then 1 Else 0 end HasAttorney"
                DatabaseHelper.AddParameter(cmd, "CommRecId", Integer.Parse(CommRecId))

                cmd.Connection.Open()
                result = cmd.ExecuteScalar()
            End Using
        End Using

        Return Not CommRecTypeId = 1 And result = 1
        Return True
    End Function

    Private Sub Requery()
        Dim payments As New List(Of Payment)
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_QueryGetServiceFeePayments")
            Using cmd.Connection
                AddStdParams(cmd)
                Session("rptcmd_report_servicefee_agency_payments") = cmd

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    While rd.Read()
                        Dim p As New Payment
                        p.CommPayId = DatabaseHelper.Peel_int(rd, "CommPayId")
                        p.AccountNumber = DatabaseHelper.Peel_string(rd, "AccountNumber")
                        p.HireDate = DatabaseHelper.Peel_date(rd, "HireDate")
                        p.AgencyName = DatabaseHelper.Peel_string(rd, "CompanyName")
                        p.FirstName = DatabaseHelper.Peel_string(rd, "FirstName")
                        p.LastName = DatabaseHelper.Peel_string(rd, "LastName")
                        p.FeeCategory = DatabaseHelper.Peel_string(rd, "FeeCategory")
                        p.SettlementNumber = DatabaseHelper.Peel_string(rd, "SettlementNumber")
                        p.PaymentDate = DatabaseHelper.Peel_date(rd, "PaymentDate")
                        p.OriginalBalance = DatabaseHelper.Peel_float(rd, "OriginalBalance")
                        p.BeginningBalance = DatabaseHelper.Peel_float(rd, "BeginningBalance")
                        p.PaymentAmount = DatabaseHelper.Peel_float(rd, "PaymentAmount")
                        p.EndingBalance = p.BeginningBalance - p.PaymentAmount
                        p.Rate = DatabaseHelper.Peel_float(rd, "Rate")
                        p.Amount = DatabaseHelper.Peel_float(rd, "Amount")
                        payments.Add(p)
                    End While
                End Using

                Session("xls_servicefeemy_list") = payments
                lblResults.Text = "Total: " & payments.Count
                PagerHelper.Handle(payments, rpPayments, pager, PageSize)

                rpPayments.Visible = payments.Count > 0
                pnlNone.Visible = payments.Count = 0
            End Using
        End Using
        If (RequiresPayments()) Then
            Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_QueryGetServiceFeeNewCharges")
                AddStdParams(cmd)
                Session("rptcmd_report_servicefee_agency_charges") = cmd
            End Using
        Else
            Session.Remove("rptcmd_report_servicefee_agency_charges")
        End If
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_QueryGetServiceFeeTotals")
            AddStdParams(cmd)
            Session("rptcmd_report_servicefee_agency") = cmd
        End Using
    End Sub
    Private Sub AddStdParams(ByVal cmd As IDbCommand)
        If txtTransDate1.Text.Length > 0 Then DatabaseHelper.AddParameter(cmd, "Date1", DateTime.Parse(txtTransDate1.Text))
        If txtTransDate2.Text.Length > 0 Then DatabaseHelper.AddParameter(cmd, "Date2", DateTime.Parse(txtTransDate2.Text))
        DatabaseHelper.AddParameter(cmd, "Period", GetPeriod())
        DatabaseHelper.AddParameter(cmd, "CommRecId", CommRecId)
        DatabaseHelper.AddParameter(cmd, "CommScenIds", AllCommScenIds)
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
    Private Sub Save()

        'blow away current stuff first
        QuerySettingHelper.Delete("UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "'")

        If txtTransDate1.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtTransDate1.ID, "value", _
                txtTransDate1.Text)
        End If

        If txtTransDate2.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtTransDate2.ID, "value", _
                txtTransDate2.Text)
        End If


        QuerySettingHelper.Insert(Me.GetType().Name, UserID, ddlQuickPickDate.ID, "index", _
            ddlQuickPickDate.SelectedIndex)

    End Sub
    Protected Sub lnkRequery_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRequery.Click
        Requery()
        Save()
    End Sub
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlBody, c, "Research-Reports-Financial-Service Fees-Agency")
    End Sub
    Protected Sub lnkFirst_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkFirst.Click
        pager.First()
    End Sub
    Protected Sub lnkLast_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkLast.Click
        pager.Last()
    End Sub
    Protected Sub lnkNext_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkNext.Click
        pager.Next()
    End Sub
    Protected Sub lnkPrev_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkPrev.Click
        pager.Previous()
    End Sub
    Protected Sub txtPageNumber_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtPageNumber.TextChanged
        pager.SetPage(DataHelper.Nz_int(txtPageNumber.Text))
    End Sub
    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        Response.Redirect(ResolveUrl("~/research/queries/financial/servicefees/myxls.ashx"))
    End Sub
End Class
