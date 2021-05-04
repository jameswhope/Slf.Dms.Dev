Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Collections.Generic
Imports System.Data.SqlClient

Partial Class clients_client_finances_bytype_addfa
    Inherits PermissionPage

#Region "Variables"

    Private Shadows ClientID As Integer

    Private qs As QueryStringCollection

    Private UserID As Integer

#End Region

#Region "rpFees Display"

    Public Function rpFees_IFP(ByVal IsFullyPaid As Boolean) As String
        If IsFullyPaid Then
            Return "&nbsp;"
        Else
            Return "<img src=""" & ResolveUrl("~/images/16x16_check.png") & """ border=""0"" align=""absmiddle"" />"
        End If
    End Function
    Public Function rpFees_Void(ByVal Void As Object) As String
        If Void Is DBNull.Value Then
            Return "&nbsp;"
        Else
            Return "<img src=""" & ResolveUrl("~/images/16x16_check.png") & """ border=""0"" align=""absmiddle"" />"
        End If
    End Function
    Public Function rpFees_Associations(ByVal Row As RepeaterItem) As String

        Dim EntryTypeID As Integer = StringHelper.ParseInt(Row.DataItem("EntryTypeID"))
        Dim EntryTypeName As String = Convert.ToString(Row.DataItem("EntryTypeName"))
        Dim AdjustedRegisterID As Object = Row.DataItem("AdjustedRegisterID")
        Dim AccountID As Object = Row.DataItem("AccountID")

        Dim Parts As New List(Of String)

        If Not AdjustedRegisterID Is DBNull.Value Then

            Dim Icon As String = String.Empty

            Dim Amount As Double = StringHelper.ParseDouble(Row.DataItem("Amount"))
            Dim AdjustedRegisterEntryTypeName As String = Convert.ToString(Row.DataItem("AdjustedRegisterEntryTypeName"))

            If Not EntryTypeName = "Payment" Then
                If Amount < 0 Then
                    Icon = "<img style=""margin-right:8;"" src=""" & ResolveUrl("~/images/12x13_arrow_up.png") & """ align=""absmiddle"" title=""Up"" />"
                Else
                    Icon = "<img style=""margin-right:8;"" src=""" & ResolveUrl("~/images/12x13_arrow_down.png") & """ align=""absmiddle"" title=""Down"" />"
                End If
            End If

            Parts.Add(Icon & AdjustedRegisterEntryTypeName & " " & Convert.ToString(AdjustedRegisterID))

        ElseIf EntryTypeID = 1 Then 'maintenance fee

            Dim FeeMonth As Object = Row.DataItem("FeeMonth")
            Dim FeeYear As Object = Row.DataItem("FeeYear")

            If Not FeeMonth Is DBNull.Value AndAlso Not FeeYear Is DBNull.Value Then
                Parts.Add(New DateTime(StringHelper.ParseInt(FeeYear), StringHelper.ParseInt(FeeMonth), 1).ToString("MMMM yyyy"))
            End If

        ElseIf EntryTypeID = 3 Then 'deposit

            Dim CheckNumber As String = Convert.ToString(Row.DataItem("CheckNumber"))
            Dim ACHMonth As Object = Row.DataItem("ACHMonth")
            Dim ACHYear As Object = Row.DataItem("ACHYear")

            If CheckNumber.Length > 0 Then
                Parts.Add("CHK # " & CheckNumber)
            End If

            If Not ACHMonth Is DBNull.Value AndAlso Not ACHYear Is DBNull.Value Then
                Parts.Add("ACH for " & New DateTime(StringHelper.ParseInt(ACHYear), StringHelper.ParseInt(ACHMonth), 1).ToString("MMM yyyy"))
            End If

        ElseIf Not AccountID Is DBNull.Value Then

            Dim AccountCreditorName As String = Convert.ToString(Row.DataItem("AccountCreditorName"))
            Dim AccountNumber As String = Convert.ToString(Row.DataItem("AccountNumber"))

            If AccountNumber.Length > 3 Then
                Parts.Add(AccountCreditorName & " ****" & AccountNumber.Substring(AccountNumber.Length - 4))
            Else
                Parts.Add(AccountNumber)
            End If

        End If

        If Parts.Count > 0 Then
            Return String.Join(", ", Parts.ToArray())
        Else
            Return "&nbsp;"
        End If

    End Function

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            ClientID = DataHelper.Nz_int(qs("id"), 0)

            If Not IsPostBack Then

                LoadFees()
                LoadRecord()
                LoadReasons()

            End If

            SetupAttributes()
            SetupCommonTasks()

        End If

    End Sub
    Private Sub LoadReasons()
        'adjusted reasons
        Using cmd As New SqlCommand("SELECT TranAdjustedReasonID, DisplayName FROM tblTranAdjustedReason", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        ddlAdjReason.Items.Add(New ListItem(reader("DisplayName"), reader("TranAdjustedReasonID")))
                    End While
                End Using
            End Using
        End Using

        ddlAdjReason.Items.Add(New ListItem("-- SELECT --", "SELECT"))
        ddlAdjReason.SelectedValue = "SELECT"

    End Sub
    
    Private Sub SetupAttributes()

        ddlDirection.Attributes("onchange") = "ResetTotals();"
        txtAmount.Attributes("onkeypress") = "AllowOnlyNumbers();"
        txtAmount.Attributes("onkeyup") = "ResetTotals();"

    End Sub
    Private Sub SetupCommonTasks()

        Dim CommonTasks As List(Of String) = Master.CommonTasks

        If Master.UserEdit Then

            If Permission.UserEdit(Master.IsMy) Then
                'add applicant tasks
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save fee adjustment</a>")
            Else
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_back.png") & """ align=""absmiddle""/>Return</a>")
            End If

            'add normal tasks

        End If

        lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
        lnkClient.HRef = "~/clients/client/?id=" & ClientID
        lnkFinanceRegister.HRef = "~/clients/client/finances/register/?id=" & ClientID

    End Sub
    Private Sub LoadFees()

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetTransactions")

            DatabaseHelper.AddParameter(cmd, "RegisterWhere", "WHERE r.ClientID = " & ClientID & " AND et.Fee = 1 AND r.Void IS NULL AND r.Bounce IS NULL")
            DatabaseHelper.AddParameter(cmd, "PaymentWhere", "WHERE 0=1")
            DatabaseHelper.AddParameter(cmd, "OrderBy", "ORDER BY r.TransactionDate, r.RegisterID")

            Using cn As IDbConnection = cmd.Connection

                cn.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    rpFees.DataSource = rd
                    rpFees.DataBind()

                    If rpFees.Items.Count > 6 Then
                        dvFees.Style("overflow") = "auto"
                        dvFees.Style("height") = "184"
                    End If

                End Using
            End Using
        End Using

    End Sub
    Private Sub LoadRecord()

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

        'get last page referrer by cycling backwards
        Dim Navigator As Navigator = CType(Page.Master, clients_client).MasterNavigator

        Dim i As Integer = Navigator.Pages.Count - 1

        While i >= 0 AndAlso (Navigator.Pages(i).Url.IndexOf("bytype/add.aspx") = -1 _
            Or Navigator.Pages(i).Url.IndexOf("bytype/addfa.aspx") = -1) 'not found

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
        Close()
    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        Dim RegisterID As Integer

        Dim AdjustedRegisterID As Integer = CType(txtSelected.Text, Integer)

        Dim FeeAdjustmentID As Integer = StringHelper.ParseInt(DataHelper.FieldLookup("tblEntryType", "EntryTypeID", "[Name] = 'Fee Adjustment'"), 0)

        Dim Amount As Double = 0.0

        If ddlDirection.SelectedValue = "0" Then 'up
            Amount = Math.Abs(StringHelper.ParseDouble(txtAmount.Text, 0)) * -1
        Else
            Amount = Math.Abs(StringHelper.ParseDouble(txtAmount.Text, 0))
        End If

        RegisterID = RegisterHelper.InsertFeeAdjustment(ClientID, AdjustedRegisterID, StringHelper.ParseDateTime(txtTransactionDate.Text, _
            DateTime.Now), txtDescription.Text, Math.Round(Amount, 2), FeeAdjustmentID, UserID, True)

        Dim sSQL As String = String.Format("update tblRegister set AdjustedReasonID = {0} where RegisterId = {1}", ddlAdjReason.SelectedItem.Value, RegisterID)
        Lexx.SqlDataHelper.SqlHelper.ExecuteNonQuery(New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString), _
                                                      CommandType.Text, _
                                                      sSQL)

        'return
        Close()

    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))

    End Sub
End Class