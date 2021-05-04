Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_finances_mediation_default
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

    Private MediationThreshold As Double
    Public QueryString As String
    Private qs As QueryStringCollection

    Private AmountRequiredTotal As Double
    Private OriginalAmountTotal As Double
    Private CurrentAmountTotal As Double

    Private UsedAmount As Double
    Private UsedPercentageTotal As Double
    Private UsedPercentageCurrent As Double

    Private TabStripPage As Integer

    Private UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        PrepQuerystring()

        If Not qs Is Nothing Then

            TabStripPage = DataHelper.Nz_int(qs("tsp"))

            LoadTabStrips()

            If Not IsPostBack Then

                LoadStatistics()
                LoadAccounts()
                LoadMediations()

                lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
                lnkClient.HRef = "~/clients/client/" & QueryString

                trInfoBoxNewMediations.Visible = DataHelper.FieldCount("tblUserInfoBox", "UserInfoBoxID", _
                    "UserID = " & UserID & " AND InfoBoxID = " & 7) = 0

                trInfoBoxDisbursementGrid.Visible = DataHelper.FieldCount("tblUserInfoBox", "UserInfoBoxID", _
                    "UserID = " & UserID & " AND InfoBoxID = " & 3) = 0

            End If

            SetRollups()

        End If

    End Sub
    Private Sub LoadTabStrips()

        tsMain.TabPages.Clear()

        tsMain.TabPages.Add(New TabPage("New&nbsp;Negotiation", dvPage0.ClientID))
        tsMain.TabPages.Add(New TabPage("Disbursement&nbsp;Grid", dvPage1.ClientID))
        tsMain.TabPages.Add(New TabPage("Existing&nbsp;Negotiations", dvPage2.ClientID))

        If TabStripPage > tsMain.TabPages.Count Then
            tsMain.TabPages(tsMain.TabPages.Count - 1).Selected = True
        Else
            tsMain.TabPages(TabStripPage).Selected = True
        End If

    End Sub
    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

        'set the proper pane on, others off
        Dim Pages As New List(Of HtmlGenericControl)

        Pages.Add(dvPage0)
        Pages.Add(dvPage1)
        Pages.Add(dvPage2)

        For Each Page As HtmlGenericControl In Pages

            If Page.ID.Substring(Page.ID.Length - 1, 1) = tsMain.SelectedIndex Then
                Page.Style("display") = "inline"
            Else
                Page.Style("display") = "none"
            End If

        Next

    End Sub
    Private Sub PrepQuerystring()

        'prep querystring for pages that need those variables
        QueryString = New QueryStringBuilder(Request.Url.Query).QueryString

        If QueryString.Length > 0 Then
            QueryString = "?" & QueryString
        End If

    End Sub
    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = Master.CommonTasks
        If master.useredit Then
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_ResetMatrix();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_accounts_refresh.png") & """ align=""absmiddle""/>Reset matrix values</a>")

        End If
        txtSelectedControlsClientIDs.Value = lnkDeleteConfirm.ClientID

    End Sub
    Private Sub LoadStatistics()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetStatsOverviewForClient")

        DatabaseHelper.AddParameter(cmd, "ClientID", DataClientID)

        Using cmd
            Using cmd.Connection

                cmd.Connection.Open()
                rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

                If rd.Read() Then

                    Dim RegisterBalance As Double = DatabaseHelper.Peel_double(rd, "RegisterBalance")
                    Dim FrozenBalance As Double = DatabaseHelper.Peel_double(rd, "FrozenBalance")
                    Dim AvailableAmount As Double = RegisterBalance - FrozenBalance

                    lblSDAAccountBalanceDisbursementGrid.Text = RegisterBalance.ToString("$#,##0.00")
                    lblFrozenAmountDisbursementGrid.Text = FrozenBalance.ToString("$#,##0.00")
                    lblAvailableAmount.Text = AvailableAmount.ToString("#,##0.00")

                    lblSDAAccountBalanceNewMediations.Text = RegisterBalance.ToString("$#,##0.00")
                    lblFrozenAmountNewMediations.Text = FrozenBalance.ToString("$#,##0.00")

                    If RegisterBalance < 0 Then
                        lblSDAAccountBalanceNewMediations.ForeColor = Color.Red
                        lblSDAAccountBalanceDisbursementGrid.ForeColor = Color.Red
                    Else
                        If RegisterBalance > 0 Then
                            lblSDAAccountBalanceNewMediations.ForeColor = Color.FromArgb(0, 139, 0)
                            lblSDAAccountBalanceDisbursementGrid.ForeColor = Color.FromArgb(0, 139, 0)
                        End If
                    End If

                    If AvailableAmount < 0 Then
                        lblAvailableAmount.ForeColor = Color.Red
                    Else
                        If AvailableAmount > 0 Then
                            lblAvailableAmount.ForeColor = Color.FromArgb(0, 139, 0)
                        End If
                    End If

                    If RegisterBalance > 0 Then
                        If RegisterBalance > FrozenBalance Then 'have balance to work with
                            lblInfoBoxDisbursementGrid.Text = "Use the matrix below to best determine what you should negotiate."
                        Else 'frozen balance trumped register balance
                            lblInfoBoxDisbursementGrid.Text = "You must release some frozen money, before attempting negotiation."
                        End If
                    Else 'register balance is negative
                        lblInfoBoxDisbursementGrid.Text = "As such, no negotiations may occur at this point."
                    End If

                    MediationThreshold = DataHelper.Nz_double(PropertyHelper.Value("MediationThreshold"))

                    Dim NumOverThreshold As Integer = ClientHelper.GetNumAccountsOverThreshold(DataClientID, _
                        AvailableAmount, MediationThreshold)

                    If NumOverThreshold = 0 Then
                        lblInfoBoxNewMediations.Text = "This client currently has no unsettled accounts that " _
                        & "are over the " & MediationThreshold.ToString("#,##0.00%") & " threshold."
                    Else
                        If NumOverThreshold = 1 Then
                            lblInfoBoxNewMediations.Text = "This client currently has 1 unsettled account " _
                            & "that is over the " & MediationThreshold.ToString("#,##0.00%") & " threshold."
                        Else
                            lblInfoBoxNewMediations.Text = "This client currently has " _
                                & NumOverThreshold & " unsettled accounts that are over the " _
                                & MediationThreshold.ToString("#,##0.00%") & " threshold."
                        End If
                    End If

                End If

            End Using
        End Using

    End Sub
    Private Sub LoadAccounts()

        Dim Accounts As New List(Of Account)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetAccounts")

            DatabaseHelper.AddParameter(cmd, "Where", "WHERE ClientID = " & DataClientID & " AND Settled IS NULL")
            DatabaseHelper.AddParameter(cmd, "OrderBy", "ORDER BY CreditorName, tblAccount.AccountID")

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    While rd.Read()

                        Accounts.Add(New Account(DatabaseHelper.Peel_int(rd, "AccountID"), _
                            DatabaseHelper.Peel_int(rd, "ClientID"), _
                            DatabaseHelper.Peel_double(rd, "OriginalAmount"), _
                            DatabaseHelper.Peel_double(rd, "CurrentAmount"), _
                            DatabaseHelper.Peel_int(rd, "CurrentCreditorInstanceID"), _
                            DatabaseHelper.Peel_double(rd, "SetupFeePercentage"), _
                            DatabaseHelper.Peel_date(rd, "OriginalDueDate"), _
                            DatabaseHelper.Peel_int(rd, "CreditorID"), _
                            DatabaseHelper.Peel_string(rd, "CreditorName"), _
                            DatabaseHelper.Peel_string(rd, "CreditorStreet"), _
                            DatabaseHelper.Peel_string(rd, "CreditorStreet2"), _
                            DatabaseHelper.Peel_string(rd, "CreditorCity"), _
                            DatabaseHelper.Peel_int(rd, "CreditorStateID"), _
                            DatabaseHelper.Peel_string(rd, "CreditorStatename"), _
                            DatabaseHelper.Peel_string(rd, "CreditorStateAbbreviation"), _
                            DatabaseHelper.Peel_string(rd, "CreditorZipCode"), _
                            DatabaseHelper.Peel_int(rd, "ForCreditorID"), _
                            DatabaseHelper.Peel_string(rd, "ForCreditorName"), _
                            DatabaseHelper.Peel_string(rd, "ForCreditorStreet"), _
                            DatabaseHelper.Peel_string(rd, "ForCreditorStreet2"), _
                            DatabaseHelper.Peel_string(rd, "ForCreditorCity"), _
                            DatabaseHelper.Peel_int(rd, "ForCreditorStateID"), _
                            DatabaseHelper.Peel_string(rd, "ForCreditorStatename"), _
                            DatabaseHelper.Peel_string(rd, "ForCreditorStateAbbreviation"), _
                            DatabaseHelper.Peel_string(rd, "ForCreditorZipCode"), _
                            DatabaseHelper.Peel_date(rd, "Acquired"), _
                            DatabaseHelper.Peel_string(rd, "AccountNumber"), _
                            DatabaseHelper.Peel_string(rd, "ReferenceNumber"), _
                            DatabaseHelper.Peel_date(rd, "Created"), _
                            DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                            DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                            DatabaseHelper.Peel_date(rd, "LastModified"), _
                            DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                            DatabaseHelper.Peel_string(rd, "LastModifiedByName"), _
                            DatabaseHelper.Peel_ndate(rd, "Settled"), _
                            DatabaseHelper.Peel_int(rd, "SettledBy"), _
                            DatabaseHelper.Peel_string(rd, "SettledByName"), _
                            rd("CreditorValidated"), _
                            rd("ForCreditorValidated"), _
                            DatabaseHelper.Peel_int(rd, "CreditorGroupID"), _
                            DatabaseHelper.Peel_int(rd, "ForCreditorGroupID")))

                    End While

                End Using
            End Using
        End Using

        If Accounts.Count > 0 Then

            rpAccountsNewMediations.DataSource = Accounts
            rpAccountsNewMediations.DataBind()

            rpAccountsDisbursementGrid.DataSource = Accounts
            rpAccountsDisbursementGrid.DataBind()

        End If

        trNoAccountsNewMediations.Visible = (Accounts.Count = 0)
        trNoAccountsDisbursementGrid.Visible = (Accounts.Count = 0)

    End Sub
    Private Sub LoadMediations()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetMediationsForClient")

        DatabaseHelper.AddParameter(cmd, "ClientID", DataClientID)

        Dim Mediations As New List(Of Mediation)

        Using cmd
            Using cmd.Connection
                Using rd

                    cmd.Connection.Open()
                    rd = cmd.ExecuteReader()

                    While rd.Read()

                        Mediations.Add(New Mediation(DatabaseHelper.Peel_int(rd, "MediationID"), _
                            DatabaseHelper.Peel_int(rd, "AccountID"), _
                            DatabaseHelper.Peel_int(rd, "ClientID"), _
                            DatabaseHelper.Peel_double(rd, "OriginalAmount"), _
                            DatabaseHelper.Peel_double(rd, "CurrentAmount"), _
                            DatabaseHelper.Peel_int(rd, "CurrentCreditorInstanceID"), _
                            DatabaseHelper.Peel_string(rd, "AccountNumber"), _
                            DatabaseHelper.Peel_int(rd, "CurrentCreditorID"), _
                            DatabaseHelper.Peel_string(rd, "CurrentCreditorName"), _
                            DatabaseHelper.Peel_double(rd, "RegisterBalance"), _
                            DatabaseHelper.Peel_double(rd, "AccountBalance"), _
                            DatabaseHelper.Peel_double(rd, "SettlementPercentage"), _
                            DatabaseHelper.Peel_double(rd, "SettlementAmount"), _
                            DatabaseHelper.Peel_double(rd, "AmountAvailable"), _
                            DatabaseHelper.Peel_double(rd, "AmountBeingSent"), _
                            DatabaseHelper.Peel_ndate(rd, "DueDate"), _
                            DatabaseHelper.Peel_double(rd, "Savings"), _
                            DatabaseHelper.Peel_double(rd, "SettlementFee"), _
                            DatabaseHelper.Peel_double(rd, "OvernightDeliveryAmount"), _
                            DatabaseHelper.Peel_double(rd, "SettlementCost"), _
                            DatabaseHelper.Peel_double(rd, "AvailableAfterSettlement"), _
                            DatabaseHelper.Peel_double(rd, "AmountBeingPaid"), _
                            DatabaseHelper.Peel_double(rd, "AmountStillOwed"), _
                            DatabaseHelper.Peel_string(rd, "Status"), _
                            DatabaseHelper.Peel_double(rd, "FrozenAmount"), _
                            DatabaseHelper.Peel_date(rd, "Created"), _
                            DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                            DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                            DatabaseHelper.Peel_date(rd, "LastModified"), _
                            DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                            DatabaseHelper.Peel_string(rd, "LastModifiedByName")))

                    End While

                    If Mediations.Count > 0 Then

                        rpMediations.DataSource = Mediations
                        rpMediations.DataBind()

                    End If

                    rpMediations.Visible = Mediations.Count > 0
                    pnlNoMediations.Visible = Mediations.Count = 0

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

        If txtSelectedMediations.Value.Length > 0 Then

            'get selected "," delimited MediationID's
            Dim Mediations() As String = txtSelectedMediations.Value.Split(",")

            'build an actual integer array
            Dim MediationIDs As New List(Of Integer)

            For Each Mediation As String In Mediations
                MediationIDs.Add(DataHelper.Nz_int(Mediation))
            Next

            'delete array of MediationID's
            MediationHelper.Delete(MediationIDs.ToArray())

        End If

        'reload same page (of applicants)
        Response.Redirect(Request.Url.AbsoluteUri)

    End Sub
    Protected Sub lnkCloseInformationNewMediations_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCloseInformationNewMediations.Click

        'insert flag record
        UserInfoBoxHelper.Insert(7, UserID)

        'reload
        Response.Redirect(Request.Url.AbsoluteUri)

    End Sub
    Protected Sub lnkCloseInformationDisbursementGrid_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCloseInformationDisbursementGrid.Click

        'insert flag record
        UserInfoBoxHelper.Insert(3, UserID)

        'reload
        Response.Redirect(Request.Url.AbsoluteUri)

    End Sub
    Protected Sub rpAccountsNewMediations_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rpAccountsNewMediations.ItemDataBound

        Dim NumAccounts As Integer = CType(rpAccountsNewMediations.DataSource, List(Of Account)).Count

        Dim CurrentAmount As Double = e.Item.DataItem.CurrentAmount
        Dim AmountRequired As Double = CurrentAmount * MediationThreshold
        Dim AvailableAmount As Double = DataHelper.Nz_double(lblAvailableAmount.Text, 0)
        Dim CurrentPercentHas As Double = AvailableAmount / CurrentAmount
        Dim CurrentPercentNeeds As Double = MediationThreshold - CurrentPercentHas

        Dim lblPercentRequired As Label = CType(e.Item.FindControl("lblPercentRequired"), Label)
        Dim lblAmountRequired As Label = CType(e.Item.FindControl("lblAmountRequired"), Label)
        Dim imgAvailable As HtmlImage = CType(e.Item.FindControl("imgAvailable"), HtmlImage)
        Dim lblPercentCurrentHas As Label = CType(e.Item.FindControl("lblPercentCurrentHas"), Label)
        Dim lblPercentCurrentNeeds As Label = CType(e.Item.FindControl("lblPercentCurrentNeeds"), Label)
        Dim lnkMediateNewMediations As HtmlAnchor = CType(e.Item.FindControl("lnkMediateNewMediations"), HtmlAnchor)

        AmountRequiredTotal += AmountRequired
        OriginalAmountTotal += e.Item.DataItem.OriginalAmount
        CurrentAmountTotal += CurrentAmount

        lblPercentRequired.Text = MediationThreshold.ToString("#,##0.00%")
        lblAmountRequired.Text = AmountRequired.ToString("c")

        lblPercentCurrentHas.Text = CurrentPercentHas.ToString("#,##0.00%")
        lblPercentCurrentNeeds.Text = CurrentPercentNeeds.ToString("#,##0.00%")

        If CurrentPercentNeeds <= 0 Then
            lblPercentCurrentNeeds.Text = "0.00%"
            imgAvailable.Src = "~/images/16x16_check.png"
            lblPercentCurrentHas.Style("color") = "rgb(0,129,0)"
            lblPercentCurrentNeeds.Style("color") = "rgb(0,129,0)"
        Else
            imgAvailable.Src = "~/images/16x16_arrowright (thin gray).png"
        End If

        lnkMediateNewMediations.HRef = ResolveUrl("~/clients/client/creditors/mediation/calculator.aspx?a=a&aid=") _
            & e.Item.DataItem.AccountID & "&sa=" & AvailableAmount

        If e.Item.ItemIndex = NumAccounts - 1 Then 'last one

            lblPercentRequiredTotal.Text = MediationThreshold.ToString("#,##0.00%")
            lblAmountRequiredTotal.Text = AmountRequiredTotal.ToString("c")
            lblOriginalAmountTotal.Text = OriginalAmountTotal.ToString("c")
            lblCurrentAmountTotal.Text = CurrentAmountTotal.ToString("c")

            CurrentPercentHas = AvailableAmount / CurrentAmountTotal
            CurrentPercentNeeds = MediationThreshold - CurrentPercentHas

            lblPercentCurrentHastotal.Text = CurrentPercentHas.ToString("#,##0.00%")
            lblPercentCurrentNeedstotal.Text = CurrentPercentNeeds.ToString("#,##0.00%")

        End If

    End Sub
    Protected Sub rpAccountsDisbursementGrid_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rpAccountsDisbursementGrid.ItemDataBound

        Dim NumAccounts As Integer = CType(rpAccountsDisbursementGrid.DataSource, List(Of Account)).Count
        Dim AvailableAmount As Double = DataHelper.Nz_double(lblAvailableAmount.Text, 0)

        Dim txtAmount As TextBox = CType(e.Item.FindControl("txtAmount"), TextBox)
        Dim txtPercentageTotal As TextBox = CType(e.Item.FindControl("txtPercentageTotal"), TextBox)
        Dim txtPercentageCurrent As TextBox = CType(e.Item.FindControl("txtPercentageCurrent"), TextBox)

        txtAmount.Text = (AvailableAmount / NumAccounts).ToString("###0.00")
        txtPercentageTotal.Text = (100 / NumAccounts).ToString("###0.00")
        txtPercentageCurrent.Text = (((AvailableAmount / NumAccounts) / DataHelper.Nz_double(e.Item.DataItem.CurrentAmount)) * 100).ToString("###0.00")

        UsedAmount += StringHelper.ParseDouble(txtAmount.Text, 0)
        UsedPercentageTotal += StringHelper.ParseDouble(txtPercentageTotal.Text, 0)
        UsedPercentageCurrent += StringHelper.ParseDouble(txtPercentageCurrent.Text, 0)

        txtAmount.Attributes("onblur") = "txtAmount_OnBlur(this);"
        txtPercentageTotal.Attributes("onblur") = "txtPercentageTotal_OnBlur(this)"
        txtPercentageCurrent.Attributes("onblur") = "txtPercentageCurrent_OnBlur(this);"

        txtAmount.Attributes("onkeypress") = "AllowOnlyNumbers();"
        txtPercentageTotal.Attributes("onkeypress") = "AllowOnlyNumbers();"
        txtPercentageCurrent.Attributes("onkeypress") = "AllowOnlyNumbers();"

        If e.Item.ItemIndex = NumAccounts - 1 Then 'last one
            lblUsedAmount.Text = UsedAmount.ToString("#,##0.00")
            lblUsedPercentageTotal.Text = UsedPercentageTotal.ToString("#,##0.00")
            lblUsedPercentageCurrent.Text = UsedPercentageCurrent.ToString("#,##0.00")
        End If

    End Sub
    Protected Sub lnkResetMatrix_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkResetMatrix.Click

        'reload same page
        Response.Redirect(Request.Url.AbsoluteUri)

    End Sub
End Class