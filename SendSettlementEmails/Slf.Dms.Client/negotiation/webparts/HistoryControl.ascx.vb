Imports LexxiomWebPartsControls
Imports System.Data
Partial Class negotiation_webparts_HistoryControl
    Inherits System.Web.UI.UserControl
    Public Event SelectOffer(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
    Public DataClientID As String
    Public accountID As String
#Region "Subs/Funcs"
    Public Sub BindGrid(ByVal sClientID As String, ByVal sCreditorID As String)

        Me.historyHiddenIDs.Value = sClientID & ":" & sCreditorID

        Dim sqlSelect As String = "SELECT [SettlementID], [OfferDirection], [CreditorAccountBalance], [SettlementPercent], [SettlementAmount], [SettlementDueDate], [SettlementSavings], [SettlementFee], [SettlementCost],  [Status], [Created], [OfferDirection] FROM [tblSettlements] "
        sqlSelect += "WHERE CreditorAccountID = " & sCreditorID & " and clientid = " & sClientID
        sqlSelect += " ORDER BY [Created] Desc"

        Me.SqlDataSource1.SelectCommand = sqlSelect
        Me.SqlDataSource1.DataBind()

        Me.GridView1.DataBind()

    End Sub
#End Region
#Region "Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        'Me.GridView1.DataBind()
        If Not IsPostBack Then
            DataClientID = Request.QueryString("cid")
            accountID = Request.QueryString("crid")
            If accountID Is Nothing And DataClientID Is Nothing Then
                Exit Sub
            End If
            Me.historyHiddenIDs.Value = DataClientID & ":" & accountID
            BindGrid(DataClientID, accountID)
        End If

    End Sub
    Protected Sub GridView1_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles GridView1.PageIndexChanging
        Dim ids As String() = Me.historyHiddenIDs.Value.ToString.Split(":")

        Dim sqlSelect As String = "SELECT [SettlementID], [OfferDirection], [CreditorAccountBalance], [SettlementPercent], [SettlementAmount], [SettlementDueDate], [SettlementSavings], [SettlementFee], [SettlementCost],  [Status], [Created], [OfferDirection] FROM [tblSettlements] "
        sqlSelect += "WHERE CreditorAccountID = " & ids(1) & " and clientid = " & ids(0)

        Me.SqlDataSource1.SelectCommand = sqlSelect
        Me.SqlDataSource1.DataBind()

        Me.GridView1.PageIndex = e.NewPageIndex
        Me.GridView1.DataBind()
    End Sub
    Protected Sub GridView1_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles GridView1.RowCommand
        Select Case e.CommandName.ToLower
            Case "select"
                RaiseEvent SelectOffer(sender, e)
        End Select
    End Sub
    Protected Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#DADAFA'; this.style.filter = 'alpha(opacity=75)';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = ''; this.style.filter = '';")

                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                Dim img As Image = e.Row.FindControl("imgDir")

                Select Case rowView("offerdirection").ToString
                    Case "Made"
                        img.ImageUrl = "~/negotiation/images/offerout.png"
                    Case "Received"
                        img.ImageUrl = "~/negotiation/images/offerin.png"
                End Select



        End Select
    End Sub
    Protected Sub GridView1_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles GridView1.Sorting
        Try
            Dim ids As String() = Me.historyHiddenIDs.Value.ToString.Split(":")

            Dim sqlSelect As String = "SELECT [SettlementID], [OfferDirection],[CreditorAccountBalance], [SettlementPercent], [SettlementAmount], [SettlementDueDate], [SettlementSavings], [SettlementFee], [SettlementCost], [Status], [Created], [OfferDirection] FROM [tblSettlements] "
            sqlSelect += "WHERE CreditorAccountID = " & ids(1) & " and clientid = " & ids(0)
            sqlSelect += " ORDER BY " & e.SortExpression

            Me.SqlDataSource1.SelectCommand = sqlSelect
            Me.SqlDataSource1.DataBind()

            Me.GridView1.DataBind()
        Catch ex As Exception


        End Try

    End Sub
#End Region
End Class
