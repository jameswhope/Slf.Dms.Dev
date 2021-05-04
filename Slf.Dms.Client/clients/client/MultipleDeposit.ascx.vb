Imports System.Collections.Generic
Imports Drg.Util.DataAccess
Imports System.Data
Imports System.Data.SqlClient

Public Enum DepositFrequency
    month = 0
    week = 1
End Enum

Public Class DepositDayItem
    Public Const LastDayOfMonth As Integer = -1
    Public Const FirstDayOfMonth As Integer = 1
    Private _day As Integer
    Private _frequency As Integer
    Private _occurrence As Integer = 0
    Private _description As String
    Private _amount As Decimal = 0
    Private _clientDepositId As Integer = 0
    Private _hasRule As Boolean = False
    Private _bankAccountId As Integer = 0
    Private _depositMethodDisplay As String = ""

    Public Sub New()

    End Sub

    Public Sub New(ByVal day As Integer, ByVal description As String, ByVal frequency As DepositFrequency)
        _day = day
        _description = description
        _frequency = frequency
    End Sub

    Public Sub New(ByVal day As Integer, ByVal description As String, ByVal frequency As DepositFrequency, ByVal occurrence As Integer)
        _day = day
        _description = description
        _frequency = frequency
        _occurrence = occurrence
    End Sub

    Public Property Day() As Integer
        Get
            Return _day
        End Get
        Set(ByVal value As Integer)
            _day = value
        End Set
    End Property

    Public Property ClientDepositId() As Integer
        Get
            Return _clientDepositId
        End Get
        Set(ByVal value As Integer)
            _clientDepositId = value
        End Set
    End Property

    Public Property Frequency() As DepositFrequency
        Get
            Return _frequency
        End Get
        Set(ByVal value As DepositFrequency)
            _frequency = value
        End Set
    End Property

    Public Property Description() As String
        Get
            Return _description
        End Get
        Set(ByVal value As String)
            _description = value
        End Set
    End Property

    Public Property Occurrence() As Integer
        Get
            Return _occurrence
        End Get
        Set(ByVal value As Integer)
            _occurrence = value
        End Set
    End Property

    Public ReadOnly Property KeyValue() As String
        Get
            Return String.Format("_{0}_{1}_{2}", _frequency, _day, _occurrence)
        End Get
    End Property

    Public Property Amount() As Decimal
        Get
            Return _amount
        End Get
        Set(ByVal value As Decimal)
            _amount = value
        End Set
    End Property

    Public ReadOnly Property FormattedAmount() As String
        Get
            Return String.Format("{0:#,###,##0.00}", _amount)
        End Get
    End Property

    Public ReadOnly Property IsAch() As Boolean
        Get
            Return (BankAccountId <> 0)
        End Get
    End Property

    Public Property HasRule() As Boolean
        Get
            Return _hasRule
        End Get
        Set(ByVal value As Boolean)
            _hasRule = value
        End Set
    End Property

    Public Property BankAccountId() As Integer
        Get
            Return _bankAccountId
        End Get
        Set(ByVal value As Integer)
            _bankAccountId = value
        End Set
    End Property

    Public Property DepositMethodDisplay() As String
        Get
            Return _depositMethodDisplay
        End Get
        Set(ByVal value As String)
            _depositMethodDisplay = value
        End Set
    End Property

End Class

Public Class DepositDayList
    Private _list As New List(Of DepositDayItem)

    Public ReadOnly Property Items() As List(Of DepositDayItem)
        Get
            Return _list
        End Get
    End Property

    Public Sub New()
    End Sub

    Public Sub New(ByVal frequency As DepositFrequency)
        Fill(frequency)
    End Sub

    Private Sub Fill(ByVal frequency As DepositFrequency)
        _list.Clear()
        Select Case frequency
            Case DepositFrequency.month
                '_list.Add(New DepositDayItem(1, "first day of the month", frequency))
                For i As Integer = 1 To 30
                    _list.Add(New DepositDayItem(i, String.Format("{0}", i.ToString), frequency))
                Next
                '_list.Add(New DepositDayItem(31, "last day of the month", frequency))
            Case DepositFrequency.week
                Dim firstweekday As Integer = DayOfWeek.Monday + 1
                Dim lastweekday As Integer = DayOfWeek.Friday + 1

                For i As Integer = firstweekday To lastweekday
                    _list.Add(New DepositDayItem(i, String.Format("every {0}", WeekdayName(i)), frequency))
                Next
                For i As Integer = firstweekday To lastweekday
                    _list.Add(New DepositDayItem(i, String.Format("first {0} of the month", WeekdayName(i)), frequency, 1))
                Next
                For i As Integer = firstweekday To lastweekday
                    _list.Add(New DepositDayItem(i, String.Format("second {0} of the month", WeekdayName(i)), frequency, 2))
                Next
                For i As Integer = firstweekday To lastweekday
                    _list.Add(New DepositDayItem(i, String.Format("third {0} of the month", WeekdayName(i)), frequency, 3))
                Next
                For i As Integer = firstweekday To lastweekday
                    _list.Add(New DepositDayItem(i, String.Format("last {0} of the month", WeekdayName(i)), frequency, -1))
                Next

        End Select
    End Sub

    Public Function FindByKey(ByVal key As String) As DepositDayItem
        For Each itm As DepositDayItem In Me.Items
            If itm.KeyValue.ToLower = key.ToLower Then
                Return itm
            End If
        Next
    End Function

End Class

Public Enum FloorValidationMode
    None = 0
    Warning = 1
    [Error] = 2
End Enum

Partial Class Clients_client_MultipleDeposit
    Inherits System.Web.UI.UserControl

    Private _list As New DepositDayList
    Private _banks As DataTable
    Private _UserId As Integer = 0
    Private _dayspace As Integer = 7
    Public Event BankChanged()
    Public Event DaysSaved()

    Public Property Client() As Integer
        Get
            Return hdnClientId.Value
        End Get
        Set(ByVal value As Integer)
            hdnClientId.Value = value
        End Set
    End Property

    Public Property MaxAllowed() As Integer
        Get
            Return hdnMaxDeposit.Value
        End Get
        Set(ByVal value As Integer)
            hdnMaxDeposit.Value = value
        End Set
    End Property

    Public Property AllowWeeklyDeposits() As Boolean
        Get
            Return CBool(hdnAllowWeeklyDep.Value)
        End Get
        Set(ByVal value As Boolean)
            hdnAllowWeeklyDep.Value = value
        End Set
    End Property

    Public Property FloorValidation() As FloorValidationMode
        Get
            Return hdnFloorValidation.Value
        End Get
        Set(ByVal value As FloorValidationMode)
            hdnFloorValidation.Value = value
        End Set
    End Property

    Public Property ShowCommandButtons() As Boolean
        Get
            Return trSave.Visible
        End Get
        Set(ByVal value As Boolean)
            trSave.Visible = value
        End Set
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me._UserId = DataHelper.Nz_int(Page.User.Identity.Name)
        Me.Client = Me.Request.QueryString("id").ToString
        ControlInitialize()
        ControlLoad(Me.IsPostBack)
        If Not Page.IsPostBack Then
            SetDepositFloor()
        End If
    End Sub

    Public Sub ControlInitialize()
        If Not Me.IsPostBack() Then
            LoadWhen(Me.ddlMonth, DepositFrequency.month)
            LoadWhen(Me.ddlWeek, DepositFrequency.week)
            LoadBankAccountsFromDB()
            Me.ShowBankAccountPanel(False)
            ShowBankInfoCtrls(0)
        Else
            LoadBankAccountsFromDB()
        End If
    End Sub

    Private Sub SetDepositFloor()
        'If this client is using the new calculator model, calculate their current min deposit amount allowed, policy starts in 2010
        If CInt(SqlHelper.ExecuteScalar("Select count(*) From tblClient Where MaintenanceFeeCap is not null and MaintenanceFeeCap > 0 and multideposit = 1 and created > '1/1/2010' and clientid = " & Me.Client, CommandType.Text)) = 1 Then
            Dim params(0) As SqlParameter
            params(0) = New SqlParameter("@ClientID", Me.Client)
            Dim tbl As DataTable = SqlHelper.GetDataTable("stp_GetClientServiceInfo", CommandType.StoredProcedure, params)
            Dim perAcctFee As Double = CDbl(tbl.Rows(0)("PerAcctFee"))
            Dim acctsToSettle As Integer = CInt(tbl.Rows(0)("AcctsToSettle"))
            Dim cap As Double = CDbl(tbl.Rows(0)("ServiceFeeCap"))
            Dim totalDebt As Double = CDbl(tbl.Rows(0)("TotalDebt"))
            Dim monthlyFee As Double
            Dim depositCommittment As Integer

            hdnPerAcctFee.Value = perAcctFee
            hdnServiceFeeCap.Value = cap

            monthlyFee = (perAcctFee * acctsToSettle)
            If monthlyFee > cap Then
                monthlyFee = cap
            End If
            If (totalDebt * 0.01) > (monthlyFee * 2) Then
                depositCommittment = Math.Round(totalDebt * 0.01)
            Else
                depositCommittment = monthlyFee * 2
            End If
            If depositCommittment < 30 Then
                depositCommittment = 30
            End If

            hdnDepositFloor.Value = depositCommittment
        End If
    End Sub

#Region "Deposit Days"

    Public Sub ControlLoad(ByVal cached As Boolean)
        If Not cached Then
            LoadFromDB()
        Else
            LoadFromCache()
        End If
        RenderGrid()
    End Sub

    Public Sub LoadFromDB()
        LoadScheduledDepositsFromDB()
    End Sub

    Public Sub LoadFromCache()
        LoadScheduledDepositsFromCache()
    End Sub

    Private Sub LoadWhen(ByVal ddl As DropDownList, ByVal frequency As DepositFrequency)
        ddl.Items.Clear()
        ddl.DataSource = New DepositDayList(frequency).Items
        ddl.DataTextField = "Description"
        ddl.DataValueField = "KeyValue"
        ddl.DataBind()
    End Sub

    Private Sub LoadScheduledDepositsFromDB()
        _list.Items.Clear()
        'Add dummy row to be used as a template when adding rows
        _list.Items.Add(New DepositDayItem(1, "dummy", DepositFrequency.month))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = String.Format("Select d.*, RuleCount = (Select count(r.ruleachid) from tbldepositruleach r where GetDate() <= isnull(r.enddate, GetDate()) and r.clientdepositid = d.clientdepositId ) from tblClientDepositDay d Where d.Clientid = {0} and DeletedDate is null order by d.depositday asc", Me.Client)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim depItem As New DepositDayItem()
                        depItem.Day = DatabaseHelper.Peel_int(rd, "DepositDay")
                        depItem.Frequency = DepositFrequency.Parse(GetType(DepositFrequency), DatabaseHelper.Peel_string(rd, "Frequency"))
                        depItem.Occurrence = DatabaseHelper.Peel_int(rd, "Occurrence")
                        depItem.Amount = Math.Round(DatabaseHelper.Peel_decimal(rd, "DepositAmount"), 2)
                        depItem.ClientDepositId = DatabaseHelper.Peel_int(rd, "ClientDepositId")
                        depItem.HasRule = (DatabaseHelper.Peel_int(rd, "RuleCount") > 0)
                        depItem.DepositMethodDisplay = DatabaseHelper.Peel_string(rd, "DepositMethodDisplay")
                        If DatabaseHelper.Peel_string(rd, "DepositMethod").ToLower = "ach" Then
                            depItem.BankAccountId = DatabaseHelper.Peel_int(rd, "BankAccountId")
                        ElseIf DatabaseHelper.Peel_string(rd, "DepositMethodDisplay").ToLower = "bank check" Then
                            depItem.BankAccountId = 1
                        Else
                            depItem.BankAccountId = 0
                        End If
                        _list.Items.Add(depItem)
                    End While
                End Using
            End Using
        End Using
        SaveCache()
    End Sub

    Private Sub SaveCache()
        Me.hdnDepositList.Value = String.Empty
        Dim sep As String = ""
        For Each itm As DepositDayItem In _list.Items
            If itm.Description <> "dummy" Then
                Me.hdnDepositList.Value = Me.hdnDepositList.Value & sep & itm.KeyValue & "|" & itm.Amount & "|" & itm.ClientDepositId & "|" & IIf(itm.HasRule, "1", "0") & "|" & itm.BankAccountId
                sep = ";"
            End If
        Next
    End Sub

    Private Sub LoadScheduledDepositsFromCache()
        _list.Items.Clear()
        'Add dummy row to be used as a template when adding rows
        _list.Items.Add(New DepositDayItem(1, "dummy", DepositFrequency.month))
        Dim Items As String() = Me.hdnDepositList.Value.Split(";")
        Dim itemFld As String()
        Dim itemWhen As String()
        For Each itm As String In Items
            itemFld = itm.Split("|")
            If itemFld.Length = 5 Then
                Dim depItem As New DepositDayItem()
                itemWhen = itemFld(0).Split("_")
                If itemWhen.Length = 4 Then
                    depItem.Frequency = itemWhen(1)
                    depItem.Day = itemWhen(2)
                    depItem.Occurrence = itemWhen(3)
                    depItem.Amount = itemFld(1)
                    depItem.ClientDepositId = IIf(itemFld(2).Trim.Length = 0, 0, itemFld(2).Trim)
                    depItem.HasRule = itemFld(3)
                    depItem.BankAccountId = itemFld(4)
                    _list.Items.Add(depItem)
                End If
            End If
        Next
    End Sub

    Private Sub RenderGrid()
        rpt.DataSource = _list.Items
        rpt.DataBind()
    End Sub

    Public Function RenderReadOnlyHTML() As String
        Dim sb As New StringBuilder
        sb.AppendLine("<span style='font-family: Tahoma; font-size: 11px; padding-top: 5px; display: block; height: 24px;'>Deposit Schedule:</span>")
        sb.AppendLine("<table style='font-family: Tahoma; font-size: 11px;' cellspacing='0' width='100%'>")
        sb.AppendLine("<thead style='background-color: #D8D8D8;'>")
        sb.AppendLine("<tr><th style='width:16px; height:20px;'><img src='../../../../images/16x16_icon.png'/></th>")
        sb.AppendLine("<th align='center' style='font-weight: normal;'> Day </th>")
        sb.AppendLine("<th align='right' style='font-weight: normal;padding-right: 10px;'> Amount </th>")
        sb.AppendLine("<th align='center' style='font-weight: normal;'> Method </th>")
        sb.AppendLine("<th align='left' style='font-weight: normal;' > Routing </th>")
        sb.AppendLine("<th align='left' style='font-weight: normal;'> Account </th>")
        sb.AppendLine("<th align='center' style='font-weight: normal;'> Type </th>")
        sb.AppendLine("</tr>")
        sb.AppendLine("</thead><tbody>{0}</tbody></table>")
        Dim htmlcode As String = sb.ToString
        Dim htmlbody As String = ""
        sb = New StringBuilder
        sb.AppendLine("<tr><td style='width:16px; height:25px;'><img src='../../../../images/16x16_accounts.png' alt='{0}'/></td>")
        sb.AppendLine("<td align='center'>{1}</td>")
        sb.AppendLine("<td align='right' style='padding-right: 10px;'>{2:c}</td>")
        sb.AppendLine("<td align='center'>{3}</td>")
        sb.AppendLine("<td>{4}</td>")
        sb.AppendLine("<td>{5}</td>")
        sb.AppendLine("<td align='center'>{6}</td></tr>")
        'sb.AppendLine("</tr><tr><td colspan='7' title='{7}'>{7}</td></tr>")
        sb.AppendLine("<tr><td colspan='7' style='border-bottom: dotted 1px gray; width:100%; height: 1px; font-size=1px;'>&nbsp;</td></tr>")
        Dim htmlrow As String = sb.ToString
        Dim i As Integer = 1
        Dim description As String
        Dim lmonth As New DepositDayList(DepositFrequency.month)
        Dim lweek As New DepositDayList(DepositFrequency.week)
        Dim bankInfo As String()
        Dim method As String
        Dim routing As String
        Dim accnumber As String
        Dim accType As String
        Dim bankname As String
        LoadBankAccountsFromDB()
        For Each itm As DepositDayItem In _list.Items
            If itm.Description <> "dummy" Then
                description = ""
                If itm.Frequency = DepositFrequency.month Then
                    description = lmonth.FindByKey(itm.KeyValue).Description
                Else
                    description = lweek.FindByKey(itm.KeyValue).Description
                End If
                method = itm.DepositMethodDisplay '"Check"
                routing = String.Empty
                accnumber = String.Empty
                accType = String.Empty
                bankname = ""
                If itm.BankAccountId > 1 Then
                    bankInfo = GetBankInfo(itm.BankAccountId).Split("|")
                    If Bankinfo.length > 2 Then
                        method = "ACH"
                        routing = bankInfo(2)
                        accnumber = bankInfo(1)
                        accType = bankInfo(3) 'IIf(bankInfo(3) = "S", "Savings", "Checking")
                        bankname = bankInfo(4).Replace("'", "").Replace("""", "")
                    End If
                End If
                htmlbody = htmlbody & String.Format(htmlrow, i, description, itm.Amount, method, routing, accnumber, accType, bankname)
                i += 1
            End If
        Next
        Return String.Format(htmlcode, htmlbody)
    End Function

    Private Function GetBankInfo(ByVal BankAccountid As Integer) As String
        For Each itm As ListItem In Me.ddlBankAccountInfo.Items
            If itm.Value.Split("|")(0) = BankAccountid Then
                Return itm.Value
            End If
        Next
        Return String.Empty
    End Function

    Public Function Save() As Boolean
        Dim success As Boolean = False
        'If Not ValidateDaySpace() Then Throw New Exception(String.Format("The interval between two days must be at least {0} days", _dayspace))
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        Try
            cmd.Connection.Open()
            'use a transaction mode.
            cmd.Transaction = cmd.Connection.BeginTransaction()
            Try
                Dim l As New List(Of String)
                l.Add("-1")
                For Each itm As DepositDayItem In _list.Items
                    If itm.Description <> "dummy" Then
                        If itm.ClientDepositId = 0 Then
                            itm.ClientDepositId = Me.InsertDepositDay(cmd, itm)
                        Else
                            Me.UpdateDepositDay(cmd, itm)
                        End If
                        l.Add(itm.ClientDepositId.ToString)
                    End If
                Next
                Me.DeleteDepositDay(cmd, String.Join(",", l.ToArray))
                cmd.Transaction.Commit()
                success = True
                RaiseEvent DaysSaved()
            Catch ex As Exception
                If Not cmd.Transaction Is Nothing Then cmd.Transaction.Rollback()
                Throw
            End Try
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
        Return success
    End Function

    Private Sub DeleteDepositDay(ByVal cmd As SqlCommand, ByVal ClientdepositIds As String)
        Dim sqlStr = String.Format("Update tblClientDepositDay Set DeletedDate = GetDate(), DeletedBy = {0} Where ClientId = {1} and ClientDepositId Not in ({2})", _UserId, Client, ClientdepositIds)
        cmd.Parameters.Clear()
        cmd.CommandText = sqlStr
        cmd.CommandType = CommandType.Text
        cmd.ExecuteNonQuery()
    End Sub

    Private Function InsertDepositDay(ByVal cmd As SqlCommand, ByVal itm As DepositDayItem) As Integer
        Dim param As SqlParameter
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "stp_InsertClientDepositDay"

        cmd.Parameters.Clear()
        param = New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = Me.Client
        cmd.Parameters.Add(param)

        param = New SqlParameter("@Frequency", SqlDbType.VarChar)
        param.Value = [Enum].GetName(GetType(DepositFrequency), itm.Frequency)
        cmd.Parameters.Add(param)

        param = New SqlParameter("@DepositDay", SqlDbType.Int)
        param.Value = itm.Day
        cmd.Parameters.Add(param)

        param = New SqlParameter("@Amount", SqlDbType.Money)
        param.Value = Math.Round(itm.Amount, 2)
        cmd.Parameters.Add(param)

        If itm.Occurrence <> 0 Then
            param = New SqlParameter("@Occurrence", SqlDbType.Int)
            param.Value = itm.Occurrence
            cmd.Parameters.Add(param)
        End If

        Dim display As String

        param = New SqlParameter("@DepositMethod", SqlDbType.VarChar)
        If itm.BankAccountId = 0 Then
            param.Value = "Check"
            display = "Check"
        ElseIf itm.BankAccountId = 1 Then
            param.Value = "Check"
            display = "Bank Check"
        Else
            param.Value = "ACH"
            display = "ACH"
        End If
        cmd.Parameters.Add(param)

        param = New SqlParameter("@DepositMethodDisplay", SqlDbType.VarChar)
        param.Value = display
        cmd.Parameters.Add(param)

        If itm.BankAccountId > 1 Then
            param = New SqlParameter("@BankAccountId", SqlDbType.Int)
            param.Value = itm.BankAccountId
            cmd.Parameters.Add(param)
        End If

        param = New SqlParameter("@UserID", SqlDbType.Int)
        param.Value = _UserId
        cmd.Parameters.Add(param)

        Return CInt(cmd.ExecuteScalar())
    End Function

    Private Sub UpdateDepositDay(ByVal cmd As SqlCommand, ByVal itm As DepositDayItem)
        Dim param As SqlParameter

        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "stp_UpdateClientDepositDay"

        cmd.Parameters.Clear()

        param = New SqlParameter("@ClientDepositId", SqlDbType.Int)
        param.Value = itm.ClientDepositId
        cmd.Parameters.Add(param)

        param = New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = Me.Client
        cmd.Parameters.Add(param)

        param = New SqlParameter("@Frequency", SqlDbType.VarChar)
        param.Value = [Enum].GetName(GetType(DepositFrequency), itm.Frequency)
        cmd.Parameters.Add(param)

        param = New SqlParameter("@DepositDay", SqlDbType.Int)
        param.Value = itm.Day
        cmd.Parameters.Add(param)

        param = New SqlParameter("@Amount", SqlDbType.Money)
        param.Value = Math.Round(itm.Amount, 2)
        cmd.Parameters.Add(param)

        If itm.Occurrence <> 0 Then
            param = New SqlParameter("@Occurrence", SqlDbType.Int)
            param.Value = itm.Occurrence
            cmd.Parameters.Add(param)
        End If

        Dim display As String

        param = New SqlParameter("@DepositMethod", SqlDbType.VarChar)
        If itm.BankAccountId = 0 Then
            param.Value = "Check"
            display = "Check"
        ElseIf itm.BankAccountId = 1 Then
            param.Value = "Check"
            display = "Bank Check"
        Else
            param.Value = "ACH"
            display = "ACH"
        End If
        cmd.Parameters.Add(param)

        param = New SqlParameter("@DepositMethodDisplay", SqlDbType.VarChar)
        param.Value = display
        cmd.Parameters.Add(param)

        If itm.BankAccountId > 1 Then
            param = New SqlParameter("@BankAccountId", SqlDbType.Int)
            param.Value = itm.BankAccountId
            cmd.Parameters.Add(param)
        End If

        param = New SqlParameter("@UserID", SqlDbType.Int)
        param.Value = _UserId
        cmd.Parameters.Add(param)

        cmd.ExecuteNonQuery()
    End Sub

    Protected Sub rpt_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rpt.ItemDataBound
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            'Load Freq 
            Dim ddl As DropDownList = e.Item.FindControl("ddlFreq")
            ddl.Enabled = AllowWeeklyDeposits
            ddl.SelectedIndex = ddl.Items.IndexOf(ddl.Items.FindByValue(CType(e.Item.DataItem, DepositDayItem).Frequency))
            'Load When
            ddl = e.Item.FindControl("ddlWhen")
            ddl.DataSource = New DepositDayList(CType(e.Item.DataItem, DepositDayItem).Frequency).Items
            ddl.DataTextField = "Description"
            ddl.DataValueField = "KeyValue"
            ddl.DataBind()
            ddl.SelectedIndex = ddl.Items.IndexOf(ddl.Items.FindByValue(CType(e.Item.DataItem, DepositDayItem).KeyValue))
            'Bank Account 
            ddl = e.Item.FindControl("ddlAccBankId")
            ddl.DataSource = _banks
            ddl.DataTextField = "Description"
            ddl.DataValueField = "BankAccountId"
            ddl.DataBind()
            ddl.SelectedIndex = ddl.Items.IndexOf(ddl.Items.FindByValue(CType(e.Item.DataItem, DepositDayItem).BankAccountId))
            If e.Item.ItemIndex = 0 Then
                Dim tr As HtmlTableRow = e.Item.FindControl("depositRow")
                tr.Style.Add("display", "none")
            End If
        End If
    End Sub

    Private Function ValidateDaySpace() As Boolean
        If _list.Items.Count > 2 Then

            Dim days As New List(Of Integer)

            For Each itm As DepositDayItem In _list.Items
                If itm.Description <> "dummy" Then
                    days.Add(itm.Day)
                End If
            Next
            Dim arr As Integer() = days.ToArray
            Array.Sort(arr)
            Dim lastday As Date = New Date(2009, 7, arr(arr.GetUpperBound(0)))
            Dim thisday As Date
            For Each d As Integer In arr
                thisday = New Date(2009, 8, d)
                If thisday.Subtract(lastday).Days < _dayspace Then
                    Return False
                Else
                    lastday = thisday
                End If
            Next
        End If
        Return True
    End Function

    Protected Sub lnkSaveDeposits_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveDeposits.Click
        Save()
    End Sub

#End Region

#Region "Bank Account"

    Private Sub LoadBankAccountsFromDB()
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.Text
        cmd.CommandText = String.Format("Select c.*,  isnull(b.customername,'') as [bankName], inuse = ((select count(clientdepositid) from tblclientdepositday where bankaccountid = c.bankaccountid and deleteddate is null) + (select count(ruleachid) from tbldepositruleach where bankaccountid = c.bankaccountid and (enddate is null or enddate > getdate())))  from tblClientBankAccount c left join tblroutingnumber b on b.routingnumber = c.routingnumber where c.clientid = {0} and c.disabled is null order by c.bankaccountid desc", Me.Client)
        Dim ds As DataSet = DatabaseHelper.ExecuteDataset(cmd)
        Dim dt As DataTable = ds.Tables(0)
        dt.Columns.Add(New DataColumn("Key", GetType(String)))
        dt.Columns.Add(New DataColumn("ShortDescription", GetType(String)))
        dt.Columns.Add(New DataColumn("Description", GetType(String)))
        Dim desc As String
        Dim acc As String
        Dim rout As String
        Dim acctype As String
        For Each dr As DataRow In dt.Rows
            rout = dr("RoutingNumber").ToString.Trim
            acc = dr("AccountNumber").ToString.Trim
            acctype = IIf(Not dr("BankType") Is DBNull.Value AndAlso dr("BankType").ToString.Trim.ToUpper = "S", "S", "C")
            desc = String.Format("{0}::{1}::{2}", acctype, rout, acc)
            dr("ShortDescription") = desc
            dr("Description") = "ACH: " & desc
            dr("Key") = String.Format("{0}|{1}|{2}|{3}|{4}|{5}", dr("BankAccountId"), acc, dr("RoutingNumber").ToString.Trim, acctype, dr("BankName").ToString, dr("inuse"))
        Next
        'Prepare Account Info
        Me.ddlBankAccountInfo.DataSource = dt
        Me.ddlBankAccountInfo.DataTextField = "ShortDescription"
        Me.ddlBankAccountInfo.DataValueField = "Key"
        Me.ddlBankAccountInfo.DataBind()
        _banks = dt
        AddCheckRowToBankList()
    End Sub

    Private Function GetMaskedNumber(ByVal Number As String) As String
        Dim desc As String
        If Number.Length >= 4 Then
            desc = String.Format("**{0}", Number.Substring(Number.Length - 4, 4))
        Else
            desc = String.Format("**{0}", Number)
        End If
        Return desc
    End Function

    Public Sub AddCheckRowToBankList()
        'Add Bank Check row (new)
        Dim bankcheckRow As DataRow = _banks.NewRow
        bankcheckRow("BankAccountId") = 1
        bankcheckRow("Description") = "Bank Check"
        _banks.Rows.Add(bankcheckRow)
        'Add Check row
        Dim checkRow As DataRow = _banks.NewRow
        checkRow("BankAccountId") = 0
        checkRow("Description") = "Check"
        _banks.Rows.Add(checkRow)
    End Sub

    Private Sub ShowBankAccountPanel(ByVal Show As Boolean)
        Dim lbl As String = " Banking Information"
        If Show Then
            Me.lnkShowBankAcc.Text = "Hide" & lbl
            Me.tableBanking.Style("display") = "block"
        Else
            Me.lnkShowBankAcc.Text = "Show" & lbl
            Me.tableBanking.Style("display") = "none"
        End If
    End Sub

    Private Sub ShowEditMode(ByVal Show As Boolean)
        If Show Then
            Me.trEditBankAcc.Style("display") = "block"
            Me.trDisplayBankAcc.Style("display") = "none"
        Else
            Me.trEditBankAcc.Style("display") = "none"
            Me.trDisplayBankAcc.Style("display") = "block"
        End If
    End Sub

    Private Sub ShowBankInfoCtrls(ByVal Index As Integer)
        Dim itmCount As Integer = Me.ddlBankAccountInfo.Items.Count
        Dim acctype As String = ""

        If itmCount > 0 Then
            'select first
            Me.ddlBankAccountInfo.SelectedIndex = Index
            Dim bankinfo As String() = Me.ddlBankAccountInfo.SelectedValue.Split("|")
            Me.hdnBankAccountId.Value = bankinfo(0)

            Me.lblAccNumber.Text = bankinfo(1)
            Me.txtAccNumber.Text = bankinfo(1)

            Me.lblAccRouting.Text = bankinfo(2)
            Me.txtAccRouting.Text = bankinfo(2)

            acctype = bankinfo(3)

            If acctype.Trim.Length = 0 Then
                Me.lblAccType.Text = ""
            Else
                Me.lblAccType.Text = "(" & IIf(acctype = "S", "Savings", "Checking") & ")"
            End If
            Me.rdChecking.Checked = (acctype = "C")
            Me.rdSaving.Checked = (acctype = "S")

            If Len(bankinfo(4)) > 23 Then
                Me.lblAccBankName.Text = Left(bankinfo(4), 23) & ".."
                Me.lblAccBankName.ToolTip = bankinfo(4)
            Else
                Me.lblAccBankName.Text = bankinfo(4)
            End If

            'Me.lnkAccDelete.Enabled = IIf(bankinfo(5) = 0, True, False)
            'If bankinfo(5) <> 0 Then
            'Me.lnkAccDelete.Attributes("disabled") = "disabled"
            'Else
            'Me.lnkAccDelete.Attributes.Remove("disabled")
            'End If
        Else
            Me.lblAccRouting.Text = ""
            Me.txtAccRouting.Text = ""
            Me.lblAccNumber.Text = ""
            Me.txtAccNumber.Text = ""
            Me.lblAccType.Text = ""
            Me.rdChecking.Checked = False
            Me.rdSaving.Checked = False
            Me.lblAccBankName.Text = ""
            Me.hdnBankAccountId.Value = 0
        End If

        Me.ddlBankAccountInfo.Style("Display") = IIf(itmCount <> 0, "inline", "none")
        Me.lnkAccEdit.Style("Display") = IIf(itmCount <> 0, "inline", "none")
        'Me.lnkAccEdit.Visible = False
        Me.lnkAccDelete.Style("Display") = IIf(itmCount <> 0, "inline", "none")
        Me.trDisplayBankAcc.Style("Display") = "block"
        Me.trEditBankAcc.Style("Display") = "none"

        Me.ddlBankAccountInfo.Attributes.Add("onchange", "return selectBankAcc();")

    End Sub

    Private Function InsertBankAccount() As Integer
        Dim AccountId As Integer = 0
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        Try
            cmd.Connection.Open()
            Dim param As SqlParameter
            cmd.CommandType = CommandType.StoredProcedure
            cmd.CommandText = "stp_InsertClientBankAccount"

            param = New SqlParameter("@ClientId", SqlDbType.Int)
            param.Value = Me.Client
            cmd.Parameters.Add(param)

            param = New SqlParameter("@Routing", SqlDbType.VarChar)
            param.Value = Me.txtAccRouting.Text.Trim
            cmd.Parameters.Add(param)

            param = New SqlParameter("@Account", SqlDbType.VarChar)
            param.Value = Me.txtAccNumber.Text.Trim
            cmd.Parameters.Add(param)

            param = New SqlParameter("@BankType", SqlDbType.VarChar)
            If Me.rdSaving.Checked Then
                param.Value = "S"
            Else
                param.Value = "C"
            End If
            cmd.Parameters.Add(param)

            param = New SqlParameter("@UserID", SqlDbType.Int)
            param.Value = _UserId
            cmd.Parameters.Add(param)

            AccountId = CInt(DatabaseHelper.ExecuteScalar(cmd))
        Catch ex As Exception
            Throw
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return AccountId
    End Function

    Private Sub UpdateBankAccount()
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        Try
            cmd.Connection.Open()
            Dim param As SqlParameter
            cmd.CommandType = CommandType.StoredProcedure
            cmd.CommandText = "stp_UpdateClientBankAccount"

            param = New SqlParameter("@BankAccountId", SqlDbType.Int)
            param.Value = Me.hdnBankAccountId.Value
            cmd.Parameters.Add(param)

            param = New SqlParameter("@ClientId", SqlDbType.Int)
            param.Value = Me.Client
            cmd.Parameters.Add(param)

            param = New SqlParameter("@Routing", SqlDbType.VarChar)
            param.Value = Me.txtAccRouting.Text.Trim
            cmd.Parameters.Add(param)

            param = New SqlParameter("@Account", SqlDbType.VarChar)
            param.Value = Me.txtAccNumber.Text.Trim
            cmd.Parameters.Add(param)

            param = New SqlParameter("@BankType", SqlDbType.VarChar)
            If Me.rdSaving.Checked Then
                param.Value = "S"
            Else
                param.Value = "C"
            End If
            cmd.Parameters.Add(param)

            param = New SqlParameter("@UserID", SqlDbType.Int)
            param.Value = _UserId
            cmd.Parameters.Add(param)

            DatabaseHelper.ExecuteNonQuery(cmd)
        Catch ex As Exception
            Throw
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub

    'Update any scheduled ACH that uses this bank account with the new account information
    Private Sub CascadeBankAccountChanges(ByVal BankAccountId As Integer)
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        Try
            cmd.Connection.Open()
            Dim param As SqlParameter
            cmd.CommandType = CommandType.StoredProcedure
            cmd.CommandText = "stp_ReplicateBankAccountUpdate"

            param = New SqlParameter("@BankAccountId", SqlDbType.Int)
            param.Value = BankAccountId
            cmd.Parameters.Add(param)

            param = New SqlParameter("@UserID", SqlDbType.Int)
            param.Value = _UserId
            cmd.Parameters.Add(param)

            DatabaseHelper.ExecuteNonQuery(cmd)
        Catch ex As Exception
            Throw
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub


    Private Sub SelectBankAccount(ByVal bankaccountid As Integer)
        ShowBankAccountPanel(True)
        For Each itm As ListItem In Me.ddlBankAccountInfo.Items
            If itm.Value.Split("|")(0) = bankaccountid Then
                Me.ShowBankInfoCtrls(Me.ddlBankAccountInfo.Items.IndexOf(itm))
                Return
            End If
        Next
    End Sub

    Private Function ValidateBankAccount() As Boolean
        Dim regExpr As New Regex("^\d{9}$")
        If Not regExpr.IsMatch(Me.txtAccRouting.Text.Trim) Then
            Throw New Exception("Invalid Routing Number. It must be a 9-digit number")
        End If
        regExpr = New Regex("^\d+$")
        If Not regExpr.IsMatch(Me.txtAccNumber.Text.Trim) Then
            Throw New Exception("Invalid Account Number. It must contains digits only")
        End If
        If Not rdChecking.Checked AndAlso Not rdSaving.Checked Then
            Throw New Exception("Account Type is not provided")
        End If
        If IsDuplicateAccount() Then
            Throw New Exception("There is already a bank account matching that information for this client")
        End If
        'Validate Routing
        'Dim csi As New WCFClient.Store
        Dim routing As String = Me.txtAccRouting.Text.Trim
        Dim bankname As String = ""
        'If Not csi.RoutingIsValid(routing, bankname) Then
        'Check our database for a match
        If Not CheckOurTable(routing, bankname) Then
            Throw New Exception("The Bank Routing Number you entered does not validate against the Federal ACH Directory.")
        End If
        'End If
        Return True
    End Function

    Private Function IsDuplicateAccount() As Boolean
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandText = String.Format("select count(bankaccountid) from tblClientBankAccount Where bankaccountid <> {0} and clientid = {1} and routingnumber = '{2}' and accountnumber = '{3}' and Disabled is Null ", Me.hdnBankAccountId.Value, Me.Client, Me.txtAccRouting.Text.Trim, Me.txtAccNumber.Text.Trim)
        cmd.CommandType = CommandType.Text
        Return (Drg.Util.DataAccess.DatabaseHelper.ExecuteScalar(cmd) <> 0)
    End Function

    Private Sub SaveBankAccount()
        Try
            ValidateBankAccount()
            Dim bankAccountid As Integer = Me.hdnBankAccountId.Value
            If bankAccountid = 0 Then
                bankAccountid = Me.InsertBankAccount()
            Else
                Me.UpdateBankAccount()
                Me.CascadeBankAccountChanges(bankAccountid)
            End If
            'Reload Lists
            LoadBankAccountsFromDB()
            'Select Modified Account
            SelectBankAccount(bankAccountid)
            'Reload Bank accounts
            ScriptManager.RegisterClientScriptBlock(Me.Page, GetType(Page), "updateaccount", String.Format("reloadBanks({0},'{1}');", bankAccountid, "ACH: " & Me.ddlBankAccountInfo.SelectedItem.Text), True)
        Catch ex As Exception
            'Redisplay edit Mode
            ShowBankAccountPanel(True)
            ShowEditMode(True)
            'Throw
            ScriptManager.RegisterClientScriptBlock(Me.Page, GetType(Page), "erroraccount", String.Format("alert('{0}');", ex.Message.Replace("'", "").Replace("""", "")), True)
        End Try
    End Sub

    Private Function CanDeleteBankAccount(ByVal bankAccountId As Integer) As Boolean
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandText = String.Format("select ((select count(clientdepositid) from tblclientdepositday where bankaccountid = {0}) + (select count(ruleachid) from tbldepositruleach where bankaccountid = {0}) + (select count(adhocachid) from tbladhocach where bankaccountid = {0}))", bankAccountId)
        cmd.CommandType = CommandType.Text
        If Drg.Util.DataAccess.DatabaseHelper.ExecuteScalar(cmd) <> 0 Then Return False 'Throw New Exception("Cannot delete bank account because is in use by a deposit, rule or scheduled additional ACH.")
        Return True
    End Function

    Private Function CanDisableBankAccount(ByVal bankAccountId As Integer) As Boolean
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandText = String.Format("select ((select count(clientdepositid) from tblclientdepositday where bankaccountid = {0} and deleteddate is null) + (select count(ruleachid) from tbldepositruleach where bankaccountid = {0} and (enddate is null or (startdate > getdate() and enddate > getdate()) or (startdate < getdate() and month(enddate) = month(getdate()) and year(enddate) = year(getdate()) and depositday > day(getdate())))) + (select count(adhocachid) from tbladhocach where bankaccountid = {0} and registerid is null))", bankAccountId)
        cmd.CommandType = CommandType.Text
        If Drg.Util.DataAccess.DatabaseHelper.ExecuteScalar(cmd) <> 0 Then Throw New Exception("Cannot delete bank account because is in use by a deposit or active or future rule or scheduled additional ACH. You have to assign a different bank account to them first and then retry deleting the bank account.")
        Return True
    End Function

    Private Sub DeleteBankAccount(ByVal bankAccountId As Integer, ByVal ClientId As Integer)
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandText = String.Format("Delete from tblClientBankAccount Where BankAccountId = {0} And ClientId = {1}", bankAccountId, ClientId)
        cmd.CommandType = CommandType.Text
        Drg.Util.DataAccess.DatabaseHelper.ExecuteNonQuery(cmd)
        AuditDeleteAccount(bankAccountId)
    End Sub

    Private Sub DisableBankAccount(ByVal bankAccountId As Integer, ByVal ClientId As Integer, ByVal UserId As Integer)
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandText = String.Format("Update tblClientBankAccount Set Disabled = GetDate(), DisabledBy = {2} Where BankAccountId = {0} And ClientId = {1}", bankAccountId, ClientId, UserId)
        cmd.CommandType = CommandType.Text
        Drg.Util.DataAccess.DatabaseHelper.ExecuteNonQuery(cmd)
    End Sub

    Private Sub AuditDeleteAccount(ByVal BankAccounID As Integer)
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        Try
            cmd.Connection.Open()
            Dim param As SqlParameter
            cmd.CommandType = CommandType.StoredProcedure
            cmd.CommandText = "stp_AuditBankAccountDelete"

            param = New SqlParameter("@BankAccountId", SqlDbType.Int)
            param.Value = BankAccounID
            cmd.Parameters.Add(param)

            param = New SqlParameter("@UserId", SqlDbType.Int)
            param.Value = _UserId
            cmd.Parameters.Add(param)

            DatabaseHelper.ExecuteNonQuery(cmd)
        Catch ex As Exception
            Throw
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Private Sub DeleteBankAccount()
        Dim bankAccountId As Integer = Me.hdnBankAccountId.Value
        Try
            If CanDeleteBankAccount(bankAccountId) Then
                DeleteBankAccount(bankAccountId, Me.Client)
            Else
                If CanDisableBankAccount(bankAccountId) Then
                    DisableBankAccount(bankAccountId, Me.Client, _UserId)
                End If
            End If
            'Reload Lists
            LoadBankAccountsFromDB()
            Me.ShowBankAccountPanel(True)
            ShowBankInfoCtrls(0)
            ScriptManager.RegisterClientScriptBlock(Me.Page, GetType(Page), "removeaccount", String.Format("removeBank({0});", bankAccountId), True)
        Catch ex As Exception
            'Redisplay edit Mode
            ShowBankAccountPanel(True)
            ShowEditMode(False)
            'Throw
            ScriptManager.RegisterClientScriptBlock(Me.Page, GetType(Page), "erroraccount", String.Format("alert('{0}');", ex.Message.Replace("'", "").Replace("""", "")), True)
        End Try
    End Sub

    Protected Sub lnkAccSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAccSave.Click
        SaveBankAccount()
        RaiseEvent BankChanged()
    End Sub

    Protected Sub lnkAccDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAccDelete.Click
        DeleteBankAccount()
        RaiseEvent BankChanged()
    End Sub

    Private Function CheckOurTable(ByVal RoutingNumber As String, Optional ByRef BankName As String = "") As Boolean
        Dim IsGood As String = ""
        IsGood = DataHelper.FieldLookup("tblRoutingNumber", "RoutingNumber", "RoutingNumber = " & RoutingNumber)
        If IsGood <> "" Then
            BankName = DataHelper.FieldLookup("tblRoutingNumber", "CustomerName", "RoutingNumber = " & RoutingNumber)
            Return True
        Else
            Return False
        End If

    End Function

#End Region

End Class
