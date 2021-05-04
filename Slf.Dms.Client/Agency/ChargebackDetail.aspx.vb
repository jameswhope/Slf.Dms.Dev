Imports Drg.Util.DataAccess

Partial Class Agency_ChargebackDetail
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            lblInfo.Text = Request.QueryString("payment").Replace("other", "All Other Payments").Replace("first", "First Payments") & " > " & Request.QueryString("type") & " > " & Request.QueryString("datepartname")
        End If
    End Sub
    Protected Sub ugDetail_InitializeLayout(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.LayoutEventArgs) Handles ugDetail.InitializeLayout
        e.Layout.Bands(0).Columns.FromKey("Amount").Format = "c"
        e.Layout.Bands(0).Columns.FromKey("Amount").CellStyle.Padding.Right = New Unit(15)
        e.Layout.Bands(0).Columns.FromKey("Amount").CellStyle.HorizontalAlign = HorizontalAlign.Right
        e.Layout.Bands(0).Columns.FromKey("Amount").Header.Style.HorizontalAlign = HorizontalAlign.Right
        e.Layout.Bands(0).Columns.FromKey("Amount").Header.Style.Padding.Right = New Unit(15)

        e.Layout.Bands(0).Columns.FromKey("client name").Header.Style.HorizontalAlign = HorizontalAlign.Left
        e.Layout.Bands(0).Columns.FromKey("client name").CellStyle.HorizontalAlign = HorizontalAlign.Left
        e.Layout.Bands(0).Columns.FromKey("client name").Width = New Unit(300)

        e.Layout.Bands(0).Columns.FromKey("Recipient").IsGroupByColumn = True
        e.Layout.Bands(0).Columns.FromKey("Recipient").CellStyle.Width = New Unit(300)

        e.Layout.Bands(0).Columns.FromKey("Chargeback Reason").IsGroupByColumn = True
        e.Layout.Bands(0).Columns.FromKey("Fee").IsGroupByColumn = True

        e.Layout.Bands(0).GroupByRowDescriptionMask = "[value] : [count:Amount] item(s), totalling [sum:Amount]"
    End Sub
End Class
