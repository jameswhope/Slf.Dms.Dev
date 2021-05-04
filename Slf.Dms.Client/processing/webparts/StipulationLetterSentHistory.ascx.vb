Imports System.Data

Partial Class processing_webparts_StipulationLetterSentHistory
    Inherits System.Web.UI.UserControl

    Public Sub LoadHistory(ByVal SettlementId As Integer)
        Dim dt As DataTable = SettlementMatterHelper.GetStipulationLetterLog(SettlementId)
        gvStipulation.DataSource = dt
        gvStipulation.DataBind()
        lblHistory.Visible = (dt.Rows.Count > 0)
    End Sub
End Class
