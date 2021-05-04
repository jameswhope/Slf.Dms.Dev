Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports SharedFunctions

Imports Slf.Dms.Records

Imports System.Data
Imports System.Collections.Generic

Partial Class clients_client_finances_bytype_addf
    Inherits PermissionPage

#Region "Variables"

    Public ClientID As Integer
    Private qs As QueryStringCollection

    Private UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            ClientID = DataHelper.Nz_int(qs("id"), 0)

            If Not IsPostBack Then
                hdnTempRegisterID.Value = SharedFunctions.DocumentAttachment.GetUniqueTempID()

                LoadDocuments()

                LoadEntryTypes(cboEntryTypeID, "-- Select a fee --", 0, "Fee = 1 AND Type = 'Debit' AND not EntryTypeID = 42")

                LoadFeeMonthsYears()
                LoadAccounts()
                LoadMediators()

            End If

            SetupAttributes()
            SetupCommonTasks()

        End If

    End Sub
    Private Sub SetupAttributes()

        cboEntryTypeID.Attributes("onchange") = "cboEntryTypeID_OnChange(this);"

    End Sub
    Private Sub LoadEntryTypes(ByVal cbo As DropDownList, ByVal EmptyText As String, ByVal SelectedID As Integer, _
        ByVal Criteria As String)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblEntryType WHERE " & Criteria & " ORDER BY [Order], [Name]"

        Dim SelectionWasMade As Boolean = False

        cbo.Items.Clear()

        Dim liEmpty As New ListItem(EmptyText, 0)

        cbo.Items.Add(liEmpty)

        Using cmd
            Using cmd.Connection

                cmd.Connection.Open()
                rd = cmd.ExecuteReader()

                While rd.Read()

                    Dim EntryTypeID As Integer = DatabaseHelper.Peel_int(rd, "EntryTypeID")
                    Dim Name As String = DatabaseHelper.Peel_string(rd, "Name")

                    Dim li As New ListItem(Name, EntryTypeID)

                    cbo.Items.Add(li)

                    If EntryTypeID = SelectedID Then

                        cbo.ClearSelection()
                        li.Selected = True
                        SelectionWasMade = True

                    Else
                        li.Selected = False
                    End If

                End While

            End Using
        End Using

        If Not SelectionWasMade Then
            cbo.ClearSelection()
            liEmpty.Selected = True
        End If

        cbo.Attributes("lastIndex") = cbo.SelectedIndex.ToString()

    End Sub
    Private Sub LoadFeeMonthsYears()

        cboFeeMonth.Items.Clear()
        cboFeeMonth.Items.Add(New ListItem("-- Month --", 0))

        For i As Byte = 1 To 12
            cboFeeMonth.Items.Add(New ListItem(i & " - " & New DateTime(DateTime.Now.Year, i, 1).ToString("MMMMM"), i))
        Next

        cboFeeYear.Items.Clear()
        cboFeeYear.Items.Add(New ListItem("-- Year --", 0))
        cboFeeYear.Items.Add(New ListItem(DateTime.Now.Year - 3, DateTime.Now.Year - 1))
        cboFeeYear.Items.Add(New ListItem(DateTime.Now.Year - 2, DateTime.Now.Year - 1))
        cboFeeYear.Items.Add(New ListItem(DateTime.Now.Year - 1, DateTime.Now.Year - 1))
        cboFeeYear.Items.Add(New ListItem(DateTime.Now.Year, DateTime.Now.Year))
        cboFeeYear.Items.Add(New ListItem(DateTime.Now.Year + 1, DateTime.Now.Year + 1))

    End Sub
    Private Sub LoadAccounts()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetAccountsForClient")

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

        cboAccountID.Items.Clear()
        cboAccountID.Items.Add(New ListItem("-- Select an account --", 0))

        Using cmd
            Using cmd.Connection

                cmd.Connection.Open()
                rd = cmd.ExecuteReader()

                While rd.Read()

                    Dim AccountID As Integer = DatabaseHelper.Peel_int(rd, "AccountID")
                    Dim AccountNumber As String = DatabaseHelper.Peel_string(rd, "AccountNumber")
                    Dim CreditorName As String = DatabaseHelper.Peel_string(rd, "CreditorName")
                    Dim CurrentAmount As Double = DatabaseHelper.Peel_double(rd, "CurrentAmount")

                    If AccountNumber.Length > 4 Then AccountNumber = "*" & AccountNumber.Substring(AccountNumber.Length - 4)
                    Dim li As New ListItem(AccountNumber & " - " & CreditorName & " (" & CurrentAmount.ToString("c") & ")", AccountID)

                    cboAccountID.Items.Add(li)

                End While

            End Using
        End Using

    End Sub
    Private Sub LoadMediators()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetMediators")

        cboMediatorID.Items.Clear()
        cboMediatorID.Items.Add(New ListItem("-- Select a mediator --", 0))

        Using cmd
            Using cmd.Connection

                cmd.Connection.Open()
                rd = cmd.ExecuteReader()

                While rd.Read()

                    Dim UserID As Integer = DatabaseHelper.Peel_int(rd, "UserID")
                    Dim FirstName As String = DatabaseHelper.Peel_string(rd, "FirstName")
                    Dim LastName As String = DatabaseHelper.Peel_string(rd, "LastName")

                    Dim li As New ListItem(LastName & ", " & FirstName, UserID)

                    cboMediatorID.Items.Add(li)

                End While

            End Using
        End Using

    End Sub
    Private Sub SetupCommonTasks()

        Dim CommonTasks As List(Of String) = Master.CommonTasks

        If Master.UserEdit Then

            If Permission.UserEdit(Master.IsMy) Then
                'add applicant tasks
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save new fee</a>")
            Else
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_back.png") & """ align=""absmiddle""/>Return</a>")
            End If

            'add normal tasks

        End If

        lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
        lnkClient.HRef = "~/clients/client/?id=" & ClientID
        lnkFinanceRegister.HRef = "~/clients/client/finances/register/?id=" & ClientID

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:OpenScanning();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_file_remove.png") & """ align=""absmiddle""/>Scan Document</a>")

    End Sub
    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""clients_client_applicants_applicant_default""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function
    Private Sub Close()

        'get last page referrer by cycling backwards
        Dim Navigator As Navigator = CType(Page.Master, clients_client).MasterNavigator

        Dim i As Integer = Navigator.Pages.Count - 1

        While i >= 0 AndAlso (Navigator.Pages(i).Url.IndexOf("bytype/add.aspx") = -1 _
            Or Navigator.Pages(i).Url.IndexOf("bytype/addf.aspx") = -1) 'not found

            'decrement i
            i -= 1

        End While

        If i >= 0 Then
            Response.Redirect(Navigator.Pages(i).Url)
        Else
            Response.Redirect("~/clients/client/finances/register/?id=" & ClientID)
        End If

    End Sub
    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        SharedFunctions.DocumentAttachment.DeleteAllForItem(hdnTempRegisterID.Value, "register", UserID)
        Close()
    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        Dim RegisterID As Integer

        Dim FeeMonth As Nullable(Of Integer) = Nothing
        Dim FeeYear As Nullable(Of Integer) = Nothing
        Dim AccountID As Nullable(Of Integer) = Nothing
        Dim MediatorID As Nullable(Of Integer) = Nothing

        Dim Amount As Double = Math.Abs(StringHelper.ParseDouble(txtAmount.Text, 0.0)) * -1

        If Not cboFeeMonth.SelectedValue = 0 Then
            FeeMonth = StringHelper.ParseInt(cboFeeMonth.SelectedValue, 0)
        End If

        If Not cboFeeYear.SelectedValue = 0 Then
            FeeYear = StringHelper.ParseInt(cboFeeYear.SelectedValue, 0)
        End If

        If Not cboAccountID.SelectedValue = 0 Then
            AccountID = StringHelper.ParseInt(cboAccountID.SelectedValue, 0)
        End If

        If Not cboMediatorID.SelectedValue = 0 Then
            MediatorID = StringHelper.ParseInt(cboMediatorID.SelectedValue, 0)
        End If

        RegisterID = RegisterHelper.InsertFee(Nothing, ClientID, AccountID, StringHelper.ParseDateTime(txtTransactionDate.Text, _
            DateTime.Now), txtDescription.Text, Amount, StringHelper.ParseInt(cboEntryTypeID.SelectedValue, 0), MediatorID, _
            FeeMonth, FeeYear, UserID, True)

        SharedFunctions.DocumentAttachment.SolidifyTempRelation(hdnTempRegisterID.Value, "register", ClientID, RegisterID)

        'return
        Close()

    End Sub
    Protected Sub lnkDeleteDocument_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteDocument.Click
        SharedFunctions.DocumentAttachment.DeleteAttachment(hdnCurrentDoc.Value, UserID)
        LoadDocuments()
    End Sub
    Private Sub LoadDocuments()
        rpDocuments.DataSource = documentHelper.GetDocumentsForRelation(hdnTempRegisterID.Value, "register")
        rpDocuments.DataBind()

        If rpDocuments.DataSource.Count > 0 Then
            hypDeleteDoc.Disabled = False
        Else
            hypDeleteDoc.Disabled = True
        End If
    End Sub
    Protected Sub lnkShowDocs_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkShowDocs.Click
        LoadDocuments()
    End Sub
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
    End Sub
End Class