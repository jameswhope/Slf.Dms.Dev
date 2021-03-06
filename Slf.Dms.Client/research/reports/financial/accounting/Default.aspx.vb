Imports System.Collections.Generic
Imports Microsoft.Reporting
Imports Microsoft.Reporting.WebForms
Imports Drg.Util.DataAccess
Imports LocalHelper
Partial Class research_reports_financial_accounting_Default
    Inherits System.Web.UI.Page
    Private ReportType As String = ""
    Private ReportPath As String = ""
    Private UserID As String = ""
    Private UserCommRecID As String
    Private UserGroupdID As String
    Private sqlReport As String = ""
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        UserGroupdID = DataHelper.FieldLookup("tblUser", "UserGroupID", "Userid = " & UserID)
        UserCommRecID = DataHelper.FieldLookup("tblUser", "CommRecID", "Userid = " & UserID)


        ReportType = Request.QueryString("rpt")

        'set viewer mode
        Me.ReportViewer1.ProcessingMode = Microsoft.Reporting.WebForms.ProcessingMode.Local

        Select Case ReportType
            Case "comm"
                'set report title
                lblMsg.Text = "Commission Report"
                'set report file path

                Me.tblDates.Style("display") = ""
                If Me.UserGroupdID.Contains("7") Or Me.UserGroupdID.Contains("11") Then
                    Me.tblFirm.Style("display") = ""
                    ReportPath = "cpa_commission.rdlc"
                Else
                    ReportPath = "CommissionByCommRecID.rdlc"
                End If
            Case "depo"
                lblMsg.Text = "Deposit Report"

                Me.tblDates.Style("display") = ""
                If Me.UserGroupdID.Contains("7") Or Me.UserGroupdID.Contains("11") Then
                    Me.tblFirm.Style("display") = ""
                    ReportPath = "cpa_deposits.rdlc"
                Else
                    ReportPath = "DepositsByCommRecID.rdlc"
                End If
            Case "disb"
                lblMsg.Text = "Disbursement Report"

                Me.tblDates.Style("display") = ""
                If Me.UserGroupdID.Contains("7") Or Me.UserGroupdID.Contains("11") Then
                    Me.tblFirm.Style("display") = ""
                    ReportPath = "cpa_disbursements.rdlc"
                Else
                    ReportPath = "DisbursementsByCommRecID.rdlc"
                End If
            Case "with"
                lblMsg.Text = "Commission Withholding Report"
                Me.tblDates.Style("display") = ""
                ReportPath = "WithholdingReport.rdlc"
            Case "sett"
                lblMsg.Text = "Settlement Fees Paid"
                ReportPath = "Settlement_Fees_Paid.rdlc"
                Me.tblDates.Style("display") = ""
            Case "nopay"
                lblMsg.Text = "No Pay List Report"
                ReportPath = "nonpaylist.rdlc"
                Me.tblDates.Style("display") = "none"
                Me.tblDays.Style("display") = ""
                Me.nodeposits.Style("display") = ""
            Case "disb_2"
                lblMsg.Text = "Disbursement Report"

                'Me.tblDates.Style("display") = ""
                'Me.tblFirm.Style("display") = ""
                ReportPath = "Disbursement_Report_2.rdlc"
                

        End Select
        If Not IsPostBack Then
            LoadQuickPickDates()
            LoadCompanys()
        End If
      
    End Sub
    Private Sub LoadCompanys()
        ddlFirm.Items.Clear()
        Dim sqlSelect As String = "select Companyid, shortconame from tblcompany"

        If UserID = 494 AndAlso (ReportType IsNot Nothing AndAlso (ReportType.Trim.ToLower = "depo" OrElse ReportType.Trim.ToLower = "disb")) Then
            sqlSelect = "select Companyid, shortconame from tblcompany where companyid in (1,2)"
        End If

        Using saTemp = New Data.SqlClient.SqlDataAdapter(sqlSelect, System.Configuration.ConfigurationManager.AppSettings("connectionstring"))
            Dim dt As New Data.DataTable
            saTemp.Fill(dt)
            ddlFirm.DataTextField = "shortconame"
            ddlFirm.DataValueField = "Companyid"
            ddlFirm.DataSource = dt
            ddlFirm.DataBind()
        End Using
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
            txtStart.Text = parts(0)
            txtEnd.Text = parts(1)
        End If

    End Sub
    Protected Sub lnkView_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkView.Click


        Dim dtD As New Data.DataTable
        'set report 
        Me.ReportViewer1.LocalReport.ReportPath = "research/reports/financial/accounting/" & ReportPath

        Me.ReportViewer1.LocalReport.DisplayName = "rpt"

        'get params
        Dim StartDate As Date
        Dim EndDate As Date
        Dim DaySinceCount As Integer
        Dim firmid As String

        Dim params(2) As ReportParameter

        ''Run the stored procedure  to fill dataset for Parent.rdlc

        If Me.tblFirm.Style("display") <> "none" Then
            'cpa reports
            firmid = ddlFirm.SelectedValue.ToString
            Select Case Me.ReportType
                Case "comm"
                    sqlReport = "select  convert(varchar,bat.batchdate,110) as [Batch Date],"
                    sqlReport += "c.clientid, c.agencyid, rec.display,c.accountnumber, p.firstname + ' ' + p.lastname as [Name], "
                    sqlReport += "cp.registerpaymentid,e.name+' Payment', rp.amount, cp.[percent], cp.amount "
                    sqlReport += "from tblcommpay cp "
                    sqlReport += "inner join tblregisterpayment rp on cp.registerpaymentid = rp.registerpaymentid "
                    sqlReport += "inner join tblregister r on rp.feeregisterid = r.registerid "
                    sqlReport += "inner join tblclient c on r.clientid = c.clientid "
                    sqlReport += "inner join tblperson p on c.primarypersonid = p.personid "
                    sqlReport += "inner join tblcommstruct cs on cp.commstructid = cs.commstructid "
                    sqlReport += "inner join tblcommrec rec on cs.commrecid = rec.commrecid "
                    sqlReport += "inner join tblentrytype e on r.entrytypeid = e.entrytypeid "
                    sqlReport += "inner join tblcommbatch bat on cp.commbatchid = bat.commbatchid "
                    sqlReport += "where bat.batchdate >= convert(datetime,'@startdate') "
                    sqlReport += "and bat.batchdate < convert(datetime,'@enddate') and c.companyid = @firmid "
                    sqlReport += "order by bat.batchdate "

                    StartDate = CDate(Me.txtStart.Text.ToString)
                    EndDate = CDate(Me.txtEnd.Text.ToString)

                    params(0) = New ReportParameter("firmid", firmid)
                    params(1) = New ReportParameter("startdate", StartDate)
                    params(2) = New ReportParameter("enddate", EndDate)
                Case "disb"
                    sqlReport = "select	c.accountnumber,p.firstname + ' '+ p.lastname as cName,	s.name as Status, "
                    sqlReport += "convert(nvarchar, r.transactiondate,110) as paymentdate,e.name,r.checknumber,r.amount,isnull(convert(nvarchar,r.void,110),' ') "
                    sqlReport += "from tblregister r inner join tblclient c on c.clientid = r.clientid "
                    sqlReport += "inner join tblperson p on c.primarypersonid = p.personid "
                    sqlReport += "inner join tblclientstatus s on c.currentclientstatusid = s.clientstatusid "
                    sqlReport += "inner join tblentrytype e on r.entrytypeid = e.entrytypeid "
                    sqlReport += "where r.entrytypeid in (18,21,48) "
                    sqlReport += "and r.transactiondate >= convert(datetime,'@startdate') and r.transactiondate < convert(datetime,'@enddate') "
                    sqlReport += "and c.companyid = @firmid order by c.accountnumber"

                    StartDate = CDate(Me.txtStart.Text.ToString)
                    EndDate = CDate(Me.txtEnd.Text.ToString)

                    params(0) = New ReportParameter("firmid", firmid)
                    params(1) = New ReportParameter("startdate", StartDate)
                    params(2) = New ReportParameter("enddate", EndDate)
                Case "depo"
                    sqlReport = "SELECT	convert(nvarchar, r.transactiondate,110) as TransDate, "
                    sqlReport += "c.accountnumber, p.firstname, p.lastname, r.amount, "
                    sqlReport += "[check] = CASE WHEN r.importid IS NULL THEN 'ACH' ELSE 'Check' END, "
                    sqlReport += "[Modified] = CASE WHEN r.void IS NULL THEN ' ' ELSE 'X' END "
                    sqlReport += "FROM	tblregister r "
                    sqlReport += "INNER JOIN tblclient c on r.clientid = c.clientid "
                    sqlReport += "INNER JOIN tblperson p on c.primarypersonid = p.personid "
                    sqlReport += "WHERE(entrytypeid = 3) "
                    sqlReport += "AND transactiondate >= convert(datetime,'@startdate') "
                    sqlReport += "AND transactiondate <= convert(datetime,'@enddate') "
                    sqlReport += "AND c.companyid = @firmid"

                    StartDate = CDate(Me.txtStart.Text.ToString)
                    EndDate = CDate(Me.txtEnd.Text.ToString)

                    params(0) = New ReportParameter("firmid", firmid)
                    params(1) = New ReportParameter("startdate", StartDate)
                    params(2) = New ReportParameter("enddate", EndDate)
                Case "sett"
                    sqlReport = "SELECT CONVERT(nvarchar, p.PaymentDate, 110) AS Date, SUM(p.Amount) AS [Amt Paid] "
                    sqlReport += "FROM tblRegisterPayment AS p INNER JOIN tblRegister AS r ON p.FeeRegisterId = r.RegisterId INNER JOIN "
                    sqlReport += "tblEntryType AS e ON r.EntryTypeId = e.EntryTypeId "
                    sqlReport += "WHERE (r.EntryTypeId = 4) AND (p.Bounced = 0) AND (p.Voided = 0) AND (p.PaymentDate >= '@startdate') AND (p.PaymentDate < '@enddate') "
                    sqlReport += "GROUP BY CONVERT(nvarchar, p.PaymentDate, 110) ORDER BY CONVERT(nvarchar, p.PaymentDate, 110)"

                    StartDate = CDate(Me.txtStart.Text.ToString)
                    EndDate = CDate(Me.txtEnd.Text.ToString)

                    ReDim params(1)
                    params(0) = New ReportParameter("startdate", StartDate)
                    params(1) = New ReportParameter("enddate", EndDate)
                Case "nopay"
                    sqlReport = String.Format("exec stp_nondeposit @daycount, {0}", IIf(chkNodeposits.Checked, 1, 0))
                    If Me.txtDaysSince.Text.Trim.Length = 0 Then Me.txtDaysSince.Text = "0"
                    DaySinceCount = Me.txtDaysSince.Text
                    ReDim params(1)
                    params(0) = New ReportParameter("daycount", DaySinceCount)
                    params(1) = New ReportParameter("nodep", False)

            End Select

        Else
            Select Case Me.ReportType
                Case "comm"
                    sqlReport = "SELECT CONVERT(varchar, bat.BatchDate, 110) AS [Batch Date], c.ClientID, c.AgencyID, rec.Display, c.AccountNumber, p.FirstName + ' ' + p.LastName AS Name, "
                    sqlReport += "cp.RegisterPaymentID, e.Name + ' Payment' as PaymentType, rp.Amount, cp.[Percent], cp.Amount "
                    sqlReport += "FROM tblCommPay AS cp INNER JOIN "
                    sqlReport += "tblRegisterPayment AS rp ON cp.RegisterPaymentID = rp.RegisterPaymentId INNER JOIN "
                    sqlReport += "tblRegister AS r ON rp.FeeRegisterId = r.RegisterId INNER JOIN "
                    sqlReport += "tblClient AS c ON r.ClientId = c.ClientID INNER JOIN "
                    sqlReport += "tblPerson AS p ON c.PrimaryPersonID = p.PersonID INNER JOIN "
                    sqlReport += "tblCommStruct AS cs ON cp.CommStructID = cs.CommStructID INNER JOIN "
                    sqlReport += "tblCommRec AS rec ON cs.CommRecID = rec.CommRecID INNER JOIN "
                    sqlReport += "tblEntryType AS e ON r.EntryTypeId = e.EntryTypeId INNER JOIN "
                    sqlReport += "tblCommBatch AS bat ON cp.CommBatchID = bat.CommBatchID "
                    sqlReport += "WHERE (bat.BatchDate >= '@startdate') AND (bat.BatchDate < '@enddate') AND (rec.CommRecID = @CommRecID) "
                    sqlReport += "ORDER BY bat.BatchDate"

                    StartDate = CDate(Me.txtStart.Text.ToString)
                    EndDate = CDate(Me.txtEnd.Text.ToString)

                    params(0) = New ReportParameter("CommRecID", UserCommRecID)
                    params(1) = New ReportParameter("startdate", StartDate)
                    params(2) = New ReportParameter("enddate", EndDate)
                Case "disb"
                    'Hotfix 5/22/09 - Settlement Payments(18) and Closing Withdrawls(21) aren't fees. Not sure why
                    'this report was joining to commstruct. Query now same as cpa report above, just
                    'filtered automatically by usercompanyaccess. Also added new entry type, Refund(48).
                    sqlReport = "select	c.accountnumber,p.firstname + ' '+ p.lastname as cName,	s.name as Status, "
                    sqlReport += "convert(nvarchar, r.transactiondate,110) as paymentdate,e.name,r.checknumber,abs(r.amount) [amount],isnull(convert(nvarchar,r.void,110),' ') "
                    sqlReport += "from tblregister r inner join tblclient c on c.clientid = r.clientid "
                    sqlReport += "inner join tblperson p on c.primarypersonid = p.personid "
                    sqlReport += "inner join tblclientstatus s on c.currentclientstatusid = s.clientstatusid "
                    sqlReport += "inner join tblentrytype e on r.entrytypeid = e.entrytypeid "
                    sqlReport += "inner join tblusercompanyaccess uca on uca.companyid = c.companyid and uca.userid = @userid "
                    sqlReport += "where r.entrytypeid in (18,21,48) "
                    sqlReport += "and r.transactiondate >= convert(datetime,'@startdate') and r.transactiondate < convert(datetime,'@enddate') "
                    sqlReport += "order by c.accountnumber"

                    StartDate = CDate(Me.txtStart.Text.ToString)
                    EndDate = CDate(Me.txtEnd.Text.ToString)

                    params(0) = New ReportParameter("CommRecID", -1) 'In report def, not used
                    params(1) = New ReportParameter("startdate", StartDate)
                    params(2) = New ReportParameter("enddate", EndDate)
                Case "depo"
                    'Hotfix 5/22/09 - Not sure why this report was joining to commstruct to display
                    'deposit information. Query now same as cpa report above, just filtered automatically
                    'by usercompanyaccess.
                    sqlReport = "SELECT	convert(nvarchar, r.transactiondate,110) as TransDate, "
                    sqlReport += "c.accountnumber, p.firstname, p.lastname, r.amount, "
                    sqlReport += "[check] = CASE WHEN r.importid IS NULL THEN 'ACH' ELSE 'Check' END, "
                    sqlReport += "[Modified] = CASE WHEN r.void IS NULL THEN ' ' ELSE 'X' END "
                    sqlReport += "FROM	tblregister r "
                    sqlReport += "INNER JOIN tblclient c on r.clientid = c.clientid "
                    sqlReport += "INNER JOIN tblperson p on c.primarypersonid = p.personid "
                    sqlReport += "INNER JOIN tblusercompanyaccess uca on uca.companyid = c.companyid and uca.userid = @userid "
                    sqlReport += "WHERE(entrytypeid = 3) "
                    sqlReport += "AND transactiondate >= convert(datetime,'@startdate') "
                    sqlReport += "AND transactiondate <= convert(datetime,'@enddate') "
                    sqlReport += "ORDER BY r.transactiondate"

                    StartDate = CDate(Me.txtStart.Text.ToString)
                    EndDate = CDate(Me.txtEnd.Text.ToString)

                    params(0) = New ReportParameter("CommRecID", -1) 'In report def, not used
                    params(1) = New ReportParameter("startdate", StartDate)
                    params(2) = New ReportParameter("enddate", EndDate)
                Case "sett"
                    sqlReport = "SELECT CONVERT(nvarchar, p.PaymentDate, 110) AS Date, SUM(p.Amount) AS [Amt Paid] "
                    sqlReport += "FROM tblRegisterPayment AS p INNER JOIN tblRegister AS r ON p.FeeRegisterId = r.RegisterId INNER JOIN "
                    sqlReport += "tblEntryType AS e ON r.EntryTypeId = e.EntryTypeId "
                    sqlReport += "WHERE (r.EntryTypeId = 4) AND (p.Bounced = 0) AND (p.Voided = 0) AND (p.PaymentDate >= '@startdate') AND (p.PaymentDate < '@enddate') "
                    sqlReport += "GROUP BY CONVERT(nvarchar, p.PaymentDate, 110) ORDER BY CONVERT(nvarchar, p.PaymentDate, 110)"

                    StartDate = CDate(Me.txtStart.Text.ToString)
                    EndDate = CDate(Me.txtEnd.Text.ToString)

                    ReDim params(1)
                    params(0) = New ReportParameter("startdate", StartDate)
                    params(1) = New ReportParameter("enddate", EndDate)
                Case "nopay"
                    Dim companyids As String = DataHelper.FieldLookup("tblUserCompany", "CompanyIDs", "UserID = " & UserID)

                    sqlReport = String.Format("exec stp_nondeposit @daycount, {0}, '{1}'", IIf(chkNodeposits.Checked, 1, 0), companyids)
                    If Me.txtDaysSince.Text.Trim.Length = 0 Then Me.txtDaysSince.Text = "0"
                    DaySinceCount = Me.txtDaysSince.Text

                    ReDim params(1)
                    params(0) = New ReportParameter("daycount", DaySinceCount)
                    params(1) = New ReportParameter("nodep", False)


            End Select
        End If

      

        Try
            'set report params
            Me.ReportViewer1.LocalReport.SetParameters(params)

            sqlReport = sqlReport.Replace("@firmid", firmid).Replace("@startdate", StartDate).Replace("@enddate", EndDate).Replace("@CommRecID", Me.UserCommRecID).Replace("@daycount", DaySinceCount).Replace("@userid", UserID)

            Using dsTemp = New Data.SqlClient.SqlDataAdapter(sqlReport, ConfigurationManager.AppSettings("connectionstring").ToString)
                dsTemp.fill(dtD)
            End Using

            'Assign dataset to report datasource
            Dim datasource As ReportDataSource = New ReportDataSource("dsReportData", dtD)

            'Assign datasource to reportviewer control
            ReportViewer1.LocalReport.DataSources.Clear()
            ReportViewer1.LocalReport.DataSources.Add(datasource)
            ReportViewer1.LocalReport.Refresh()
            ReportViewer1.DataBind()
        Catch ex As Exception
            Me.lblMsg.Text = ex.Message & vbCrLf & ex.InnerException.ToString

        End Try

    End Sub

    Protected Sub ddlQuickPickDate_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)

        Dim ddl As DropDownList = DirectCast(sender, DropDownList)
        If ddl.SelectedValue.ToString <> "Custom" Then
            Dim parts As String() = ddl.SelectedValue.Split(",")
            txtStart.Text = parts(0)
            txtEnd.Text = parts(1)
        End If
    End Sub

End Class
