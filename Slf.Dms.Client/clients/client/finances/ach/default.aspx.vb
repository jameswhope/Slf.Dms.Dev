Option Explicit On
'
Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports Slf.Dms.Controls
Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic
Imports System.Data.SqlClient

Partial Class clients_client_finances_ach_default
    Inherits PermissionPage

#Region "Variables"
    Public ReadOnly Property DataClientID() As Integer
        Get
            Return Master.DataClientID
        End Get
    End Property
    Public Shadows ReadOnly Property ClientID() As Integer
        Get
            Return DataClientID
        End Get
    End Property

    Private Const PageSize As Integer = 5

    Private ResultsChecksToPrint As Integer
    Private ResultsACHRules As Integer
    Private ResultsCheckRules As Integer
    Private ResultsAdHocACH As Integer

    Private OnlyNotPrinted As Integer
    Private OnlyCurrent As Integer
    Private OnlyCurrentCheck As Integer
    Private OnlyNotDeposited As Integer

    Private UserID As Integer
   Private ClientStatus As String
    Private qs As QueryStringCollection

    Private pagerCTP As SmallPagerWrapper
    Private pagerACHRules As SmallPagerWrapper
    Private pagerCheckRules As SmallPagerWrapper
    Private pagerAdHocACH As SmallPagerWrapper
    Private OpenTabIndex As Integer
    Private blnMultiDepositClient As Boolean = False

    Public Pct As Integer
    Public OldPct As Integer
    Private fnConvertToMulti As String = "Clients-Client Single Record-Finances-ACH-Convert To Multi"

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim RetainerPct As String
        Dim fixedfeepct As String 'cholt 2/11/2020
        Dim feeCollectionType As String 'cholt 2/11/2020

        blnMultiDepositClient = CBool(DataHelper.FieldLookup("tblClient", "MultiDeposit", "ClientID = " & ClientID))


        pagerCTP = New SmallPagerWrapper(lnkFirstCheckToPrint, lnkPrevCheckToPrint, lnkNextCheckToPrint, lnkLastCheckToPrint, labLocationChecksToPrint, Context, "pctp")
        pagerACHRules = New SmallPagerWrapper(lnkFirstACHRule, lnkPrevACHRule, lnkNextACHRule, lnkLastACHRule, labLocationACHRule, Context, "pach")
        pagerCheckRules = New SmallPagerWrapper(lnkFirstCheckRule, lnkPrevCheckRule, lnkNextCheckRule, lnkLastCheckRule, labLocationCheckRule, Context, "pcheck")
        pagerAdHocACH = New SmallPagerWrapper(lnkFirstAdHocACH, lnkPrevAdHocACH, lnkNextAdHocACH, lnkLastAdHocACH, labLocationAdHocACH, Context, "pahach")

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()


        RetainerPct = DataHelper.FieldLookup("tblClient", "SetupFeePercentage", "ClientID = " & ClientID)
        fixedfeepct = SqlHelper.ExecuteScalar("select lc.FixedFeePercentage from tblclient c inner join vw_LeadApplicant_Client v on v.clientid = c.ClientID inner join tblLeadApplicant la on la.LeadApplicantID = v.leadapplicantid inner join tblLeadCalculator lc on lc.LeadApplicantID = la.LeadApplicantID where c.ClientID = " & ClientID, CommandType.Text) 'cholt 2/11/2020
        feeCollectionType = DataHelper.FieldLookup("tblClient", "Processing", "ClientID = " & ClientID)

        If RetainerPct <> "" Then
            setupFeePercentageReadOnly.InnerHtml = CStr(CDbl((RetainerPct) * 100))
            Pct = RetainerPct * 100
            OldPct = CInt((RetainerPct) * 100)
            Me.txtOldPct.Text = CStr(OldPct)
        End If

        If fixedfeepct <> "" Then
            fixedFeePercentageReadOnly.InnerHtml = CStr(CDbl((fixedfeepct) * 100))
        End If

        If feeCollectionType <> "" Then
            If feeCollectionType = "4" Then
                fixedFeeCollectionType.InnerHtml = "Deposit"
            ElseIf feeCollectionType = "5" Then
                fixedFeeCollectionType.InnerHtml = "Monthly"
            End If
        End If
        If Not qs Is Nothing Then

            'ChecksToPrintPageIndex = DataHelper.Nz_int(qs("cp"))
            OnlyNotPrinted = DataHelper.Nz_int(qs("o"), 1)
            OnlyCurrent = DataHelper.Nz_int(qs("c"), 1)
            OnlyCurrentCheck = DataHelper.Nz_int(qs("ch"), 1)
            OnlyNotDeposited = DataHelper.Nz_int(qs("nd"), 1)

            OpenTabIndex = DataHelper.Nz_int(qs("tab"), 0)

            LoadTabStrips()

            If Not IsPostBack Then

                RetainerPct = DataHelper.FieldLookup("tblClient", "SetupFeePercentage", "ClientID = " & ClientID)
                If RetainerPct <> "" Then
                    setupFeePercentageReadOnly.InnerHtml = CStr(CDbl((RetainerPct) * 100))
                    Pct = RetainerPct * 100
                    OldPct = CInt((RetainerPct) * 100)
                    Me.txtOldPct.Text = CStr(OldPct)
                End If

                LoadACHInfo()
                LoadFeeInfo()

                Requery()

                lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
                lnkClient.HRef = "~/clients/client/?id=" & ClientID

                chkOnlyNotPrinted.Checked = OnlyNotPrinted > 0
                chkOnlyCurrent.Checked = OnlyCurrent = 1
                chkOnlyCurrentCheck.Checked = OnlyCurrentCheck = 1
                chkOnlyNotDeposited.Checked = OnlyNotDeposited = 1

                If chkOnlyCurrent.Checked Then
                    pnlNoACHRules.InnerHtml = "This client has no active ACH Rules."
                Else
                    pnlNoACHRules.InnerHtml = "This client has no ACH Rules."
                End If
                If chkOnlyCurrentCheck.Checked Then
                    pnlNoCheckRules.InnerHtml = "This client has no active Check Rules"
                Else
                    pnlNoCheckRules.InnerHtml = "This client has no Check Rules."
                End If
                If chkOnlyNotDeposited.Checked Then
                    pnlNoAdHocACH.InnerHtml = "This client has no undeposited Additional ACHs."
                Else
                    pnlNoAdHocACH.InnerHtml = "This client has no Additional ACHs."
                End If
            End If
            'JHope only active clients can be converted to Multi Pay
            Select Case DataHelper.FieldLookup("tblClient", "CurrentClientStatusID", "ClientID = " & ClientID)
                Case 15, 17, 18
                    ClientStatus = "Inactive"
                Case Else
                    ClientStatus = "Active"
            End Select

            SetRollups()

        End If


    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As Dictionary(Of String, Control))
        'AddControl(Me.lnkConvertToMulti, c, fnConvertToMulti, PermissionHelper.PermissionType.View, True)
    End Sub

    Private Sub SetRollups()

        Dim userrole As Integer = UserHelper.GetUserRole(UserID)

        'Select Case userrole
        'Case 11
        'feeEditButton.Visible = True
        'Case Else
        'feeEditButton.Visible = False
        'End Select

        Dim CommonTasks As List(Of String) = Master.CommonTasks
        If Master.UserEdit() Then
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_AddAdHocACH();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_tools.png") & """ align=""absmiddle""/>Add Additional ACH</a>")
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_AddACHRule();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_tools.png") & """ align=""absmiddle""/>Add ACH Rule</a>")
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_AddCheckRule();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cheque.png") & """ align=""absmiddle""/>Add Check Rule</a>")
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_AddCheckToPrint();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cheque.png") & """ align=""absmiddle""/>Add check to print</a>")
            'Dim FunctionId As Integer = DataHelper.Nz_string(DataHelper.FieldLookup("tblFunction", "FunctionID", String.Format("FullName='{0}'", fnConvertToMulti)))
            'Dim p As PermissionHelper.Permission = PermissionHelper.GetPermission(Context, Me.GetType.Name, FunctionId, UserID)
            If Not CBool(Val(DataHelper.FieldLookup("tblClient", "MultiDeposit", "ClientID = " & ClientID))) And ClientStatus = "Active" Then 'And (Not p Is Nothing AndAlso p.CanDo(PermissionHelper.PermissionType.View)) Then
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""ConvertToMulti();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_entrytype.png") & """ align=""absmiddle""/>Convert Multi-deposit</a>")
            End If

            If CanSwitchToNewFeeStruct() AndAlso (userrole = 11 OrElse DataHelper.FieldLookup("tblUser", "Manager", "UserId = " & UserID).ToString <> "0") Then
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""ConvertToServiceFeeCap();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_entrytype.png") & """ align=""absmiddle""/>Switch Fee Structure</a>")
            End If

            If DataHelper.FieldLookup("tblClient", "BofAConversionDate", "ClientID = " & ClientID) = "" And ClientStatus = "Active" Then
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""ConvertToBofA();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_trust.png") & """ align=""absmiddle""/>Move Account to BofA</a>")
            End If

        End If

    End Sub

    Private Function CanSwitchToNewFeeStruct() As Boolean
        'only sd client with old fee structure
        Return DataHelper.RecordExists("tblClient", String.Format("ClientId = {0} and SubsequentMaintFee is not null and SubsequentMaintFee > 0 and MaintenanceFeeCap is null and serviceimportid is not null", ClientID))
    End Function

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

        tsMain.TabPages(OpenTabIndex).Selected = True

        'set the proper pane on, others off
        Dim Panes As New List(Of HtmlGenericControl)

        Panes.Add(dvPanel0)
        Panes.Add(dvPanel1)
        Panes.Add(dvPanel3)
        Panes.Add(dvPanel2)

        For Each Pane As HtmlGenericControl In Panes
            If Panes.IndexOf(Pane) = tsMain.SelectedIndex Then
                Pane.Style("display") = "inline"
            Else
                Pane.Style("display") = "none"
            End If
        Next

    End Sub
    Private Sub LoadTabStrips()

        tsMain.TabPages.Clear()

        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("Additional&nbsp;ACHs", dvPanel0.ClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("ACH&nbsp;Rules", dvPanel1.ClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("Check&nbsp;Rules", dvPanel3.ClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("Checks&nbsp;To&nbsp;Print", dvPanel2.ClientID))

    End Sub
    Private Sub Requery()

        Dim Results As Integer

        ResultsChecksToPrint += RequeryChecksToPrint()
        ResultsACHRules += RequeryACHRules()
        ResultsCheckRules += RequeryCheckRules()
        ResultsAdHocACH += RequeryAdHocACH()

        Results = ResultsChecksToPrint + ResultsACHRules + ResultsCheckRules + ResultsAdHocACH

    End Sub

    Protected Structure AdHocACH
        Dim AdHocAchID As Integer
        Dim Status As String
        Dim DepositDate As DateTime
        Dim DepositAmount As Single
        Dim BankName As String
        Dim BankRoutingNumber As String
        Dim BankAccountNumber As String
        Dim RegisterID As Nullable(Of Integer)
    End Structure
    Protected Structure ACHRule
        Dim RuleACHId As Integer
        Dim Status As String
        Dim StartDate As DateTime
        Dim EndDate As Nullable(Of DateTime)
        Dim DepositDay As Integer
        Dim DepositAmount As Single
        Dim OriginalDepositDay As Integer
        Dim BankName As String
        Dim BankRoutingNumber As String
        Dim BankAccountNumber As String
        Dim Locked As Boolean
    End Structure
    Protected Structure CheckRule
        Dim RuleCheckId As Integer
        Dim Status As String
        Dim StartDate As DateTime
        Dim EndDate As Nullable(Of DateTime)
        Dim DepositDay As Integer
        Dim DepositAmount As Single
        Dim OriginalDepositDay As Integer
        Dim Locked As Boolean
        Dim DateUsed As Nullable(Of DateTime)
    End Structure
    Protected Function GetDateString(ByVal d As Nullable(Of DateTime)) As String
        Return GetDateString(d, "MMM d, yyyy")
    End Function

    Protected Function GetDateString(ByVal d As Nullable(Of DateTime), ByVal format As String) As String
        If d.HasValue Then
            Return d.Value.ToString(format)
        Else
            Return ""
        End If
    End Function

    Public ReadOnly Property IsMultiDeposit() As Boolean
        Get
            Return blnMultiDepositClient
        End Get
    End Property

    Private Function RequeryAdHocACH() As Integer

        Dim results As New List(Of AdHocACH)

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                cmd.CommandText = "SELECT * FROM tblAdHocACH WHERE ClientID = @ClientID " _
                    & IIf(OnlyNotDeposited = 1, "AND RegisterID is null", "") & " ORDER BY tblAdHocACH.DepositDate Desc, tblAdHocACH.Created Desc"

                DatabaseHelper.AddParameter(cmd, "ClientId", DataClientID)

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()

                        Dim ah As New AdHocACH

                        ah.AdHocAchID = DatabaseHelper.Peel_int(rd, "AdHocAchID")
                        ah.BankAccountNumber = DatabaseHelper.Peel_string(rd, "BankAccountNumber")
                        ah.BankRoutingNumber = DatabaseHelper.Peel_string(rd, "BankRoutingNumber")
                        ah.BankName = DatabaseHelper.Peel_string(rd, "BankName")
                        ah.DepositAmount = DatabaseHelper.Peel_float(rd, "DepositAmount")
                        ah.DepositDate = DatabaseHelper.Peel_date(rd, "DepositDate")
                        ah.RegisterID = DatabaseHelper.Peel_nint(rd, "RegisterID")


                        If ah.RegisterID.HasValue Then
                            ah.Status = "DEPOSITED"
                        Else
                            ah.Status = "NOT DEPOSITED"
                        End If

                        results.Add(ah)

                    End While
                End Using
            End Using
        End Using

        PagerHelper.Handle(results, rpAdHocACH, pagerAdHocACH, PageSize)

        rpAdHocACH.Visible = results.Count > 0
        pnlAdHocACH.Visible = results.Count > 0
        pnlNoAdHocACH.Visible = results.Count = 0

        If results.Count > 0 Then
            tsMain.TabPages(0).Caption = "<font style=""font-weight:normal;"">Additional&nbsp;ACHs</font>&nbsp;&nbsp;<font style=""color:blue;"">(" & results.Count & ")</font>"
        Else
            tsMain.TabPages(0).Caption = "Additional&nbsp;ACHs"
        End If

        Return results.Count

    End Function
    Private Function RequeryACHRules() As Integer

        Dim ACHRules As New List(Of ACHRule)

        If Not blnMultiDepositClient Then

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                    cmd.CommandText = "SELECT * FROM tblRuleACH WHERE ClientID = @ClientID " _
                        & IIf(OnlyCurrent = 1, "AND StartDate <= '" & Now.Date & "' AND (EndDate is null OR EndDate >= '" & Now.Date & "')", "") & " ORDER BY  tblRuleACH.StartDate Desc, tblRuleACH.Created Desc"

                DatabaseHelper.AddParameter(cmd, "ClientId", DataClientID)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim newACHRule As New ACHRule
                        newACHRule.RuleACHId = DatabaseHelper.Peel_int(rd, "RuleACHId")
                        newACHRule.BankAccountNumber = DatabaseHelper.Peel_string(rd, "BankAccountNumber")
                        newACHRule.BankRoutingNumber = DatabaseHelper.Peel_string(rd, "BankRoutingNumber")
                        newACHRule.BankName = DatabaseHelper.Peel_string(rd, "BankName")
                        newACHRule.DepositAmount = DatabaseHelper.Peel_float(rd, "DepositAmount")
                        newACHRule.DepositDay = DatabaseHelper.Peel_int(rd, "DepositDay")
                        newACHRule.StartDate = DatabaseHelper.Peel_date(rd, "StartDate")
                        newACHRule.EndDate = DatabaseHelper.Peel_ndate(rd, "EndDate")
                        If newACHRule.StartDate <= Now And (Not newACHRule.EndDate.HasValue OrElse newACHRule.EndDate.Value >= Now.Date) Then
                                newACHRule.Status = "ACTIVE"
                            ElseIf newACHRule.StartDate > Now And (Not newACHRule.EndDate.HasValue OrElse newACHRule.EndDate.Value >= Now.Date) Then
                                newACHRule.Status = "FUTURE"
                            Else
                                newACHRule.Status = "EXPIRED"
                        End If

                        ACHRules.Add(newACHRule)

                    End While
                    End Using

                End Using
            End Using
        Else
            'get multi-deposit rules
            Dim sOnlyCurrent As String = IIf(OnlyCurrent = 1, "AND DeletedDate IS NULL AND StartDate <= '" & Now.Date & "' AND (EndDate is null OR EndDate >= '" & Now.Date & "')", "")

            Dim dtRules As DataTable = MultiDepositHelper.getMultiDepositRulesByClientID(DataClientID, sOnlyCurrent)
            For Each row As DataRow In dtRules.Rows
                Dim newACHRule As New ACHRule
                newACHRule.RuleACHId = row("RuleACHId")
                newACHRule.BankAccountNumber = row("BankAccountNumber")
                newACHRule.BankRoutingNumber = row("BankRoutingNumber")
                newACHRule.BankName = row("BankName")
                newACHRule.DepositAmount = row("DepositAmount")
                newACHRule.DepositDay = row("DepositDay")
                newACHRule.OriginalDepositDay = row("OriginalDepositDay")
                newACHRule.StartDate = row("StartDate")
                newACHRule.EndDate = row("EndDate")
                newACHRule.Locked = row("Locked")
                If Not row("DeletedDate") Is DBNull.Value Then
                    newACHRule.Status = "DELETED"
                ElseIf newACHRule.StartDate <= Now And (Not newACHRule.EndDate.HasValue OrElse newACHRule.EndDate.Value >= Now.Date) Then
                    newACHRule.Status = "ACTIVE"
                ElseIf newACHRule.StartDate > Now And (Not newACHRule.EndDate.HasValue OrElse newACHRule.EndDate.Value >= Now.Date) Then
                    newACHRule.Status = "FUTURE"
                Else
                    newACHRule.Status = "EXPIRED"
                End If
                ACHRules.Add(newACHRule)
            Next
            dtRules.Dispose()
            dtRules = Nothing
        End If

        PagerHelper.Handle(ACHRules, rpACHRules, pagerACHRules, PageSize)

        rpACHRules.Visible = ACHRules.Count > 0
        pnlACHRules.Visible = ACHRules.Count > 0
        pnlNoACHRules.Visible = ACHRules.Count = 0

        If ACHRules.Count > 0 Then
            tsMain.TabPages(1).Caption = "<font style=""font-weight:normal;"">ACH&nbsp;Rules</font>&nbsp;&nbsp;<font style=""color:blue;"">(" & ACHRules.Count & ")</font>"
        Else
            tsMain.TabPages(1).Caption = "ACH&nbsp;Rules"
        End If

        Return ACHRules.Count

    End Function

    Private Function RequeryCheckRules() As Integer

        Dim CheckRules As New List(Of CheckRule)

        If Not blnMultiDepositClient Then

            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection
                    cmd.CommandText = "SELECT * FROM tblRuleCheck WHERE ClientID = @ClientID " _
                        & IIf(OnlyCurrentCheck = 1, "AND StartDate <= '" & Now.Date & "' AND (EndDate is null OR EndDate >= '" & Now.Date & "')", "") & " ORDER BY  tblRuleCheck.StartDate Desc, tblRuleCheck.Created Desc"

                    DatabaseHelper.AddParameter(cmd, "ClientId", DataClientID)
                    cmd.Connection.Open()
                    Using rd As IDataReader = cmd.ExecuteReader()
                        While rd.Read()
                            Dim newCheckRule As New CheckRule
                            newCheckRule.RuleCheckId = DatabaseHelper.Peel_int(rd, "RuleCheckId")
                            newCheckRule.DepositAmount = DatabaseHelper.Peel_float(rd, "DepositAmount")
                            newCheckRule.DepositDay = DatabaseHelper.Peel_int(rd, "DepositDay")
                            newCheckRule.StartDate = DatabaseHelper.Peel_date(rd, "StartDate")
                            newCheckRule.EndDate = DatabaseHelper.Peel_ndate(rd, "EndDate")
                            newCheckRule.DateUsed = DatabaseHelper.Peel_ndate(rd, "DateUsed")
                            If newCheckRule.StartDate <= Now And (Not newCheckRule.EndDate.HasValue OrElse newCheckRule.EndDate.Value >= Now.Date) Then
                                newCheckRule.Status = "ACTIVE"
                            ElseIf newCheckRule.StartDate > Now And (Not newCheckRule.EndDate.HasValue OrElse newCheckRule.EndDate.Value >= Now.Date) Then
                                newCheckRule.Status = "FUTURE"
                            Else
                                newCheckRule.Status = "EXPIRED"
                            End If

                            CheckRules.Add(newCheckRule)

                        End While
                    End Using

                End Using
            End Using
        Else
            'get multi-deposit rules
            Dim sOnlyCurrent As String = IIf(OnlyCurrentCheck = 1, "AND DeletedDate IS NULL AND StartDate <= '" & Now.Date & "' AND (EndDate is null OR EndDate >= '" & Now.Date & "')", "")

            Dim dtRules As DataTable = MultiDepositHelper.getMultiDepositCheckRulesByClientID(DataClientID, sOnlyCurrent)
            For Each row As DataRow In dtRules.Rows
                Dim newCheckRule As New CheckRule
                newCheckRule.RuleCheckId = row("RuleCheckId")
                newCheckRule.DepositAmount = row("DepositAmount")
                newCheckRule.DepositDay = row("DepositDay")
                newCheckRule.OriginalDepositDay = row("OriginalDepositDay")
                newCheckRule.StartDate = row("StartDate")
                newCheckRule.EndDate = row("EndDate")
                If Not row("DateUsed") Is DBNull.Value Then
                    newCheckRule.DateUsed = row("DateUsed")
                End If
                newCheckRule.Locked = row("Locked")
                If Not row("DeletedDate") Is DBNull.Value Then
                    newCheckRule.Status = "DELETED"
                ElseIf newCheckRule.StartDate <= Now And (Not newCheckRule.EndDate.HasValue OrElse newCheckRule.EndDate.Value >= Now.Date) Then
                    newCheckRule.Status = "ACTIVE"
                ElseIf newCheckRule.StartDate > Now And (Not newCheckRule.EndDate.HasValue OrElse newCheckRule.EndDate.Value >= Now.Date) Then
                    newCheckRule.Status = "FUTURE"
                Else
                    newCheckRule.Status = "EXPIRED"
                End If
                CheckRules.Add(newCheckRule)
            Next
            dtRules.Dispose()
            dtRules = Nothing
        End If

        PagerHelper.Handle(CheckRules, rpCheckRules, pagerCheckRules, PageSize)

        rpCheckRules.Visible = CheckRules.Count > 0
        pnlCheckRules.Visible = CheckRules.Count > 0
        pnlNoCheckRules.Visible = CheckRules.Count = 0

        If CheckRules.Count > 0 Then
            tsMain.TabPages(2).Caption = "<font style=""font-weight:normal;"">Check&nbsp;Rules</font>&nbsp;&nbsp;<font style=""color:blue;"">(" & CheckRules.Count & ")</font>"
        Else
            tsMain.TabPages(2).Caption = "Check&nbsp;Rules"
        End If

        Return CheckRules.Count

    End Function

    Private Function RequeryChecksToPrint() As Integer

        Dim ChecksToPrint As New List(Of CheckToPrint)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetChecksToPrint")

            If OnlyNotPrinted > 0 Then
                DatabaseHelper.AddParameter(cmd, "Where", "WHERE tblCheckToPrint.ClientID = " & DataClientID & " AND Printed IS NULL")
            Else
                DatabaseHelper.AddParameter(cmd, "Where", "WHERE tblCheckToPrint.ClientID = " & DataClientID)
            End If

            DatabaseHelper.AddParameter(cmd, "OrderBy", "tblCheckToPrint.Created")

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

        PagerHelper.Handle(ChecksToPrint, rpChecksToPrint, pagerCTP, PageSize)

        rpChecksToPrint.Visible = ChecksToPrint.Count > 0
        pnlChecksToPrint.Visible = ChecksToPrint.Count > 0
        pnlNoChecksToPrint.Visible = ChecksToPrint.Count = 0

        If ChecksToPrint.Count > 0 Then
            tsMain.TabPages(3).Caption = "<font style=""font-weight:normal;"">Checks&nbsp;To&nbsp;Print</font>&nbsp;&nbsp;<font style=""color:blue;"">(" & ChecksToPrint.Count & ")</font>"
        Else
            tsMain.TabPages(3).Caption = "Checks&nbsp;To&nbsp;Print"
        End If

        Return ChecksToPrint.Count

    End Function
    Private Sub SetPage(ByVal col As IList, ByVal index As Integer, ByVal size As Integer)

        For i As Integer = col.Count - 1 To (index + 1) * size Step -1
            col.RemoveAt(i)
        Next i

        For i As Integer = Math.Min(index * size - 1, col.Count - 1) To 0 Step -1
            col.RemoveAt(i)
        Next i

    End Sub
    Private Sub SetRedirectPage(ByVal index As Integer, ByVal type As String)

        Dim qsb As New QueryStringBuilder(Request.Url.Query)

        qsb(type) = index.ToString()

        Response.Redirect("default.aspx" & IIf(qsb.QueryString.Length > 0, "?" & qsb.QueryString, String.Empty))

    End Sub
    Private Sub LoadACHInfo()

        If blnMultiDepositClient Then
            tblDepositInfo.Visible = False
            tblMultiDepositInfo.Visible = True
            achEditButton.HRef = "javascript:EditMulti()"
            Flyout1.AttachTo = "lnkEditMulti"
            Me.multipleDepositList.Client = ClientID
            Me.multipleDepositList.ControlLoad(False)
            Me.multiDepositListReadOnly.InnerHtml = Me.multipleDepositList.RenderReadOnlyHTML
            Me.multipleDepositList.FloorValidation = FloorValidationMode.Warning
        End If

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("get_ClientACHInfo")

            DatabaseHelper.AddParameter(cmd, "ClientID", DataClientID)

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    If rd.Read() Then

                        If blnMultiDepositClient Then
                            multidepositStartDate.Text = DatabaseHelper.Peel_datestring(rd, "DepositStartDate", "MM/dd/yyyy")
                            multidepositStartDateReadOnly.InnerText = DatabaseHelper.Peel_datestring(rd, "DepositStartDate", "MM/dd/yyyy")
                        Else
                            If DatabaseHelper.Peel_string(rd, "DepositMethod") = "ACH" Then
                                depositMethod.Value = "ACH"
                                depositMethodReadOnly.InnerText = "ACH"
                            Else
                                depositMethod.Value = "Check"
                                depositMethodReadOnly.InnerText = "Check"
                            End If

                            cboBankType.SelectedValue = Trim(DatabaseHelper.Peel_string(rd, "BankType"))
                            cboBankTypeReadOnly.InnerText = cboBankType.SelectedItem.Text

                            Dim depositDayVal As Integer = DatabaseHelper.Peel_int(rd, "DepositDay")

                            ListHelper.SetSelected(cboDepositDay, depositDayVal)
                            cboDepositDayReadOnly.InnerText = cboDepositDay.SelectedItem.Text
                            bankNameReadOnly.InnerText = DatabaseHelper.Peel_string(rd, "BankName")
                            routingNumber.Value = DatabaseHelper.Peel_string(rd, "BankRoutingNumber")
                            routingNumberReadOnly.InnerText = routingNumber.Value
                            accountNumber.Value = DatabaseHelper.Peel_string(rd, "BankAccountNumber")
                            accountNumberReadOnly.InnerText = accountNumber.Value
                            depositAmount.Value = DatabaseHelper.Peel_decimal(rd, "DepositAmount").ToString("n2")
                            depositAmountReadOnly.InnerText = DatabaseHelper.Peel_decimal(rd, "DepositAmount").ToString("c")
                            depositStartDate.Text = DatabaseHelper.Peel_datestring(rd, "DepositStartDate", "MM/dd/yyyy")
                            depositStartDateReadOnly.InnerText = DatabaseHelper.Peel_datestring(rd, "DepositStartDate", "MM/dd/yyyy")
                        End If

                    End If

                End Using
            End Using
        End Using

    End Sub
    Private Sub LoadFeeInfo()


        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("get_ClientFeeInfo")

            DatabaseHelper.AddParameter(cmd, "ClientID", DataClientID)

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    If rd.Read() Then

                        setupFeePercentage.SelectedValue = (DatabaseHelper.Peel_decimal(rd, "SetupFeePercentage") * 100).ToString("n2")
                        setupFeePercentageReadOnly.InnerText = setupFeePercentage.SelectedValue
                        settlementFeePercentage.Value = (DatabaseHelper.Peel_decimal(rd, "SettlementFeePercentage") * 100).ToString("n2")
                        settlementFeePercentageReadOnly.InnerText = settlementFeePercentage.Value
                        additionalAccountFee.Value = DatabaseHelper.Peel_decimal(rd, "AdditionalAccountFee").ToString("n2")
                        additionalAccountFeeReadOnly.InnerText = additionalAccountFee.Value
                        returnedCheckFee.Value = DatabaseHelper.Peel_decimal(rd, "ReturnedCheckFee").ToString("n2")
                        returnedCheckFeeReadOnly.InnerText = returnedCheckFee.Value
                        overnightDeliveryFee.Value = DatabaseHelper.Peel_decimal(rd, "OvernightDeliveryFee").ToString("n2")
                        overnightDeliveryFeeReadOnly.InnerText = overnightDeliveryFee.Value

                        Dim seltxt As String
                        seltxt = DatabaseHelper.Peel_decimal(rd, "MonthlyFee").ToString("n2").ToString
                        If DatabaseHelper.Peel_decimal(rd, "MaintenanceFeeCap") > 0 Then
                            Me.hdnUseMonthlyFeeType.Value = "2"
                            Me.dvMonthlyFee.Style.Add("display", "none")
                            Me.lblMonthlyFeeWithCap.Text = seltxt & " per acct, max " & DatabaseHelper.Peel_decimal(rd, "MaintenanceFeeCap").ToString("c")
                        Else
                            Me.hdnUseMonthlyFeeType.Value = "0"
                            Me.dvMonthlyFeeCap.Style.Add("display", "none")
                            Dim submaint As Decimal = DatabaseHelper.Peel_decimal(rd, "SubsequentMaintFee")
                            Dim submaintstart As DateTime = DatabaseHelper.Peel_date(rd, "SubMaintFeeStart")

                            If submaint > 0 AndAlso submaintstart <= Now Then
                                seltxt = submaint.ToString("n2")
                                Me.hdnUseMonthlyFeeType.Value = "1"
                            End If

                            monthlyFee.SelectedValue = seltxt

                            'monthlyFee.SelectedItem = DatabaseHelper.Peel_decimal(rd, "MonthlyFee").ToString("n2")
                            monthlyFeeReadOnly.InnerText = DatabaseHelper.Peel_decimal(rd, "MonthlyFee").ToString("n2")

                        End If

                    End If

                End Using
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
    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click

        If txtSelectedChecksToPrint.Value.Length > 0 Then

            'get selected "," delimited CheckToPrintID's
            Dim ChecksToPrint() As String = txtSelectedChecksToPrint.Value.Split(",")

            'build an actual integer array
            Dim CheckToPrintIDs As New List(Of Integer)

            For Each CheckToPrint As String In ChecksToPrint
                CheckToPrintIDs.Add(DataHelper.Nz_int(CheckToPrint))
            Next

            'delete array of CheckToPrintID's
            CheckToPrintHelper.Delete(CheckToPrintIDs.ToArray())

        End If

        'reload same page (of checks to print)
        Dim qsb As New QueryStringBuilder(Request.Url.Query)
        qsb("tab") = 3
        Response.Redirect("default.aspx?" & qsb.QueryString)

    End Sub
    Protected Sub lnkDeleteACHRules_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteACHRules.Click
        If txtSelectedACHRules.Value.Length > 0 Then

            'get selected "," delimited ID's
            Dim ACHRules() As String = txtSelectedACHRules.Value.Split(",")

            'build an actual integer array
            Dim ACHRuleIDs As New List(Of Integer)

            For Each ACHRule As String In ACHRules
                ACHRuleIDs.Add(DataHelper.Nz_int(ACHRule))
            Next

            'delete array of ID's
            'Dont delete a rule if used or expired
            Dim used As Boolean = False
            Dim expired As Boolean = False
            Dim startdate As DateTime
            Dim enddate As String
            For Each RuleACHId As Integer In ACHRules
                If MultiDepositHelper.IsMultiDepositClient(DataClientID) Then
                    startdate = DataHelper.FieldLookup("tblDepositRuleACH", "StartDate", "RuleACHId = " & RuleACHId)
                    enddate = DataHelper.FieldLookup("tblDepositRuleACH", "EndDate", "RuleACHId = " & RuleACHId)
                    used = (MultiDepositHelper.GetMultiDepositsForRule(RuleACHId).Rows.Count > 0)
                    If Not used Then
                        Dim oldRuleId As Integer = Val(Drg.Util.DataAccess.DataHelper.FieldLookup("tblDepositRuleACh", "OldRuleId", "RuleACHId = " & RuleACHId))
                        If oldRuleId > 0 Then
                            used = (MultiDepositHelper.GetDepositsForRule(oldRuleId).Rows.Count > 0)
                        End If
                    End If
                    expired = startdate < Now AndAlso enddate.Trim.Length > 0 AndAlso CDate(enddate) < Now
                    If Not used And Not expired Then
                        DataHelper.Delete("tblDepositRuleACH", "RuleACHId = " & RuleACHId)
                    End If
                Else
                    startdate = DataHelper.FieldLookup("tblRuleACH", "StartDate", "RuleACHId = " & RuleACHId)
                    enddate = DataHelper.FieldLookup("tblRuleACH", "EndDate", "RuleACHId = " & RuleACHId)
                    expired = startdate < Now AndAlso enddate.Trim.Length > 0 AndAlso CDate(enddate) < Now
                    used = (MultiDepositHelper.GetDepositsForRule(RuleACHId).Rows.Count > 0)
                    If Not used And Not expired Then
                        DataHelper.Delete("tblRuleACH", "RuleACHId = " & RuleACHId)
                    End If
                End If
            Next
        End If

        'reload same page
        Dim qsb As New QueryStringBuilder(Request.Url.Query)
        qsb("tab") = 1
        Response.Redirect("default.aspx?" & qsb.QueryString)
    End Sub

    Protected Sub lnkDeleteCheckRules_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteCheckRules.Click
        If txtSelectedCheckRules.Value.Length > 0 Then

            'get selected "," delimited ID's
            Dim CheckRules() As String = txtSelectedCheckRules.Value.Split(",")

            'build an actual integer array
            Dim CheckRuleIDs As New List(Of Integer)

            For Each CheckRule As String In CheckRules
                CheckRuleIDs.Add(DataHelper.Nz_int(CheckRule))
            Next

            'delete array of ID's
            'Dont delete a rule if used or expired
            Dim used As Boolean = False
            Dim expired As Boolean = False
            Dim startdate As DateTime
            Dim enddate As String
            For Each RuleCheckId As Integer In CheckRules
                If MultiDepositHelper.IsMultiDepositClient(DataClientID) Then
                    startdate = DataHelper.FieldLookup("tblDepositRuleCheck", "StartDate", "RuleCheckId = " & RuleCheckId)
                    enddate = DataHelper.FieldLookup("tblDepositRuleCheck", "EndDate", "RuleCheckId = " & RuleCheckId)
                    used = (DataHelper.FieldLookup("tblDepositRuleCheck", "DateUsed", "RuleCheckId = " & RuleCheckId).Trim.Trim.Length > 0)
                    If Not used Then
                        Dim oldRuleId As Integer = Val(Drg.Util.DataAccess.DataHelper.FieldLookup("tblDepositRuleCheck", "OldRuleId", "RuleCheckId = " & RuleCheckId))
                        If oldRuleId > 0 Then
                            used = (DataHelper.FieldLookup("tblRuleCheck", "DateUsed", "RuleCheckId = " & RuleCheckId).Trim.Trim.Length > 0)
                        End If
                    End If
                    expired = startdate < Now AndAlso enddate.Trim.Length > 0 AndAlso CDate(enddate) < Now
                    If Not used And Not expired Then
                        DataHelper.Delete("tblDepositRuleCheck", "RuleCheckId = " & RuleCheckId)
                    End If
                Else
                    startdate = DataHelper.FieldLookup("tblRuleCheck", "StartDate", "RulCheckId = " & RuleCheckId)
                    enddate = DataHelper.FieldLookup("tblRuleCheck", "EndDate", "RuleCheckId = " & RuleCheckId)
                    expired = startdate < Now AndAlso enddate.Trim.Length > 0 AndAlso CDate(enddate) < Now
                    used = (DataHelper.FieldLookup("tblRuleCheck", "DateUsed", "RuleCheckId = " & RuleCheckId).Trim.Trim.Length > 0)
                    If Not used And Not expired Then
                        DataHelper.Delete("tblRuleCheck", "RuleCheckId = " & RuleCheckId)
                    End If
                End If
            Next
        End If

        'reload same page
        Dim qsb As New QueryStringBuilder(Request.Url.Query)
        qsb("tab") = 2
        Response.Redirect("default.aspx?" & qsb.QueryString)
    End Sub


    Protected Sub lnkDeleteAdHocAch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteAdHocACH.Click
        If txtSelectedAdHocACH.Value.Length > 0 Then
            'get selected "," delimited ID's
            Dim arr() As String = txtSelectedAdHocACH.Value.Split(",")

            'delete array of ID's
            For Each s As String In arr
                'Delete only if not used yet
                If DataHelper.FieldLookup("tblAdHocACH", "RegisterId", "AdHocAchId= " & s).Trim.Length = 0 Then
                    If NonDepositHelper.GetMatterIdByReplacementAdHoc(s) = 0 Then
                        DataHelper.Delete("tblAdHocACH", "AdHocAchId= " & s)
                        MultiDepositHelper.AuditDeleteAdHocACH(s, UserID)
                    End If
                End If
            Next
        End If

        'reload same page
        Dim qsb As New QueryStringBuilder(Request.Url.Query)
        qsb("tab") = 0
        Response.Redirect("default.aspx?" & qsb.QueryString)
    End Sub
    Private Sub ACHDisplayError(ByVal Message As String, ByVal ToFocus As HtmlControl)

        dvError.Style("display") = "inline"
        tdError.InnerHtml = Message

        ToFocus.Style("border") = "solid 2px red"

        depositMethod.Style("display") = "inline"
        depositMethodReadOnly.Style("display") = "none"
        cboDepositDay.Style("display") = "inline"
        cboDepositDayReadOnly.Style("display") = "none"
        accountNumber.Style("display") = "inline"
        accountNumberReadOnly.Style("display") = "none"
        depositStartDate.Style("display") = "inline"
        depositStartDateReadOnly.Style("display") = "none"
        routingNumber.Style("display") = "inline"
        routingNumberReadOnly.Style("display") = "none"
        depositAmount.Style("display") = "inline"
        depositAmountReadOnly.Style("display") = "none"

        achSaveButtons.style("display") = "inline"
        achEditButton.style("display") = "none"

    End Sub
    Private Function ACHRequiredExist() As Boolean

        Me.routingNumber.Style.Remove("border")

        If Me.routingNumber.Value.Length > 0 Then
            Dim objStore As New WCFClient.Store

            If Not objStore.RoutingIsValid(Me.routingNumber.Value, bankNameReadOnly.InnerText) Then
                ACHDisplayError("The Routing Number you entered does not validate against the Federal ACH Directory.", Me.routingNumber)
                Return False
            End If
        End If

        Return True

    End Function
    Protected Sub lnkSaveACH_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveACH.Click

        If ACHRequiredExist() Then

            Dim fields As New List(Of DataHelper.FieldValue)

            fields.Add(New DataHelper.FieldValue("DepositMethod", depositMethod.Value))
            fields.Add(New DataHelper.FieldValue("DepositDay", ListHelper.GetSelected(cboDepositDay)))
            fields.Add(New DataHelper.FieldValue("DepositAmount", DataHelper.Zn_double(depositAmount.Value)))
            fields.Add(New DataHelper.FieldValue("BankName", DataHelper.Zn(bankNameReadOnly.InnerText)))
            fields.Add(New DataHelper.FieldValue("BankRoutingNumber", DataHelper.Zn(routingNumber.Value)))
            fields.Add(New DataHelper.FieldValue("BankAccountNumber", DataHelper.Zn(accountNumber.Value)))

            If cboBankType.SelectedValue = "0" Then
                fields.Add(New DataHelper.FieldValue("BankType", DBNull.Value))
            Else
                fields.Add(New DataHelper.FieldValue("BankType", cboBankType.SelectedValue))
            End If

            fields.Add(New DataHelper.FieldValue("DepositStartDate", DataHelper.Zn(depositStartDate.Text)))

            DataHelper.AuditedUpdate(fields, "tblClient", DataClientID, UserID)

            Refresh()

        End If

    End Sub
    Protected Sub lnkSaveFees_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveFees.Click

      Dim Percentage As Double = CDbl(Val(setupFeePercentage.SelectedValue)) / 100

      Dim Underwriting As String = DataHelper.FieldLookup("tblClient", "VWUWResolved", "ClientID = " & ClientID)
      Dim HowOldIsClient As Integer = DateDiff(DateInterval.Day, Now(), CDate(DataHelper.FieldLookup("tblClient", "Created", "ClientID = " & ClientID)))

        If Percentage = 0.1 Then
            DataHelper.FieldUpdate("tblClient", "InitialAgencyPercent", "0.02", "ClientID = " + ClientID.ToString())
            DataHelper.FieldUpdate("tblClient", "SetupFeePercentage", CStr(setupFeePercentage.SelectedValue / 100), "ClientID = " + ClientID.ToString())
            DataHelper.FieldUpdate("tblAccount", "SetupFeePercentage", CStr(setupFeePercentage.SelectedValue / 100), "ClientID = " & ClientID.ToString())
        Else
            DataHelper.FieldUpdate("tblClient", "InitialAgencyPercent", Nothing, "ClientID = " + ClientID.ToString())
            DataHelper.FieldUpdate("tblClient", "SetupFeePercentage", CStr(setupFeePercentage.SelectedValue / 100), "ClientID = " + ClientID.ToString())
            DataHelper.FieldUpdate("tblAccount", "SetupFeePercentage", CStr(setupFeePercentage.SelectedValue / 100), "ClientID = " & ClientID.ToString())
        End If

        Dim fields As New List(Of DataHelper.FieldValue)

        fields.Add(New DataHelper.FieldValue("SettlementFeePercentage", DataHelper.Zn_double(settlementFeePercentage.Value / 100)))
        fields.Add(New DataHelper.FieldValue("AdditionalAccountFee", DataHelper.Zn_double(additionalAccountFee.Value)))
        fields.Add(New DataHelper.FieldValue("SetupFeePercentage", DataHelper.Zn_double(setupFeePercentage.SelectedValue / 100)))
        fields.Add(New DataHelper.FieldValue("ReturnedCheckFee", DataHelper.Zn_double(returnedCheckFee.Value)))
        fields.Add(New DataHelper.FieldValue("OvernightDeliveryFee", DataHelper.Zn_double(overnightDeliveryFee.Value)))

        Select Case Me.hdnUseMonthlyFeeType.Value
            Case "1"
                fields.Add(New DataHelper.FieldValue("SubsequentMaintFee", DataHelper.Zn_double(monthlyFee.SelectedValue)))
            Case "2"
                'Do Nothing
            Case Else
                fields.Add(New DataHelper.FieldValue("MonthlyFee", DataHelper.Zn_double(monthlyFee.SelectedValue)))
        End Select

        'nudge all accounts for fees
        OldPct = CInt(Me.txtOldPct.Text)
        Pct = CInt(Me.setupFeePercentage.SelectedValue)

        Dim RtrChange As New RtrFeeAdjustmentHelper
        'If OldPct = Pct Then
        RtrChange.ShouldRtrFeeChange(ClientID, UserID)
        'AccountHelper.AdjustRetainerFees(ClientID, UserID, False, Pct, OldPct)
        'Else
        'RtrChange.ShouldRtrFeeChange(ClientID, UserID)
        'AccountHelper.ClientRetainerCorrect(ClientID, UserID, False, Pct, OldPct)
        'End If

        ClientHelper.CleanupRegister(DataClientID)

        DataHelper.AuditedUpdate(fields, "tblClient", DataClientID, UserID)

        Refresh()

    End Sub
    Private Sub Refresh()
        Response.Redirect(Request.Url.AbsoluteUri)
    End Sub
    Protected Sub lnkFirstCheckToPrint_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkFirstCheckToPrint.Click
        pagerCTP.First()
    End Sub
    Protected Sub lnkLastCheckToPrint_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkLastCheckToPrint.Click
        pagerCTP.Last()
    End Sub
    Protected Sub lnkNextCheckToPrint_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkNextCheckToPrint.Click
        pagerCTP.Next()
    End Sub
    Protected Sub lnkPrevCheckToPrint_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkPrevCheckToPrint.Click
        pagerCTP.Previous()
    End Sub

    Protected Sub lnkFirstCheckRule_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkFirstCheckRule.Click
        pagerCheckRules.First()
    End Sub
    Protected Sub lnkLastCheckRule_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkLastCheckRule.Click
        pagerCheckRules.Last()
    End Sub
    Protected Sub lnkNextCheckRule_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkNextCheckRule.Click
        pagerCheckRules.Next()
    End Sub
    Protected Sub lnkPrevCheckRule_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkPrevCheckRule.Click
        pagerCheckRules.Previous()
    End Sub
    Protected Sub lnkFirstACHRule_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkFirstACHRule.Click
        pagerACHRules.First()
    End Sub
    Protected Sub lnkLastACHRule_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkLastACHRule.Click
        pagerACHRules.Last()
    End Sub
    Protected Sub lnkNextACHRule_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkNextACHRule.Click
        pagerACHRules.Next()
    End Sub
    Protected Sub lnkPrevACHRule_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkPrevACHRule.Click
        pagerACHRules.Previous()
    End Sub
    Protected Sub lnkFirstAdHocACH_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkFirstAdHocACH.Click
        pagerAdHocACH.First()
    End Sub
    Protected Sub lnkLastAdHocACH_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkLastAdHocACH.Click
        pagerAdHocACH.Last()
    End Sub
    Protected Sub lnkNextAdHocACH_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkNextAdHocACH.Click
        pagerAdHocACH.Next()
    End Sub
    Protected Sub lnkPrevAdHocACH_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkPrevAdHocACH.Click
        pagerAdHocACH.Previous()
    End Sub
    Protected Sub chkOnlyCurrent_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkOnlyCurrent.CheckedChanged
        Dim qsb As New QueryStringBuilder(Request.Url.Query)
        If chkOnlyCurrent.Checked Then
            qsb.Remove("c")
        Else
            qsb("c") = 0
        End If
        qsb("tab") = 1
        Response.Redirect("default.aspx?" & qsb.QueryString)
    End Sub

    Protected Sub chkOnlyCurrentCheck_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkOnlyCurrentCheck.CheckedChanged
        Dim qsb As New QueryStringBuilder(Request.Url.Query)
        If chkOnlyCurrentCheck.Checked Then
            qsb.Remove("ch")
        Else
            qsb("ch") = 0
        End If
        qsb("tab") = 2
        Response.Redirect("default.aspx?" & qsb.QueryString)
    End Sub

    Protected Sub chkOnlyNotPrinted_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkOnlyNotPrinted.CheckedChanged
        Dim qsb As New QueryStringBuilder(Request.Url.Query)
        If Not chkOnlyNotPrinted.Checked Then
            qsb("o") = 0
        Else
            qsb.Remove("o")
        End If
        qsb("tab") = 3
        Response.Redirect("default.aspx?" & qsb.QueryString)
    End Sub
    Protected Sub chkOnlyNotDeposited_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkOnlyNotDeposited.CheckedChanged
        Dim qsb As New QueryStringBuilder(Request.Url.Query)
        If Not chkOnlyNotDeposited.Checked Then
            qsb("nd") = 0
        Else
            qsb.Remove("nd")
        End If
        qsb("tab") = 0
        Response.Redirect("default.aspx?" & qsb.QueryString)
    End Sub

    Protected Sub lnkSaveMulti_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveMulti.Click
        Dim fields As New List(Of DataHelper.FieldValue)

        fields.Add(New DataHelper.FieldValue("DepositStartDate", DataHelper.Zn(multidepositStartDate.Text)))

        DataHelper.AuditedUpdate(fields, "tblClient", DataClientID, UserID)

        Try
            Dim startdate As Date = CDate(multidepositStartDate.Text)
            multipleDepositList.Save()
            dvError.Style("display") = "none"
            multipleDepositList.Client = ClientID
            multipleDepositList.ControlLoad(False)
            multiDepositListReadOnly.InnerHtml = Me.multipleDepositList.RenderReadOnlyHTML
            multidepositStartDateReadOnly.InnerText = String.Format("{0:MM/dd/yyyy}", startdate)
        Catch ex As Exception
            dvError.Visible = True
            tdError.InnerHtml = ex.Message
        End Try

    End Sub

    Protected Sub lnkCancelMulti_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelMulti.Click
    End Sub

    Public Sub ConvertToMulti(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkConvertToMulti.Click
        Dim DepositStartDate As Date
        Dim DepositAmount As Double = -1
        Dim DepositDay As Integer = -1
        Dim DepositMethod As String = ""
        Dim BankRoutingNumber As String = ""
        Dim BankAccountNumber As String = ""
        Dim BankType As String = ""
        Dim BankId As Integer = -1
        Dim ClientDepositId As Integer = -1
        Dim RoutingAndAccount As New Dictionary(Of String, Integer)
        Dim OldRuleId As Integer
        Dim Duplicated As Integer = -1
        Dim ClientStatus As Integer = -1
        Dim Alert As New Alert

        Dim StartDate As Date
        Dim EndDate As Date
        Dim dt1 As DataTable

        Try
            'Duplication check on conversion.
            'Since we are converting to multi deposits from a single deposit there can only be one entry
            'If there is already one entry then this would duplicate the entries. A refresh can cause this to happen.
            If Me.blnMultiDepositClient Then Throw New Exception("This client was converted already. Please, contact you supervisor")

            dt1 = MultiDepositHelper.getMultiDepositsForClient(ClientID)
            If dt1.Rows.Count > 0 Then Throw New Exception("This client was converted already. Please, contact you supervisor")

            'Check any current client accounts stored in tblClientBankAccounts. Should never be any
            dt1 = MultiDepositHelper.getMultiDepositClientBanks(ClientID)
            If dt1.Rows.Count > 0 Then Throw New Exception("This client already has a bank account in the MultiPay tables. This client can not be converted. Please contact your supervisor.")

            'Clear any garbage if exists
            MultiDepositHelper.ClearMultiDeposit(ClientID)

            'Get the basic client data from tblClient
            dt1 = MultiDepositHelper.getClientDepositInformation(ClientID)
            If dt1.Rows.Count > 0 Then
                For Each dr1 As DataRow In dt1.Rows
                    ClientStatus = IIf(Not dr1.Item("CurrentClientStatusID") Is DBNull.Value, dr1.Item("CurrentClientStatusID"), 0)
                    If dr1.Item("DepositStartDate") Is DBNull.Value Then Throw New Exception("The deposit start date is not provided")
                    DepositStartDate = CDate(dr1.Item("DepositStartDate"))
                    If dr1.Item("DepositAmount") Is DBNull.Value OrElse Not dr1.Item("DepositAmount") > 0 Then Throw New Exception("The deposit amount must be greater than zero")
                    DepositAmount = IIf(Not dr1.Item("DepositAmount") Is DBNull.Value, dr1.Item("DepositAmount"), "")
                    DepositDay = IIf(Not dr1.Item("DepositDay") Is DBNull.Value, dr1.Item("DepositDay"), 0)
                    DepositMethod = IIf(Not dr1.Item("DepositMethod") Is DBNull.Value, dr1.Item("DepositMethod"), "")
                    BankRoutingNumber = IIf(Not dr1.Item("BankRoutingNumber") Is DBNull.Value, dr1.Item("BankRoutingNumber").ToString.Trim, "")
                    BankAccountNumber = IIf(Not dr1.Item("BankAccountNumber") Is DBNull.Value, dr1.Item("BankAccountNumber").ToString.Trim, "")
                    BankType = IIf(Not dr1.Item("BankType") Is DBNull.Value, dr1.Item("BankType"), "C")
                Next
            End If

            'Validate the data
            'Check the clients status
            If ClientStatus = 15 Or ClientStatus = 17 Or ClientStatus = 18 Then Throw New Exception("This client is not active. Please activate this client before converting them to MultiPay.")
            'Do we have a deposit day
            If DepositDay < 1 Or DepositDay > 30 Then Throw New Exception("This client does not have a deposit day assigned. Please assign this client a deposit day before converting them to MultiPay.")
            'Do we have a deposit amount
            If DepositAmount <= 0 Then Throw New Exception("This client has no deposit amount. Please add a deposit amount for this client before converting them to MultiPay.")
            'Need a deposit method
            If DepositMethod.ToString = "" Then Throw New Exception("Please include a deposit method for this client before converting to MultiPay.")
            'Need Bank Info for ACH
            If DepositMethod.ToUpper = "ACH" And (BankAccountNumber = "" Or BankRoutingNumber = "") Then
                Throw New Exception("This is an ACH client with no banking information. Please add the banking information before converting them to MultiPay.")
            End If
            'Incomplete Banking Information
            If (BankAccountNumber = "" And BankRoutingNumber <> "") Or (BankAccountNumber <> "" And BankRoutingNumber = "") Then
                Throw New Exception("The banking information is incomplete. Please add the banking information before converting them to MultiPay.")
            End If
            'Check for overlaps. Exclude the old rules from validation
            If Me.RulesOverlap(MultiDepositHelper.getOldDepositRulesByClientID(ClientID, True)) Then
                Throw New Exception("The active and/or future rules overlap each other.")
            End If

            'Start inserting the data
            Dim BankKey As String = String.Empty
            'Insert the bank account in tblClientBankAccount if there is one
            RoutingAndAccount.Clear()
            If BankRoutingNumber <> "" Or BankAccountNumber <> "" Then
                BankId = MultiDepositHelper.InsertClientBank(ClientID, BankRoutingNumber, BankAccountNumber, BankType, UserID)
                BankKey = BankRoutingNumber & BankAccountNumber
                RoutingAndAccount.Add(BankKey, BankId)
            End If

            'insert the deposit day information
            If DepositMethod.ToUpper = "ACH" Then
                ClientDepositId = MultiDepositHelper.InsertClientDepositDay(ClientID, "month", DepositDay, DepositAmount, 0, DepositMethod, BankId, UserID)
            Else
                ClientDepositId = MultiDepositHelper.InsertClientDepositDay(ClientID, "month", DepositDay, DepositAmount, 0, DepositMethod, 0, UserID)
            End If

            'This is the section that deals with the rules to be converted.  
            dt1 = MultiDepositHelper.getOldDepositRulesByClientID(ClientID, False)
            Dim LockRule As Boolean = False
            If dt1.Rows.Count > 0 Then 'We have some rules to deal with
                For Each dr1 As DataRow In dt1.Rows
                    'Get the necessary data for the insert
                    OldRuleId = dr1.Item("RuleACHId")
                    StartDate = dr1.Item("StartDate")
                    EndDate = dr1.Item("EndDate")
                    DepositDay = IIf(Not dr1.Item("DepositDay") Is DBNull.Value, dr1.Item("DepositDay"), 0)
                    DepositAmount = IIf(Not dr1.Item("DepositAmount") Is DBNull.Value, dr1.Item("DepositAmount"), 0.0)
                    LockRule = (Not dr1.Item("EndDate") Is DBNull.Value AndAlso CDate(dr1.Item("EndDate")) < Today)
                    'Get Rule Bank info
                    BankType = IIf(Not dr1.Item("BankType") Is DBNull.Value, dr1.Item("BankType"), "C")
                    BankRoutingNumber = IIf(Not dr1.Item("BankRoutingNumber") Is DBNull.Value, dr1.Item("BankRoutingNumber").ToString.Trim, "")
                    If BankRoutingNumber.Length = 0 Then Throw New Exception("Cannot insert bank account from rule because the routing number is not provided")
                    BankAccountNumber = IIf(Not dr1.Item("BankAccountNumber") Is DBNull.Value, dr1.Item("BankAccountNumber").ToString.Trim, "")
                    If BankAccountNumber.Length = 0 Then Throw New Exception("Cannot insert bank account from rule because the account number is not provided")
                    BankKey = BankRoutingNumber & BankAccountNumber
                    'Is this rule coming from a bank not entered
                    If Not RoutingAndAccount.ContainsKey(BankKey) Then
                        BankId = MultiDepositHelper.InsertClientBank(ClientID, BankRoutingNumber, BankAccountNumber, BankType, UserID)
                        RoutingAndAccount.Add(BankKey, BankId)
                    Else
                        BankId = RoutingAndAccount(BankKey)
                    End If

                    'Now post the rule to the new table with the bank account information. The new rules are not locked so unlock them
                    MultiDepositHelper.InsertMultiDepositRule(ClientDepositId, StartDate, EndDate, DepositDay, DepositAmount, BankId, UserID, UserID, OldRuleId, LockRule)
                Next 'Got all the bank accounts from the current and future rules in the list
            End If

            'Check if there are ANY old AdHocACHs for this client and validate the bank accounts against what we already have
            dt1 = MultiDepositHelper.getAllACHsByClientID(ClientID)
            If dt1.Rows.Count > 0 Then
                For Each dr1 As DataRow In dt1.Rows
                    BankType = IIf(Not dr1.Item("BankType") Is DBNull.Value, dr1.Item("BankType"), "C")
                    BankRoutingNumber = IIf(Not dr1.Item("BankRoutingNumber") Is DBNull.Value, dr1.Item("BankRoutingNumber").ToString.Trim, "")
                    If BankRoutingNumber.Length = 0 Then Throw New Exception("Cannot insert bank account from rule because the routing number is not provided")
                    BankAccountNumber = IIf(Not dr1.Item("BankAccountNumber") Is DBNull.Value, dr1.Item("BankAccountNumber").ToString.Trim, "")
                    If BankAccountNumber.Length = 0 Then Throw New Exception("Cannot insert bank account from rule because the account number is not provided")
                    BankKey = BankRoutingNumber & BankAccountNumber
                    'Is this rule coming from a bank not entered
                    If Not RoutingAndAccount.ContainsKey(BankKey) Then
                        BankId = MultiDepositHelper.InsertClientBank(ClientID, BankRoutingNumber, BankAccountNumber, BankType, UserID)
                        RoutingAndAccount.Add(BankKey, BankId)
                    End If
                Next
            End If

            'Assign the client as a converted multi deposit client.
         MultiDepositHelper.MakeMultiDepositClient(ClientID, True, UserID)

        Catch ex As Exception
            'Roll back all inserts
            MultiDepositHelper.ClearMultiDeposit(ClientID)
            'Alert.Show("All updates will be rolled back. " & ex.Message)
            ScriptManager.RegisterClientScriptBlock(Me, GetType(PermissionPage), "converttomultierror", String.Format("alert('Cannot convert this client. {0}');", ex.Message.Replace("'", "")), True)
            Return
        End Try
        'Refresh Page
        Refresh()
    End Sub

    Public Sub lnkConvertFeeStruct_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkConvertFeeStruct.Click
        Try
            SDModelHelper.ConvertToServiceFeeCapModel(ClientID, UserID)
        Catch ex As Exception
            ScriptManager.RegisterClientScriptBlock(Me, GetType(PermissionPage), "converttofeneweerror", String.Format("alert('Error while converting this client to the new fee structure. {0}');", ex.Message.Replace("'", "")), True)
            Return
        End Try
        'Refresh Page
        Refresh()
    End Sub

    Public Sub MultiDep_BankChanged() Handles multipleDepositList.BankChanged
        Me.multiDepositListReadOnly.InnerHtml = multipleDepositList.RenderReadOnlyHTML
        UpdateAchRulePanel()
    End Sub

    Public Sub MultiDep_DaysSaved() Handles multipleDepositList.DaysSaved
        UpdateAchRulePanel()
    End Sub

    Private Sub UpdateAchRulePanel()
        Me.RequeryACHRules()
        Me.UpdAchRules.Update()
        Me.RequeryAdHocACH()
        Me.updAdHocPanel.Update()
    End Sub

    Private Function RulesOverlap(ByVal rules As DataTable) As Boolean
        For Each rule As DataRow In rules.Rows
            If RuleOverlap(rules, rule) Then Return True
        Next
        Return False
    End Function

    Private Function RuleOverlap(ByVal rules As DataTable, ByVal rule As DataRow) As Boolean
        Dim startDate As Date = CDate(rule("StartDate"))
        Dim endDate As Date = New Date(2050, 12, 31)
        If Not rule("EndDate") Is DBNull.Value Then endDate = CDate(rule("EndDate"))
        Dim ruleid As Integer = CInt(rule("ruleachid"))

        Dim dv As DataView
        dv = New DataView(rules)
        dv.RowFilter = String.Format("ruleachid <> {0} and ((#{1}# >= startDate and #{1}# <= enddate) or (#{2}#  >= startDate and #{2}# <= enddate) or (#{1}# <= startdate and #{2}# >= enddate)) ", ruleid, startDate, endDate)

        Return (dv.Count > 0)
    End Function

    Public Sub ConvertToBofA_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkConvertToBofA.Click
        Dim BofA As New BofAHelper
        Dim Alert As New Alert

        Dim TrustID As Integer = CStr(CInt(Val(DataHelper.FieldLookup("tblTrust", "TrustID", "Name = 'Woolery'"))))

        Try
            If DataHelper.FieldLookup("tblClient", "TrustID", "ClientID = " & ClientID) <> TrustID.ToString() Then
                'Flag the client for creation
                If BofA.TransferAccount(ClientID) > 0 Then 'The account was flagged for creation
                    Throw New Exception(" This clients account has been flagged for the bank account change.\n\n The change will take affect on the following business day.")
                    'Alert.Show("This client has been flagged and an account will be established this evening with Lexxiom Payment Systems, Inc.")
                End If
            Else
                Throw New Exception("This client already had their account changed. No conversion is necessary.")
                'Alert.Show("This client has an account with Lexxiom Payment Systems, Inc.. No conversion is necessary.")
                Exit Sub
            End If
        Catch ex As Exception
            ScriptManager.RegisterClientScriptBlock(Me, GetType(PermissionPage), "converttomultierror", String.Format("alert('Status for this client: {0}');", ex.Message.Replace("'", "")), True)
        End Try
    End Sub

End Class
