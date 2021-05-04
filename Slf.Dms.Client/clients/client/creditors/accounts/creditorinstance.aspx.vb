Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_accounts_creditorinstance
    Inherits EntityPage

#Region "Variables"

    Private Action As String
    Private CreditorInstanceID As Integer
    Private CurrentCreditorInstanceID As Integer
    Private AccountID As Integer
    Public Shadows ClientID As Integer
    Private qs As QueryStringCollection

    Public UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            ClientID = DataHelper.Nz_int(qs("id"), 0)
            CreditorInstanceID = DataHelper.Nz_int(qs("ciid"), 0)
            AccountID = DataHelper.Nz_int(qs("aid"), 0)
            CurrentCreditorInstanceID = DataHelper.FieldLookup("tblAccount", "CurrentCreditorInstanceID", "AccountID=" & AccountID)
            Action = DataHelper.Nz_string(qs("a"))

            If Not IsPostBack Then
                HandleAction()
            End If

            SetRollups()
            SetAttributes()

        End If

    End Sub
    Private Sub SetAttributes()
        txtOriginalAmount.Attributes("onkeypress") = "AllowOnlyNumbers();"
        txtCurrentAmount.Attributes("onkeypress") = "AllowOnlyNumbers();"
    End Sub
    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = Master.CommonTasks

        If Master.UserEdit Then

            'add applicant tasks
            If Permission.UserEdit(Master.IsMy) Then
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save this instance</a>")
            Else
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_back.png") & """ align=""absmiddle""/>Return</a>")
            End If

            If Not Action = "a" And Permission.UserDelete(Master.IsMy) Then
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_DeleteConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_delete.png") & """ align=""absmiddle""/>Delete this instance</a>")
            End If

        End If

        lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
        lnkClient.HRef = "~/clients/client/?id=" & ClientID
        lnkAccounts.HRef = "~/clients/client/creditors/accounts/?id=" & ClientID
        lnkAccount.HRef = "~/clients/client/creditors/accounts/account.aspx?id=" & ClientID & "&aid=" & AccountID
        lnkAccount.InnerHtml = AccountHelper.GetCreditorName(AccountID)

    End Sub
    Private Sub HandleAction()

        Select Case Action
            Case "a"    'add
                'lblCreditorInstance.Text = "Add New Creditor Instance"
                NewInfo.visible = True
                LoadRecord(CurrentCreditorInstanceID, True)
                txtAcquired.Text = Now.ToString("MM/dd/yyyy")
            Case Else   'edit
                LoadRecord(CreditorInstanceID, False)
        End Select

    End Sub
    Private Sub LoadRecord(ByVal ci As Integer, ByVal IsNew As Boolean)

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            cmd.CommandText = "SELECT * FROM tblcreditorinstance ci inner join tblcreditor c on ci.creditorid=c.creditorid where ci.creditorinstanceid=@ciid"

            DatabaseHelper.AddParameter(cmd, "ciid", ci)

            cmd.Connection.Open()
            Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleRow)

                If rd.Read() Then
                    txtAcquired.Text = DatabaseHelper.Peel_date(rd, "Acquired").ToString("MM/dd/yyyy")
                    txtAccountNumber.Value = DatabaseHelper.Peel_string(rd, "AccountNumber")
                    txtReferenceNumber.Value = DataHelper.Nz_string(DatabaseHelper.Peel_string(rd, "ReferenceNumber"))
                    If IsNew Then
                        txtOriginalAmount.Value = DatabaseHelper.Peel_float(rd, "Amount").ToString("c")
                        txtCurrentAmount.Value = ""
                    Else
                        txtOriginalAmount.Value = DatabaseHelper.Peel_float(rd, "OriginalAmount").ToString("c")
                        txtCurrentAmount.Value = DatabaseHelper.Peel_float(rd, "Amount").ToString("c")
                    End If

                    hdnForCreditor.Value = DataHelper.Nz_int(DatabaseHelper.Peel_int(rd, "ForCreditorID"), -1)
                    hdnCreditor.Value = DatabaseHelper.Peel_int(rd, "CreditorID")

                    txtForCreditor.InnerHtml = SetupCreditorButton(btnForCreditor, DatabaseHelper.Peel_nint(rd, "ForCreditorID"))
                    txtCreditor.InnerHtml = SetupCreditorButton(btnCreditor, DatabaseHelper.Peel_int(rd, "CreditorID"))
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
    Private Sub Close()
        Response.Redirect("~/clients/client/creditors/accounts/account.aspx?id=" & ClientID & "&aid=" & AccountID)
    End Sub
    Private Function InsertOrUpdate() As Integer

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                DatabaseHelper.AddParameter(cmd, "Acquired", DateTime.Parse(txtAcquired.Text))
                DatabaseHelper.AddParameter(cmd, "AccountNumber", txtAccountNumber.Value)
                DatabaseHelper.AddParameter(cmd, "ReferenceNumber", DataHelper.Zn(txtReferenceNumber.Value))
                DatabaseHelper.AddParameter(cmd, "OriginalAmount", Single.Parse(txtOriginalAmount.Value.Replace("$", "")))
                DatabaseHelper.AddParameter(cmd, "Amount", Single.Parse(txtCurrentAmount.Value.Replace("$", "")))

                Dim CreditorParts As String() = hdnCreditor.Value.Split("|")
                Dim CreditorID As Integer = CInt(CreditorParts(0))
                Dim CreditorGroupID As Integer

                If CreditorParts.Length > 1 Then 'creditor changed?
                    CreditorGroupID = CInt(CreditorParts(7))

                    If CreditorID = -1 Then
                        If CreditorGroupID = -1 Then
                            CreditorGroupID = CreditorGroupHelper.InsertCreditorGroup(CreditorParts(1), UserID)
                        End If
                        CreditorID = CreditorHelper.InsertCreditor(CreditorParts(1), CreditorParts(2), CreditorParts(3), CreditorParts(4), Integer.Parse(CreditorParts(5)), CreditorParts(6), UserID, CreditorGroupID)
                    End If
                End If

                DatabaseHelper.AddParameter(cmd, "CreditorID", CreditorID)

                If hdnForCreditor.Value.Length > 0 Then
                    Dim ForCreditorParts As String() = hdnForCreditor.Value.Split("|")

                    If ForCreditorParts.Length > 1 Then 'for creditor changed?
                        Dim ForCreditorID As Integer = CInt(ForCreditorParts(0))
                        Dim ForCreditorGroupID As Integer = CInt(ForCreditorParts(7))

                        If ForCreditorID = -1 Then
                            If ForCreditorGroupID = -1 Then
                                ForCreditorGroupID = CreditorGroupHelper.InsertCreditorGroup(ForCreditorParts(1), UserID)
                            End If
                            ForCreditorID = CreditorHelper.InsertCreditor(ForCreditorParts(1), ForCreditorParts(2), ForCreditorParts(3), ForCreditorParts(4), Integer.Parse(ForCreditorParts(5)), ForCreditorParts(6), UserID, ForCreditorGroupID)
                        End If
                        DatabaseHelper.AddParameter(cmd, "ForCreditorID", ForCreditorID)
                    End If
                Else
                    DatabaseHelper.AddParameter(cmd, "ForCreditorID", DBNull.Value)
                End If

                DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

                If Action = "a" Then 'add

                    DatabaseHelper.AddParameter(cmd, "AccountID", AccountID)
                    DatabaseHelper.AddParameter(cmd, "Created", Now)
                    DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                    
                    DatabaseHelper.BuildInsertCommandText(cmd, "tblCreditorInstance", "CreditorInstanceID", SqlDbType.Int)

                    cmd.Connection.Open()
                    cmd.ExecuteNonQuery()
                Else 'edit
                    DataHelper.AuditedUpdate(cmd, "tblCreditorInstance", CreditorInstanceID, UserID)
                End If

                
            End Using

            If Action = "a" Then 'add
                CreditorInstanceID = DataHelper.Nz_int(cmd.Parameters("@CreditorInstanceID").Value)
            End If

            AccountHelper.SetWarehouseValues(AccountID)

        End Using

        Return CreditorInstanceID

    End Function
    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        InsertOrUpdate()
        Close()

    End Sub
    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click

        CreditorInstanceHelper.Delete(CreditorInstanceID)

        AccountHelper.SetWarehouseValues(AccountID)

        Close()

    End Sub
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))

    End Sub

    Public Overrides ReadOnly Property BaseQueryString() As String
        Get
            Return "aid"
        End Get
    End Property

    Public Overrides ReadOnly Property BaseTable() As String
        Get
            Return "tblAccount"
        End Get
    End Property
    Private Function SetupCreditorButton(ByVal btn As HtmlInputButton, ByVal CreditorId As Nullable(Of Integer)) As String
        btn.Attributes("onclick") = "FindCreditor(this);"

        Dim Creditor As String = "&nbsp;"
        If CreditorId.HasValue Then
            btn.Attributes("creditorid") = CreditorId
            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection
                    cmd.CommandText = "SELECT tblCreditor.*, tblState.Name AS StateName, tblState.Abbreviation AS StateAbbreviation, isnull(g.Name,tblCreditor.Name) AS CreditorName FROM tblCreditor LEFT JOIN tblState ON tblCreditor.StateId=tblState.StateId LEFT JOIN tblCreditorGroup g on g.CreditorGroupID = tblCreditor.CreditorGroupID WHERE tblCreditor.CreditorId=@creditorid"
                    DatabaseHelper.AddParameter(cmd, "creditorid", CreditorId)

                    cmd.Connection.Open()
                    Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleRow)
                        If rd.Read() Then
                            Dim validated As String = "-1"

                            If Not rd("validated") Is DBNull.Value Then
                                validated = IIf(DatabaseHelper.Peel_bool(rd, "validated"), "1", "0")
                            End If

                            Creditor = DatabaseHelper.Peel_string(rd, "creditorname")
                            btn.Attributes("creditor") = Creditor
                            btn.Attributes("street") = DatabaseHelper.Peel_string(rd, "street")
                            btn.Attributes("street2") = DatabaseHelper.Peel_string(rd, "street2")
                            btn.Attributes("city") = DatabaseHelper.Peel_string(rd, "city")
                            btn.Attributes("stateid") = DatabaseHelper.Peel_int(rd, "stateid")
                            btn.Attributes("statename") = DatabaseHelper.Peel_string(rd, "statename")
                            btn.Attributes("stateabbreviation") = DatabaseHelper.Peel_string(rd, "stateabbreviation")
                            btn.Attributes("zipcode") = DatabaseHelper.Peel_string(rd, "zipcode")
                            btn.Attributes("creditorgroupid") = DataHelper.Nz_int(DatabaseHelper.Peel_int(rd, "creditorgroupid"), -1)
                            btn.Attributes("validated") = validated

                            If validated = "0" Then
                                Creditor = "<font color='red'>" & DatabaseHelper.Peel_string(rd, "creditorname") + "</font>&nbsp;"
                                dvErrorAccounts.Style("display") = ""
                            End If
                        End If
                    End Using
                End Using
            End Using
        End If
        Return Creditor
    End Function
End Class