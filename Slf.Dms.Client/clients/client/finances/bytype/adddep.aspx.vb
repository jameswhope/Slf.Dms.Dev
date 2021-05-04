Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports SharedFunctions

Imports Slf.Dms.Records

Imports System.Data
Imports System.Collections.Generic

Partial Class clients_client_finances_bytype_adddep
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
                SetupDefaults()
            End If

            SetupCommonTasks()

        End If

    End Sub

    Private Function GetNextBusinessDate() As DateTime
        Dim dDate As DateTime = Now
        Dim days As Integer = 1
        Do
            dDate = dDate.AddDays(days) '.ToString("MM/dd/yyyy hh:mm tt")
            If dDate.DayOfWeek = DayOfWeek.Saturday Then
                days = 2
            ElseIf dDate.DayOfWeek = DayOfWeek.Sunday OrElse IsBankHoliday(dDate) Then
                days = 1
            Else
                Exit Do
            End If
        Loop
        Return dDate
    End Function

    Private Function IsBankHoliday(ByVal d As DateTime) As Boolean
        Dim HolidayName As String = DataHelper.Nz_string(DataHelper.FieldLookup("tblBankHoliday", "Name", DataHelper.StripTime("Date") & "='" & d.ToString("MM/dd/yyyy") & "'"))
        Return (HolidayName.Trim.Length > 0)
    End Function

    Private Sub SetupDefaults()

        lblHoldBy.Text = UserHelper.GetName(DataHelper.Nz_int(Page.User.Identity.Name))
        lblHoldWhen.Text = DateTime.Now.ToString("MM/dd/yyyy hh:mm tt")

        Me.hdnTrustId.Value = Drg.Util.DataAccess.DataHelper.FieldLookup("tblClient", "trustId", "ClientId = " & ClientID)
        Dim HoldCheckDays As Double = DataHelper.Nz_double(PropertyHelper.Value("HoldCheckDays"))
        Me.hdnCheckHoldDays.Value = HoldCheckDays
        Me.hdnCheckHoldAmount.Value = DataHelper.Nz_double(PropertyHelper.Value("HoldCheckAmount"))

        'If Me.hdnTrustId.Value = 22 Then
        '    Me.chkHold.Checked = True
        '    Me.imHoldDate.Text = GetNextBusinessDate().ToString("MM/dd/yyyy hh:mm tt")
        'Else
        '    imHoldDate.Text = DateTime.Now.AddDays(HoldCheckDays).ToString("MM/dd/yyyy hh:mm tt")
        'End If

        imHoldDate.Text = DateTime.Now.AddDays(HoldCheckDays).ToString("MM/dd/yyyy hh:mm tt")

    End Sub
    Private Sub SetupCommonTasks()

        Dim CommonTasks As List(Of String) = Master.CommonTasks

        If Master.UserEdit Then

            If Permission.UserEdit(Master.IsMy) Then
                'add applicant tasks
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save new deposit</a>")
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
            Or Navigator.Pages(i).Url.IndexOf("bytype/adddep.aspx") = -1) 'not found

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
        SharedFunctions.DocumentAttachment.DeleteAllForItem(hdnTempRegisterID.Value, "note", UserID)

        Close()
    End Sub

    Private Function ValidateShadowSore() As Boolean
        Dim storeOk As Boolean = True
        Try
            Dim store As New WCFClient.Store
            Dim accountNumber As String = DataHelper.FieldLookup("tblclient", "AccountNumber", "Clientid=" & ClientID).Trim
            If accountNumber.Length = 0 Then Throw New Exception("Invalid Account Number.")
            If Not store.StoreExists(New String() {accountNumber}) Then
                store.OpenAccount(ClientID, UserID)
                If store.OpenAccountFailture.Count > 0 Then Throw New Exception("Open Account Failure. " & store.OpenAccountFailture(0))
            End If
        Catch ex As Exception
            storeOk = False
            'ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "shadowstoreerror", "alert(""" & ex.Message & """);", True)
            Throw New Exception("Could not open or validate a shadow store for this client. " & ex.Message)
        End Try
        Return storeOk
    End Function

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        'Validate shadow store. Create shadow store if needed 
        If Me.hdnTrustId.Value = 22 Then
            If Not ValidateShadowSore() Then Return
        End If

        Dim RegisterID As Integer

        Dim Amount As Double = DataHelper.Nz_double(txtAmount.Text)

        If chkHold.Checked Then 'hold was issued

            RegisterID = RegisterHelper.InsertDeposit(ClientID, DataHelper.Nz_date(txtTransactionDate.Text), txtCheckNumber.Text, _
                txtDescription.Text, Amount, 3, DataHelper.Nz_date(imHoldDate.Text), UserID, UserID)

        Else

            RegisterID = RegisterHelper.InsertDeposit(ClientID, DataHelper.Nz_date(txtTransactionDate.Text), txtCheckNumber.Text, _
                txtDescription.Text, Amount, 3, Nothing, Nothing, UserID)

        End If

        SharedFunctions.DocumentAttachment.SolidifyTempRelation(hdnTempRegisterID.Value, "register", ClientID, RegisterID)

        'return
        Close()

    End Sub
    Protected Sub lnkShowDocs_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkShowDocs.Click
        LoadDocuments()
    End Sub
    Protected Sub lnkDeleteDocument_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteDocument.Click
        SharedFunctions.DocumentAttachment.DeleteAttachment(hdnCurrentDoc.Value, UserID)
        LoadDocuments()
    End Sub
    Private Sub LoadDocuments()
        rpDocuments.DataSource = documentHelper.GetDocumentsForRelation(Integer.Parse(hdnTempRegisterID.Value), "register")
        rpDocuments.DataBind()

        If rpDocuments.DataSource.Count > 0 Then
            hypDeleteDoc.Disabled = False
        Else
            hypDeleteDoc.Disabled = True
        End If
    End Sub
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))

    End Sub

End Class