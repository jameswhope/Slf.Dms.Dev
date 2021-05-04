Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports SharedFunctions
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Collections.Generic
Imports System.IO


Partial Class Clients_client_creditors_matters_matterexpenses
    Inherits System.Web.UI.Page
#Region "Variables"
    Private Action As String
    Public QueryString As String
    Private qs As QueryStringCollection
    Public UserID As Integer
    Public Shadows ClientID As Integer
    Public AccountID As Integer
    Public dTotal As Double = 0
    Public MatterId As Integer
    Public MatterTypeId As Integer
    Public CreditorInstanceId As Integer = 0
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        qs = LoadQueryString()
        ClientID = DataHelper.Nz_int(qs("id"), 0)
        AccountID = DataHelper.Nz_int(qs("aid"), 0)
        Action = DataHelper.Nz_string(qs("a"))
        MatterId = DataHelper.Nz_int(qs("mid"), 0)
        MatterTypeId = DataHelper.Nz_int(qs("type"), 0)
        CreditorInstanceId = DataHelper.Nz_int(qs("ciid"), 0)
        If Not IsPostBack Then
            LoadClientInformation()
            LoadMatterInformation()
            LoadEntryTypes(cboEntryType, 0)
            LoadAttorney(cboAttorney, 0)
            LoadExpenses()
            HandleAction()
        End If
    End Sub

    'Private Sub LoadEntryTypes(ByRef cboEntryType As DropDownList, ByVal SelectedTaskTypeID As Integer)

    '    Dim rd As IDataReader = Nothing
    '    Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

    '    cmd.CommandText = "SELECT * FROM tblEntryType Where Type='Debit' and Fee=1 order by DisplayName"

    '    cboEntryType.Items.Clear()

    '    cboEntryType.Items.Add(New ListItem(" -- Select -- ", 0))

    '    Try

    '        cmd.Connection.Open()
    '        rd = cmd.ExecuteReader()

    '        While rd.Read()
    '            cboEntryType.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "DisplayName"), DatabaseHelper.Peel_int(rd, "EntryTypeId")))
    '        End While

    '    Finally
    '        DatabaseHelper.EnsureReaderClosed(rd)
    '        DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
    '    End Try

    '    ListHelper.SetSelected(cboEntryType, SelectedTaskTypeID)

    'End Sub

    'Private Sub LoadAttorney(ByRef cboAttorney As DropDownList, ByVal SelectedAttorneyId As Integer)

    '    cboAttorney.Items.Clear()

    '    Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
    '        Using cmd.Connection
    '            ' cmd.CommandText = "select AttorneyId, Firstname+' '+LastName as [name]  from tblAttorney order by name "
    '            cmd.CommandText = "stp_GetLocalCounselListbyClient"
    '            cmd.CommandType = CommandType.StoredProcedure
    '            DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
    '            cmd.Connection.Open()
    '            Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
    '                While rd.Read()
    '                    cboAttorney.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "LocalCounsel"), DatabaseHelper.Peel_int(rd, "AttorneyId")))
    '                End While
    '                cboAttorney.Items.Insert(0, New ListItem("-- Select -- ", "0"))
    '            End Using
    '        End Using
    '    End Using

    '    ListHelper.SetSelected(cboAttorney, SelectedAttorneyId)

    'End Sub

    Private Sub LoadEntryTypes(ByRef cboEntryType As DropDownList, ByVal SelectedTaskTypeID As Integer)

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        Using cmd.Connection
            cmd.CommandText = "stp_GetValidMatterExpenseEntryType"
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Connection.Open()
            Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                While rd.Read()
                    Dim strDisplayName As String = DatabaseHelper.Peel_string(rd, "DisplayName")
                    Dim strEntryTypeValue As String = DatabaseHelper.Peel_int(rd, "EntryTypeId").ToString() + "/" + DatabaseHelper.Peel_bool(rd, "IsFlateRate").ToString() + "/" + DatabaseHelper.Peel_float(rd, "Rate").ToString()
                    cboEntryType.Items.Add(New ListItem(strDisplayName, strEntryTypeValue))
                End While
                cboEntryType.Items.Insert(0, New ListItem("-- Select -- ", "0"))
            End Using
        End Using
        ListHelper.SetSelected(cboEntryType, SelectedTaskTypeID)

    End Sub

    Private Sub LoadAttorney(ByRef cboAttorney As DropDownList, ByVal SelectedAttorneyId As Integer)

        cboAttorney.Items.Clear()

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "stp_GetLocalCounselListbyClient"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                DatabaseHelper.AddParameter(cmd, "ShowInhouse", 1)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()
                        cboAttorney.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "LocalCounsel"), DatabaseHelper.Peel_int(rd, "AttorneyId")))
                    End While
                    cboAttorney.Items.Insert(0, New ListItem("-- Select -- ", "0"))
                End Using
            End Using
        End Using

        ListHelper.SetSelected(cboAttorney, SelectedAttorneyId)

    End Sub

    Private Sub HandleAction()

        Dim CommonTasks As List(Of String) = Master.CommonTasks

        lblMatterExpense.Text = "Matter Time and Expense"

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""SaveMatterExpenses();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_report.png") & """ align=""absmiddle""/>Save Matter Expense</a>")

        lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
        lnkClient.HRef = "~/clients/client/?id=" & ClientID
        lnkCommunications.HRef = "~/clients/client/creditors/matters/matterinstance.aspx?id=" & ClientID & "&aid=" & AccountID & "&mid=" & MatterId & "&ciid=" & CreditorInstanceId
    End Sub

    Private Sub LoadClientInformation()
        lblClient.Text = ClientHelper.GetDefaultPersonName(ClientID)
        lblClientID.Text = ClientID

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "select tp.firstname,tp.lastname,  tcm.name,tp.EmailAddress, " & _
        " tpn.areacode , tpn.number , tpn.extension, tc.primarypersonid," & _
        " tp.street, tp.webcity,  (select name from tblstate where stateid=tp.webstateid) statename , tp.webzipcode, tc.SDABalance " & _
         " from tblperson tp, tblcompany tcm, tblClient tc  left outer join" & _
        " tblPersonPhone tpp on tc.primarypersonid=tpp.personid left outer join" & _
        " tblphone tpn on tpp.phoneid=tpn.phoneid" & _
         "  where(tc.clientid = @ClientID And tc.primarypersonid = tp.personid)" & _
        " and tc.companyid=tcm.companyid "
        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then
                lblFirm.Text = DatabaseHelper.Peel_string(rd, "name")

            End If
            rd.Close()
        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Private Sub LoadMatterInformation()
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                cmd.CommandText = "stp_GetMatterInstance"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "MatterId", MatterId)
                DatabaseHelper.AddParameter(cmd, "AccountId", AccountID)
                DatabaseHelper.AddParameter(cmd, "MatterTypeId", MatterTypeId)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()
                        txtMatterNumber.Text = rd("MatterNumber")
                        txtAccountNumber.Text = rd("AccountNumber")
                        txtMatterDate.Text = rd("MatterDate")
                        txtLocalCounsel.Text = rd("LocalCounsel")
                    End While
                End Using
            End Using
        End Using
    End Sub

    Private Sub LoadExpenses()
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        cmd.CommandText = "select et.DisplayName, tmt.EntryTypeID, tmt.AttorneyID, ta.Firstname+' '+ta.LastName as [AttorneyName], tmt.BillableTime, CONVERT(VARCHAR,tmt.billrate,1) BillRate, tmt.TimeExpenseDescription, tmt.TimeExpenseDatetime, cast(CONVERT(VARCHAR,cast(CONVERT(VARCHAR,tmt.BillableTime,0) as decimal(18,2)) * cast(CONVERT(VARCHAR,tmt.billrate,0) as decimal(18,2)),0) as decimal(18,2)) SubTotal, tmt.MatterTimeExpenseId, tmt.Note, et.IsFlateRate, et.Rate from tblmatter tm, tblAttorney ta, tblMatterTimeExpense tmt left outer join tblEntryType et on et.EntryTypeID = tmt.EntryTypeID where tm.matterid = @matterid And tmt.attorneyid = ta.attorneyid And tm.matterid = tmt.matterid order by tmt.TimeExpenseDatetime Desc"
        DatabaseHelper.AddParameter(cmd, "MatterId", MatterId)
        Try
            cmd.Connection.Open()

            ''Binding Data to Grid
            Dim sqlDA As New SqlDataAdapter(cmd)
            Dim ds As New DataSet
            sqlDA.Fill(ds)
            rpMatterExpenses.DataSource = ds
            rpMatterExpenses.DataBind()

            Dim TotalExp As Double = 0.0
            Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                While rd.Read()
                    Dim dtExpDate As DateTime
                    dtExpDate = DatabaseHelper.Peel_date(rd, "TimeExpenseDatetime")
                    Dim strEntryTypeValue As String = Convert.ToString(DatabaseHelper.Peel_int(rd, "EntryTypeID")) + "/" + DatabaseHelper.Peel_bool(rd, "IsFlateRate").ToString() + "/" + DatabaseHelper.Peel_float(rd, "Rate").ToString()
                    If txtPropagations.Value.Length > 0 Then
                        txtPropagations.Value += "|" + Convert.ToString(DatabaseHelper.Peel_string(rd, "DisplayName")) + "," + strEntryTypeValue + "," + Convert.ToString(FormatDateTime(dtExpDate, DateFormat.ShortDate)) + "," + Convert.ToString(DatabaseHelper.Peel_string(rd, "AttorneyName")) + "," + Convert.ToString(DatabaseHelper.Peel_int(rd, "AttorneyID")) + "," + DatabaseHelper.Peel_string(rd, "TimeExpenseDescription") + "," + Convert.ToString(DatabaseHelper.Peel_int(rd, "MatterTimeExpenseId")) + "," + Convert.ToString(DatabaseHelper.Peel_float(rd, "BillableTime")) + "," + Convert.ToString(DatabaseHelper.Peel_float(rd, "BillRate")) + "," + Convert.ToString(DatabaseHelper.Peel_float(rd, "SubTotal")) + "," + DatabaseHelper.Peel_string(rd, "Note")
                        TotalExp = TotalExp + DatabaseHelper.Peel_float(rd, "SubTotal")
                    Else
                        txtPropagations.Value = Convert.ToString(DatabaseHelper.Peel_string(rd, "DisplayName")) + "," + strEntryTypeValue + "," + Convert.ToString(FormatDateTime(dtExpDate, DateFormat.ShortDate)) + "," + Convert.ToString(DatabaseHelper.Peel_string(rd, "AttorneyName")) + "," + Convert.ToString(DatabaseHelper.Peel_int(rd, "AttorneyID")) + "," + DatabaseHelper.Peel_string(rd, "TimeExpenseDescription") + "," + Convert.ToString(DatabaseHelper.Peel_int(rd, "MatterTimeExpenseId")) + "," + Convert.ToString(DatabaseHelper.Peel_float(rd, "BillableTime")) + "," + Convert.ToString(DatabaseHelper.Peel_float(rd, "BillRate")) + "," + Convert.ToString(DatabaseHelper.Peel_float(rd, "SubTotal")) + "," + DatabaseHelper.Peel_string(rd, "Note")
                        TotalExp = TotalExp + DatabaseHelper.Peel_float(rd, "SubTotal")
                    End If

                End While
            End Using

            lblExpenseTotal.Text = TotalExp.ToString()

        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
        rpMatterExpenses.Visible = rpMatterExpenses.Items.Count > 0
        pnlNoAccounts.Visible = Not rpMatterExpenses.Visible

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

    Private Sub Close()
        If Action = "am" And MatterId > 0 Then
            Response.Redirect("~/clients/client/creditors/matters/matterinstance.aspx?id=" & ClientID & "&aid=" & AccountID & "&mid=" & MatterId & "&ciid=" & CreditorInstanceId)
        Else
            Response.Redirect("~/clients/client/communication/?id=" & ClientID)
        End If
    End Sub

    Protected Sub lnkReload_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkReload.Click
        LoadClientInformation()
        LoadMatterInformation()
        LoadExpenses()
        HandleAction()
    End Sub

    Protected Sub rpMatterExpenses_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rpMatterExpenses.ItemDataBound
        If e.Item.ItemType = ListItemType.AlternatingItem Or e.Item.ItemType = ListItemType.Item Then
            dTotal += Convert.ToDouble(CType(e.Item.FindControl("hdnST"), HtmlInputHidden).Value)
        ElseIf e.Item.ItemType = ListItemType.Footer Then
            CType(e.Item.FindControl("lblTotal"), Label).Text = dTotal.ToString("0.00")
        End If
    End Sub

    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub

    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click
        
        'reload same page (of applicants)
        Response.Redirect(Request.Url.AbsoluteUri)
    End Sub

    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        ExportToExcel()
    End Sub

    Private Sub ExportToExcel()
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        cmd.CommandText = "select et.DisplayName, tmt.EntryTypeID, tmt.AttorneyID, ta.Firstname+' '+ta.LastName as [AttorneyName], tmt.BillableTime, CONVERT(VARCHAR,tmt.billrate,1) BillRate, tmt.TimeExpenseDescription, tmt.TimeExpenseDatetime, cast(CONVERT(VARCHAR,cast(CONVERT(VARCHAR,tmt.BillableTime,0) as decimal(18,2)) * cast(CONVERT(VARCHAR,tmt.billrate,0) as decimal(18,2)),0) as decimal(18,2)) SubTotal, tmt.MatterTimeExpenseId, tmt.Note, et.IsFlateRate, et.Rate from tblmatter tm, tblAttorney ta, tblMatterTimeExpense tmt left outer join tblEntryType et on et.EntryTypeID = tmt.EntryTypeID where tm.matterid = @matterid And tmt.attorneyid = ta.attorneyid And tm.matterid = tmt.matterid order by tmt.TimeExpenseDatetime Desc"
        DatabaseHelper.AddParameter(cmd, "MatterId", MatterId)
        Try
            cmd.Connection.Open()
            Dim sqlDA As New SqlDataAdapter(cmd)
            Dim tblTransactions As New DataTable
            sqlDA.Fill(tblTransactions)

            Dim sw As New StringWriter
            Dim htw As New HtmlTextWriter(sw)
            Dim table As New System.Web.UI.WebControls.Table
            Dim tr As New System.Web.UI.WebControls.TableRow
            Dim cell As TableCell

            For i As Integer = 0 To tblTransactions.Columns.Count - 1
                cell = New TableCell
                cell.Text = tblTransactions.Columns(i).ColumnName
                tr.Cells.Add(cell)
            Next
            table.Rows.Add(tr)

            For Each row As DataRow In tblTransactions.Rows
                tr = New TableRow
                For i As Integer = 0 To tblTransactions.Columns.Count - 1
                    cell = New TableCell
                    cell.Attributes.Add("class", "text")
                    cell.Text = row.Item(i).ToString
                    tr.Cells.Add(cell)
                Next
                table.Rows.Add(tr)
            Next

            table.RenderControl(htw)

            HttpContext.Current.Response.Clear()
            HttpContext.Current.Response.ContentType = "application/ms-excel"
            HttpContext.Current.Response.AddHeader("content-disposition", "attachment; filename=matter_expense.xls")
            HttpContext.Current.Response.Write(sw.ToString)
            HttpContext.Current.Response.End()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Private Sub SaveMatterExpenses()

        Dim Propagations() As String
        Propagations = txtPropagations.Value.Split("|")

        For Each Propagation As String In Propagations

            If Propagation.Length > 0 Then

                Dim Parts() As String = Propagation.Split(",")

                Dim EntryTypeValue As String = Parts(0)
                Dim EntryTypeList() As String = EntryTypeValue.Split("/")
                Dim EntryTypeID As Integer = DataHelper.Nz_int(EntryTypeList(0))
                Dim blnFlatRate As Boolean = DataHelper.Nz_bool(EntryTypeList(1))
                Dim FlatRate As Double = Math.Abs(StringHelper.ParseDouble(EntryTypeList(2), 0.0))
                Dim MatterID As Integer = DataHelper.Nz_int(Parts(1))
                Dim ExpenseDate As String = Parts(2)
                'Dim Due As String = Parts(3)
                Dim AttorneyID As Integer = DataHelper.Nz_int(Parts(4))
                Dim Description As String = Parts(5)
                Dim ExpenseID As Integer = Parts(6)
                Dim BillTime As Double = Math.Abs(StringHelper.ParseDouble(Parts(7), 0.0))
                Dim BillRate As Double = Math.Abs(StringHelper.ParseDouble(Parts(8), 0.0))
                Dim Memo As String = Parts(9)
                Dim SubTotal As Double = Math.Abs(StringHelper.ParseDouble(Parts(10), 0.0))

                If blnFlatRate = True Then
                    If FlatRate <> SubTotal Then
                        BillRate = SubTotal
                    End If
                End If

                If ExpenseID > 0 Then
                    ''Edit Matter expense
                Else
                    Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                        Using cmd.Connection
                            cmd.Connection.Open()
                            cmd.CommandText = "insert into tblMatterTimeExpense (MatterId, TimeExpenseDatetime, TimeExpenseDescription, BillableTime, BillRate, AttorneyId, CreateDatetime, Createdby, Note, EntryTypeID)  values(@MatterID, @TimeExpenseDatetime,@TimeExpenseDescription, @BillableTime, @BillRate, @AttorneyId, getdate(),@UserID, @Note, @EntryTypeID)"
                            DatabaseHelper.AddParameter(cmd, "MatterID", MatterID)
                            DatabaseHelper.AddParameter(cmd, "TimeExpenseDatetime", ExpenseDate)
                            DatabaseHelper.AddParameter(cmd, "TimeExpenseDescription", Description)
                            DatabaseHelper.AddParameter(cmd, "BillableTime", BillTime)
                            DatabaseHelper.AddParameter(cmd, "BillRate", BillRate)
                            DatabaseHelper.AddParameter(cmd, "AttorneyId", AttorneyID)
                            DatabaseHelper.AddParameter(cmd, "Note", Memo)
                            DatabaseHelper.AddParameter(cmd, "UserID", UserID)
                            DatabaseHelper.AddParameter(cmd, "EntryTypeID", EntryTypeID)
                            cmd.ExecuteNonQuery()

                        End Using
                    End Using
                End If

            End If
        Next

        If txtDeletedIDs.Value.Length > 0 Then
            'get selected "," delimited MatterExpenses's
            Dim MatterExpenses() As String = txtDeletedIDs.Value.Split(",")
            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            Try
                cmd.Connection.Open()
                For Each MatterExpenseID In MatterExpenses
                    If MatterExpenseID <> "" Then
                        cmd.CommandText = "delete from tblMatterTimeExpense where MatterTimeExpenseID=@MatterTimeExpenseID"
                        cmd.Parameters.Clear()
                        DatabaseHelper.AddParameter(cmd, "MatterTimeExpenseID", MatterExpenseID)
                        cmd.ExecuteNonQuery()
                    End If
                Next
            Catch ex As Exception
            Finally
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Try
        End If

        Response.Redirect("~/clients/client/creditors/matters/matterexpenses.aspx?a=am&aid=" & AccountID & "&mid=" & MatterId & "&id=" & ClientID & "&type=" & MatterTypeId & "&t=c")

    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        SaveMatterExpenses()
        If txtDeletedIDs.Value.Trim() <> "" Then
            Dim strIds As String() = txtDeletedIDs.Value.Split(",")
            Dim i As Int32 = 0
            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            cmd.Connection.Open()
            cmd.CommandText = "delete from tblMatterTimeExpense where MatterTimeExpenseId=@MatterTimeExpenseId"
            For i = 0 To strIds.Length - 1
                If Not strIds(i).Trim() = "" Then
                    Dim strMeId As String = strIds(i)
                    cmd.Parameters.Clear()
                    DatabaseHelper.AddParameter(cmd, "MatterTimeExpenseId", strMeId)
                    cmd.ExecuteNonQuery()
                End If
            Next i
        End If
    End Sub
End Class
