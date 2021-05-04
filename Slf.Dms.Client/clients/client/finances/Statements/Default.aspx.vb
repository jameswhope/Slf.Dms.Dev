Imports System
Imports System.Data
Imports Drg.Util.DataAccess
Imports Drg.Util.Helpers
Imports Drg.Util.DataHelpers
Imports LexxiomLetterTemplates
Imports GrapeCity.ActiveReports.Export.Pdf
Imports Microsoft.VisualBasic

Namespace Clients.client.finances.Statements

    Partial Class Clients_client_finances_Statements_Default
        Inherits System.Web.UI.Page

#Region "Variables"

        Private UserID As Integer
        Private Month As String
        Private Year As String
        Private Shadows ClientID As Integer
        Private AccountNumber As String
        Private qs As QueryStringCollection
        Private vMonth As String
        Private vYear As String

#End Region

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

            qs = LoadQueryString()

            UserID = DataHelper.Nz_int(Page.User.Identity.Name)

            If Not qs Is Nothing Then

                ClientID = DataHelper.Nz_int(qs("id"), 0)
                AccountNumber = Drg.Util.DataAccess.DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " & ClientID)

                If IsPostBack Then
                    If ClientID <> 0 Then
                        CreateDataSet(ClientID)
                    End If
                    Me.prtButton.Visible = True
                Else
                    ddlMonth.SelectedValue = MonthName(Now.AddMonths(-1).Month) 'MonthName(Format(DateAdd(DateInterval.Month, -1, Now), "MM"), False)
                    ddlYear.SelectedValue = Now.AddMonths(-1).Year 'Format(Now, "yyyy")
                    Me.prtButton.Visible = False
                    lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
                    lnkClient.HRef = "~/clients/client/?id=" & ClientID
                End If

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

        Private Sub CreateDataSet(ByVal ClientID As Integer)
            Dim sh As New StatementHelper
            Dim ds As DataSet

            Dim Created As Date = CDate(DataHelper.FieldLookup("tblClient", "Created", "ClientID = " & ClientID))
            Dim DepositDay As Integer = CInt(DataHelper.FieldLookup("tblClient", "DepositDay", "ClientID = " & ClientID))

            vMonth = ddlMonth.SelectedValue
            vYear = ddlYear.SelectedValue

            Dim rDate As DateTime = "#" & vMonth & "/1/" & vYear & "#"
            Dim TheMonth As Integer
            TheMonth = Microsoft.VisualBasic.Month(rDate)

            If vYear = Now.Year And TheMonth = Now.Month And Now.Day <= 15 And DepositDay <= 15 Then
                Me.lblStatusReport.Text = "This statement will not be created until the 16th."
                Me.lblStatusReport.ForeColor = System.Drawing.Color.Red
                Me.lblStatusReport.Font.Size = "11"
                Exit Sub
            End If

            ds = sh.GetTheStatementData(ClientID, vMonth, vYear)
            If ds.Tables.Count > 0 Then
                Me.lblStatusReport.Text = "Status Report"
                Me.lblStatusReport.ForeColor = System.Drawing.Color.Black
                Me.lblStatusReport.Font.Size = "24"
                If ds.Tables(0).Rows.Count > 0 Then
                    AssignPersonnalData(ds, ClientID)
                Else
                    If Created > vMonth & " 1, " & vYear Or Created > vMonth & " 16, " & vYear Then
                        Alert.Show("There are no statements for this client for this period. The Client was just created on " & Format(Created, "MMM. dd, yyyy"))
                    Else
                        Alert.Show("There is no statement for this client, for this period.") 'Let's see if we can't create one
                    End If
                End If
            Else
                Me.lblStatusReport.Text = "There is a problem accessing the statement data for this client, for this period."
                Me.lblStatusReport.ForeColor = System.Drawing.Color.Red
                Me.lblStatusReport.Font.Size = "12"
            End If

        End Sub

        Private Sub AssignPersonnalData(ByVal ds As DataSet, ByVal ClientID As Integer)
            Dim sh As New StatementHelper
            Dim DepositDay As Integer = CInt(DataHelper.FieldLookup("tblClient", "DepositDay", "ClientID = " & ClientID))

            If ds.Tables(0).Rows.Count > 0 Then
                Dim DepositDate As String = ds.Tables(0).Rows(0).Item(9)
                If DepositDate.ToString().Contains("February 30") Then
                    If Date.IsLeapYear(Right(DepositDate, 4)) Then
                        DepositDate = "February 29, " & Right(DepositDate.ToString(), 4)
                        UpdatePTable(ds, DepositDate)
                    Else
                        DepositDate = "February 28, " & Right(DepositDate.ToString(), 4)
                        UpdatePTable(ds, DepositDate)
                    End If
                End If
                Dim AttorneyName As String = DataHelper.FieldLookup("tblCompany", "Name", "CompanyID = " & ds.Tables(0).Rows(0).Item(1).ToString)

                With ds.Tables(0).Rows(0)
                    Me.tcAccountNo.Text = .Item(1).ToString
                    Me.tcClientName.Text = .Item(3).ToString
                    Me.tcClientAddress.Text = .Item(4).ToString
                    Me.tcClientCSZ.Text = .Item(5).ToString() & ", " & .Item(6).ToString() & " " & .Item(7).ToString()
                    Me.lblPeriod.Text = .Item(8).ToString
                    Me.tcDepDate0.Text = sh.ConvertToDate(DepositDate)
                    If .Item(10).ToString <> "" Then
                        Me.tcMinDeposit.Text = Format(System.Convert.ToDouble(.Item(10)), "$#,###.00")
                    End If
                    Me.tcAttyName.Text = AttorneyName
                    Me.tcAttyAddress.Text = .Item(15).ToString
                    Me.tcAttyCSZ.Text = .Item(16).ToString
                    Me.tcDepDate1.Text = DepositDate '.Item(19).ToString
                    If .Item(21).ToString <> "" Then
                        Me.tcDepAmt1.Text = Format(System.Convert.ToDouble(.Item(21)), "$#,###.00")
                    End If
                    If .Item(22).ToString().Contains("February 30") Then
                        If Date.IsLeapYear(Right(.Item(21).ToString, 4)) Then
                            DepositDate = "February 29, " & Right(Items(21).ToString(), 4)
                            UpdatePTable(ds, DepositDate)
                        Else
                            DepositDate = "February 28, " & Right(.Item(21).ToString(), 4)
                            UpdatePTable(ds, DepositDate)
                        End If
                    End If
                    Me.tcDepDate2.Text = .Item(23).ToString
                    Me.tcDepAmt2.Text = .Item(24).ToString
                    Me.tcDepDate3.Text = .Item(25).ToString
                    Me.tcDepAmt3.Text = .Item(26).ToString
                    Me.tcDepDate4.Text = .Item(25).ToString
                    Me.tcDepAmt4.Text = .Item(26).ToString
                    Me.spAccountNo.Text = "Account Number" & " " & .Item(1).ToString
                End With

                Me.grdTransactions.DataSource = ds
                Me.grdTransactions.DataMember = "Trans"
                Me.grdTransactions.DataBind()


                Me.grdCreditor.DataSource = ds
                Me.grdCreditor.DataMember = "Creditor"
                Me.grdCreditor.DataBind()

            Else
                If ddlYear.SelectedValue > Format(Now, "yyyy") Then
                    Alert.Show("No statements have been created for the year " & ddlYear.SelectedValue & " yet.")
                End If
                If sh.GetMonthNumber(ddlMonth.SelectedValue) > CInt(Format(Now, "MM")) Then
                    Alert.Show("No statements have been created for the month of " & ddlYear.SelectedValue & " yet.")
                End If
                If DepositDay >= 1 And DepositDay < 16 Then
                    If DatePart(DateInterval.Day, Now) < 16 And sh.GetMonthNumber(ddlMonth.SelectedValue) = DatePart(DateInterval.Month, Now) Then
                        Alert.Show("No statements have been created for this client yet " & ddlYear.SelectedValue & " yet.")
                    End If
                End If
                If sh.GetClientCurrentStatus(ClientID) = 15 Or sh.GetClientCurrentStatus(ClientID) = 17 Or sh.GetClientCurrentStatus(ClientID) = 185 Then
                    Alert.Show("This client has been either Cancelled, Terminated or marked Inactive. Please verify the date the client status was changed as it may have been prior to this statement's run period.")
                End If
                ClearData()
            End If
        End Sub

        Public Sub ClearData()
            Me.grdCreditor.DataSource = Nothing
            Me.grdCreditor.DataBind()
            Me.grdTransactions.DataSource = Nothing
            Me.grdTransactions.DataBind()
        End Sub

        Public Sub lnkPrintStatement(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkPrint.Click
            'Response.Redirect("ClientStatements.aspx?id=" & ClientID & "&m=" & vMonth & "&y=" & vYear)
            Dim iMonth As String = CDate(String.Format("{0} 1, {1}", vMonth, vYear)).Month

            Using rptTemplates As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
                Dim cRpt As GrapeCity.ActiveReports.SectionReport = Nothing
                cRpt = New GrapeCity.ActiveReports.SectionReport
                cRpt = New LexxiomLetterTemplates.ClientStatement(ClientID, iMonth, vYear)
                cRpt.Run()
                Dim rs As New IO.MemoryStream
                Using pdf As New PdfExport()
                    pdf.Export(cRpt.Document, rs)
                End Using

                rs.Seek(0, IO.SeekOrigin.Begin)

                Session("statement") = rs.ToArray

                Dim _sb As New System.Text.StringBuilder()
                _sb.Append("window.open('../../reports/viewPDFStream.aspx?type=statement','',")
                _sb.Append("'toolbar=0,menubar=0,resizable=yes');")
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), "winOpen", _sb.ToString(), True)

            End Using


        End Sub

        Private Function UpdatePTable(ByVal ds As DataSet, ByVal DepositDate As String) As DataSet
            ds.Tables(0).Rows(0).Item(8) = DepositDate
            ds.AcceptChanges()
            Return ds
        End Function

    End Class
End Namespace