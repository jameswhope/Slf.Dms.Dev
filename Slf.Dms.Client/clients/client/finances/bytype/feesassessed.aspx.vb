Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_finances_bytype_feesassessed
    Inherits System.Web.UI.Page

#Region "Variables"

    Private UserID As Integer
    Public Shadows ClientID As Integer
    Private qs As QueryStringCollection
    Private Total As Decimal = 0

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            ClientID = DataHelper.Nz_int(qs("id"), 0)

            LoadTabStrips()

            If Not IsPostBack Then

                Requery()

                lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
                lnkClient.HRef = "~/clients/client/?id=" & ClientID

            End If

            SetRollups()

        End If

    End Sub
    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = Master.CommonTasks
        If Master.UserEdit Then
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href="""" onclick=""Record_AddTransaction();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_transaction.png") & """ align=""absmiddle""/>Add transaction</a>")
        End If
    End Sub
    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

        tsMain.TabPages(3).Selected = True

    End Sub
    Private Sub LoadTabStrips()

        tsMain.TabPages.Clear()

        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("<span id=""tabCaption0"">Payments</span>", dvPanel0.ClientID, "./?id=" & ClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("<span id=""tabCaption1"">Deposits</span>", dvPanel0.ClientID, "deposits.aspx?id=" & ClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("<span id=""tabCaption2"">Credits</span>", dvPanel0.ClientID, "credits.aspx?id=" & ClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("<span id=""tabCaption3"">Fees&nbsp;Assessed</span>", dvPanel0.ClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("<span id=""tabCaption4"">Fee&nbsp;Adjustments</span>", dvPanel0.ClientID, "feeadjustments.aspx?id=" & ClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("<span id=""tabCaption5"">Debits</span>", dvPanel0.ClientID, "debits.aspx?id=" & ClientID))

    End Sub
    Private Shared Function Peel_int_nullable(ByVal rd As IDataReader, ByVal field As String) As Nullable(Of Integer)
        Dim i As Integer = rd.GetOrdinal(field)
        If rd.IsDBNull(i) Then
            Return Nothing
        Else
            Return rd.GetInt32(i)
        End If
    End Function
    Private Sub Requery()
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetTransactionByType_Fees")
            DatabaseHelper.AddParameter(cmd, "clientid", ClientID)

            Using cmd.Connection
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()

                    rpPayments.DataSource = rd
                    rpPayments.DataBind()

                    rpPayments.Visible = rpPayments.Items.Count > 0
                    pnlNone.Visible = Not rpPayments.Visible
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

    Private Sub rpPayments_ItemDataBound(sender As Object, e As RepeaterItemEventArgs) Handles rpPayments.ItemDataBound
        If e.Item.ItemType = ListItemType.Item OrElse e.Item.ItemType = ListItemType.AlternatingItem Then
            If IsDBNull(DataBinder.Eval(e.Item.DataItem, "Void")) And IsDBNull(DataBinder.Eval(e.Item.DataItem, "Bounce")) Then
                Total += Convert.ToDecimal(DataBinder.Eval(e.Item.DataItem, "Amount"))
            End If
        ElseIf e.Item.ItemType = ListItemType.Footer Then
                TryCast(rpPayments.Controls(rpPayments.Controls.Count - 1).Controls(0).FindControl("lblPaidTotal"), Label).Text = Decimal.Round(Total, 2).ToString("C")
        End If
    End Sub
End Class
