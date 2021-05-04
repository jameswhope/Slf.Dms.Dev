Imports System.Collections.Generic
Imports Microsoft.Reporting
Imports Microsoft.Reporting.WebForms
Imports Drg.Util.DataAccess
Imports LocalHelper
Imports System.Data.SqlClient

Partial Class admin_Processes_ProcessClients_Statements_Default
    Inherits System.Web.UI.Page

#Region "Variables"

   Private ReportType As String = ""
   Private ReportPath As String = "NewStatementExceptions.rdl"
   Private UserID As String = ""
   Private UserCommRecID As String
   Private UserGroupdID As String
   Private strSQL As String = ""
   Private StartDate As String
   Private EndDate As String
   Private EType As String

#End Region

#Region "Processing"

   Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
      UserID = DataHelper.Nz_int(Page.User.Identity.Name)
      UserGroupdID = DataHelper.FieldLookup("tblUser", "UserGroupID", "Userid = " & UserID)
      UserCommRecID = DataHelper.FieldLookup("tblUser", "CommRecID", "Userid = " & UserID)


      ReportType = Request.QueryString("rpt")

      If ReportType = "" Then
         ReportType = "Exceptions"
      End If

      'set viewer mode
      Me.ReportViewer1.ProcessingMode = Microsoft.Reporting.WebForms.ProcessingMode.Local

      Select Case ReportType
         Case "Exceptions"
            'set report title
            lblMsg.Text = "Statement Exception Report"
            'set report file path
            ReportPath = "NewStatementExceptions.rdl"
            Me.tblDates.Style("display") = ""
            If Me.UserGroupdID.Contains("7") Or Me.UserGroupdID.Contains("11") Then
               'Me.tblAgent.Style("display") = ""
            End If
         Case Else

      End Select
      If Not IsPostBack Then
         LoadQuickPickDates()
         LoadReasons()
      End If
   End Sub

   Private Sub LoadQuickPickDates()
      ddlQuickPickDate.Items.Clear()

      ddlQuickPickDate.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("MM/dd/yy")))
      ddlQuickPickDate.Items.Add(New ListItem("This Year", RoundDate(Now, -1, DateUnit.Year).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Year).ToString("MM/dd/yy")))

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
      Dim dsD As Data.DataSet

      'set report 
      Me.ReportViewer1.LocalReport.ReportPath = "admin\Processes\ProcessClients\Statements\" & ReportPath

      'get params
      Dim AccountNo As Integer

      Dim params(3) As ReportParameter

      If txtAcctNo.Text <> "" Then
         AccountNo = CInt(txtAcctNo.Text)
      Else
         AccountNo = 0
      End If

      EType = Me.ddlEType.SelectedValue

      '************TEST************
      'StartDate = "03/01/2008"
      'EndDate = "03/31/2008"

      StartDate = Me.txtStart.Text.ToString
      EndDate = Me.txtEnd.Text.ToString

      'set report params
      params(0) = New ReportParameter("AcctNo", AccountNo)
      params(1) = New ReportParameter("SDate", StartDate)
      params(2) = New ReportParameter("EDate", EndDate)
      params(3) = New ReportParameter("EType", EType)

      Try
         Me.ReportViewer1.LocalReport.SetParameters(params)

         If AccountNo = 0 And EType = "All" Then
            strSQL = "SELECT ExStmtID, ExceptionDate, AccountNumber, ExceptionReasonID, ExceptionReason, "
            strSQL += "ExceptionType, Created, CreatedBy, Modified, ModifiedBy, PeriodCovered "
            strSQL += "FROM tblStatementExceptions "
            strSQL += "WHERE AccountNumber >= " & AccountNo & " "
            strSQL += "AND PeriodCovered BETWEEN '" & StartDate & "' AND '" & EndDate & "' "
            strSQL += "ORDER BY ExceptionType, ExceptionDate"
         End If

         If AccountNo = 0 And EType <> "All" Then
            strSQL = "SELECT ExStmtID, ExceptionDate, AccountNumber, ExceptionReasonID, ExceptionReason, "
            strSQL += "ExceptionType, Created, CreatedBy, Modified, ModifiedBy, PeriodCovered "
            strSQL += "FROM tblStatementExceptions "
            strSQL += "WHERE AccountNumber >= " & AccountNo & " "
            strSQL += "AND PeriodCovered BETWEEN '" & StartDate & "' AND '" & EndDate & "' "
            strSQL += " AND ExceptionType LIKE '%" & EType & "%' "
            strSQL += "ORDER BY ExceptionType, ExceptionDate"
         End If

         If AccountNo <> 0 And EType = "All" Then
            strSQL = "SELECT ExStmtID, ExceptionDate, AccountNumber, ExceptionReasonID, ExceptionReason, "
            strSQL += "ExceptionType, Created, CreatedBy, Modified, ModifiedBy, PeriodCovered "
            strSQL += "FROM tblStatementExceptions "
            strSQL += "WHERE AccountNumber = " & AccountNo & " "
            strSQL += "AND PeriodCovered BETWEEN '" & StartDate & "' AND '" & EndDate & "' "
            strSQL += "ORDER BY ExceptionType, ExceptionDate"
         End If

         If AccountNo <> 0 And EType <> "All" Then
            strSQL = "SELECT ExStmtID, ExceptionDate, AccountNumber, ExceptionReasonID, ExceptionReason, "
            strSQL += "ExceptionType, Created, CreatedBy, Modified, ModifiedBy, PeriodCovered "
            strSQL += "FROM tblStatementExceptions "
            strSQL += "WHERE AccountNumber = " & AccountNo & " "
            strSQL += "AND PeriodCovered BETWEEN '" & StartDate & "' AND '" & EndDate & "' "
            strSQL += " AND ExceptionType LIKE '%" & EType & "%' "
            strSQL += "ORDER BY ExceptionType, ExceptionDate"
         End If

         Using cnSQL As New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString())
            Dim adapter As New SqlDataAdapter()
            adapter.SelectCommand = New SqlCommand(strSQL, cnSQL)
            adapter.Fill(dtD)
         End Using

         'Assign dataset to report datasource
         Dim datasource As ReportDataSource = New ReportDataSource("dsSExceptions", dtD)

         'Assign datasource to report viewer control
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

   Protected Sub LoadReasons()
      ddlEType.Items.Clear()

      ddlEType.Items.Add(New ListItem("All", "All"))
      ddlEType.Items.Add(New ListItem("Negative PFO", "Client"))

      ddlEType.Items.Add(New ListItem("Compression", "Comp"))
      ddlEType.Items.Add(New ListItem("FTP", "FTP"))
   End Sub

#End Region
End Class
