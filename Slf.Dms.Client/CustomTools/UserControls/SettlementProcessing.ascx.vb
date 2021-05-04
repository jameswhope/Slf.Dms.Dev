Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Xml
Imports System.Xml.Linq
Imports System.Linq
Imports System.IO
Imports System.Reflection
Imports System.Collections.Generic

Partial Class CustomTools_UserControls_SettlementProcessing
    Inherits System.Web.UI.UserControl

    Private UserID As Integer
    Public tabIndex As Integer = -1

    Private Enum Tabs As Integer
        PaymentsToApprove = 7
        ChecksToPrint = 4
        CheckTracking = 6
        OpenSettlements = 3
        PaymentsOverride = 5
        ChecksByPhone = 2
    End Enum

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Not Page.IsPostBack Then
            If PermissionHelperLite.HasPermission(UserID, "Settlement Processing") Then
                divSettlementProc.Visible = True
                LoadSettlementProcData()
            End If
        End If
    End Sub

    Private Sub LoadSettlementProcData()
        If PermissionHelperLite.HasPermission(UserID, "Settlement Processing-Open Settlements") Or PermissionHelperLite.HasPermission(UserID, "Settlement Processing-My Open Settlements") Then
            ViewState("SortDir") = "ASC"
            LoadFirms(ddlClient)
            BindOpenSettlements()
            If tabIndex = -1 Then
                tabIndex = Tabs.OpenSettlements
            End If
        End If

        If PermissionHelperLite.HasPermission(UserID, "Settlement Processing-Payments Override") Then
            LoadPaymentsOverride()
            If tabIndex = -1 Then
                tabIndex = Tabs.PaymentsOverride
            End If
        End If

        If PermissionHelperLite.HasPermission(UserID, "Settlement Processing-Payments To Approve") Then
            ViewState("SortApprove") = "DueDate ASC"
            LoadFirms(ddlAccCompany)
            LoadPaymentsForApproval()
            If tabIndex = -1 Then
                tabIndex = Tabs.PaymentsToApprove
            End If
        End If

        If PermissionHelperLite.HasPermission(UserID, "Settlement Processing-Checks To Print") Then
            LoadChecksToPrint()
            lnkPrint.Attributes.Add("onClick", "javascript:return PrintConfirm()")
            If tabIndex = -1 Then
                tabIndex = Tabs.ChecksToPrint
            End If
        End If

        If PermissionHelperLite.HasPermission(UserID, "Settlement Processing-Checks Tracking") Then
            ViewState("SortConfirm") = "DESC"
            LoadSettlementsForProcessing(True)
            If tabIndex = -1 Then
                tabIndex = Tabs.CheckTracking
            End If
        End If

        If PermissionHelperLite.HasPermission(UserID, "Settlement Processing-Checks By Phone") Then
            LoadChecksByPhone()
        End If

    End Sub

    Public Sub LoadSettlementProcTabStrips()
        tsSettlementProc.TabPages.Clear()

        If PermissionHelperLite.HasPermission(UserID, "Settlement Processing-Open Settlements") Or PermissionHelperLite.HasPermission(UserID, "Settlement Processing-My Open Settlements") Then
            tsSettlementProc.TabPages.Add(New Slf.Dms.Controls.TabPage("Open&nbsp;Settlements&nbsp;&nbsp;<font color='blue'>(" & hdnSettlementsProcessed.Value.ToString() & ")</font>", phSettlementsProcessed.ClientID))
        End If

        If PermissionHelperLite.HasPermission(UserID, "Settlement Processing-Payments Override") Then
            tsSettlementProc.TabPages.Add(New Slf.Dms.Controls.TabPage("Payments&nbsp;Override&nbsp;&nbsp;<font color='blue'>(" & hdnPaymentsOverrideCount.Value.ToString() & ")</font>", phPaymentsOverride.ClientID))
        End If

        If PermissionHelperLite.HasPermission(UserID, "Settlement Processing-Payments To Approve") Then
            tsSettlementProc.TabPages.Add(New Slf.Dms.Controls.TabPage("Payments&nbsp;To&nbsp;Approve&nbsp;&nbsp;<font color='blue'>(" & hdnPayments.Value.ToString() & ")</font>", phAccounting.ClientID))
        End If

        If PermissionHelperLite.HasPermission(UserID, "Settlement Processing-Checks To Print") Then
            tsSettlementProc.TabPages.Add(New Slf.Dms.Controls.TabPage("Checks&nbsp;To&nbsp;Print&nbsp;&nbsp;<font color='blue'>(" & hdnChecksPrinted.Value.ToString() & ")</font>", phPrintChecks.ClientID))
        End If

        If PermissionHelperLite.HasPermission(UserID, "Settlement Processing-Checks Tracking") Then
            tsSettlementProc.TabPages.Add(New Slf.Dms.Controls.TabPage("Check&nbsp;Tracking&nbsp;&nbsp;<font color='blue'>(" & hdnConfirmSettlements.Value.ToString() & ")</font>", phConfirmSettlements.ClientID))
        End If

        If PermissionHelperLite.HasPermission(UserID, "Settlement Processing-Checks By Phone") Then
            tsSettlementProc.TabPages.Add(New Slf.Dms.Controls.TabPage("Checks&nbsp;By&nbsp;Phone&nbsp;&nbsp;<font color='blue'>(" & hdnChecksByPhone.Value & ")</font>", phCheckByPhone.ClientID))
        End If

    End Sub

#Region "Bind Data"

    Sub BindOpenSettlements()
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        Dim CompanyXml As String
        Dim FromDate As Nullable(Of DateTime)
        Dim ToDate As Nullable(Of DateTime)

        txtFromDate.Value = String.Format("{0} 00:01", FormatDateTime(Now.AddDays(Now.Day * -1).AddDays(1), DateFormat.ShortDate))

        If ddlClient.SelectedIndex > 0 Then
            CompanyXml = New XElement("Company", New XAttribute("id", ddlClient.SelectedIndex.ToString())).ToString()
        End If

        If Not txtFromDate.Value Is Nothing AndAlso Not DateTime.Parse(txtFromDate.Value.ToString()) = DateTime.MinValue Then
            FromDate = DateTime.Parse(txtFromDate.Value)
        End If

        If Not txtToDate.Value Is Nothing AndAlso Not DateTime.Parse(txtToDate.Value.ToString()) = DateTime.MinValue Then
            ToDate = DateTime.Parse(txtToDate.Value)
        End If
        cmd.CommandText = "stp_GetTasksForSettlementMatter"
        cmd.CommandType = CommandType.StoredProcedure
        DatabaseHelper.AddParameter(cmd, "CompanyXml", CompanyXml)
        DatabaseHelper.AddParameter(cmd, "FromDate", FromDate)
        DatabaseHelper.AddParameter(cmd, "ToDate", ToDate)
        If PermissionHelperLite.HasPermission(UserID, "Settlement Processing-My Open Settlements") And Not PermissionHelperLite.HasPermission(UserID, "Settlement Processing-Open Settlements") Then
            DatabaseHelper.AddParameter(cmd, "NegotiatorID", UserID)
        End If

        Dim ds As New DataSet
        Dim sqlDA As New SqlDataAdapter(cmd)
        sqlDA.Fill(ds)

        If Not IsNothing(ds) Then
            If ds.Tables.Count > 0 Then

                gvSettlementsProcessed.DataSource = ds
                gvSettlementsProcessed.DataBind()

                If ds.Tables(0).Rows.Count > 0 Then
                    For i As Integer = 0 To (ds.Tables(0).Rows.Count - 1)
                        If txtToDate.Value Is Nothing Or DateTime.Parse(txtToDate.Value.ToString()) = DateTime.MinValue And i = ds.Tables(0).Rows.Count - 1 Then
                            txtToDate.Value = ds.Tables(0).Rows(i)("SettlementDueDate")
                        ElseIf txtFromDate.Value Is Nothing Or DateTime.Parse(txtFromDate.Value.ToString()) = DateTime.MinValue And i = 0 Then
                            txtFromDate.Value = ds.Tables(0).Rows(i)("SettlementDueDate")
                        End If
                    Next
                End If
            End If
        End If

        hdnSettlementsProcessed.Value = ds.Tables(0).Rows.Count
    End Sub

    Private Sub LoadPaymentsOverride()
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetSettlementsForOverride")
        Dim ds As New DataSet
        DatabaseHelper.AddParameter(cmd, "UserID", UserID)
        Dim output As New SqlParameter("@ModifiedMatters", SqlDbType.Xml, 1000)
        output.Direction = ParameterDirection.Output
        cmd.Parameters.Add(output)
        Dim sqlDA As New SqlDataAdapter(cmd)
        sqlDA.Fill(ds)

        If Not IsNothing(ds) Then
            If ds.Tables.Count > 0 Then
                If ds.Tables(0).Rows.Count > 0 Then
                    gvPaymentsOverride.DataSource = ds
                    gvPaymentsOverride.DataBind()
                End If
            End If
        End If

        hdnPaymentsOverrideCount.Value = ds.Tables(0).Rows.Count
    End Sub

    Public Function GetNextDepositDate(ByVal ClientId As Integer) As String
        Dim ds As DataSet = ClientHelper2.ExpectedDeposits(ClientId, DateAdd(DateInterval.Day, 60, Now))
        If ds.Tables(1).Rows.Count > 0 Then
            Return Format(CDate(ds.Tables(1).Rows(0)("depositdate")), "MMM d")
        End If
    End Function

    Public Function GetNextDepositFullDate(ByVal ClientId As Integer) As DateTime
        Dim ds As DataSet = ClientHelper2.ExpectedDeposits(ClientId, DateAdd(DateInterval.Day, 60, Now))
        If ds.Tables(1).Rows.Count > 0 Then
            Return CDate(ds.Tables(1).Rows(0)("depositdate"))
        End If
    End Function

    Public Function GetExpectedDeposits(ByVal ClientId As Integer, ByVal SettlementDueDate As String) As String
        Dim ds As DataSet = ClientHelper2.ExpectedDeposits(ClientId, SettlementDueDate)
        Return FormatCurrency(ds.Tables(0)(0)("expectedamount")) & "(" & ds.Tables(0)(0)("numdeposits") & ")"
    End Function

    Private Sub LoadChecksToPrint()
        Dim ds As New DataSet
        Dim params(0) As SqlParameter

        If ddlDeliveryAddressPrint.SelectedIndex > 0 Then
            params(0) = New SqlParameter("DeliveryAddress", ddlDeliveryAddressPrint.SelectedItem.Text)
        Else
            params(0) = New SqlParameter("DeliveryAddress", DBNull.Value)
        End If
        ds = SqlHelper.GetDataSet("stp_GetSettlementChecksToPrint", , params)

        If Not IsNothing(ds) Then
            If ds.Tables.Count > 0 Then
                gvPrintChecks.DataSource = ds
                gvPrintChecks.DataBind()

                If Not Page.IsPostBack Then
                    With ddlDeliveryAddressPrint
                        .DataSource = ds.Tables(1)
                        .DataTextField = "DeliveryAddress"
                        .DataValueField = "DeliveryAddress"
                        .DataBind()
                    End With
                End If
            End If
        End If

        hdnChecksPrinted.Value = ds.Tables(0).Rows.Count
    End Sub

    Private Sub LoadPaymentsForApproval()
        Dim dTable As DataTable = Me.GetDataSetForAccounting()
        Dim sortExp As String = ViewState("SortApprove").ToString.Trim
        Dim sortdata As String() = sortExp.Split(" ")
        Dim sortfield As String = sortdata(0)
        Dim sortdirection As String = sortdata(1)

        Select Case sortfield.ToLower
            Case "nextdeposit"
                If sortdirection.ToUpper = "ASC" Then
                    dTable = dTable.AsEnumerable.OrderBy(Function(r As DataRow) GetNextDepositFullDate(r("clientid"))).CopyToDataTable
                Else
                    dTable = dTable.AsEnumerable.OrderByDescending(Function(r As DataRow) GetNextDepositFullDate(r("clientid"))).CopyToDataTable
                End If
            Case "expected"
                If sortdirection.ToUpper = "ASC" Then
                    dTable = dTable.AsEnumerable.OrderBy(Function(r As DataRow) GetExpectedDeposits(r("clientid"), r("duedate"))).CopyToDataTable
                Else
                    dTable = dTable.AsEnumerable.OrderByDescending(Function(r As DataRow) GetExpectedDeposits(r("clientid"), r("duedate"))).CopyToDataTable
                End If
            Case Else
                Dim dataView As DataView = New DataView(dTable)
                dataView.Sort = sortExp
                dTable = dataView.ToTable
        End Select

        gvAccounting.DataSource = dTable
        gvAccounting.DataBind()

        If Not dTable Is Nothing Then
            hdnPayments.Value = dTable.Rows.Count
        End If
    End Sub

    Private Function GetDataSetForAccounting() As DataTable
        Dim CompanyXml As String
        Dim RequestXml As String
        Dim delXml As String
        Dim FromDate As Nullable(Of DateTime)
        Dim ToDate As Nullable(Of DateTime)
        Dim dTable As DataTable

        If ddlAccCompany.SelectedIndex > 0 Then
            If ddlAccCompany.SelectedValue = 99 Then
                Dim lawfirms As New Lexxiom.ImportClients.LawFirmList
                'get all lawfirms with id greater than 2
                Dim qry = From firm In lawfirms.LawFirms _
                               Where firm.Id > 2 _
                               Select New XElement("Company", New XAttribute("id", firm.Id))

                CompanyXml = String.Join("", qry.Select(Function(x) x.ToString()).ToArray())

            Else
                CompanyXml = New XElement("Company", New XAttribute("id", ddlAccCompany.SelectedValue.ToString())).ToString()
            End If
        End If

        If ddlRequestType.SelectedIndex > 0 Then
            RequestXml = New XElement("RequestType", New XAttribute("type", ddlRequestType.SelectedItem.Text)).ToString()
        End If

        If ddlDelMethod.SelectedValue <> "All" Then
            delXml = New XElement("DeliveryMethod", New XAttribute("del", ddlDelMethod.SelectedValue)).ToString()
        End If

        If Not txtDueStart.Value Is Nothing AndAlso Not DateTime.Parse(txtDueStart.Value.ToString()) = DateTime.MinValue Then
            FromDate = DateTime.Parse(txtDueStart.Value)
        End If

        If Not txtDueEnd.Value Is Nothing AndAlso Not DateTime.Parse(txtDueEnd.Value.ToString()) = DateTime.MinValue Then
            ToDate = DateTime.Parse(txtDueEnd.Value)
        End If

        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetPaymentsToApprove")
        DatabaseHelper.AddParameter(cmd, "CompanyXml", CompanyXml)
        DatabaseHelper.AddParameter(cmd, "RequestType", RequestXml)
        DatabaseHelper.AddParameter(cmd, "DelMethod", delXml)
        DatabaseHelper.AddParameter(cmd, "ToDate", ToDate)
        DatabaseHelper.AddParameter(cmd, "FromDate", FromDate)
        If txtAccSearch.Text.Trim.Length > 0 Then
            DatabaseHelper.AddParameter(cmd, "Search", txtAccSearch.Text.Trim)
        End If
        Dim ds As New DataSet
        Dim sqlDA As New SqlDataAdapter(cmd)
        sqlDA.Fill(ds)

        If Not IsNothing(ds) Then
            If ds.Tables.Count > 0 Then
                If ds.Tables(0).Rows.Count > 0 Then
                    'For i As Integer = 0 To (ds.Tables(0).Rows.Count - 1)
                    '    If txtDueEnd.Value Is Nothing Or DateTime.Parse(txtDueEnd.Value.ToString()) = DateTime.MinValue And i = ds.Tables(0).Rows.Count - 1 Then
                    '        txtDueEnd.Value = ds.Tables(0).Rows(i)("DueDate")
                    '    ElseIf txtDueStart.Value Is Nothing Or DateTime.Parse(txtDueStart.Value.ToString()) = DateTime.MinValue And i = 0 Then
                    '        txtDueStart.Value = ds.Tables(0).Rows(i)("DueDate")
                    '    End If
                    'Next
                    'txtDueEnd.Value = ds.Tables(0).Compute("max([DueDate])", "")
                    'txtDueStart.Value = ds.Tables(0).Compute("min([DueDate])", "")
                End If
                dTable = ds.Tables(0).Clone
                Select Case ddlSDAFilter.SelectedValue
                    Case "1"
                        Dim firmCleared As EnumerableRowCollection(Of DataRow) = (From ShowOverage In ds.Tables(0).AsEnumerable() Where _
                         CDbl(ShowOverage("SDABalance")) >= CDbl(ShowOverage("CheckAmount")) Select ShowOverage)

                        If firmCleared.Count() > 0 Then
                            dTable = firmCleared.CopyToDataTable()
                        End If
                    Case "2"
                        Dim firmCleared As EnumerableRowCollection(Of DataRow) = (From ShowOverage In ds.Tables(0).AsEnumerable() Where _
                         CDbl(ShowOverage("AvailableSDA")) >= CDbl(ShowOverage("CheckAmount")) Select ShowOverage)

                        If firmCleared.Count() > 0 Then
                            dTable = firmCleared.CopyToDataTable()
                        End If
                    Case "3"
                        Dim firmCleared As EnumerableRowCollection(Of DataRow) = (From ShowOverage In ds.Tables(0).AsEnumerable() Where _
                         CDbl(ShowOverage("AvailableSDA")) < CDbl(ShowOverage("CheckAmount")) Select ShowOverage)

                        If firmCleared.Count() > 0 Then
                            dTable = firmCleared.CopyToDataTable()
                        End If
                    Case "4"
                        Dim firmCleared As EnumerableRowCollection(Of DataRow) = (From ShowOverage In ds.Tables(0).AsEnumerable() Where _
                          ShowOverage("Hold") IsNot DBNull.Value Select ShowOverage)

                        If firmCleared.Count() > 0 Then
                            dTable = firmCleared.CopyToDataTable()
                        End If
                    Case Else
                        dTable = ds.Tables(0)
                End Select

            End If
        End If

        'txtDueStart.Value = String.Format("{0} 00:01", FormatDateTime(Now.AddDays(Now.Day * -1).AddDays(1), DateFormat.ShortDate))

        Return dTable
    End Function

    Private Sub LoadSettlementsForProcessing(ByVal bReloadAddresses As Boolean)
        Dim ds As New DataSet
        Dim params(0) As SqlParameter

        If ddlDeliveryAddress.SelectedIndex > 0 Then
            params(0) = New SqlParameter("DeliveryAddress", ddlDeliveryAddress.SelectedItem.Text)
        Else
            params(0) = New SqlParameter("DeliveryAddress", DBNull.Value)
        End If
        ds = SqlHelper.GetDataSet("stp_GetSettlementForConfirmation", , params)

        If Not IsNothing(ds) Then
            If ds.Tables.Count > 0 Then
                gvConfirmSettlement.DataSource = ds
                gvConfirmSettlement.DataBind()

                If bReloadAddresses Then
                    With ddlDeliveryAddress
                        .DataSource = ds.Tables(1)
                        .DataTextField = "DeliveryAddress"
                        .DataValueField = "DeliveryAddress"
                        .DataBind()
                    End With
                End If
            End If
        End If

        hdnConfirmSettlements.Value = ds.Tables(0).Rows.Count
    End Sub

    Private Function GetDeliveryMethodName(ByVal Code As String) As String
        Dim desc As String = Code.Trim.ToUpper
        Select Case Code.Trim.ToUpper
            Case "E"
                desc = "Email"
            Case "P"
                desc = "Phone"
            Case "C"
                desc = "Check"
        End Select
        Return desc
    End Function

    'Protected Sub lnkExportAcc_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExportAcc.Click
    '    Dim sw As New StringWriter
    '    Dim htw As New HtmlTextWriter(sw)
    '    Dim table As New System.Web.UI.WebControls.Table
    '    Dim tr As New System.Web.UI.WebControls.TableRow
    '    Dim cell As TableCell
    '    Dim dTable As DataTable = Me.GetDataSetForAccounting()

    '    Dim qry = From r As DataRow In dTable.Rows _
    '              Select [Del_Method] = GetDeliveryMethodName(r("deliverymethod").ToString()), _
    '                     [Sett_Due] = String.Format("{0:yyyy/MM/dd}", CDate(r("DueDate"))), _
    '                     [Type] = r("RequestType").ToString, _
    '                     [Firm] = r("Firm").ToString, _
    '                     [Account] = r("AccountNumber").ToString, _
    '                     [Client] = r("ClientName").ToString, _
    '                     [Payable_To] = r("CreditorName").ToString, _
    '                     [Acc_No] = r("Last4").ToString, _
    '                     [Check_Amt] = String.Format("{0:c}", r("CheckAmount")), _
    '                     [Avail_SDA] = String.Format("{0:c}", r("AvailableSDA")), _
    '                     [SDA_Balance] = String.Format("{0:c}", r("SDABalance")), _
    '                     [Next_Dep] = String.Format("{0:c}", GetNextDepositDate(r("ClientId"))), _
    '                     [Expected] = String.Format("{0:c}", GetExpectedDeposits(r("ClientId"), r("DueDate"))), _
    '                     [PA] = IIf(r("IsPaymentArrangement"), "Yes", "No")

    '    Dim l = qry.ToList

    '    For Each p As PropertyInfo In l.First.GetType().GetProperties
    '        cell = New TableCell
    '        cell.Text = p.Name.Replace("_", " ")
    '        tr.Cells.Add(cell)
    '    Next

    '    table.Rows.Add(tr)

    '    For Each obj As Object In l
    '        tr = New TableRow
    '        For Each p As PropertyInfo In l.First.GetType().GetProperties
    '            cell = New TableCell
    '            'cell.Attributes.Add("class", "entry")
    '            cell.Text = p.GetValue(obj, Nothing)
    '            tr.Cells.Add(cell)
    '        Next
    '        table.Rows.Add(tr)
    '    Next

    '    table.RenderControl(htw)

    '    HttpContext.Current.Response.Clear()
    '    HttpContext.Current.Response.ContentType = "application/ms-excel"
    '    HttpContext.Current.Response.AddHeader("content-disposition", "attachment; filename=PaymentsToApprove.xls")
    '    HttpContext.Current.Response.Write(sw.ToString)
    '    HttpContext.Current.Response.End()
    'End Sub

    Protected Sub lnkExportAcc_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExportAcc.Click
        Dim dTable As DataTable = Me.GetDataSetForAccounting()
        Dim sortExp As String = ViewState("SortApprove").ToString.Trim
        Dim sortdata As String() = sortExp.Split(" ")
        Dim sortfield As String = sortdata(0)
        Dim sortdirection As String = sortdata(1)

        Select Case sortfield.ToLower
            Case "nextdeposit"
                If sortdirection.ToUpper = "ASC" Then
                    dTable = dTable.AsEnumerable.OrderBy(Function(r As DataRow) GetNextDepositFullDate(r("clientid"))).CopyToDataTable
                Else
                    dTable = dTable.AsEnumerable.OrderByDescending(Function(r As DataRow) GetNextDepositFullDate(r("clientid"))).CopyToDataTable
                End If
            Case "expected"
                If sortdirection.ToUpper = "ASC" Then
                    dTable = dTable.AsEnumerable.OrderBy(Function(r As DataRow) GetExpectedDeposits(r("clientid"), r("duedate"))).CopyToDataTable
                Else
                    dTable = dTable.AsEnumerable.OrderByDescending(Function(r As DataRow) GetExpectedDeposits(r("clientid"), r("duedate"))).CopyToDataTable
                End If
            Case Else
                Dim dataView As DataView = New DataView(dTable)
                dataView.Sort = sortExp
                dTable = dataView.ToTable
        End Select

        Dim xdoc As XDocument = New XDocument( _
            New XElement("table", _
                New XElement("thead", _
                    New XElement("tr", _
                        New XElement("th", "Del. Method"), _
                        New XElement("th", "Sett. Due"), _
                        New XElement("th", "Type"), _
                        New XElement("th", "Firm"), _
                        New XElement("th", "Account"), _
                        New XElement("th", "Client"), _
                        New XElement("th", "Payable To"), _
                        New XElement("th", "Acc. #"), _
                        New XElement("th", "Check Amt"), _
                        New XElement("th", "Avail. SDA"), _
                        New XElement("th", "SDA Balance"), _
                        New XElement("th", "Next Dep."), _
                        New XElement("th", "Expected"), _
                        New XElement("th", "P.A"))), _
                New XElement("tbody", _
                    From r As DataRow In dTable.Rows _
                    Select New XElement("tr", _
                            New XElement("td", GetDeliveryMethodName(r("deliverymethod").ToString())), _
                            New XElement("td", String.Format("{0:yyyy/MM/dd}", CDate(r("DueDate")))), _
                            New XElement("td", r("RequestType").ToString), _
                            New XElement("td", r("Firm").ToString), _
                            New XElement("td", r("AccountNumber").ToString), _
                            New XElement("td", r("ClientName").ToString), _
                            New XElement("td", r("CreditorName").ToString), _
                            New XElement("td", r("Last4").ToString), _
                            New XElement("td", String.Format("{0:c}", r("CheckAmount"))), _
                            New XElement("td", String.Format("{0:c}", r("AvailableSDA")), _
                            New XElement("td", String.Format("{0:c}", r("SDABalance"))), _
                            New XElement("td", String.Format("{0:c}", GetNextDepositDate(r("ClientId")))), _
                            New XElement("td", String.Format("{0:c}", GetExpectedDeposits(r("ClientId"), r("DueDate")))), _
                            New XElement("td", IIf(r("IsPaymentArrangement"), "Yes", "No")))))))


        HttpContext.Current.Response.Clear()
        HttpContext.Current.Response.ContentType = "application/ms-excel"
        HttpContext.Current.Response.AddHeader("content-disposition", "attachment; filename=PaymentsToApprove.xls")
        HttpContext.Current.Response.Write(xdoc.ToString())
        HttpContext.Current.Response.End()
    End Sub
#End Region

#Region "gvPrintChecks"

    Protected Sub gvPrintChecks_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvPrintChecks.PageIndexChanging
        gvPrintChecks.PageIndex = e.NewPageIndex
        LoadChecksToPrint()
        tabIndex = Tabs.ChecksToPrint
    End Sub

    Protected Sub gvPrintChecks_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvPrintChecks.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim strMatterID As String = CType(e.Row.FindControl("hdnCheckSettlement"), HtmlInputHidden).Value
            Dim SettlementId As Integer = CInt(DataHelper.FieldLookup("tblSettlements", "SettlementId", "MatterId = " & strMatterID))
            Dim payableTo As String = DataHelper.FieldLookup("tblSettlements_DeliveryAddresses", "PayableTo", "SettlementId = " & SettlementId)
            Dim PaymentId As String = CType(e.Row.FindControl("hdnCheckPaymentId"), HtmlInputHidden).Value
            Dim popupDelivery As String = String.Format("javascript:return popupDeliveryMethod({0},{1},'C','{2}')", PaymentId, strMatterID, payableTo)
            e.Row.Cells(1).Attributes.Add("onClick", popupDelivery)

            e.Row.Attributes("onmouseover") = "javascript:setMouseOverColor(this);"
            e.Row.Attributes("onmouseout") = "javascript:setMouseOutColor(this);"

            'Settlement Due Date
            If CDate(e.Row.Cells(2).Text) < DateTime.Now Then
                e.Row.Cells(2).ForeColor = Color.Red
            End If
        End If
    End Sub

#End Region

#Region "gvConfirmSettlement"

    Protected Sub gvConfirmSettlement_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvConfirmSettlement.PageIndexChanging
        gvConfirmSettlement.PageIndex = e.NewPageIndex
        LoadSettlementsForProcessing(False)
        tabIndex = Tabs.CheckTracking
    End Sub

    Protected Sub gvConfirmSettlement_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvConfirmSettlement.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim strMatterID As String = CType(e.Row.FindControl("hdnConfirmSettlement"), HtmlInputHidden).Value
            Dim SettlementId As Integer = CInt(DataHelper.FieldLookup("tblSettlements", "SettlementId", "MatterId = " & strMatterID))
            Dim payableTo As String = DataHelper.FieldLookup("tblSettlements_DeliveryAddresses", "PayableTo", "SettlementId = " & SettlementId)
            Dim PaymentId As String = CType(e.Row.FindControl("hdnConfirmPaymentId"), HtmlInputHidden).Value

            e.Row.Cells(1).Attributes.Add("onClick", "javascript:return popupDeliveryMethod(" & PaymentId & "," & strMatterID & ",'C','" & payableTo & "')")

            e.Row.Attributes("onmouseover") = "javascript:setMouseOverColor(this);"
            e.Row.Attributes("onmouseout") = "javascript:setMouseOutColor(this);"
        End If
    End Sub

    Protected Sub gvConfirmSettlement_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvConfirmSettlement.Sorting
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "stp_GetSettlementForConfirmation"
        cmd.CommandType = CommandType.StoredProcedure

        Dim ds As New DataSet
        Dim sqlDA As New SqlDataAdapter(cmd)
        sqlDA.Fill(ds)

        If Not IsNothing(ds) Then
            If ds.Tables.Count > 0 Then
                If ds.Tables(0).Rows.Count > 0 Then
                    Dim dataView As DataView = New DataView(ds.Tables(0))

                    Dim sortExp As String = "[" & e.SortExpression & "]"

                    If ViewState("SortConfirm") = "ASC" Then
                        sortExp += " DESC"
                        ViewState("SortConfirm") = "DESC"
                    Else
                        sortExp += " ASC"
                        ViewState("SortConfirm") = "ASC"
                    End If

                    dataView.Sort = sortExp
                    Dim dtSort As DataTable = dataView.ToTable
                    gvConfirmSettlement.DataSource = dtSort
                    gvConfirmSettlement.DataBind()
                End If
            End If
        End If

        tabIndex = 6
    End Sub

#End Region

#Region "gvAccounting"

    Protected Sub gvAccounting_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvAccounting.PageIndexChanging
        gvAccounting.PageIndex = e.NewPageIndex
        LoadPaymentsForApproval()
        tabIndex = Tabs.PaymentsToApprove
    End Sub

    Protected Sub gvAccounting_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvAccounting.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim strMatterID As String = CType(e.Row.FindControl("hdnMatterID"), HtmlInputHidden).Value
            Dim strProcessingId As String = CType(e.Row.FindControl("hdnProcessingID"), HtmlInputHidden).Value
            Dim strDelMethod As String = CType(e.Row.FindControl("hdnPayDelivery"), HtmlInputHidden).Value
            Dim requestType As String = e.Row.Cells(3).Text.Trim.ToLower
            Dim payableTo As String = e.Row.Cells(7).Text
            Dim popAccInfo As String
            Select Case requestType
                Case "settlement"
                    popAccInfo = String.Format("javascript:return popupAccountingInfo({0})", strMatterID)
                Case "settlement - p.a."
                    Dim PaymentScheduleID As Integer = PaymentScheduleHelper.GetPaymentScheduleIdByPaymentId(strProcessingId)
                    popAccInfo = String.Format("javascript:return popupAccountingInfoPA({0})", PaymentScheduleID)
                Case Else
                    Throw New Exception("Request type is unknown")
            End Select
            Dim popDelivery As String = String.Format("javascript:return popupDeliveryMethod({0}, {1}, '{2}', '{3}')", strProcessingId, strMatterID, strDelMethod, payableTo.Replace("'", "\'"))
            e.Row.Cells(1).Attributes.Add("onClick", popDelivery)
            e.Row.Cells(2).Attributes.Add("onClick", popAccInfo)
            e.Row.Cells(3).Attributes.Add("onClick", popAccInfo)
            e.Row.Cells(4).Attributes.Add("onClick", popAccInfo)
            e.Row.Cells(6).Attributes.Add("onClick", popAccInfo)
            e.Row.Cells(7).Attributes.Add("onClick", popAccInfo)
            e.Row.Cells(8).Attributes.Add("onClick", popAccInfo)
            e.Row.Cells(9).Attributes.Add("onClick", popAccInfo)
            e.Row.Cells(12).Attributes.Add("onClick", popAccInfo)
            e.Row.Cells(13).Attributes.Add("onClick", popAccInfo)

            Dim row As DataRowView = CType(e.Row.DataItem, DataRowView)
            Dim lnk As HyperLink

            If Val(row.Item("AvailableSDA")) < Val(row.Item("CheckAmount")) Then
                lnk = TryCast(e.Row.Cells(10).Controls(0), HyperLink)
                lnk.ForeColor = System.Drawing.Color.Red
            End If

            Dim lnk1 As HyperLink
            If Val(row.Item("SDABalance")) < Val(row.Item("CheckAmount")) Then
                lnk1 = TryCast(e.Row.Cells(11).Controls(0), HyperLink)
                lnk1.ForeColor = System.Drawing.Color.Red
            End If

            If Not row("Hold") Is DBNull.Value Then
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#F5A9A9")
                e.Row.Attributes("onmouseover") = "javascript:setMouseOverColor(this,'#F78181');"
                e.Row.Attributes("onmouseout") = "javascript:setMouseOutColor(this,'#F5A9A9');"
            ElseIf CBool(row("IsPreApproved")) Then
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#B4EEB4")
                e.Row.Attributes("onmouseover") = "javascript:setMouseOverColor(this,'#98FB98');"
                e.Row.Attributes("onmouseout") = "javascript:setMouseOutColor(this,'#B4EEB4');"
            Else
                e.Row.Attributes("onmouseover") = "javascript:setMouseOverColor(this);"
                e.Row.Attributes("onmouseout") = "javascript:setMouseOutColor(this);"
            End If
        End If
    End Sub

    Protected Sub gvAccounting_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvAccounting.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                Dim srcString As String
                If ViewState("SortApprove").ToString().Split(" ")(1).ToUpper.Equals("DESC") Then
                    srcString = "~/images/sort-desc.png"
                Else
                    srcString = "~/images/sort-asc.png"
                End If

                For Each dataCell As DataControlFieldHeaderCell In e.Row.Cells
                    If Not String.IsNullOrEmpty(dataCell.ContainingField.SortExpression) AndAlso ViewState("SortApprove").ToString().Split(" ")(0).ToUpper.Equals(dataCell.ContainingField.SortExpression.ToUpper) Then
                        If TypeOf dataCell.ContainingField Is TemplateField Then
                            Dim img As New HtmlImage()
                            img.Src = srcString
                            img.Style("border") = "0px"
                            Dim lnk As LinkButton = CType(dataCell.Controls(1), LinkButton)
                            Dim txt As String = lnk.Text
                            Dim spn As New HtmlGenericControl("span")
                            spn.InnerHtml = txt & "&nbsp;"
                            lnk.Controls.Add(spn)
                            lnk.Controls.Add(img)
                        Else
                            Dim img As New HtmlImage()
                            img.Src = srcString
                            img.Style("border") = "0px"

                            Dim lnk As LinkButton = CType(dataCell.Controls(0), LinkButton)
                            Dim txt As String = lnk.Text
                            Dim spn As New HtmlGenericControl("span")
                            spn.InnerHtml = txt & "&nbsp;"
                            lnk.Controls.Add(spn)
                            lnk.Controls.Add(img)
                        End If

                    End If
                Next
        End Select
    End Sub

    Protected Sub gvAccounting_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvAccounting.Sorting
        If gvAccounting.Rows.Count > 0 Then
            Dim dTable As DataTable = Me.GetDataSetForAccounting()

            If Not IsNothing(dTable) Then
                If dTable.Rows.Count > 0 Then

                    Dim sortExp As String = e.SortExpression

                    If ViewState("SortApprove").ToString.Split(" ")(0).ToUpper = sortExp.ToUpper AndAlso ViewState("SortApprove").ToString.Split(" ")(1).ToUpper = "ASC" Then
                        sortExp += " DESC"
                        ViewState("SortApprove") = sortExp
                    Else
                        sortExp += " ASC"
                        ViewState("SortApprove") = sortExp
                    End If

                    Select Case e.SortExpression.ToLower
                        Case "nextdeposit"
                            If ViewState("SortApprove").ToString.Split(" ")(1).ToUpper = "ASC" Then
                                dTable = dTable.AsEnumerable.OrderBy(Function(r As DataRow) GetNextDepositFullDate(r("clientid"))).CopyToDataTable
                            Else
                                dTable = dTable.AsEnumerable.OrderByDescending(Function(r As DataRow) GetNextDepositFullDate(r("clientid"))).CopyToDataTable
                            End If
                        Case "expected"
                            If ViewState("SortApprove").ToString.Split(" ")(1).ToUpper = "ASC" Then
                                dTable = dTable.AsEnumerable.OrderBy(Function(r As DataRow) GetExpectedDeposits(r("clientid"), r("duedate"))).CopyToDataTable
                            Else
                                dTable = dTable.AsEnumerable.OrderByDescending(Function(r As DataRow) GetExpectedDeposits(r("clientid"), r("duedate"))).CopyToDataTable
                            End If
                        Case Else
                            Dim dataView As DataView = New DataView(dTable)
                            dataView.Sort = sortExp
                            dTable = dataView.ToTable
                    End Select

                    gvAccounting.DataSource = dTable
                    gvAccounting.DataBind()
                End If
            End If

            tabIndex = 7
        End If
    End Sub

    Public Function GetSettKitCount() As String
        Dim cnt As Integer = SettlementMatterHelper.GetPAByClientSettKittToPrintCount
        Return IIf(cnt > 0, String.Format("<span style=""color:red;"">({0})</span>", cnt), "")
    End Function

#End Region

#Region "gvPaymentsOverride"

    Protected Sub gvPaymentsOverride_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvPaymentsOverride.PageIndexChanging
        gvPaymentsOverride.PageIndex = e.NewPageIndex
        LoadPaymentsOverride()
        tabIndex = 5
    End Sub

    Protected Sub gvPaymentsOverride_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvPaymentsOverride.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim strSettlementID As String = CType(e.Row.FindControl("hdnSettlementID"), HtmlInputHidden).Value

            e.Row.Cells(1).Attributes.Add("onClick", "javascript:return popupSettlementInfo(" & strSettlementID & ")")
            e.Row.Cells(3).Attributes.Add("onClick", "javascript:return popupSettlementInfo(" & strSettlementID & ")")
            e.Row.Cells(5).Attributes.Add("onClick", "javascript:return popupSettlementInfo(" & strSettlementID & ")")
            e.Row.Cells(6).Attributes.Add("onClick", "javascript:return popupSettlementInfo(" & strSettlementID & ")")
            e.Row.Cells(7).Attributes.Add("onClick", "javascript:return popupSettlementInfo(" & strSettlementID & ")")
            e.Row.Cells(8).Attributes.Add("onClick", "javascript:return popupSettlementInfo(" & strSettlementID & ")")
            e.Row.Cells(9).Attributes.Add("onClick", "javascript:return popupSettlementInfo(" & strSettlementID & ")")

            e.Row.Attributes("onmouseover") = "javascript:setMouseOverColor(this);"
            e.Row.Attributes("onmouseout") = "javascript:setMouseOutColor(this);"

            Dim row As DataRowView = CType(e.Row.DataItem, DataRowView)

            If CDate(row.Item("SettlementDueDate")) < DateTime.Now Then
                e.Row.Cells(1).ForeColor = System.Drawing.Color.Red
            End If
        End If
    End Sub

#End Region

#Region "gvSettlementsProcessed"

    Protected Sub gvSettlementsProcessed_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvSettlementsProcessed.PageIndexChanging
        gvSettlementsProcessed.PageIndex = e.NewPageIndex
        BindOpenSettlements()
        tabIndex = 3
    End Sub

    Protected Sub gvSettlementsProcessed_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSettlementsProcessed.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                Dim srcString As String
                If ViewState("SortDir").ToString().Equals("DESC") Then
                    srcString = "~/images/sort-desc.png"
                Else
                    srcString = "~/images/sort-asc.png"
                End If

                For Each dataCell As DataControlFieldHeaderCell In e.Row.Cells
                    If Not String.IsNullOrEmpty(dataCell.ContainingField.SortExpression) Then
                        Dim img As New HtmlImage()
                        img.Src = srcString
                        dataCell.Controls.Add(img)
                        dataCell.HorizontalAlign = HorizontalAlign.Center
                    End If
                Next
        End Select
    End Sub

    Protected Sub gvSettlementsProcessed_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSettlementsProcessed.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim strTaskID As String = CType(e.Row.FindControl("hdnSettTaskId"), HtmlInputHidden).Value

            'Settlement Due Date
            If CDate(e.Row.Cells(1).Text) < DateTime.Now Then
                e.Row.Cells(1).ForeColor = Color.Red
            End If

            Dim row As DataRowView = CType(e.Row.DataItem, DataRowView)
            Dim lnk As HyperLink

            If Not IsDBNull(row.Item("RegisterBalance")) Then
                If Val(row.Item("RegisterBalance")) < Val(row.Item("SettlementAmount")) Then
                    lnk = TryCast(e.Row.Cells(7).Controls(0), HyperLink)
                    lnk.ForeColor = System.Drawing.Color.Red
                End If
            End If

            Dim bgcolor = "#ffffff"
            Dim bgcolorhover = "#e5e5e5"
            Dim ltr As Literal = Nothing
            ltr = CType(e.Row.Cells(8).FindControl("ltrStipulation"), Literal)
            ltr.Text = ""
            If Not IsDBNull(row.Item("IsClientStipulation")) AndAlso row.Item("IsClientStipulation") Then
                If row.Item("TaskTypeId") = 84 Then
                    bgcolor = "#81F781"
                    bgcolorhover = "#2EFE2E"
                    e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml(bgcolor)
                    'Find is Stipulation letter has ben sent to client
                    Dim dtsl As DataTable = SettlementMatterHelper.GetStipulationLetterLog(row.Item("SettlementId"))
                    Dim ltrText As String = "<img id=""imgSL{0}"" src=""{1}"" title=""{2}""/>"
                    If dtsl.Rows.Count > 0 Then
                        ltr.Text = String.Format(ltrText, row.Item("SettlementId"), ResolveUrl("~/images/16x16_check.png"), String.Format("Letter last sent on {0:MM/dd/yy} by {1}", dtsl.Rows(0)("datesent"), dtsl.Rows(0)("sentbyuser")))
                    Else
                        ltr.Text = String.Format(ltrText, row.Item("SettlementId"), ResolveUrl("~/images/12x12_flag_orange.png"), "Letter must be sent!")
                    End If
                End If
            End If

            e.Row.Cells(0).Attributes.Add("onClick", "javascript:return SettlementClick(" & strTaskID & ")")
            e.Row.Cells(1).Attributes.Add("onClick", "javascript:return SettlementClick(" & strTaskID & ")")
            e.Row.Cells(2).Attributes.Add("onClick", "javascript:return SettlementClick(" & strTaskID & ")")
            e.Row.Cells(3).Attributes.Add("onClick", "javascript:return SettlementClick(" & strTaskID & ")")
            e.Row.Cells(6).Attributes.Add("onClick", "javascript:return SettlementClick(" & strTaskID & ")")
            e.Row.Cells(7).Attributes.Add("onClick", "javascript:return SettlementClick(" & strTaskID & ")")
            e.Row.Cells(8).Attributes.Add("onClick", "javascript:return SettlementClick(" & strTaskID & ")")

            e.Row.Attributes("onmouseover") = String.Format("javascript:setMouseOverColor(this, '{0}');", bgcolorhover)
            e.Row.Attributes("onmouseout") = String.Format("javascript:setMouseOutColor(this, '{0}');", bgcolor)

        End If
    End Sub

    Protected Sub gvSettlementsProcessed_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvSettlementsProcessed.Sorting
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        Dim CompanyXml As String
        Dim FromDate As Nullable(Of DateTime)
        Dim ToDate As Nullable(Of DateTime)

        If ddlClient.SelectedIndex > 0 Then
            CompanyXml = New XElement("Company", New XAttribute("id", ddlClient.SelectedIndex.ToString())).ToString()
        End If

        If Not txtFromDate.Value Is Nothing AndAlso Not DateTime.Parse(txtFromDate.Value.ToString()) = DateTime.MinValue Then
            FromDate = DateTime.Parse(txtFromDate.Value)
        End If

        If Not txtToDate.Value Is Nothing AndAlso Not DateTime.Parse(txtToDate.Value.ToString()) = DateTime.MinValue Then
            ToDate = DateTime.Parse(txtToDate.Value)
        End If
        cmd.CommandText = "stp_GetTasksForSettlementMatter"
        cmd.CommandType = CommandType.StoredProcedure
        DatabaseHelper.AddParameter(cmd, "CompanyXml", CompanyXml)
        DatabaseHelper.AddParameter(cmd, "FromDate", FromDate)
        DatabaseHelper.AddParameter(cmd, "ToDate", ToDate)

        Dim ds As New DataSet
        Dim sqlDA As New SqlDataAdapter(cmd)
        sqlDA.Fill(ds)

        If Not IsNothing(ds) Then
            If ds.Tables.Count > 0 Then
                If ds.Tables(0).Rows.Count > 0 Then
                    Dim dataView As DataView = New DataView(ds.Tables(0))

                    Dim sortExp As String = "[" & e.SortExpression & "]"

                    If ViewState("SortDir") = "ASC" Then
                        sortExp += " DESC"
                        ViewState("SortDir") = "DESC"
                    Else
                        sortExp += " ASC"
                        ViewState("SortDir") = "ASC"
                    End If

                    dataView.Sort = sortExp
                    Dim dtSort As DataTable = dataView.ToTable
                    gvSettlementsProcessed.DataSource = dtSort
                    gvSettlementsProcessed.DataBind()
                End If
            End If
        End If

        tabIndex = 3
    End Sub

#End Region

#Region "Click Events"

    Protected Sub lnkPrint_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkPrint.Click
        Dim docCnt As Integer = 0
        Dim Success As Boolean = True
        Dim batchId As Integer = 0
        Dim CheckNumber As Integer = 0
        Dim filePath As String
        Dim SubFolder As String
        Dim DocId As String
        Dim listOfChecks(2) As String
        Dim dtMerge As New DataTable

        dtMerge.Columns.Add("DocPath", GetType(System.String))
        dtMerge.Columns.Add("DocPages", GetType(System.String))

        For Each row As GridViewRow In gvPrintChecks.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chk_select")
                Dim MatterId As String = CType(row.FindControl("hdnCheckSettlement"), HtmlInputHidden).Value
                Dim SettlementId As Integer = CInt(DataHelper.FieldLookup("tblSettlements", "SettlementId", "MatterId = " & MatterId))
                Dim bIsClientStipulation As Boolean = DataHelper.FieldLookup("tblSettlements", "IsClientStipulation", "SettlementId = " & SettlementId)
                Dim PaymentID As Integer = CType(row.FindControl("hdnCheckPaymentId"), HtmlInputHidden).Value

                CheckNumber = Val(DataHelper.FieldLookup("tblAccount_PaymentProcessing", "CheckNumber", "PaymentProcessingId = " & PaymentID))

                Dim clientId As String = CType(row.FindControl("hdnCheckClientId"), HtmlInputHidden).Value
                Dim accountId As String = CType(row.FindControl("hdnCheckAccountId"), HtmlInputHidden).Value
                Dim checkAmount As Double = CDbl(row.Cells(6).Text)
                If chk.Checked = True Then
                    Dim _MatterStatus As Integer = CInt(DataHelper.FieldLookup("tblMatter", "MatterSubStatusId", "MatterId = " & MatterId))

                    If _MatterStatus = 63 Then
                        If docCnt = 0 Then
                            batchId = SettlementMatterHelper.InsertCheckBatch(UserID)

                            If batchId = 0 Then
                                Exit For
                            End If
                        End If

                        'Dim SifPath As String = SettlementMatterHelper.GetSIFForPrinting(MatterId)

                        'Generate Check
                        If CheckNumber = 0 Then
                            CheckNumber = CInt(SettlementMatterHelper.GetCheckNumber(clientId))
                        End If

                        filePath = SettlementMatterHelper.GenerateSettlementCheck(PaymentID, SettlementId, clientId, CheckNumber, checkAmount, accountId, UserID, False, "D9011")

                        If Not String.IsNullOrEmpty(filePath) AndAlso File.Exists(filePath) Then
                            Dim nr As DataRow = dtMerge.NewRow
                            nr(0) = filePath
                            nr(1) = "1"
                            dtMerge.Rows.Add(nr)
                        End If
                        'Success = RawPrinterHelper.SendFileToPrinter("\\LIT-SRV-0003\COPIER", filePath)

                        'If Not String.IsNullOrEmpty(SifPath) AndAlso IO.File.Exists(SifPath) Then
                        '    RawPrinterHelper.SendFileToPrinter("\\DMF-APP-0001\Xerox Phaser 8560 PS", SifPath)
                        'End If

                        'If bIsClientStipulation Then
                        '    Dim clientStipulationPath As String = SettlementMatterHelper.GetSignedStipulationPathForPrinting(MatterId)
                        '    If Not String.IsNullOrEmpty(clientStipulationPath) AndAlso IO.File.Exists(clientStipulationPath) Then
                        '        RawPrinterHelper.SendFileToPrinter("\\DMF-APP-0001\Xerox Phaser 8560 PS", clientStipulationPath)
                        '    End If
                        'End If

                        SubFolder = SettlementMatterHelper.GetSubFolder(accountId)

                        Dim folderPaths() As String = filePath.Split("\")
                        DocId = SettlementMatterHelper.GetDocIdFromPath(folderPaths(folderPaths.Length - 1))

                        SettlementMatterHelper.InsertCheckInfo(PaymentID, MatterId, UserID, CheckNumber, DocId, SubFolder, batchId, Success)

                        docCnt += 1
                    End If
                End If
            End If
        Next

        If batchId > 0 Then
            SettlementMatterHelper.UpdateCheckBatchEndDate(batchId)
        End If

        If dtMerge.Rows.Count > 0 Then
            Dim emailMergeDocPath As String = "c:/settlementchecks/merged/" + Now.ToString("yyyy_MM_dd_HHmmss") + ".pdf"
            PdfManipulation.ExtractAndMergePdfPages(dtMerge, emailMergeDocPath)
        End If

        ddlDeliveryAddressPrint.SelectedIndex = 0
        LoadChecksToPrint()
        LoadSettlementsForProcessing(True) 'Check Tracking
        tabIndex = Tabs.ChecksToPrint
    End Sub

    Protected Sub lnkPreApprovePayment_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkPreApprovePayment.Click

        For Each row As GridViewRow In gvAccounting.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chk_Accselect")
                Dim PaymentProcessingId As Integer = CType(row.FindControl("hdnProcessingId"), HtmlInputHidden).Value
                Dim MatterId As Integer = CType(row.FindControl("hdnMatterID"), HtmlInputHidden).Value
                Dim DeliveryMethod As String = CType(row.FindControl("hdnPayDelivery"), HtmlInputHidden).Value
                Dim SettlementId As Integer = CType(row.FindControl("hdnSettlementId"), HtmlInputHidden).Value
                If chk.Checked Then
                    If row.Cells(3).Text.Equals("Settlement") OrElse row.Cells(3).Text.Equals("Settlement - P.A.") Then
                        SettlementMatterHelper.PreApprovePayment(PaymentProcessingId, SettlementId, MatterId, DeliveryMethod, row.Cells(9).Text, row.Cells(6).Text, row.Cells(7).Text, row.Cells(8).Text, UserID)
                    End If
                End If
            End If
        Next

        LoadPaymentsForApproval()
        tabIndex = Tabs.PaymentsToApprove
    End Sub

    Protected Sub lnkHoldPayment_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkHoldPayment.Click

        For Each row As GridViewRow In gvAccounting.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chk_Accselect")
                Dim PaymentProcessingId As Integer = CType(row.FindControl("hdnProcessingId"), HtmlInputHidden).Value
                Dim MatterId As Integer = CType(row.FindControl("hdnMatterID"), HtmlInputHidden).Value
                Dim DeliveryMethod As String = CType(row.FindControl("hdnPayDelivery"), HtmlInputHidden).Value
                Dim SettlementId As Integer = CType(row.FindControl("hdnSettlementId"), HtmlInputHidden).Value
                If chk.Checked Then
                    If row.Cells(3).Text.Equals("Settlement") OrElse row.Cells(3).Text.Equals("Settlement - P.A.") Then
                        SettlementMatterHelper.HoldPayment(PaymentProcessingId, SettlementId, MatterId, DeliveryMethod, row.Cells(9).Text, row.Cells(6).Text, row.Cells(7).Text, row.Cells(8).Text, UserID)
                    End If
                End If
            End If
        Next

        LoadPaymentsForApproval()
        tabIndex = Tabs.PaymentsToApprove
    End Sub

    Protected Sub lnkApprovePayment_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkApprovePayment.Click
        Dim ApproveXml As New XElement("Payments")
        Dim bLoadChecksToPrint As Boolean
        Dim AcctNumber As String

        For Each row As GridViewRow In gvAccounting.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chk_Accselect")
                Dim PaymentId As Integer = CType(row.FindControl("hdnProcessingId"), HtmlInputHidden).Value
                Dim MatterId As Integer = CType(row.FindControl("hdnMatterID"), HtmlInputHidden).Value
                Dim _Client As Integer = CInt(DataHelper.FieldLookup("tblMatter", "ClientId", "MatterId = " & MatterId))
                Dim delMethod As String = CType(row.FindControl("hdnPayDelivery"), HtmlInputHidden).Value
                Dim checkNumber As Integer = 0
                Dim payXml As XElement
                If chk.Checked = True Then
                    Dim _SettlementId As Integer = CInt(DataHelper.FieldLookup("tblSettlements", "SettlementId", "MatterId = " & MatterId))
                    Dim _MatterStatus As Integer = CInt(DataHelper.FieldLookup("tblMatter", "MatterSubStatusId", "MatterId = " & MatterId))
                    Dim _CheckAmount As Double = CDbl(DataHelper.FieldLookup("tblAccount_PaymentProcessing", "CheckAmount", "PaymentProcessingId = " & PaymentId))
                    Dim _AccountId As Integer = CInt(DataHelper.FieldLookup("tblSettlements", "CreditorAccountId", "SettlementId = " & _SettlementId))
                    AcctNumber = DataHelper.FieldLookup("tblCreditorInstance", "AccountNumber", "CreditorInstanceId = " & AccountHelper.GetCurrentCreditorInstanceID(_AccountId))

                    'Process only if the matter is still in Pending Accounting Approval state
                    If _MatterStatus = 67 Then
                        If Not delMethod.Equals("C") Then
                            If DataHelper.FieldLookup("tblAccount_PaymentProcessing", "CheckNumber", "PaymentProcessingId = " & PaymentId) <> "" Then
                                checkNumber = DataHelper.FieldLookup("tblAccount_PaymentProcessing", "CheckNumber", "PaymentProcessingId = " & PaymentId)
                            Else
                                checkNumber = SettlementMatterHelper.GetCheckNumber(_Client)
                            End If

                            bLoadChecksToPrint = True
                        End If
                        payXml = New XElement("Payment")
                        payXml.Add(New XAttribute("PaymentId", PaymentId))

                        If checkNumber <> 0 Then
                            payXml.Add(New XAttribute("CheckNumber", checkNumber))
                        End If
                        ApproveXml.Add(payXml)

                        Dim Note = UserHelper.GetName(UserID) & " approved to process " & FormatCurrency(_CheckAmount, 2) & " by " & IIf(delMethod.Equals("C"), "Check", IIf(delMethod.Equals("P"), "Check By Phone", "Email")) & " to settle " & AccountHelper.GetCurrentCreditorName(_AccountId) & " #" & Right(AcctNumber, 4) & " for client " & ClientHelper.GetDefaultPersonName(_Client)

                        SettlementMatterHelper.AddSettlementNote(_SettlementId, Note, UserID)
                    End If
                End If
            End If
        Next

        Using connection As IDbConnection = ConnectionFactory.Create()
            connection.Open()

            Using cmd As IDbCommand = connection.CreateCommand()
                cmd.CommandText = "stp_ApprovePayment"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "ApproveXml", ApproveXml.ToString())
                DatabaseHelper.AddParameter(cmd, "UserId", UserID)
                cmd.ExecuteNonQuery()
            End Using
        End Using

        For Each row As GridViewRow In gvAccounting.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chk_Accselect")
                Dim MatterId As Integer = CType(row.FindControl("hdnMatterID"), HtmlInputHidden).Value
                Dim delMethod As String = CType(row.FindControl("hdnPayDelivery"), HtmlInputHidden).Value
                Dim _MatterStatus As Integer = CInt(DataHelper.FieldLookup("tblMatter", "MatterSubStatusId", "MatterId = " & MatterId))
                Dim PaymentId As Integer = CType(row.FindControl("hdnProcessingId"), HtmlInputHidden).Value
                If chk.Checked = True Then
                    If delMethod.Equals("E") And _MatterStatus = 68 Then
                        SettlementMatterHelper.PayByEMail(PaymentId, MatterId, UserID)
                    End If
                End If
            End If
        Next

        If bLoadChecksToPrint Then
            LoadChecksToPrint()
        End If
        LoadPaymentsForApproval()
        tabIndex = Tabs.PaymentsToApprove
    End Sub

    Protected Sub lnkRejectPayment_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRejectPayment.Click
        Dim ApproveXml As New XElement("Payments")
        Dim AcctNumber As String
        For Each row As GridViewRow In gvAccounting.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chk_Accselect")
                Dim PaymentId As Integer = CType(row.FindControl("hdnProcessingId"), HtmlInputHidden).Value
                Dim MatterId As Integer = CType(row.FindControl("hdnMatterID"), HtmlInputHidden).Value
                Dim payXml As XElement
                If chk.Checked = True Then
                    Dim _SettlementId As Integer = CInt(DataHelper.FieldLookup("tblSettlements", "SettlementId", "MatterId = " & MatterId))
                    Dim _MatterStatus As Integer = CInt(DataHelper.FieldLookup("tblMatter", "MatterSubStatusId", "MatterId = " & MatterId))

                    'Process only if the matter is still in Pending Accounting Approval state
                    If _MatterStatus = 67 Then
                        Dim _CheckAmount As Double = CDbl(DataHelper.FieldLookup("tblAccount_PaymentProcessing", "CheckAmount", "PaymentProcessingId = " & PaymentId))
                        Dim _AccountId As Integer = CInt(DataHelper.FieldLookup("tblSettlements", "CreditorAccountId", "SettlementId = " & _SettlementId))
                        Dim _Client As Integer = CInt(DataHelper.FieldLookup("tblMatter", "ClientId", "MatterId = " & MatterId))
                        AcctNumber = DataHelper.FieldLookup("tblCreditorInstance", "AccountNumber", "CreditorInstanceId = " & AccountHelper.GetCurrentCreditorInstanceID(_AccountId))
                        Dim IsPaymentArrangement As Boolean = CBool(DataHelper.FieldLookup("tblSettlements", "IsPaymentArrangement", "SettlementId = " & _SettlementId))

                        payXml = New XElement("Payment")
                        payXml.Add(New XAttribute("PaymentId", PaymentId))

                        ApproveXml.Add(payXml)

                        Dim Note = UserHelper.GetName(UserID) & " rejected the payment of " & FormatCurrency(_CheckAmount, 2) & " for settlement of account " & AccountHelper.GetCurrentCreditorName(_AccountId) & " #" & AcctNumber.Substring(AcctNumber.Length - 4) & " for client " & ClientHelper.GetDefaultPersonName(_Client)
                        If IsPaymentArrangement Then
                            Note = Note & ". The payment arrangement has been cancelled."
                        End If

                        SettlementMatterHelper.AddSettlementNote(_SettlementId, Note, UserID)
                    End If
                End If
            End If
        Next

        Using connection As IDbConnection = ConnectionFactory.Create()
            connection.Open()

            Using cmd As IDbCommand = connection.CreateCommand()
                cmd.CommandText = "stp_Accounting_RejectPayment"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "ApproveXml", ApproveXml.ToString())
                DatabaseHelper.AddParameter(cmd, "UserId", UserID)
                cmd.ExecuteNonQuery()
            End Using
        End Using
        LoadPaymentsForApproval()
        tabIndex = Tabs.PaymentsToApprove
    End Sub

    Protected Sub lnkApproveOverrides_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkApproveOverrides.Click
        ApproveRejectOverrides(True)
    End Sub

    Protected Sub lnkRejectOverrides_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRejectOverrides.Click
        ApproveRejectOverrides(False)
    End Sub

    Protected Sub lnkProcessChecks_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkProcessChecks.Click
        For Each row As GridViewRow In gvConfirmSettlement.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chk_confirmSelect")
                Dim MatterId As Integer
                Dim PaymentID As Integer
                Dim _MatterStatus As Integer
                Dim SettlementId As Integer
                Dim AccountId As Integer
                Dim _clientId As Integer

                If chk.Checked Then
                    PaymentID = CType(row.FindControl("hdnConfirmPaymentId"), HtmlInputHidden).Value
                    MatterId = CType(row.FindControl("hdnConfirmSettlement"), HtmlInputHidden).Value
                    SettlementId = CInt(DataHelper.FieldLookup("tblSettlements", "SettlementId", "MatterId=" & MatterId))
                    _MatterStatus = CInt(DataHelper.FieldLookup("tblMatter", "MatterSubStatusId", "MatterId=" & MatterId))

                    If _MatterStatus = 64 Then
                        _clientId = CType(row.FindControl("hdnProcessClientId"), HtmlInputHidden).Value
                        AccountId = CType(row.FindControl("hdnProcessAccountId"), HtmlInputHidden).Value
                        Dim CheckNumber As Integer

                        CheckNumber = CInt(DataHelper.FieldLookup("tblAccount_PaymentProcessing", "CheckNumber", "PaymentProcessingId = " & PaymentID))
                        Dim CheckAmount As Double = CDbl(DataHelper.FieldLookup("tblAccount_PaymentProcessing", "CheckAmount", "PaymentProcessingId = " & PaymentID))

                        Dim RegisterXml As XElement = SettlementMatterHelper.InsertSettlementPayments(PaymentID, _clientId, AccountId, CheckNumber, UserID, SettlementId)

                        Dim RegisterId = CInt(RegisterXml.Attribute("Id").Value)
                        Dim FeeRegisterId = CInt(RegisterXml.Attribute("FeeId").Value)

                        Dim Note = UserHelper.GetName(UserID) & " Processed Check for Amount $" & CheckAmount.ToString() & " with the tracking# " & txtReference.Text

                        SettlementMatterHelper.AddSettlementNote(SettlementId, Note, UserID)

                        Using connection As IDbConnection = ConnectionFactory.Create()
                            connection.Open()

                            Using cmd As IDbCommand = connection.CreateCommand()
                                cmd.CommandText = "stp_ResolveSettlementProcessing"
                                cmd.CommandType = CommandType.StoredProcedure
                                DatabaseHelper.AddParameter(cmd, "PaymentId", PaymentID)
                                DatabaseHelper.AddParameter(cmd, "SettlementId", SettlementId)
                                DatabaseHelper.AddParameter(cmd, "Note", IIf(String.IsNullOrEmpty(txtConfirmNote.Text), Nothing, txtConfirmNote.Text))
                                DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                                DatabaseHelper.AddParameter(cmd, "Reference", IIf(String.IsNullOrEmpty(txtReference.Text), Nothing, txtReference.Text))
                                DatabaseHelper.AddParameter(cmd, "CheckNumber", CheckNumber)
                                DatabaseHelper.AddParameter(cmd, "CheckAmount", CheckAmount)
                                DatabaseHelper.AddParameter(cmd, "RegisterId", RegisterId)
                                DatabaseHelper.AddParameter(cmd, "FeeRegisterId", FeeRegisterId)
                                cmd.ExecuteNonQuery()
                            End Using
                        End Using
                    End If
                End If
            End If
        Next

        ddlDeliveryAddress.SelectedIndex = 0
        LoadSettlementsForProcessing(True)
        tabIndex = Tabs.CheckTracking
        txtConfirmNote.Text = ""
        txtReference.Text = ""
    End Sub

    Protected Sub lnkFilterChecks_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkFilterChecks.Click
        LoadSettlementsForProcessing(False)
        tabIndex = Tabs.CheckTracking
    End Sub

    Protected Sub lnkFilterChecksToPrint_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkFilterChecksToPrint.Click
        LoadChecksToPrint()
        tabIndex = Tabs.ChecksToPrint
    End Sub

    Protected Sub lnkAcctFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAcctFilter.Click
        gvAccounting.PageIndex = 0
        LoadPaymentsForApproval()
        tabIndex = Tabs.PaymentsToApprove
    End Sub

    Protected Sub lnkFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkFilter.Click
        gvSettlementsProcessed.PageIndex = 0
        BindOpenSettlements()
        tabIndex = 3
    End Sub

    Protected Sub lnkExportOpen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExportOpen.Click
        Dim sw As New StringWriter
        Dim htw As New HtmlTextWriter(sw)
        Dim table As New System.Web.UI.WebControls.Table
        Dim tr As New System.Web.UI.WebControls.TableRow
        Dim cell As TableCell
        Dim params(2) As SqlParameter

        Dim CompanyXml As String
        Dim FromDate As Nullable(Of DateTime)
        Dim ToDate As Nullable(Of DateTime)
        If ddlClient.SelectedIndex > 0 Then
            params(0) = New SqlParameter("CompanyXml", New XElement("Company", New XAttribute("id", ddlClient.SelectedIndex.ToString())).ToString())
        Else
            params(0) = New SqlParameter("CompanyXml", DBNull.Value)
        End If

        If Not txtToDate.Value Is Nothing AndAlso Not DateTime.Parse(txtToDate.Value.ToString()) = DateTime.MinValue Then
            params(1) = New SqlParameter("ToDate", DateTime.Parse(txtToDate.Value))
        Else
            params(1) = New SqlParameter("ToDate", DBNull.Value)
        End If

        If Not txtFromDate.Value Is Nothing AndAlso Not DateTime.Parse(txtFromDate.Value.ToString()) = DateTime.MinValue Then
            params(2) = New SqlParameter("FromDate", DateTime.Parse(txtFromDate.Value))
        Else
            params(2) = New SqlParameter("FromDate", DBNull.Value)
        End If

        Dim ds As DataSet = SqlHelper.GetDataSet("stp_GetTasksForSettlementMatter", , params)

        If ds.Tables(0).Columns.Count > 0 Then
            ds.Tables(0).Columns.Remove("TaskId")
            ds.Tables(0).Columns.Remove("TaskTypeId")
            ds.Tables(0).Columns.Remove("TaskDueDate")
            ds.Tables(0).Columns.Remove("TaskStatus")
            ds.Tables(0).Columns.Remove("SettlementId")
            ds.Tables(0).Columns.Remove("ClientId")
            ds.Tables(0).Columns.Remove("Status")
            ds.Tables(0).Columns.Remove("AccountId")
            ds.Tables(0).Columns.Remove("SDABalance")
            ds.Tables(0).Columns.Remove("BankReserve")
        End If

        For i As Integer = 0 To ds.Tables(0).Columns.Count - 1
            cell = New TableCell
            cell.Text = ds.Tables(0).Columns(i).ColumnName
            tr.Cells.Add(cell)
        Next
        table.Rows.Add(tr)

        For Each row As DataRow In ds.Tables(0).Rows
            tr = New TableRow
            For i As Integer = 0 To ds.Tables(0).Columns.Count - 1
                cell = New TableCell
                cell.Attributes.Add("class", "entry")
                cell.Text = row.Item(i).ToString
                tr.Cells.Add(cell)
            Next
            table.Rows.Add(tr)
        Next

        table.RenderControl(htw)

        HttpContext.Current.Response.Clear()
        HttpContext.Current.Response.ContentType = "application/ms-excel"
        HttpContext.Current.Response.AddHeader("content-disposition", "attachment; filename=OpenSettlements.xls")
        HttpContext.Current.Response.Write(sw.ToString)
        HttpContext.Current.Response.End()
    End Sub

#End Region

    Private Sub LoadFirms(ByVal ddl As DropDownList)
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            cmd.CommandText = "select ShortCoName [Name], companyid from tblcompany"
            Using cmd.Connection
                cmd.Connection.Open()
                ddl.ClearSelection()
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        ddl.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "companyid")))
                    End While
                    ddl.Items.Insert(0, New ListItem(" -- All -- ", 0))
                    ddl.Items.Insert(1, New ListItem(" LEXX. PMT. SYSTEMS", 99))
                End Using
            End Using
        End Using
    End Sub

    Public Function GetDeliveryMethodIcon(ByVal method As String) As String
        Select Case method
            Case "E"
                Return "<img src='images/16x16_email.png' border='0' title='Check by Email' />"
            Case "P"
                Return "<img src='images/16x16_phone3.png' border='0' title='Check by Phone' />"
            Case Else 'check
                Return "<img src='images/16x16_cheque.png' border='0' title='Printed Check' />"
        End Select
    End Function

    Private Sub ApproveRejectOverrides(ByVal bApprove As Boolean)
        For Each row As GridViewRow In gvPaymentsOverride.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chkOverride")

                If chk.Checked Then
                    Dim hdn As HtmlInputHidden = TryCast(row.FindControl("hdnSettlementID"), HtmlInputHidden)
                    Dim MatterId As Integer = CInt(DataHelper.FieldLookup("tblSettlements", "MatterId", "SettlementId = " & hdn.Value))
                    Dim _MatterStatus As Integer = CInt(DataHelper.FieldLookup("tblMatter", "MatterSubStatusId", "MatterId = " & MatterId))

                    If _MatterStatus = 55 Then
                        Dim returnParam As IDataParameter
                        Dim returnValue As Integer
                        Dim matterTransaction As IDbTransaction = Nothing

                        Using connection As IDbConnection = ConnectionFactory.Create()
                            connection.Open()
                            matterTransaction = CType(connection, IDbConnection).BeginTransaction(IsolationLevel.RepeatableRead)

                            Using cmd As IDbCommand = connection.CreateCommand()
                                cmd.CommandText = "stp_ResolveManagerOverride"
                                cmd.CommandType = CommandType.StoredProcedure
                                DatabaseHelper.AddParameter(cmd, "SettlementId", hdn.Value)
                                DatabaseHelper.AddParameter(cmd, "IsApproved", bApprove)
                                DatabaseHelper.AddParameter(cmd, "Note", DBNull.Value)
                                DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                                returnParam = DatabaseHelper.CreateAndAddParamater(cmd, "Return", DbType.Int32)
                                returnParam.Direction = ParameterDirection.ReturnValue
                                cmd.Transaction = matterTransaction
                                cmd.ExecuteNonQuery()
                            End Using

                            If returnParam.Value = 0 And returnValue = 0 Then
                                matterTransaction.Commit()
                            Else
                                matterTransaction.Rollback()
                            End If
                        End Using
                    End If
                End If
            End If
        Next

        LoadPaymentsOverride()
        tabIndex = Tabs.PaymentsOverride
    End Sub

#Region "Check By Phone"

    Protected Sub dsPhoneProcessing_Selected(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles dsPhoneProcessing.Selected
        hdnChecksByPhone.Value = e.AffectedRows
    End Sub

    Protected Sub gvPhoneProcessing_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvPhoneProcessing.DataBound
        hdnChecksByPhone.Value = gvPhoneProcessing.Rows.Count
    End Sub

    Protected Sub gvPhoneProcessing_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvPhoneProcessing.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim strMatterID As String = CType(e.Row.FindControl("hdnChkPhoneMatterId"), HtmlInputHidden).Value
            Dim checkNumber As String = CType(e.Row.FindControl("hdnPhoneCheck"), HtmlInputHidden).Value
            Dim paymentid As String = CType(e.Row.FindControl("hdnChkPhonePaymentId"), HtmlInputHidden).Value
            Dim strSettlementID As String = DataHelper.FieldLookup("tblSettlements", "SettlementId", "MatterId = " & CInt(strMatterID))
            Dim popupPhoneInfo As String = String.Format("javascript:return popupPhoneInfo({0},{1},{2})", strSettlementID, IIf(String.IsNullOrEmpty(checkNumber), "0", checkNumber), paymentid)
            Dim payableTo As String = DataHelper.FieldLookup("tblSettlements_DeliveryAddresses", "PayableTo", "SettlementId = " & strSettlementID)
            Dim popupDelivery As String = String.Format("javascript:return popupDeliveryMethod({0},{1},'P','{2}', {3})", paymentid, strMatterID, payableTo.Replace("'", ""), "function(){ReloadChecks();}")
            Dim img As HtmlImage = CType(e.Row.Cells(0).FindControl("ImgPhoneIcon"), HtmlImage)
            img.Attributes.Add("onClick", popupDelivery)
            'e.Row.Cells(0).Attributes.Add("onClick", popupPhoneInfo)
            e.Row.Cells(1).Attributes.Add("onClick", popupPhoneInfo)
            e.Row.Cells(2).Attributes.Add("onClick", popupPhoneInfo)
            e.Row.Cells(3).Attributes.Add("onClick", popupPhoneInfo)
            e.Row.Cells(4).Attributes.Add("onClick", popupPhoneInfo)
            e.Row.Cells(7).Attributes.Add("onClick", popupPhoneInfo)

            e.Row.Attributes("onmouseover") = "javascript:setMouseOverColor(this);"
            e.Row.Attributes("onmouseout") = "javascript:setMouseOutColor(this);"
        End If
    End Sub

    Private Sub LoadChecksByPhone()
        dsPhoneProcessing.SelectParameters("userid").DefaultValue = UserID
        dsPhoneProcessing.DataBind()
        gvPhoneProcessing.DataBind()
        Dim args As New DataSourceSelectArguments("CreditorName")
        Dim dv As DataView = CType(dsPhoneProcessing.Select(args), DataView)
        ddlCBPCreditors.DataSource = dv.ToTable(True, "CreditorName")
        ddlCBPCreditors.DataTextField = "CreditorName"
        ddlCBPCreditors.DataValueField = "CreditorName"
        ddlCBPCreditors.DataBind()
    End Sub

    Private Sub FilterCBP()
        Dim filterExpr As String = ddlCBPCreditors.SelectedItem.Text
        If filterExpr.Trim.ToLower = "--all--" Then
            filterExpr = ""
        Else
            filterExpr = String.Format("CreditorName = '{0}'", filterExpr.Replace("'", "''"))
        End If
        dsPhoneProcessing.SelectParameters("userid").DefaultValue = UserID
        dsPhoneProcessing.FilterExpression = filterExpr
        dsPhoneProcessing.DataBind()
        gvPhoneProcessing.DataBind()
        tabIndex = Tabs.ChecksByPhone
    End Sub

    Protected Sub btnReloadCheckByPhone_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnReloadCheckByPhone.Click
        FilterCBP()
    End Sub

    Protected Sub lnkCBPFiler_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCBPFiler.Click
        FilterCBP()
    End Sub
#End Region


End Class
