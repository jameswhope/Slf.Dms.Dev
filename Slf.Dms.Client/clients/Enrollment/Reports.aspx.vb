Imports System.Collections.Generic
Imports Microsoft.Reporting
Imports Microsoft.Reporting.WebForms
Imports Drg.Util.DataAccess
Imports LocalHelper
Imports System.Data.SqlClient
Imports System.IO

Partial Class Clients_Enrollment_Reports
	Inherits System.Web.UI.Page

#Region "Variables"
	Private ReportType As String = ""
	Public ReportPath As String
	Private UserID As String = ""
	Private UserGroupdID As String
	Private strSQL As String = ""
	Private StartDate As Date
	Private EndDate As Date
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        UserGroupdID = DataHelper.FieldLookup("tblUser", "UserGroupID", "Userid = " & UserID)

        If IsPostBack Then
            If ddlReports.Text = "Select a Report" Then
                dvMsg.Attributes("class") = "error"
                dvMsg.Style("display") = "block"
                dvMsg.InnerHtml = "Please Select a Report!"
            Else
                If ddlReports.Text = "Cancellation Report" Then
                    'Dim strScript As String = "<script language=javascript id ='ClientScript'>Setddls();</script>"
                    'Page.ClientScript.RegisterStartupScript(Me.GetType(), "callSetddls", strScript)
                End If
            End If
        End If

        ReportType = Request.QueryString("rpt")

        'set viewer mode
        'Me.ReportViewer1.Reset()
        Me.ReportViewer1.ProcessingMode = Microsoft.Reporting.WebForms.ProcessingMode.Local

        'Me.tblDates.Style("display") = ""

        '*********NOT USED HERE YET
        'If ReportType = "" Then
        '   ReportType = ""
        'End If

        'If Me.UserGroupdID.Contains("7") Or Me.UserGroupdID.Contains("11") Then

        'End If

        If Not IsPostBack Then
            LoadQuickPickDates()
            LoadDDLs()
        End If

        Dim strScript As String = "<script language=javascript id ='ClientScript'>Setddls();</script>"
        Page.ClientScript.RegisterStartupScript(Me.GetType(), "callSetddls", strScript)
    End Sub

	Protected Sub ddlQuickPickDate_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
		Dim ddl As DropDownList = DirectCast(sender, DropDownList)
		If ddl.SelectedValue.ToString <> "Custom" Then
			Dim parts As String() = ddl.SelectedValue.Split(",")
			txtStart.Text = parts(0)
			txtEnd.Text = parts(1)
		End If
	End Sub

	Protected Sub LoadDDLs()
		ddlTelemarketer.Items.Clear()
        bindDDL(ddlTelemarketer, "Select UserID, LastName + ', ' + FirstName[Name] from tbluser Where UserGroupId IN (24) Order by [LastName]", "Name", "UserID") 'Consultant
        bindDDL(ddlScreener, "Select UserID, LastName + ', ' + FirstName[Name] from tbluser Where UserGroupId IN (25, 26) Order by [LastName]", "Name", "UserID") 'Law Firm Rep
		bindCBL(ddlDNIS, "select distinct right(dnis,4)[dnis] from tblleadDNIS where dnis <> '' order by dnis", "DNIS", "DNIS", True)	'dnis


		'Set the onchange event
		Me.ddlReports.Attributes.Add("onchange", "return Setddls();")
		'Report list
        ddlReports.Items.Add("Select a Report")
        ddlReports.Items.Add("All Client Information Report")
        ddlReports.Items.Add("Bounced/Canceled Report")
        ddlReports.Items.Add("Cancellation Report")
        ddlReports.Items.Add("Consultant Comm. Report")
        ddlReports.Items.Add("Deposits By Hire Date")
        ddlReports.Items.Add("KPI")
        ddlReports.Items.Add("Lead Dashboard (Agency Reps)")
        ddlReports.Items.Add("Lead Deposit Analysis")
        ddlReports.Items.Add("Lead DNIS Report")
        ddlReports.Items.Add("Pending Clients")
        ddlReports.Items.Add("Pipe Line Report")
        ddlReports.Items.Add("Rep. Commission Report")


        'ddlReports.Items.Add("KPI Report")
    End Sub

	Private Sub bindDDL(ByVal ddlToBind As DropDownList, ByVal sqlSelect As String, ByVal TextField As String, ByVal ValueField As String, Optional ByVal blnAddEmptyRow As Boolean = True)

		Try
			If blnAddEmptyRow Then
				Dim blankItem As New ListItem("All", 0)
				blankItem.Selected = False
				ddlToBind.Items.Add(blankItem)
			End If

			ddlToBind.AppendDataBoundItems = True

			Dim cmd As New SqlCommand(sqlSelect, ConnectionFactory.Create())
			Dim rdr As SqlDataReader = DatabaseHelper.ExecuteReader(cmd, Data.CommandBehavior.CloseConnection)
			ddlToBind.DataTextField = TextField
			ddlToBind.DataValueField = ValueField
			ddlToBind.DataSource = rdr
			ddlToBind.DataBind()
		Catch ex As Exception
			Throw ex
		End Try

	End Sub
	Private Sub bindCBL(ByVal ddlToBind As CheckBoxList, ByVal sqlSelect As String, ByVal TextField As String, ByVal ValueField As String, Optional ByVal blnAddEmptyRow As Boolean = True)

		Try
			If blnAddEmptyRow Then
				Dim blankItem As New ListItem("All", 0)
				blankItem.Selected = True
				ddlToBind.Items.Add(blankItem)
			End If

			ddlToBind.AppendDataBoundItems = True

			Dim cmd As New SqlCommand(sqlSelect, ConnectionFactory.Create())
			Dim rdr As SqlDataReader = DatabaseHelper.ExecuteReader(cmd, Data.CommandBehavior.CloseConnection)
			ddlToBind.DataTextField = TextField
			ddlToBind.DataValueField = ValueField
			ddlToBind.DataSource = rdr
			ddlToBind.DataBind()

		Catch ex As Exception
			Throw ex
		End Try

	End Sub


	Private Sub LoadQuickPickDates()

		ddlQuickPickDate.Items.Clear()


		ddlQuickPickDate.Items.Add(New ListItem("This Week", DateAdd("d", 1 - Now.DayOfWeek, Now) & "," & DateAdd("d", 7 - Now.DayOfWeek, Now)))
		ddlQuickPickDate.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("MM/dd/yy")))
		ddlQuickPickDate.Items.Add(New ListItem("This Year", RoundDate(Now, -1, DateUnit.Year).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Year).ToString("MM/dd/yy")))

		ddlQuickPickDate.Items.Add(New ListItem("Last Week", DateAdd("d", -6 - Now.DayOfWeek, Now) & "," & DateAdd("d", -0 - Now.DayOfWeek, Now)))
		ddlQuickPickDate.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("MM/dd/yy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("MM/dd/yy")))
		ddlQuickPickDate.Items.Add(New ListItem("Last Year", RoundDate(Now.AddYears(-1), -1, DateUnit.Year).ToString("MM/dd/yy") & "," & RoundDate(Now.AddYears(-1), 1, DateUnit.Year).ToString("MM/dd/yy")))


		ddlQuickPickDate.Items.Add(New ListItem("Custom", DateAdd("d", -1, Now) & "," & DateAdd("d", 0, Now), True))

		Dim SelectedIndex As Integer = 6 '= DataHelper.Nz_int(DataHelper.FieldLookup("tblQuerySetting", "Value", _
		'"UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = 'ddlQuickPickDate'"), 0)


		ddlQuickPickDate.SelectedIndex = SelectedIndex

		If Not ddlQuickPickDate.Items(SelectedIndex).Value = "Custom" Then
			Dim parts As String() = ddlQuickPickDate.Items(SelectedIndex).Value.Split(",")
			txtStart.Text = parts(0)
			txtEnd.Text = parts(1)
		End If

	End Sub

	Protected Sub lnkView_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkView.Click
		Dim dsA As Data.DataSet = Nothing
		Dim dtD As New Data.DataTable
		'set viewer mode
        'Me.ReportViewer1.Reset()
		Me.ReportViewer1.LocalReport.ReportPath = ""

		'This may need a table later
        Select Case ddlReports.SelectedItem.Text
            Case "All Client Information Report"
                'Me.ReportViewer1.Reset()
                Me.ReportViewer1.ProcessingMode = Microsoft.Reporting.WebForms.ProcessingMode.Remote
                Me.ReportViewer1.ServerReport.ReportServerUrl = New Uri("http://lex-srv-sql1/ReportServer")
                Me.ReportViewer1.ServerReport.ReportPath = "/smart debtor reports/total clients"

                Exit Sub
            Case "Bounced/Canceled Report"
                ReportPath = "SDBounceStatusReport.rdl"
                'uwToolBar.Items.Item(2).enabled = True
            Case "Cancellation Report"
                ReportPath = "CancelledClients.rdl"

                'Begin assigning basic stuff
                StartDate = Me.txtStart.Text.ToString
                EndDate = Me.txtEnd.Text.ToString
                'Get the complete sqlStatement
                strSQL = CancellationRptHelper.SmartDebtorCancellations(StartDate, EndDate)
                'Setup the report basics and paths.

                strSQL = getReportSQL(ReportPath)

                dsA = CancellationRptHelper.getReportDataSet(strSQL, "Cancellations")
            Case "Consultant Comm. Report"
                ReportPath = "ConsultantComish.rdl"
                'uwToolBar.Items.Item(2).enabled = True

            Case "KPI"
                Response.Redirect("kpireport.aspx", True)

            Case "KPI Report"
                ReportPath = "kpi.rdl"

            Case "Lead Deposit Analysis"
                Response.Redirect("DepositAnalysisReport.aspx", True)

            Case "Deposits By Hire Date"
                Response.Redirect("DepositAnalysisReport1.aspx", True)

            Case "Lead DNIS Report"
                ReportPath = "lead_dnis_report.rdl"

            Case "Pipe Line Report"
                ReportPath = "PipeLineByRep.rdl"

            Case "Rep. Commission Report"
                ReportPath = "CommissionReport1.rdl"
                'uwToolBar.Items.Item(2).enabled = True
            Case "Pending Clients"
                Response.Redirect("AttorneyPendingQueue.aspx", True)
            Case "Lead Dashboard (Agency Reps)"
                Response.Redirect("DashboardAgencyJQ.aspx", True)

            Case Else
                dvMsg.Attributes("class") = "error"
                dvMsg.Style("display") = "block"
                dvMsg.InnerHtml = "Please Select a Report!"

                'uwToolBar.Items.Item(2).enabled = False
                Exit Sub
        End Select

		'set report 
        'Me.ReportViewer1.Reset()
		Me.ReportViewer1.ProcessingMode = Microsoft.Reporting.WebForms.ProcessingMode.Local
		Me.ReportViewer1.LocalReport.ReportPath = "Clients\Enrollment\Reports\" & ReportPath

		If ReportPath <> "CancelledClients.rdl" Then
			strSQL = getReportSQL(ReportPath)
		End If
		Try
			Me.ReportViewer1.LocalReport.SetParameters(getReportParameters(ReportPath))
		Catch ex As Exception
			Dim sbEx As New StringBuilder(ex.Message & vbCrLf)
			If ex.InnerException IsNot Nothing Then
				sbEx.Append(String.Format("Inner: {0}", ex.InnerException.ToString))
			End If

			'Response.Write(sbEx.ToString)
			

		End Try


		If strSQL <> "" Then
			Try
				Using cnSQL As New SqlConnection("server=Lexsrvsqlprod1\lexsrvsqlprod;uid=dms_sql2;pwd=j@ckp0t!;database=dms;connect timeout=60;max pool size = 150")
					'Using cnSQL As New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString())
					Dim adapter As New SqlDataAdapter()
					adapter.SelectCommand = New SqlCommand(strSQL, cnSQL)
					adapter.SelectCommand.CommandTimeout = 300
					adapter.Fill(dtD)
				End Using

				'Assign dataset to report datasource
				Dim datasource As ReportDataSource = Nothing
				If ReportPath <> "CancelledClients.rdl" Then
					datasource = New ReportDataSource("dsReportData", dtD)
				Else
					datasource = New ReportDataSource("dsReportData", dsA.Tables(0))
				End If


				'Assign datasource to report viewer control
				ReportViewer1.LocalReport.DataSources.Clear()
				ReportViewer1.LocalReport.DataSources.Add(datasource)
				ReportViewer1.LocalReport.Refresh()
				ReportViewer1.DataBind()

				dvMsg.Attributes("class") = ""
				dvMsg.Style("display") = "none"
				dvMsg.InnerHtml = ""

			Catch ex As Exception
				dvMsg.Attributes("class") = "error"
				dvMsg.Style("display") = "block"
				dvMsg.InnerHtml = ex.Message

			End Try
		End If
	End Sub

	Private Sub uwToolbar_ButtonClicked(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebToolbar.ButtonEvent) Handles uwToolBar.ButtonClicked
		Select Case e.Button.Text
			Case "Back"
				Response.Redirect("Default.aspx")
			Case "Print"
				Select Case ddlReports.SelectedIndex
					Case 1
						ReportPath = "CommissionReport1.rdl"
					Case 2
						ReportPath = "ConsultantComish.rdl"
					Case 3
						ReportPath = "SDBounceStatusReport.rdl"
					Case 4
						ReportPath = "PipeLineByRep.rdl"
					Case Else
				End Select
				Me.ReportViewer1.LocalReport.ReportPath = "Clients\Enrollment\" & ReportPath
				PrintLocalRdlc(Me.ReportViewer1, Me)
			Case Else

		End Select
    End Sub

	Public Sub PrintLocalRdlc(ByVal rwRpt As Microsoft.Reporting.WebForms.ReportViewer, ByVal page As Page)
		Dim di As New DirectoryInfo(HttpContext.Current.Server.MapPath("~/Upload/"))
		For Each fi As FileInfo In di.GetFiles()
			If fi.Name.IndexOf("_" & HttpContext.Current.Session.SessionID & "_") <> -1 Then
				fi.Delete()
			End If
		Next

		Dim mimeType As String
		Dim deviceinfo = "<DeviceInfo>" _
		& "<OutputFormat>EMF</OutputFormat>" _
		& "<PageWidth>8.5in</PageWidth>" _
		& "<PageHeight>11in</PageHeight>" _
		& "<MarginTop>0.25in</MarginTop>" _
		& "<MarginLeft>0.25in</MarginLeft>" _
		& "<MarginRight>0.25in</MarginRight>" _
		& "<MarginBottom>0.25in</MarginBottom>" _
		& "</DeviceInfo>"
		Dim encoding As String
		Dim fileNameExtension As String
		Dim streams() As String
		Dim warnings() As Warning = Nothing

		Dim pdfContent As Byte() = rwRpt.LocalReport.Render("EMF", deviceinfo, mimeType, encoding, fileNameExtension, streams, _
		warnings)

		Dim realUrl As String = ("~/Upload/Report_" & HttpContext.Current.Session.SessionID & "_") + Guid.NewGuid().ToString() & ".pdf"
		Dim pdfPath As String = HttpContext.Current.Server.MapPath(realUrl)
		Dim pdfFile As New System.IO.FileStream(pdfPath, System.IO.FileMode.Create)
		pdfFile.Write(pdfContent, 0, pdfContent.Length)
		pdfFile.Close()

		Dim windowOpen As String = "printWin = window.open('" & page.ResolveUrl(realUrl) & "', '_blank','height=800,left=100,top=100,width=1200,toolbar=no,titlebar=0,status=0,menubar=yes,location=no,scrollb ars=1' " & ");printWin.focus();self.print();"
		page.ClientScript.RegisterStartupScript(page.[GetType](), Guid.NewGuid().ToString(), windowOpen, True)
	End Sub
	Private Function getReportSQL(ByVal ReportPath As String) As String
		Dim TelemarketerNo As Integer = -1
		Dim ScreenerNo As Integer = -1
		Dim s As New StringBuilder

		If ddlTelemarketer.SelectedValue <= 0 Then
			TelemarketerNo = 0
		Else
			TelemarketerNo = ddlTelemarketer.SelectedValue
		End If

		If ddlScreener.SelectedValue <= 0 Then
			ScreenerNo = 0
		Else
			ScreenerNo = ddlScreener.SelectedValue
		End If

		StartDate = Me.txtStart.Text.ToString
		EndDate = Me.txtEnd.Text.ToString


		Select Case ReportPath
			Case "kpi.rdl"
				strSQL = String.Format("stp_Reporting_SmartDebtor_KPI '{0} 12:00:00 AM','{1} 12:00:00 AM'", FormatDateTime(StartDate, DateFormat.ShortDate), FormatDateTime(EndDate, DateFormat.ShortDate))
			Case "lead_dnis_report.rdl"
				Dim dnisList As New List(Of String)
				If Not ddlDNIS.SelectedItem Is Nothing Then
					Select Case ddlDNIS.SelectedItem.Value
						Case 0
							For Each dnis As ListItem In ddlDNIS.Items
								dnisList.Add(dnis.Text)
							Next
						Case Else
							For Each dnis As ListItem In ddlDNIS.Items
								If dnis.Selected = True Then
									dnisList.Add(dnis.Text)
								End If
							Next
					End Select
				Else
					dnisList.Add("-1")
				End If

				strSQL = String.Format("stp_Reporting_SmartDebtor_LeadDNIS '{0}','{1} 12:00:00 AM','{2} 12:00:00 AM'", Join(dnisList.ToArray, ","), FormatDateTime(StartDate, DateFormat.ShortDate), FormatDateTime(EndDate, DateFormat.ShortDate))

			Case "CommissionReport1.rdl"
				'Law Firm Rep. Commission report
				strSQL = "SELECT ru.FirstName + ' ' + ru.LastName [Lawfirm Rep], au.FirstName + ' ' + au.LastName [Consultant], "
				strSQL += "p.FirstName + ' ' + p.LastName [Applicant], la.Created [Created], c.created [Transfer Date], "
				strSQL += "ca.MaintenanceFee [1st Service Fee], "
				strSQL += "CASE WHEN ca.MaintenanceFee > 225 THEN ca.MaintenanceFee - 25 WHEN ca.MaintenanceFee < 226 THEN 200 WHEN ca.MaintenanceFee < c.DepositAmount THEN 0 END [Commission], "
				strSQL += "r.transactiondate [Date Draft Received], "
				strSQL += "CASE WHEN r.Bounce IS NOT NULL THEN r.Bounce WHEN r.void IS NOT NULL THEN r.void END  [Rejected], "
				strSQL += "br.BouncedDescription [Reason] FROM tblleadapplicant la "
				strSQL += "INNER JOIN tblimportedclient i ON la.LeadApplicantID = i.ExternalClientId "
				strSQL += "AND i.sourceid = 1 INNER JOIN tblClient c ON i.importid = c.serviceimportid "
				strSQL += "INNER JOIN tblPerson p ON p.clientid = c.clientid AND p.Relationship = 'Prime' "
				strSQL += "LEFT JOIN tblRegister r ON r.ClientID = c.ClientID "
				strSQL += "AND r.registerid = (SELECT TOP 1 RegisterID FROM tblRegister WHERE entrytypeid = 3 AND clientid = c.ClientID) "
				strSQL += "INNER JOIN tblUser ru ON ru.userid = la.RepID "
				strSQL += "INNER JOIN tblLeadCalculator ca ON ca.LeadApplicantID = la.LeadApplicantID "
				strSQL += "INNER JOIN tblUser au ON au.userid = la.CreatedByID "
				strSQL += "LEFT JOIN tblBouncedReasons br ON br.bouncedID = r.BouncedReason "
				strSQL += "WHERE r.TransactionDate IS NOT NULL AND "
				If TelemarketerNo <= 0 And ScreenerNo <= 0 Then	'All records
					strSQL += "(la.RepID > -1 OR la.RepID IS NULL) AND (la.CreatedByID > -1 OR la.CreatedByID IS NULL) "
					strSQL += "AND r.TransactionDate BETWEEN '" & StartDate & "' AND '" & EndDate & "' "
					strSQL += "ORDER BY ru.lastname, r.TransactionDate"
				End If

				If TelemarketerNo > 0 And ScreenerNo <= 0 Then 'Consultants
					strSQL += "la.RepID > -1 AND la.CreatedByID = " & TelemarketerNo & " "
					strSQL += "AND r.TransactionDate BETWEEN '" & StartDate & "' AND '" & EndDate & "' "
					strSQL += "ORDER BY ru.lastname, r.TransactionDate"
				End If

				If TelemarketerNo <= 0 And ScreenerNo > 0 Then 'Law Firm Reps
					strSQL += "la.RepID = " & ScreenerNo & " AND la.CreatedByID > 0 "
					strSQL += "AND r.TransactionDate BETWEEN '" & StartDate & "' AND '" & EndDate & "' "
					strSQL += "ORDER BY ru.lastname, r.TransactionDate"
				End If

				If TelemarketerNo > 0 And ScreenerNo > 0 Then 'Both Law Firm rep and Consultant
					strSQL += "la.RepID = " & ScreenerNo & " AND la.CreatedByID = " & TelemarketerNo & " "
					strSQL += "AND r.TransactionDate BETWEEN '" & StartDate & "' AND '" & EndDate & "' "
					strSQL += "ORDER BY ru.lastname, r.TransactionDate"
				End If
			Case "SDBounceStatusReport.rdl"
				'Bounced report no consultant
				s.Append("SELECT ru.firstname + ' ' + ru.lastname [Law Firm Rep], ")
				s.Append("au.firstname + ' ' + au.lastname [Consultant], la.LeadName [Applicant], ")
				s.Append("rm.created [Status Changed Date], cs.Name [Current Client Status], ")
				s.Append("et.DisplayName [Transaction Type], r.TransactionDate [Transaction Date], ")
				s.Append("ca.MaintenanceFee [Transaction Amount], ")
				s.Append("CASE WHEN ca.MaintenanceFee > 225 THEN ca.MaintenanceFee - 25 WHEN ca.MaintenanceFee < 226 THEN 200 WHEN ca.MaintenanceFee < c.DepositAmount THEN 0 END [Commission Amount], ")
				s.Append("CASE WHEN r.Bounce IS NOT NULL THEN r.bounce WHEN r.void IS NOT NULL THEN r.void END [Returned], ")
				s.Append("r.description [Reason] ")
				s.Append("FROM tblclient c INNER JOIN tblperson pe ON pe.clientid = c.clientid ")
				s.Append("INNER JOIN tblroadmap rm ON rm.clientid = c.clientid AND rm.clientstatusid = c.CurrentClientStatusID ")
				s.Append("LEFT JOIN tblimportedclient i ON i.importid = c.ServiceImportId ")
				s.Append("LEFT JOIN tblLeadApplicant la ON la.LeadApplicantID = i.ExternalClientId ")
				s.Append("LEFT JOIN tblUser ru ON ru.userid = la.RepID ")
				s.Append("LEFT JOIN tblUser au ON au.userid = la.CreatedByID ")
				s.Append("INNER JOIN tblLeadCalculator ca ON ca.LeadApplicantID = la.LeadApplicantID ")
				s.Append("LEFT JOIN tblregister r ON r.clientid = c.clientid  AND r.TransactionDate = c.InitialDraftDate ")
				s.Append("INNER JOIN tblentrytype et ON et.EntryTypeID = r.EntryTypeId ")
				s.Append("INNER JOIN tblbouncedreasons br ON br.BouncedID = r.BouncedReason ")
				s.Append("INNER JOIN tblclientstatus cs ON cs.clientstatusid = c.currentclientstatusid ")
				s.Append("WHERE c.agencyid = 856 ")
				s.Append("AND pe.relationship = 'Prime' ")
				s.Append("AND c.created > dateadd(day, -90, getdate()) ")
				s.Append("AND (r.Bounce IS NOT NULL OR r.Void IS NOT NULL OR c.currentclientstatusid IN (15, 17, 18)) ")
				s.Append("AND ")
				s.Replace(Chr(13), "")
				s.Replace(Chr(10), "")
				strSQL = s.ToString
				If TelemarketerNo <= 0 And ScreenerNo <= 0 Then	'All records
					strSQL += "(la.RepID > -1 OR la.RepID IS NULL) "
					strSQL += "AND (la.CreatedByID > -1 OR la.CreatedByID IS NULL) "
					strSQL += "AND r.TransactionDate BETWEEN '" & StartDate & "' AND '" & EndDate & "' "
					strSQL += "ORDER BY ru.lastname, r.TransactionDate"
				End If

				If TelemarketerNo > 0 And ScreenerNo <= 0 Then 'Consultants
					strSQL += "la.RepID > -1 "
					strSQL += "AND la.CreatedByID = " & TelemarketerNo & " "
					strSQL += "AND r.TransactionDate BETWEEN '" & StartDate & "' AND '" & EndDate & "' "
					strSQL += "ORDER BY ru.lastname, r.TransactionDate"
				End If

				If TelemarketerNo <= 0 And ScreenerNo > 0 Then 'Law Firm Reps
					strSQL += "la.RepID = " & ScreenerNo & " "
					strSQL += "AND la.CreatedByID > 0 "
					strSQL += "AND r.TransactionDate BETWEEN '" & StartDate & "' AND '" & EndDate & "' "
					strSQL += "ORDER BY ru.lastname, r.TransactionDate"
				End If

				If TelemarketerNo > 0 And ScreenerNo > 0 Then 'Both Law Firm rep and Consultant
					strSQL += "la.RepID = " & ScreenerNo & " "
					strSQL += "AND la.CreatedByID = " & TelemarketerNo & " "
					strSQL += "AND r.TransactionDate BETWEEN '" & StartDate & "' AND '" & EndDate & "' "
					strSQL += "ORDER BY ru.lastname, r.TransactionDate"
				End If

			Case "ConsultantComish.rdl"
				'Consultant Commission report
				strSQL = "SELECT "
				strSQL += "ru.FirstName + ' ' + ru.LastName [Lawfirm Rep], "
				strSQL += "au.FirstName + ' ' + au.LastName [Consultant], "
				strSQL += "p.FirstName + ' ' + p.LastName [Applicant], "
				strSQL += "la.Created [Created], "
				strSQL += "c.created [Transfer Date], "
				strSQL += "ca.MaintenanceFee [1st Service Fee], "
				strSQL += "15.00 [Commission], "
				strSQL += "r.transactiondate [Date Draft Received], "
				strSQL += "CASE WHEN r.Bounce IS NOT NULL THEN r.Bounce WHEN r.void IS NOT NULL THEN r.void END  [Rejected], "
				strSQL += "br.BouncedDescription [Reason] "
				strSQL += "FROM tblleadapplicant la "
				strSQL += "INNER JOIN tblimportedclient i ON la.LeadApplicantID = i.ExternalClientId "
				strSQL += "AND i.sourceid = 1 "
				strSQL += "INNER JOIN tblClient c ON i.importid = c.serviceimportid "
				strSQL += "INNER JOIN tblPerson p ON p.clientid = c.clientid "
				strSQL += "AND p.Relationship = 'Prime' "
				strSQL += "LEFT JOIN tblRegister r ON r.ClientID = c.ClientID "
				strSQL += "AND r.registerid = (SELECT TOP 1 RegisterID FROM tblRegister WHERE entrytypeid = 3 AND clientid = c.ClientID) "
				strSQL += "INNER JOIN tblUser ru ON ru.userid = la.RepID "
				strSQL += "INNER JOIN tblLeadCalculator ca ON ca.LeadApplicantID = la.LeadApplicantID "
				strSQL += "INNER JOIN tblUser au ON au.userid = la.CreatedByID "
				strSQL += "AND au.userid <> ru.userid "
				strSQL += "LEFT JOIN tblBouncedReasons br ON br.bouncedID = r.BouncedReason "
				strSQL += "WHERE r.TransactionDate IS NOT NULL AND "
				If TelemarketerNo <= 0 And ScreenerNo <= 0 Then	'All records
					strSQL += "(la.RepID > -1 OR la.RepID IS NULL) "
					strSQL += "AND (la.CreatedByID > -1 OR la.CreatedByID IS NULL) "
					strSQL += "AND r.TransactionDate BETWEEN '" & StartDate & "' AND '" & EndDate & "' "
					strSQL += "ORDER BY ru.lastname, r.TransactionDate"
				End If

				If TelemarketerNo > 0 And ScreenerNo <= 0 Then 'Consultants
					strSQL += "la.RepID > -1 "
					strSQL += "AND la.CreatedByID = " & TelemarketerNo & " "
					strSQL += "AND r.TransactionDate BETWEEN '" & StartDate & "' AND '" & EndDate & "' "
					strSQL += "ORDER BY ru.lastname, r.TransactionDate"
				End If

				If TelemarketerNo <= 0 And ScreenerNo > 0 Then 'Law Firm Reps
					strSQL += "la.RepID = " & ScreenerNo & " "
					strSQL += "AND la.CreatedByID > 0 "
					strSQL += "AND r.TransactionDate BETWEEN '" & StartDate & "' AND '" & EndDate & "' "
					strSQL += "ORDER BY ru.lastname, r.TransactionDate"
				End If

				If TelemarketerNo > 0 And ScreenerNo > 0 Then 'Both Law Firm rep and Consultant
					strSQL += "la.RepID = " & ScreenerNo & " "
					strSQL += "AND la.CreatedByID = " & TelemarketerNo & " "
					strSQL += "AND r.TransactionDate BETWEEN '" & StartDate & "' AND '" & EndDate & "' "
					strSQL += "ORDER BY ru.lastname, r.TransactionDate"
				End If
			Case "PipeLineByRep.rdl"
				'Pipeline report
				strSQL += "SELECT "
				strSQL += "ru.FirstName + ' ' + ru.LastName [Law Firm Rep], "
				strSQL += "au.FirstName + ' ' + au.LastName [Consultant], "
				strSQL += "la.FullName [Applicant], "
				strSQL += "st.Abbreviation [State], "
				strSQL += "la.Created [Created], "
				strSQL += "la.LastModified [Last Modified], "
				strSQL += "s.Description [Status], "
				strSQL += "ls.Name [Lead Source] "
				strSQL += "FROM tblleadapplicant la "
				strSQL += "INNER JOIN tblUser ru ON ru.userid = la.RepID "
				strSQL += "INNER JOIN tblUser au ON au.userid = la.CreatedByID "
				strSQL += "INNER JOIN tblLeadCalculator ca ON ca.LeadApplicantID = la.LeadApplicantID "
				strSQL += "INNER JOIN tblLeadStatus s ON s.statusid = la.statusid "
				strSQL += "INNER JOIN tblleadsources ls ON ls.LeadSourceID = la.leadsourceid "
				strSQL += "INNER JOIN tblState st ON st.stateid = la.StateID "
				strSQL += "WHERE "
				If TelemarketerNo <= 0 And ScreenerNo <= 0 Then	'All records
					strSQL += String.Format("(la.RepID > -1 OR la.RepID IS NULL) AND (la.CreatedByID > -1 OR la.CreatedByID IS NULL)")
					strSQL += String.Format("AND la.Created BETWEEN '{0}' AND '{1}' ", StartDate, EndDate)
					strSQL += String.Format("ORDER BY ru.lastname, st.abbreviation, s.description, la.created")
				End If

				If TelemarketerNo > 0 And ScreenerNo <= 0 Then 'Consultants
					strSQL += "la.RepID > -1 "
					strSQL += "AND la.CreatedByID = " & TelemarketerNo & " "
					strSQL += "AND la.Created BETWEEN '" & StartDate & "' AND '" & EndDate & "' "
					strSQL += "ORDER BY ru.lastname, st.abbreviation, s.description, la.created"
				End If

				If TelemarketerNo <= 0 And ScreenerNo > 0 Then 'Law Firm Reps
					strSQL += "la.RepID = " & ScreenerNo & " "
					strSQL += "AND la.CreatedByID > 0 "
					strSQL += "AND la.Created BETWEEN '" & StartDate & "' AND '" & EndDate & "' "
					strSQL += "ORDER BY ru.lastname, st.abbreviation, s.description, la.created"
				End If

				If TelemarketerNo > 0 And ScreenerNo > 0 Then 'Both Law Firm rep and Consultant
					strSQL += "la.RepID = " & ScreenerNo & " "
					strSQL += "AND la.CreatedByID = " & TelemarketerNo & " "
					strSQL += "AND la.Created BETWEEN '" & StartDate & "' AND '" & EndDate & "' "
					strSQL += "ORDER BY ru.lastname, st.abbreviation, s.description, la.created"
				End If
			Case "CancelledClients.rdl"
				'screener is law firm rep or RepID
				'telemarketer is createdbyid
				If TelemarketerNo <= 0 And ScreenerNo <= 0 Then	'All records
					strSQL += " AND (la.RepID > -1 OR la.RepID IS NULL)"
					strSQL += " AND (la.CreatedByID > -1 OR la.CreatedByID IS NULL)"
				End If

				If TelemarketerNo > 0 And ScreenerNo <= 0 Then 'Consultants
					strSQL += " AND la.CreatedByID > -1"
					strSQL += " AND la.CreatedByID = " & TelemarketerNo & " "
				End If

				If TelemarketerNo <= 0 And ScreenerNo > 0 Then 'Law Firm Reps
					strSQL += " AND la.RepID = " & ScreenerNo
					strSQL += " AND la.RepID > -1 "
				End If

				If TelemarketerNo > 0 And ScreenerNo > 0 Then 'Both Law Firm rep and Consultant
					strSQL += " AND la.RepID = " & ScreenerNo
					strSQL += " AND la.CreatedByID = " & TelemarketerNo
				End If
				strSQL += " ORDER BY convert(nvarchar(10), rm.created, 101)"


			Case Else
				strSQL = ""
		End Select

		Return strSQL

	End Function
	Private Function getReportParameters(ByVal reportPath As String) As ReportParameter()
		Dim TelemarketerNo As Integer = -1
		Dim ScreenerNo As Integer = -1
		Dim params(3) As ReportParameter


		If ddlTelemarketer.SelectedValue <= 0 Then
			TelemarketerNo = 0
		Else
			TelemarketerNo = ddlTelemarketer.SelectedValue
		End If

		If ddlScreener.SelectedValue <= 0 Then
			ScreenerNo = 0
		Else
			ScreenerNo = ddlScreener.SelectedValue
		End If

		StartDate = Me.txtStart.Text.ToString
		EndDate = Me.txtEnd.Text.ToString

		'This may need a table later
		Select Case reportPath
			Case "CancelledClients.rdl"
				ReDim params(1)
				'set report params
				params(0) = New ReportParameter("StartDate", StartDate)
				params(1) = New ReportParameter("EndDate", EndDate)

			Case "CommissionReport1.rdl"
				'set report params
				params(0) = New ReportParameter("RepID", ScreenerNo)
				params(1) = New ReportParameter("CreatedByID", TelemarketerNo)
				params(2) = New ReportParameter("StartDate", StartDate)
				params(3) = New ReportParameter("EndDate", EndDate)
			Case "ConsultantComish.rdl"
				'set report params
				params(0) = New ReportParameter("RepID", ScreenerNo)
				params(1) = New ReportParameter("CreatedByID", TelemarketerNo)
				params(2) = New ReportParameter("StartDate", StartDate)
				params(3) = New ReportParameter("EndDate", EndDate)
			Case "SDBounceStatusReport.rdl"
				'set report params
				params(0) = New ReportParameter("RepID", ScreenerNo)
				params(1) = New ReportParameter("CreatedByID", TelemarketerNo)
				params(2) = New ReportParameter("StartDate", StartDate)
				params(3) = New ReportParameter("EndDate", EndDate)
			Case "PipeLineByRep.rdl"
				'set report params
				params(0) = New ReportParameter("RepID", ScreenerNo)
				params(1) = New ReportParameter("CreatedByID", TelemarketerNo)
				params(2) = New ReportParameter("StartDate", StartDate)
				params(3) = New ReportParameter("EndDate", EndDate)
			Case "lead_dnis_report.rdl"
				ReDim params(2)
				Dim dnisList As New List(Of String)

				Select Case ddlDNIS.SelectedItem.Value
					Case "All"
						For Each dnis As ListItem In ddlDNIS.Items
							dnisList.Add(dnis.Text)
						Next
					Case Else
						For Each dnis As ListItem In ddlDNIS.Items
							If dnis.Selected = True Then
								dnisList.Add(dnis.Text)
							End If
						Next


				End Select

				params(0) = New ReportParameter("dnis", Join(dnisList.ToArray, ","))
				params(1) = New ReportParameter("startDate", StartDate)
				params(2) = New ReportParameter("endDate", EndDate)
			Case "kpi.rdl"
				ReDim params(1)
				params(0) = New ReportParameter("startdate", StartDate)
				params(1) = New ReportParameter("enddate", EndDate)

		End Select

		Return params

    End Function

End Class
