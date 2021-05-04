Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports SharedFunctions

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_accounts_default
    Inherits System.Web.UI.Page

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
    Public QueryString As String
    Private qs As QueryStringCollection
    Private baseTable As String = "tblClient"

    Protected accountTotal As Double
    Protected accountTotalActive As Double
    Protected originalTotal As Double
    Protected originalTotalActive As Double
    Protected notRepTotal As Double
    Protected notRepOrigTotal As Double

    Private UserID As Integer
    Private relations As New List(Of SharedFunctions.DocRelation)

#End Region

#Region "rpAccounts_Display"

    Public Function rpAccounts_AccountNumber(ByVal Row As RepeaterItem, ByVal Detail As Boolean) As String

        Dim OriginalCreditorID As Integer = StringHelper.ParseInt(Row.DataItem("OriginalCreditorID"))
        Dim OriginalAccountNumber As String = Convert.ToString(Row.DataItem("OriginalAccountNumber"))
        Dim CurrentCreditorID As Integer = StringHelper.ParseInt(Row.DataItem("CurrentCreditorID"))
        Dim CurrentAccountNumber As String = Convert.ToString(Row.DataItem("CurrentAccountNumber"))

        Dim Values As New List(Of String)

        If OriginalAccountNumber.Length > 0 Then
            Values.Add(Snippet(OriginalAccountNumber))
        End If

        If Detail And CurrentAccountNumber.Length > 0 And (Not OriginalCreditorID = CurrentCreditorID) _
            And (Not OriginalAccountNumber = CurrentAccountNumber) Then
            Values.Add(Snippet(CurrentAccountNumber))
        End If

        If Values.Count > 0 Then
            Return String.Join("<br>", Values.ToArray)
        Else
            Return "&nbsp;"
        End If

    End Function
    Public Function rpAccounts_ReferenceNumber(ByVal Row As RepeaterItem, ByVal Detail As Boolean) As String

        Dim OriginalCreditorID As Integer = StringHelper.ParseInt(Row.DataItem("OriginalCreditorID"))
        Dim OriginalReferenceNumber As String = Convert.ToString(Row.DataItem("OriginalReferenceNumber"))
        Dim CurrentCreditorID As Integer = StringHelper.ParseInt(Row.DataItem("CurrentCreditorID"))
        Dim CurrentReferenceNumber As String = Convert.ToString(Row.DataItem("CurrentReferenceNumber"))

        Dim Values As New List(Of String)

        If OriginalReferenceNumber.Length > 0 Then
            Values.Add(Snippet(OriginalReferenceNumber))
        End If

        If Detail And CurrentReferenceNumber.Length > 0 And (Not OriginalCreditorID = CurrentCreditorID) _
            And (Not OriginalReferenceNumber = CurrentReferenceNumber) Then
            Values.Add(Snippet(CurrentReferenceNumber))
        End If

        If Values.Count > 0 Then
            Return String.Join("<br>", Values.ToArray)
        Else
            Return "&nbsp;"
        End If

    End Function
    Public Function rpAccounts_CreditorName(ByVal Row As RepeaterItem, ByVal Detail As Boolean) As String

        Dim OriginalCreditorID As Integer = StringHelper.ParseInt(Row.DataItem("OriginalCreditorID"))
        Dim OriginalCreditorName As String = Convert.ToString(Row.DataItem("OriginalCreditorName"))
        Dim CurrentCreditorID As Integer = StringHelper.ParseInt(Row.DataItem("CurrentCreditorID"))
        Dim CurrentCreditorName As String = Convert.ToString(Row.DataItem("CurrentCreditorName"))

        If Detail Then
            If OriginalCreditorID = CurrentCreditorID Then 'same creditor
                Return OriginalCreditorName
            Else
                Return OriginalCreditorName & "<br>" & "<img style=""margin:3 0 0 5;"" src=""" _
                    & ResolveUrl("~/") & "images/arrow_end.png"" align=""absmiddle"" border=""0"" />" _
                    & CurrentCreditorName
            End If
        Else
            Return OriginalCreditorName
        End If

    End Function
    Public Function rpAccounts_CreditorPhone(ByVal Row As RepeaterItem) As String

        Dim OriginalCreditorID As Integer = StringHelper.ParseInt(Row.DataItem("OriginalCreditorID"))
        Dim OriginalCreditorPhone As String = Convert.ToString(Row.DataItem("OriginalCreditorPhone"))
        Dim CurrentCreditorID As Integer = StringHelper.ParseInt(Row.DataItem("CurrentCreditorID"))
        Dim CurrentCreditorPhone As String = Convert.ToString(Row.DataItem("CurrentCreditorPhone"))

        Dim Values As New List(Of String)

        If OriginalCreditorPhone.Length > 0 Then
            Values.Add(LocalHelper.FormatPhone(OriginalCreditorPhone))
        End If

        If Not OriginalCreditorID = CurrentCreditorID Then 'not same creditor
            If CurrentCreditorPhone.Length > 0 Then
                Values.Add(LocalHelper.FormatPhone(CurrentCreditorPhone))
            End If
        End If

        If Values.Count > 0 Then
            Return String.Join("<br>", Values.ToArray)
        Else
            Return "&nbsp;"
        End If

    End Function

#End Region

    Public Function rpAccounts_Comms(ByVal NumComms As Object) As String

        If StringHelper.ParseInt(Convert.ToString(NumComms)) > 0 Then
            Return "<img src=""" & ResolveUrl("~/images/11x16_paperclip.png") & """ border=""0""/>"
        Else
            Return "&nbsp;"
        End If

    End Function

    Public Function rpNR_CreditorName(ByVal Row As RepeaterItem, ByVal Detail As Boolean) As String
        If Not IsDBNull(Row.DataItem("OriginalCreditor")) Then
            If Detail Then
                Return Convert.ToString(Row.DataItem("OriginalCreditor")) & "<br>" & "<img style=""margin:3 0 0 5;"" src=""" _
                & ResolveUrl("~/") & "images/arrow_end.png"" align=""absmiddle"" border=""0"" />" _
                & Convert.ToString(Row.DataItem("CurrentCreditor"))
            Else
                Return Convert.ToString(Row.DataItem("OriginalCreditor"))
            End If
        Else
            Return Convert.ToString(Row.DataItem("CurrentCreditor"))
        End If
    End Function

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        PrepQuerystring()

        If Not qs Is Nothing Then
            If Not IsPostBack Then
                relations = SharedFunctions.DocumentAttachment.GetRelationsForClient(ClientID)
                lnkClient.InnerText = ClientHelper.GetDefaultPersonName(DataClientID)
                lnkClient.HRef = "~/clients/client/" & QueryString

                LocalHelper.LoadValues(GetControls(), Me)
            End If

            LoadAccounts()
            SetRollups()

        End If

    End Sub
    Private Sub PrepQuerystring()

        'prep querystring for pages that need those variables
        QueryString = New QueryStringBuilder(Request.Url.Query).QueryString

        If QueryString.Length > 0 Then
            QueryString = "?" & QueryString
        End If

    End Sub
    Public Function GetAttachmentText(ByVal id As Integer, ByVal type As String) As String
        For Each rel As SharedFunctions.DocRelation In relations
            If rel.RelationID = id And rel.RelationType = type Then
                Return "<img src=""" + ResolveUrl("~/images/11x16_paperclip.png") + """ border="""" alt="""" />"
            End If
        Next

        Return "&nbsp"
    End Function

    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = Master.CommonTasks
        If Master.UserEdit Then
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_AddAccount();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_accounts.png") & """ align=""absmiddle""/>Add new account</a>")
        End If

        txtSelectedControlsClientIDs.Value = lnkDeleteConfirm.ClientID

        'only show delete optoin if client account has NOT finished verification)
        tdDelete.Visible = (DataHelper.FieldLookup("tblClient", "VWUWResolved", "ClientID = " & ClientID).Length = 0)
        
    End Sub
    Public Function Snippet(ByVal s As Object) As String

        If IsDBNull(s) OrElse s Is Nothing Then
            Return ""
        ElseIf CType(s, String).Length <= 4 Then
            Return CType(s, String)
        Else
            Return "***" & CType(s, String).Substring(CType(s, String).Length - 4)
        End If

    End Function
    Private Sub SetStyle()

        colReferenceNumber.Visible = Not (ddlType.SelectedIndex = 0)
        thReferenceNumber.Visible = Not (ddlType.SelectedIndex = 0)
        colVerified.Visible = Not (ddlType.SelectedIndex = 0)
        thVerified.Visible = Not (ddlType.SelectedIndex = 0)
        colColor.Visible = (ddlType.SelectedIndex = 0)
        thColor.Visible = (ddlType.SelectedIndex = 0)

        phStatistics.Visible = (ddlType.SelectedIndex = 0)

        colPhone.Visible = Not (ddlType.SelectedIndex = 0)
        thPhone.Visible = Not (ddlType.SelectedIndex = 0)
        colOriginalAmount.Visible = Not (ddlType.SelectedIndex = 0)
        thOriginalAmount.Visible = Not (ddlType.SelectedIndex = 0)
        tdOriginalTotal1.Visible = Not (ddlType.SelectedIndex = 0)
        tdOriginalTotal2.Visible = Not (ddlType.SelectedIndex = 0)

        colPercent.Visible = (ddlType.SelectedIndex = 0)
        thPercent.Visible = (ddlType.SelectedIndex = 0)

    End Sub
    Private Sub LoadAccounts()

        SetStyle()

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("get_ClientAccountSums")
            DatabaseHelper.AddParameter(cmd, "ClientID", DataClientID)
            If chkHideRemoved.Checked Then DatabaseHelper.AddParameter(cmd, "Removed", False)
            If chkHideSettled.Checked Then DatabaseHelper.AddParameter(cmd, "Settled", False)

            Using cmd.Connection
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    If rd.Read Then
                        accountTotal = DatabaseHelper.Peel_float(rd, "Total")
                        accountTotalActive = DatabaseHelper.Peel_float(rd, "TotalActive")
                        originalTotal = DatabaseHelper.Peel_float(rd, "OriginalTotal")
                        originalTotalActive = DatabaseHelper.Peel_float(rd, "OriginalTotalActive")
                    End If
                End Using
            End Using
        End Using

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("get_ClientAccountOverviewList")
            DatabaseHelper.AddParameter(cmd, "ClientID", DataClientID)
            If chkHideRemoved.Checked Then DatabaseHelper.AddParameter(cmd, "Removed", False)
            If chkHideSettled.Checked Then DatabaseHelper.AddParameter(cmd, "Settled", False)

            Using cmd.Connection
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    rpAccounts.DataSource = rd
                    rpAccounts.DataBind()
                End Using
            End Using
        End Using

        Dim tblNR As DataTable = SqlHelper.GetDataTable("exec stp_CreditLiabilitiesNR " & DataClientID, CommandType.Text)

        rpNR.DataSource = tblNR
        rpNR.DataBind()

        For Each row As DataRow In tblNR.Rows
            notRepTotal += CDbl(row("currentamount"))
            notRepOrigTotal += CDbl(row("originalamount"))
        Next

        rpAccounts.Visible = (rpAccounts.Items.Count > 0 Or tblNR.Rows.Count > 0)
        pnlNoAccounts.Visible = Not rpAccounts.Visible
    End Sub
    Protected Function GetBackgroundColor(ByVal removed As Object, ByVal settled As Object, ByVal verified As Object, ByVal NR As Object, ByVal PA As Object, ByVal StatusCode As Object) As String
        If Not IsDBNull(removed) Then
            Return " style=""background-color:rgb(255,210,210)"" "
        ElseIf Not IsDBNull(settled) AndAlso StatusCode = "SA" AndAlso Not IsDBNull(PA) AndAlso PA > 0 Then
            Return " style=""background-color:#CEECF5"" "
        ElseIf Not IsDBNull(settled) AndAlso StatusCode = "SA" Then
            Return " style=""background-color:rgb(210,255,210)"" "
        ElseIf Not IsDBNull(NR) Then
            Return " style=""background-color:#DEDEDE"" "
        ElseIf verified = 0 And IsDBNull(settled) Then
            Return " style=""background-color:#FFFF99"" "
        Else
            Return ""
        End If
    End Function
    Protected Function GetAccountColor(ByVal index As Integer) As String
        Dim c As Color = BaseGraphHandler.DefaultColors(index Mod (BaseGraphHandler.DefaultColors.Length - 1))

        Return "#" + c.R.ToString("x2") + c.G.ToString("x2") + c.B.ToString("x2")
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
    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click

        If txtSelectedAccounts.Value.Length > 0 Then

            'get selected "," delimited AccountID's
            Dim Accounts() As String = txtSelectedAccounts.Value.Split(",")

            'build an actual integer array
            Dim AccountIDs As New List(Of Integer)

            For Each Account As String In Accounts
                AccountIDs.Add(DataHelper.Nz_int(Account))
            Next

            'delete array of PersonID's
            AccountHelper.Delete(AccountIDs.ToArray())

        End If

        'reload same page (of accounts)
        Response.Redirect(Request.Url.AbsoluteUri)

    End Sub

    Private Function GetControls() As Dictionary(Of String, Control)

        Dim c As New Dictionary(Of String, Control)

        c.Add(ddlType.ID, ddlType)
        c.Add(chkHideRemoved.ID, chkHideRemoved)
        c.Add(chkHideSettled.ID, chkHideSettled)

        Return c

    End Function
    Protected Sub ddlType_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlType.SelectedIndexChanged

        If ddlType.SelectedValue = "0" Then 'group adjustments
            QuerySettingHelper.Delete("UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = 'ddlType'")
        Else
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "ddlType", "value", ddlType.SelectedValue)
        End If
    End Sub
    Protected Sub chkHideRemoved_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkHideRemoved.CheckedChanged

        If Not chkHideRemoved.Checked Then
            QuerySettingHelper.Delete("UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = 'chkHideRemoved'")
        Else
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "chkHideRemoved", "value", chkHideRemoved.Checked)
        End If
    End Sub
    Protected Sub chkHideSettled_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkHideSettled.CheckedChanged

        If Not chkHideSettled.Checked Then
            QuerySettingHelper.Delete("UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = 'chkHideSettled'")
        Else
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "chkHideSettled", "value", chkHideSettled.Checked)
        End If
    End Sub

    Protected Sub lnkVerAction_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkVerAction.Click
        Dim rtrHelper As New RtrFeeAdjustmentHelper

        If txtSelectedAccounts.Value.Length > 0 Then
            'get selected "," delimited AccountID's
            Dim Accounts() As String = txtSelectedAccounts.Value.Split(",")
            'build an actual integer array
            Dim AccountIDs As New List(Of Integer)
            For Each Account As String In Accounts
                AccountIDs.Add(DataHelper.Nz_int(Account))
            Next

            For Each acctID As Integer In AccountIDs

                Dim PreviousAmount As Double = AccountHelper.GetCurrentAmount(acctID)
                Dim PreviousFee As Double = AccountHelper.GetSumRetainerFees(acctID)
                Dim SetupFeePercentage As Double = DataHelper.FieldLookup("tblaccount", "SetupFeePercentage", String.Format("accountid = {0}", acctID))

                'save verified amount
                DataHelper.FieldUpdate("tblCreditorInstance", "Amount", StringHelper.ParseDouble(PreviousAmount), _
                    "CreditorInstanceID = " & AccountHelper.GetCurrentCreditorInstanceID(acctID))

                'update original/current amounts on master account
                AccountHelper.SetWarehouseValues(acctID)


                'adjust retainer fee if suppose to
                If chkAdjustRet.Checked Then
                    Dim ChangeIt As Boolean = rtrHelper.ShouldRtrFeeChange(ClientID, UserID)
                    If ChangeIt Then
                        ClientHelper.CleanupRegister(ClientID)
                    End If
                End If

                'lock verification
                AccountHelper.LockVerification(acctID, PreviousAmount, PreviousFee, DateTime.Now, UserID, _
                    StringHelper.ParseDouble(PreviousAmount), AccountHelper.GetSumRetainerOrAdditionalAccountFees(acctID))

            Next


        End If

        'reload same page (of accounts)
        Response.Redirect(Request.Url.AbsoluteUri)

      
    End Sub
End Class