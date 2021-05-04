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

Partial Class research_queries_financial_checkstoprint_default
    Inherits PermissionPage

#Region "Variables"

    Private Const PageSize As Integer = 20

    Dim pager As PagerWrapper

    Private UserID As Integer
    Private qs As QueryStringCollection

#End Region
#Region "Event"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        grdResults.ActionButtonID = lnkDeleteConfirm.ClientID & "," & lnkFulfillment.ClientID
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            LoadClients()

            If Not IsPostBack Then

                LoadValues(GetControls(), Me)

            End If
            SetAttributes()

        End If

    End Sub
    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        Requery()
    End Sub
    Protected Sub lnkShowFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkShowFilter.Click

        If lnkShowFilter.Attributes("class") = "gridButtonSel" Then 'is selected

            'insert settings
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "tdFilter", "style", "display:none")
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "lnkShowFilter", "attribute", "class=gridButton")

        Else 'is NOT selected

            'just delete the settings  - which will select on refresh
            QuerySettingHelper.Delete("UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name _
                & "' AND [Object] IN ('tdFilter', 'lnkShowFilter')")

        End If

        Refresh()

    End Sub
    Protected Sub lnkRequery_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRequery.Click

        'insert settings to table
        Save()
        grdResults.Reset(True)

    End Sub
    Protected Sub lnkClear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClear.Click

        'blow away all settings in table
        Clear()
        grdResults.Reset(True)

    End Sub
    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click

        'delete array of CheckToPrintID's
        CheckToPrintHelper.Delete(grdResults.SelectedValues.ToArray())

        grdResults.Reset(True)

    End Sub
    Private Sub Save()

        'blow away current stuff first
        Clear()

        If optClientChoice.SelectedValue = 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "optClientChoice", "value", _
                optClientChoice.SelectedValue)
        End If

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, "csClientID", "store", csClientID.SelectedStr)

        If Not chkChecksPrinted.Checked Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "chkChecksPrinted", "value", _
                chkChecksPrinted.Checked)
        End If

        If Not chkChecksNotPrinted.Checked Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "chkChecksNotPrinted", "value", _
                chkChecksNotPrinted.Checked)
        End If

        If imCreatedDate1.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "imCreatedDate1", "value", _
                imCreatedDate1.Text)
        End If

        If imCreatedDate2.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "imCreatedDate2", "value", _
                imCreatedDate2.Text)
        End If

        If imPrintedDate1.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "imPrintedDate1", "value", _
                imPrintedDate1.Text)
        End If

        If imPrintedDate2.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "imPrintedDate2", "value", _
                imPrintedDate2.Text)
        End If

        If txtAmount1.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "txtAmount1", "value", _
                txtAmount1.Text)
        End If

        If txtAmount2.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "txtAmount2", "value", _
                txtAmount2.Text)
        End If

    End Sub
    Private Sub Clear()

        'delete all settings for this user on this query
        QuerySettingHelper.Delete("UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "'")

        If Not lnkShowFilter.Attributes("class") = "gridButtonSel" Then 'is selected

            'insert settings
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "tdFilter", "style", "display:none")
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "lnkShowFilter", "attribute", "class=gridButton")

        End If

    End Sub
#End Region
#Region "Util"
    Private Sub SetAttributes()

        txtAmount1.Attributes("onkeypress") = "AllowOnlyNumbers();"
        txtAmount2.Attributes("onkeypress") = "AllowOnlyNumbers();"

        'register jscript for "printResults" popup
        WebHelper.RegisterPopup(Page, ResolveUrl("~/reports/interface/frame.aspx"), "?rpt=checkstoprint", _
            "printResults", 850, 600, 75, 50, "no", "no", "no", "yes", "no", "yes", "yes")

    End Sub
    Private Sub LoadClients()

        csClientID.Items.Clear()
        csClientID.AddItem(New ListItem(" -- Select --", 0))

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetClientsWithChecksToPrint")

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    While rd.Read()

                        Dim ClientID As Integer = DatabaseHelper.Peel_int(rd, "ClientID")
                        Dim FirstName As String = DatabaseHelper.Peel_string(rd, "PrimaryPersonFirstName")
                        Dim LastName As String = DatabaseHelper.Peel_string(rd, "PrimaryPersonLastName")

                        csClientID.AddItem(New ListItem(LastName & ", " & FirstName, ClientID))

                    End While

                End Using
            End Using
        End Using
        If Not IsPostBack Then
            csClientID.SelectedStr = DataHelper.FieldLookup("tblQuerySetting", "Value", _
                "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = '" & csClientID.ID + "'")
        End If
    End Sub
    Private Function GetControls() As Dictionary(Of String, Control)

        Dim c As New Dictionary(Of String, Control)

        c.Add(optClientChoice.ID, optClientChoice)
        c.Add(chkChecksPrinted.ID, chkChecksPrinted)
        c.Add(chkChecksNotPrinted.ID, chkChecksNotPrinted)
        c.Add(imCreatedDate1.ID, imCreatedDate1)
        c.Add(imCreatedDate2.ID, imCreatedDate2)
        c.Add(imPrintedDate1.ID, imPrintedDate1)
        c.Add(imPrintedDate2.ID, imPrintedDate2)
        c.Add(txtAmount1.ID, txtAmount1)
        c.Add(txtAmount2.ID, txtAmount2)
        c.Add(lnkShowFilter.ID, lnkShowFilter)
        c.Add(tdFilter.ID, tdFilter)

        Return c

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
    Private Sub Refresh()
        Response.Redirect(Request.Url.AbsoluteUri)
    End Sub
#End Region
#Region "Query"
    Private Function GetList() As List(Of CheckToPrint)
        Dim ChecksToPrint As New List(Of CheckToPrint)

        Dim Criteria As String = GetCriteria()

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetChecksToPrint")

            If Criteria.Length > 0 Then
                DatabaseHelper.AddParameter(cmd, "Where", Criteria)
            End If

            Session("rptcmd_checkstoprint") = cmd
            Session("rptcmd_checkstoprintreal") = cmd

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    While rd.Read()

                        ChecksToPrint.Add(New CheckToPrint(DatabaseHelper.Peel_int(rd, "CheckToPrintID"), _
                            DatabaseHelper.Peel_int(rd, "ClientID"), _
                            DatabaseHelper.Peel_string(rd, "FirstName"), _
                            DatabaseHelper.Peel_string(rd, "LastName"), _
                            DatabaseHelper.Peel_string(rd, "SpouseFirstName"), _
                            DatabaseHelper.Peel_string(rd, "SpouseLastName"), _
                            DatabaseHelper.Peel_string(rd, "Street"), _
                            DatabaseHelper.Peel_string(rd, "Street2"), _
                            DatabaseHelper.Peel_string(rd, "City"), _
                            DatabaseHelper.Peel_string(rd, "StateAbbreviation"), _
                            DatabaseHelper.Peel_string(rd, "StateName"), _
                            DatabaseHelper.Peel_string(rd, "ZipCode"), _
                            DatabaseHelper.Peel_string(rd, "AccountNumber"), _
                            DatabaseHelper.Peel_string(rd, "BankName"), _
                            DatabaseHelper.Peel_string(rd, "BankCity"), _
                            DatabaseHelper.Peel_string(rd, "BankStateAbbreviation"), _
                            DatabaseHelper.Peel_string(rd, "BankStateName"), _
                            DatabaseHelper.Peel_string(rd, "BankZipCode"), _
                            DatabaseHelper.Peel_string(rd, "BankRoutingNumber"), _
                            DatabaseHelper.Peel_string(rd, "BankAccountNumber"), _
                            DatabaseHelper.Peel_double(rd, "Amount"), _
                            DatabaseHelper.Peel_string(rd, "CheckNumber"), _
                            DatabaseHelper.Peel_ndate(rd, "CheckDate"), _
                            DatabaseHelper.Peel_string(rd, "Fraction"), _
                            DatabaseHelper.Peel_ndate(rd, "Printed"), _
                            DatabaseHelper.Peel_int(rd, "PrintedBy"), _
                            DatabaseHelper.Peel_string(rd, "PrintedByName"), _
                            DatabaseHelper.Peel_date(rd, "Created"), _
                            DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                            DatabaseHelper.Peel_string(rd, "CreatedByName")))

                    End While

                End Using
            End Using
        End Using
        Return ChecksToPrint
    End Function
    Private Sub Requery()
        Dim grd As QueryGrid = grdResults

        'Setup misc settings
        grd.IconSrcURL = "~/images/16x16_cheque.png"
        grd.PageSize = PageSize
        grd.SortOptions.Allow = False
        grd.SortOptions.DefaultSortField = "tblCheckToPrint.Created"
        grd.AllowAction = True

        'Setup Click settings
        grd.ClickOptions.Clickable = True
        grd.ClickOptions.ClickableURL = "~/clients/client/finances/ach/checktoprint.aspx?ctpid=$x$&id=$y$"
        grd.ClickOptions.KeyField = "NA"
        grd.ClickOptions.KeyField2 = "NA"
        grd.NoWrap = True


        'Create a list of rows, and assign it to the grid
        Dim ChecksToPrint As List(Of CheckToPrint) = GetList()
        Dim l As New List(Of QueryGrid.GridRow)
        For Each a As CheckToPrint In ChecksToPrint
            Dim r As New QueryGrid.GridRow

            r.Cells.Add(a.FirstName & " " & a.LastName)
            r.Cells.Add(a.BankName)
            r.Cells.Add(a.BankRoutingNumber)
            r.Cells.Add(a.BankAccountNumber)
            r.Cells.Add(a.Amount)
            r.Cells.Add(a.CheckNumber)
            r.Cells.Add(a.StatusFormatted)
            r.Cells.Add(a.Created)
            r.KeyId1 = a.CheckToPrintID
            r.KeyId2 = a.ClientID

            l.Add(r)
        Next a
        grd.List = l

        'Setup the Fields
        grd.Fields.Clear()
        grd.Fields.Add(New QueryGrid.GridField("Client", QueryGrid.eFieldType.Text, Nothing, "ClientName", SqlDbType.VarChar, True, "ClientName"))
        grd.Fields.Add(New QueryGrid.GridField("Bank", QueryGrid.eFieldType.Text, Nothing, "BankName", SqlDbType.VarChar, True, "BankName"))
        grd.Fields.Add(New QueryGrid.GridField("Routing No.", QueryGrid.eFieldType.Text, Nothing, "BankRoutingNumber", SqlDbType.VarChar, True, "BankRoutingNumber"))
        grd.Fields.Add(New QueryGrid.GridField("Acct No.", QueryGrid.eFieldType.Text, Nothing, "BankAccountNumber", SqlDbType.VarChar, True, "BankAccountNumber"))
        grd.Fields.Add(New QueryGrid.GridField("Amount", QueryGrid.eFieldType.Currency, Nothing, "Amount", SqlDbType.Money, True, "Amount"))
        grd.Fields.Add(New QueryGrid.GridField("Check No.", QueryGrid.eFieldType.Text, Nothing, "CheckNumber", SqlDbType.VarChar, True, "CheckNumber"))
        grd.Fields.Add(New QueryGrid.GridField("Status", QueryGrid.eFieldType.Text, Nothing, "StatusFormatted", SqlDbType.VarChar, True, "StatusFormatted"))
        grd.Fields.Add(New QueryGrid.GridField("Entered", QueryGrid.eFieldType.DateTime, Nothing, "Created", SqlDbType.DateTime, True, "tblCheckToPrint.Created"))


        Session("xls_" & Me.GetType.Name) = grd.GetXlsHtml()
    End Sub
    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        Response.Redirect(ResolveUrl("~/queryxls.ashx?Query=" & Me.GetType.Name))
    End Sub
    Private Function GetCriteria() As String

        Dim Where As String = String.Empty


        If csClientID.SelectedList.Count > 0 Then
            If optClientChoice.SelectedValue = 0 Then 'exclude
                Where = "NOT (" & csClientID.GenerateCriteria("tblCheckToPrint.ClientID") & ")"
            Else 'include
                Where = "(" & csClientID.GenerateCriteria("tblCheckToPrint.ClientID") & ")"
            End If
        End If

        If Not chkChecksPrinted.Checked Then
            If Where.Length > 0 Then
                Where += " AND tblCheckToPrint.Printed IS NULL"
            Else
                Where = "tblCheckToPrint.Printed IS NULL"
            End If
        End If

        If Not chkChecksNotPrinted.Checked Then
            If Where.Length > 0 Then
                Where += " AND NOT tblCheckToPrint.Printed IS NULL"
            Else
                Where = "NOT tblCheckToPrint.Printed IS NULL"
            End If
        End If

        If imCreatedDate1.Text.Length > 0 Then
            If Where.Length > 0 Then
                Where += " AND " & DataHelper.StripTime("tblCheckToPrint.Created") & " >= '" & imCreatedDate1.Text & "'"
            Else
                Where = DataHelper.StripTime("tblCheckToPrint.Created") & " >= '" & imCreatedDate1.Text & "'"
            End If
        End If

        If imCreatedDate2.Text.Length > 0 Then
            If Where.Length > 0 Then
                Where += " AND " & DataHelper.StripTime("tblCheckToPrint.Created") & " <= '" & imCreatedDate2.Text & "'"
            Else
                Where = DataHelper.StripTime("tblCheckToPrint.Created") & " <= '" & imCreatedDate2.Text & "'"
            End If
        End If

        If imPrintedDate1.Text.Length > 0 Then
            If Where.Length > 0 Then
                Where += " AND " & DataHelper.StripTime("tblCheckToPrint.Printed") & " >= '" & imPrintedDate1.Text & "'"
            Else
                Where = DataHelper.StripTime("tblCheckToPrint.Printed") & " >= '" & imPrintedDate1.Text & "'"
            End If
        End If

        If imPrintedDate2.Text.Length > 0 Then
            If Where.Length > 0 Then
                Where += " AND " & DataHelper.StripTime("tblCheckToPrint.Printed") & " <= '" & imPrintedDate2.Text & "'"
            Else
                Where = DataHelper.StripTime("tblCheckToPrint.Printed") & " <= '" & imPrintedDate2.Text & "'"
            End If
        End If

        If txtAmount1.Text.Length > 0 Then
            If Where.Length > 0 Then
                Where += " AND tblCheckToPrint.Amount >= '" & txtAmount1.Text & "'"
            Else
                Where = "tblCheckToPrint.Amount >= '" & txtAmount1.Text & "'"
            End If
        End If

        If txtAmount2.Text.Length > 0 Then
            If Where.Length > 0 Then
                Where += " AND tblCheckToPrint.Amount <= '" & txtAmount2.Text & "'"
            Else
                Where = "tblCheckToPrint.Amount <= '" & txtAmount2.Text & "'"
            End If
        End If

        If Where.Length > 0 Then
            Where = "WHERE " & Where
        End If

        Return Where

    End Function
#End Region

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlBody, c, "Research-Queries-Financial-Accounting-Checks To Print")
    End Sub
End Class