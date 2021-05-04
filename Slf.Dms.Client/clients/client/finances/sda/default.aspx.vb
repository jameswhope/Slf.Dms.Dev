Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports Slf.Dms.Records
Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

'Note: Page does not currently allow Palmer/Seideman transfers to Checksite without also having to change
' the client's SA. Add functionality if needed.

Partial Class clients_client_finances_sda_default
    Inherits PermissionPage

    Private qs As QueryStringCollection
    Public Shadows ClientID As Integer
    Private UserID As Integer
    Private DebitDesc As String
    Private DepositDesc As String
    Private dblCurrentSDA As Double

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        qs = LoadQueryString()

        If Not qs Is Nothing Then
            ClientID = StringHelper.ParseInt(qs("id"), 0)

            If Not IsPostBack Then
                lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
                lnkClient.HRef = "~/clients/client/?id=" & ClientID

                LoadRecord()
            End If

            Dim bshow As String = qs("showltr")
            If bshow IsNot Nothing Then
                If bshow.ToLower = "true" Then
                    ShowTransferLetter()
                End If
            End If
        End If
    End Sub

    Private Sub LoadRecord()
        trCompany.Style("display") = "none"

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        Const ColonialTrustID As Integer = 20

        cmd.CommandText = "SELECT c.*, t.displayname [trust] FROM tblClient c JOIN tblTrust t on t.TrustID = c.TrustID WHERE c.ClientID = @ClientID"
        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

        Using cmd
            Using cmd.Connection
                cmd.Connection.Open()
                rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

                If rd.Read() Then
                    Dim TrustID As Integer = DatabaseHelper.Peel_int(rd, "TrustID")
                    Dim CompanyId As Integer = DatabaseHelper.Peel_int(rd, "CompanyId")
                    Dim PrimaryPersonId As Integer = DatabaseHelper.Peel_int(rd, "PrimaryPersonId")
                    Dim ClientStateId As Integer = DataHelper.FieldLookup("tblPerson", "StateId", "PersonID = " & PrimaryPersonId)
                    Dim ClientStatusId As Integer = DatabaseHelper.Peel_int(rd, "CurrentClientStatusID")

                    lblAccountNumber.Text = DatabaseHelper.Peel_string(rd, "AccountNumber")
                    lblTrustName.Text = DatabaseHelper.Peel_string(rd, "Trust")
                    dblCurrentSDA = DatabaseHelper.Peel_double(rd, "SDABalance")
                    lblSDABalance.Text = dblCurrentSDA.ToString("c")
                    lblSettlAttorney.Text = DataHelper.FieldLookup("tblCompany", "Name", "CompanyID = " & CompanyId) & " (" & CompanyId & ")"
                    lblAgency.Text = DataHelper.FieldLookup("tblAgency", "Name", "AgencyID = " & DatabaseHelper.Peel_int(rd, "AgencyID")) & " (" & rd("AgencyID").ToString & ")"
                    lblState.Text = DataHelper.FieldLookup("tblState", "Name", "StateID = " & ClientStateId)

                    Try
                        If Math.Sign(dblCurrentSDA) = -1 Then
                            lblSDABalance.ForeColor = Color.Red
                            dvError.Style("display") = "inline"
                            tdError.InnerHtml = "Cannot convert negative SDA Balance clients.  Please fix SDA Balance before converting."
                        Else
                            Dim CommonTasks As List(Of String) = Master.CommonTasks

                            If ClientStatusId < 15 Then
                                'Lists which SA's this client can move to
                                SetupCompanyConversion(CompanyId, ClientStateId)
                            End If

                            If ddlToCompany.Items.Count > 0 Then
                                If CanConvert() Then 'No pending deposits
                                    If NewCommScenExists() Then
                                        If TrustID = ColonialTrustID Then
                                            SetupPlazaConversion()
                                        Else
                                            'Enable reversals if needed
                                            'SetupReverseCompanyConversion()
                                            'SetupReversal()
                                        End If

                                        dvError.Style("display") = "none"
                                        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href="""" onclick=""Convert_Trust();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_entrytype.png") & """ align=""absmiddle""/>Move Client</a>")
                                    Else
                                        dvError.Style("display") = "inline"
                                        tdError.InnerHtml = "Commission Scenario does not exist for this Agency/Settl. Attorney, cannot move client at this time. Please notify IT Dept."
                                    End If
                                Else
                                    dvError.Style("display") = "inline"
                                    tdError.InnerHtml = "This client has pending deposits at their current Trust Location, cannot move client at this time."
                                End If
                            Else
                                'Client cannot be moved. There are no active transfers from the client's current Settl. Attorney and State. Page is read only.
                                If SettlementProcessingHelper.IsManager(UserID) Then
                                    CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""transfer.aspx?id=" & ClientID & """><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_results_last.png") & """ align=""absmiddle""/>Adhoc Transfer</a>")
                                End If
                            End If
                        End If
                    Catch ex As Exception
                        dvError.Style("display") = "inline"
                        tdError.InnerHtml = ex.Message
                    End Try
                End If
            End Using
        End Using

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

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        ''check and fix account number
        'If AccountNumberExists(txtAccountNumber.Text, ClientID) Then

        '    dvError.Style("display") = "inline"
        '    tdError.InnerHtml = "The Account Number you entered is already in use by another client."

        '    lblTrustName.Style("display") = "none"
        '    cboTrustID.Style("display") = "inline"
        '    lblAccountNumber.Style("display") = "none"
        '    txtAccountNumber.Style("display") = "inline"

        '    pnlEdit.Style("display") = "none"
        '    pnlSave.Style("display") = "inline"
        'Else
        '    'save sda info
        '    UpdateClient()

        '    'refresh the page
        '    Reload()
        'End If
    End Sub

    'Private Function AccountNumberExists(ByVal AccountNumber As String, ByVal ClientID As Integer) As Boolean
    '    Dim NumClients As Integer = DataHelper.FieldCount("tblClient", "ClientID", "AccountNumber = '" & AccountNumber & "' AND NOT ClientID = " & ClientID)
    '    Return NumClients > 0
    'End Function

    'Private Sub UpdateClient()
    '    Dim fields As New List(Of DataHelper.FieldValue)

    '    fields.Add(New DataHelper.FieldValue("TrustID", DataHelper.Nz_int(txtTrustID.Value)))
    '    fields.Add(New DataHelper.FieldValue("AccountNumber", DataHelper.Nz(txtAccountNumber.Text)))

    '    DataHelper.AuditedUpdate(fields, "tblClient", ClientID, UserID)
    'End Sub

    Private Sub Reload()
        Response.Redirect("~/clients/client/finances/sda/?id=" & ClientID)
    End Sub

    Private Sub Reload(ByVal bShowLetter As Boolean)
        Response.Redirect("~/clients/client/finances/sda/?id=" & ClientID & "&showltr=" & bShowLetter)
    End Sub

    Private Sub ShowTransferLetter()
        'add client transfer doc
        Dim sqlAccts As String = String.Format("SELECT ClientID, CurrentCreditorInstanceID FROM tblAccount AS a WHERE (ClientID = {0}) AND (NOT (AccountStatusID IN (54, 55)))", ClientID)
        Dim reports As New List(Of String)

        Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sqlAccts, ConfigurationManager.AppSettings("connectionstring").ToString)
            reports.Add(String.Format("ClientTransferWelcomeLetter_{0}", ClientID))
            For Each row As DataRow In dt.Rows
                reports.Add(String.Format("TransferLetterOfRepresentation_{0}", row("CurrentCreditorInstanceID").ToString))
            Next
        End Using

        Dim queryString As String = "../../reports/report.aspx?clientid=" & ClientID & "&reports=" & Join(reports.ToArray, "|") & "&user=" & UserID
        Dim frm As HtmlControl = TryCast(dvReport.FindControl("frmReport"), HtmlControl)
        frm.Attributes("src") = queryString

        programmaticModalPopup.Show()
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
    End Sub

    Protected Sub lnkAssignNew_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAssignNew.Click
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_AssignNewAccountNumber")
        DatabaseHelper.AddParameter(cmd, "clientid", ClientID)
        DataHelper.AuditedUpdateCommand(cmd, New List(Of String)(New String() {"AccountNumber"}), "tblClient", ClientID, UserID)
    End Sub

    Public Sub lnkConvert_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkConvert.Click
        ConvertToPlaza(ClientID, lblAccountNumber.Text, UserID)
    End Sub

    Private Sub SetupPlazaConversion()
        Dim strCellText As String = ""

        RegisterHelper.Rebalance(ClientID)

        Dim dblCurrentSDA As Double = Drg.Util.DataAccess.DataHelper.FieldLookup("tblClient", "SDABalance", "Clientid = " & ClientID)

        Dim tblInfo As New Table
        tblInfo.CellPadding = 0
        tblInfo.CellSpacing = 0
        tblInfo.BorderStyle = BorderStyle.None
        tblInfo.CssClass = "confirmTable"
        tblInfo.Style("width") = "98%"
        tblInfo.Style("padding") = "5px"

        Dim trHdr As New TableRow
        trHdr.Height = "25"
        trHdr.HorizontalAlign = HorizontalAlign.Center

        Dim tcHdr As New TableCell
        tcHdr.Text = "<h2>Conversion Actions</h2>"
        tcHdr.HorizontalAlign = HorizontalAlign.Left
        tcHdr.VerticalAlign = VerticalAlign.Middle
        tcHdr.Font.Underline = True
        tcHdr.Style("bottom-border") = "black 1 px solid"
        trHdr.Cells.Add(tcHdr)
        tblInfo.Rows.Add(trHdr)

        If Math.Sign(dblCurrentSDA) <> -1 Then
            Dim strTransactions As New List(Of String)
            Dim sqlClient As String = "SELECT distinct c.AccountNumber, c.CompanyID, c.SDABalance, case when nr.registerid is null then 'False' else 'True' end as [Processed], "
            sqlClient += "sum(case when isnull(r.hold,getdate()) > dateadd(d,1,getdate())or isnull(r.transactiondate,getdate()) > dateadd(d,1,getdate())  then r.amount else 0 end) as [OnHold] "
            sqlClient += "from tblClient as c left outer join (select r.hold, r.transactiondate, r.amount, r.clientid ,r.registerid,r.void,r.bounce,nr.registerid as [ProcessedRegisterID] "
            sqlClient += "from tblregister as r left outer join tblnacharegister as nr on r.registerid=nr.registerid "
            sqlClient += "where	(isnull(r.hold,getdate()) > dateadd(d,1,getdate())or isnull(r.transactiondate,getdate()) > dateadd(d,1,getdate())) "
            sqlClient += "and (r.void is null and r.bounce is null))as r on c.clientid =r.clientid  left outer join tblnacharegister as nr on r.registerid=nr.registerid "
            sqlClient += "where (c.clientid = " & ClientID & ") "
            sqlClient += "group by c.AccountNumber, c.CompanyID, c.SDABalance,nr.registerid"
            Dim dtClient As DataTable = GetDataTable(sqlClient)
            If dtClient.Rows.Count > 0 Then
                For Each dRow As DataRow In dtClient.Rows
                    dblCurrentSDA = CDbl(dRow("sdabalance").ToString) - CDbl(dRow("OnHold").ToString)
                    Exit For
                Next
                dtClient.Dispose()
                dtClient = Nothing
            End If

            strTransactions.Add("Transfer " & FormatCurrency(dblCurrentSDA, 2) & " from " & lblTrustName.Text & " to Shadow Account " & DataHelper.FieldLookup("tblClient", "Accountnumber", "Clientid = " & ClientID) & ".")

            For Each sTrans As String In strTransactions
                trHdr = New TableRow
                tcHdr = New TableCell
                tcHdr.Text = sTrans
                tcHdr.Style("padding") = "10px"
                trHdr.Cells.Add(tcHdr)
                tblInfo.Rows.Add(trHdr)
            Next
        Else
            trHdr = New TableRow
            tcHdr = New TableCell
            strCellText = "<b>Unable to convert for the following reason:</b></br>"
            strCellText += "<blockquote>Negative SDA Balance (" & dblCurrentSDA & ").</br>"
            strCellText += "</blockquote>"
            tcHdr.Text = strCellText

            trHdr.Cells.Add(tcHdr)
            tblInfo.Rows.Add(trHdr)
            Me.lnkConvert.Visible = False
        End If

        lnkReverse.Visible = False
        Me.pnlConfirm.Controls.AddAt(0, tblInfo)
    End Sub

    'Private Sub SetupReversal()
    '    Dim strCellText As String = ""

    '    dblCurrentSDA = Drg.Util.DataAccess.DataHelper.FieldLookup("tblClient", "SDABalance", "Clientid = " & ClientID)
    '    RegisterHelper.Rebalance(ClientID)
    '    Dim postSDABal As Double = Drg.Util.DataAccess.DataHelper.FieldLookup("tblClient", "SDABalance", "Clientid = " & ClientID)

    '    Dim CommonTasks As List(Of String) = Master.CommonTasks
    '    If Master.UserEdit() Then
    '        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href="""" onclick=""Reverse_Trust();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel2.png") & """ align=""absmiddle""/>Reverse Trust</a>")
    '    End If

    '    Dim tblInfo As New Table
    '    tblInfo.CellPadding = 0
    '    tblInfo.CellSpacing = 0
    '    tblInfo.BorderStyle = BorderStyle.None
    '    tblInfo.CssClass = "confirmTable"
    '    tblInfo.Style("width") = "98%"
    '    tblInfo.Style("padding") = "5px"

    '    Dim trHdr As New TableRow
    '    trHdr.Height = "25"
    '    trHdr.HorizontalAlign = HorizontalAlign.Center

    '    Dim tcHdr As New TableCell
    '    tcHdr.Text = "<h2>Conversion Reversal Actions</h2>"
    '    tcHdr.HorizontalAlign = HorizontalAlign.Left
    '    tcHdr.VerticalAlign = VerticalAlign.Middle
    '    tcHdr.Font.Underline = True
    '    tcHdr.Style("bottom-border") = "black 1 px solid"
    '    trHdr.Cells.Add(tcHdr)
    '    tblInfo.Rows.Add(trHdr)

    '    lnkReverse.Visible = False
    '    If dblCurrentSDA = postSDABal Then
    '        If Math.Sign(dblCurrentSDA) <> -1 Then

    '            'Edit 7/21/08 - jhernandez
    '            'Exclude on hold amounts if they have a clear date that has already passed.
    '            Dim strCompanyID As Integer = 0
    '            Dim strTransactions As New List(Of String)
    '            Dim sqlClient As String = "SELECT distinct c.AccountNumber, c.CompanyID, c.SDABalance, case when nr.registerid is null then 'False' else 'True' end as [Processed], "
    '            sqlClient += "isnull(sum(r.amount),0) [OnHold] "
    '            sqlClient += "from tblClient as c left outer join (select r.hold, r.transactiondate, r.amount, r.clientid ,r.registerid,r.void,r.bounce,nr.registerid as [ProcessedRegisterID] "
    '            sqlClient += "from tblregister as r left outer join tblnacharegister as nr on r.registerid=nr.registerid "
    '            sqlClient += "where	(isnull(r.hold,getdate()) > dateadd(d,1,getdate())or isnull(r.transactiondate,getdate()) > dateadd(d,1,getdate())) "
    '            sqlClient += "and (r.void is null and r.bounce is null) and isnull(r.Clear,'1/1/2050') > dateadd(d,1,getdate())) as r on c.clientid =r.clientid  left outer join tblnacharegister as nr on r.registerid=nr.registerid "
    '            sqlClient += "where (c.clientid = " & ClientID & ") "
    '            sqlClient += "group by c.AccountNumber, c.CompanyID, c.SDABalance,nr.registerid"
    '            Dim dtClient As DataTable = GetDataTable(sqlClient)
    '            If dtClient.Rows.Count > 0 Then
    '                For Each dRow As DataRow In dtClient.Rows
    '                    dblCurrentSDA = CDbl(dRow("sdabalance").ToString) - CDbl(dRow("OnHold").ToString)
    '                    strCompanyID = dRow("companyid")
    '                    Exit For
    '                Next
    '                dtClient.Dispose()
    '                dtClient = Nothing
    '            End If


    '            strTransactions.Add("Transfer " & FormatCurrency(dblCurrentSDA, 2) & " from Shadow Account " & DataHelper.FieldLookup("tblClient", "Accountnumber", "Clientid = " & ClientID) & " to " & DataHelper.FieldLookup("tblcommrec", "Display", "istrust =1 and companyid = " & strCompanyID) & ".")

    '            For Each sTrans As String In strTransactions
    '                trHdr = New TableRow
    '                tcHdr = New TableCell
    '                tcHdr.Text = sTrans
    '                tcHdr.Style("padding") = "10px"
    '                trHdr.Cells.Add(tcHdr)
    '                tblInfo.Rows.Add(trHdr)
    '            Next

    '            lnkReverse.Visible = True
    '        Else
    '            trHdr = New TableRow
    '            tcHdr = New TableCell
    '            strCellText = "<b>Unable to convert for the following reason:</b></br>"
    '            strCellText += "<blockquote>Negative SDA Balance (" & dblCurrentSDA & ").</br>"
    '            strCellText += "</blockquote>"
    '            tcHdr.Text = strCellText
    '            lnkReverse.Visible = True
    '            trHdr.Cells.Add(tcHdr)
    '            tblInfo.Rows.Add(trHdr)
    '            Me.lnkConvert.Visible = False
    '        End If
    '    Else
    '        trHdr = New TableRow
    '        tcHdr = New TableCell
    '        strCellText = "<b>Unable to convert for the following reason:</b></br>"
    '        strCellText += "<blockquote>SDA Balance Conflict.</br>"
    '        strCellText += "SDA Balance Before Rebalance: " & dblCurrentSDA & "</br>"
    '        strCellText += "SDA Balance After Rebalance: " & postSDABal & "</br>"
    '        strCellText += "</blockquote>"
    '        tcHdr.Text = strCellText
    '        trHdr.Cells.Add(tcHdr)
    '        tblInfo.Rows.Add(trHdr)
    '    End If

    '    Me.lnkConvert.Visible = False
    '    Me.pnlConfirm.Controls.AddAt(0, tblInfo)
    'End Sub

    Private Sub SetupCompanyConversion(ByVal CompanyID As Integer, ByVal StateID As Integer)
        If Not Page.IsPostBack Then
            Dim tbl As DataTable = GetDataTable(String.Format("select c.CompanyId, c.Name From tblCompany c Join tblConversionlookup l on l.tocompanyid = c.companyid and l.fromCompanyId = {0} and l.fromstateid = {1} order by companyid", CompanyID, StateID))

            If tbl.Rows.Count > 0 Then
                trCompany.Style("display") = "inline"
            End If

            ddlToCompany.DataSource = tbl
            ddlToCompany.DataTextField = "Name"
            ddlToCompany.DataValueField = "CompanyId"
            ddlToCompany.DataBind()
        End If
    End Sub

    'Private Sub SetupReverseCompanyConversion()
    '    If Not Page.IsPostBack Then
    '        Dim OldCompanyId As Integer = GetPreviousCompanyId()
    '        Dim dtCompany As DataTable = GetCompanyByTrust(20)
    '        Dim dv As New DataView(dtCompany)

    '        trCompany.Style("display") = "inline"

    '        Me.ddCompany.DataSource = dv
    '        Me.ddCompany.DataTextField = "Name"
    '        Me.ddCompany.DataValueField = "CompanyId"
    '        Me.ddCompany.DataBind()

    '        Dim index As Integer = 0
    '        If OldCompanyId <> 0 Then
    '            If Not Me.ddCompany.Items.FindByValue(OldCompanyId) Is Nothing Then
    '                index = Me.ddCompany.Items.IndexOf(ddCompany.Items.FindByValue(OldCompanyId))
    '            End If
    '        End If
    '        Me.ddCompany.SelectedIndex = index
    '    End If
    'End Sub

    'Private Function GetPreviousCompanyId() As Integer
    '    Dim OldId As Integer = 0
    '    Dim sqlStr As String = String.Format("Select Top 2 Value from tblAudit Where AuditColumnId = 27 And PK = {0} order by AuditId desc", ClientID)
    '    Dim dt As DataTable = GetDataTable(sqlStr)
    '    If dt.Rows.Count = 2 Then
    '        OldId = CInt(dt.Rows(1)("Value"))
    '    End If
    '    Return OldId
    'End Function

    Private Function CanConvert() As Boolean
        Dim sqlStr As String = "select top 1 registerid from tblregister where ClientID = {0} and amount <> 0 and entrytypeid = 3 and " _
                             & " (((hold is not null and hold > cast(convert(varchar,getdate(),101) as datetime)) " _
                             & " or (hold is null and transactiondate > cast(convert(varchar,getdate(),101) as datetime))) " _
                             & " and [clear] is null and bounce is null and void is null)"

        Dim dt As DataTable = GetDataTable(String.Format(sqlStr, ClientID))
        Return (dt.Rows.Count = 0)
    End Function

    Private Sub ConvertToPlaza(ByVal ClientID As Integer, ByVal AccountNumber As String, ByVal ActionUserID As Integer)
        Dim store As New WCFClient.Store
        Dim stores(0) As String

        'change TrustID, change CompanyID, move SDA, log updates
        ClientHelper.ConvertToPlaza(ClientID, CInt(ddlToCompany.SelectedItem.Value), ActionUserID)

        Try
            stores(0) = lblAccountNumber.Text
            If Not store.StoreExists(stores) Then
                store.OpenAccount(ClientID, ActionUserID, False)
            End If
        Catch ex As Exception
            'Ignore error. Shadow store will be created at transfer time if not exists
        End Try

        store = Nothing
        Reload(True)
    End Sub

    Private Shared Function GetDataTable(ByVal sqlText As String) As DataTable
        Try
            Dim dtData As New DataTable
            Using saTemp = New SqlClient.SqlDataAdapter(sqlText, System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
                saTemp.Fill(dtData)
            End Using
            Return dtData
        Catch ex As Exception
            Return Nothing
        End Try
    End Function

    Public Sub lnkReverse_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkReverse.Click
        'ClientHelper.ReverseConvertToPlaza(ClientID, Me.ddCompany.SelectedValue, UserID)
        'Reload()
    End Sub

    Protected Sub hideModalPopupViaServer_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles hideModalPopupViaServer.Click
        programmaticModalPopup.Hide()
        Reload()
    End Sub

    Private Function NewCommScenExists() As Boolean
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_NewCommScenExists")
            Using cmd.Connection
                Dim param As New SqlClient.SqlParameter
                param.ParameterName = "@return_value"
                param.SqlDbType = SqlDbType.Bit
                param.Direction = ParameterDirection.ReturnValue
                cmd.Parameters.Add(param)
                DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
                DatabaseHelper.AddParameter(cmd, "NewCompanyID", CInt(ddlToCompany.SelectedItem.Value))
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
                Return CBool(cmd.Parameters(0).value)
            End Using
        End Using
    End Function

    Protected Sub ddlToCompany_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlToCompany.SelectedIndexChanged
        LoadRecord()
        trCompany.Style("display") = "inline"
    End Sub
End Class