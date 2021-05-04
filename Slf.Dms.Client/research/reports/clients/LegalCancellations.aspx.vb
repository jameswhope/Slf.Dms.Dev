Imports System.Collections.Generic
Imports Microsoft.Reporting
Imports Microsoft.Reporting.WebForms
Imports Drg.Util.DataAccess
Imports LocalHelper
Imports System.Data.SqlClient
Imports System.IO
Imports System.Data
Imports System.Web.UI
Partial Class research_reports_financial_servicefees_LegalCancellations
    Inherits System.Web.UI.Page

#Region "Variables"

   Private ReportType As String = ""
   Public ReportPath As String
   Private UserID As String = ""
   Private UserGroupdID As String
   Private strSQL As String = ""
   Private StartDate As String
   Private EndDate As String

#End Region

   Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
      UserID = DataHelper.Nz_int(Page.User.Identity.Name)
      UserGroupdID = DataHelper.FieldLookup("tblUser", "UserGroupID", "Userid = " & UserID)

        ReportType = Request.QueryString("rpt")

        If IsPostBack Then
            If ReportType = "cancellations" Then
                lblMsg.Text = "Cancellation Report"
            Else
                lblMsg.Text = "Legal Cancellation Report."
            End If

            lblMsg.ForeColor = System.Drawing.Color.Black
        Else
            If ReportType = "cancellations" Then
                lblMsg.Text = "Cancellation Report"
            Else
                lblMsg.Text = "Legal Cancellation Report."
            End If
        End If

      'set viewer mode
      Me.ReportViewer1.Reset()
      Me.ReportViewer1.ProcessingMode = Microsoft.Reporting.WebForms.ProcessingMode.Local

      Me.tblDates.Style("display") = ""

      '*********NOT USED HERE YET
      'If ReportType = "" Then
      '   ReportType = ""
      'End If

      'If Me.UserGroupdID.Contains("7") Or Me.UserGroupdID.Contains("11") Then

      'End If

      If Not IsPostBack Then
         LoadQuickPickDates()
      End If
   End Sub

   Protected Sub ddlQuickPickDate_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
      Dim ddl As DropDownList = DirectCast(sender, DropDownList)
      If ddl.SelectedValue.ToString <> "Custom" Then
         Dim parts As String() = ddl.SelectedValue.Split(",")
         txtStart.Text = parts(0)
         txtEnd.Text = parts(1)
      End If
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
      Dim dtD As Data.DataTable = Nothing
      Dim dsT As Data.DataSet = Nothing
      Dim dsA As Data.DataSet = Nothing
      Dim strSQL As String = ""

      'Begin assigning basic stuff
      StartDate = Me.txtStart.Text.ToString
      EndDate = Me.txtEnd.Text.ToString

      'Get the complete sqlStatement
      strSQL = CancellationRptHelper.CreateCancelledTSQL(StartDate, EndDate)

      'Setup the report basics and paths.
      Try
         ReportPath = "LegalCancelledClients.rdl"
         'set viewer mode
         Me.ReportViewer1.Reset()
         Me.ReportViewer1.ProcessingMode = Microsoft.Reporting.WebForms.ProcessingMode.Local

         Dim params(1) As ReportParameter

         'set report 
         Me.ReportViewer1.LocalReport.ReportPath = ""
         Me.ReportViewer1.LocalReport.ReportPath = "research\reports\Clients\" & ReportPath

         'set report params
         params(0) = New ReportParameter("StartDate", StartDate)
         params(1) = New ReportParameter("EndDate", EndDate)

         Me.ReportViewer1.LocalReport.SetParameters(params)

         dsA = CancellationRptHelper.getReportDataSet(strSQL, "Cancellations")

      Catch ex As Exception

      End Try

      If strSQL <> "" Then
         Try
            'Assign dataset to report datasource
            Dim datasource As ReportDataSource = New ReportDataSource("dsQA", dsA.Tables(0))

            'Assign datasource to report viewer control
            ReportViewer1.LocalReport.DataSources.Clear()
            ReportViewer1.LocalReport.DataSources.Add(datasource)
            ReportViewer1.LocalReport.Refresh()
            ReportViewer1.DataBind()
         Catch ex As Exception
            Alert.Show("There was an error retrieving this report from the server. Please wait and try again in a few minutes.")
         End Try
      End If

   End Sub

   Private Sub uwToolbar_ButtonClicked(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebToolbar.ButtonEvent) Handles uwToolBar.ButtonClicked
      Select Case e.Button.Text
         Case "Back"
            Response.Redirect("../Default.aspx")
         Case "Print"
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

End Class
