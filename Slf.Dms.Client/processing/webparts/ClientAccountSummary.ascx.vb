Imports System.Data

Partial Class processing_webparts_ClientAccountSummary
    Inherits System.Web.UI.UserControl
    Private _NumberOfAccounts As Integer
    Public Event GridSorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs)

    Public Property NumberOfAccounts() As Integer
        Get
            Return _NumberOfAccounts
        End Get
        Set(ByVal value As Integer)
            _NumberOfAccounts = value
        End Set
    End Property
    Public Sub LoadAccounts(ByVal DataClientID As Integer)

        dsSummary.SelectParameters("clientid").DefaultValue = DataClientID
        dsSummary.DataBind()
        gvSummary.DataBind()

    End Sub


    Protected Sub gvSummary_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSummary.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow

                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)

                Select Case rowView("AccountStatusID").ToString
                    Case "54"
                        e.Row.Style("background-color") = "rgb(210,255,210)"
                    Case "55"
                        e.Row.Style("background-color") = "rgb(255,210,210)"
                End Select

                Dim strAcct As String = e.Row.Cells(1).Text.Replace("(duplicate)", "")
                If strAcct.Length > 3 And strAcct.ToString <> "&nbsp;" Then
                    e.Row.Cells(1).Text = Right(strAcct, 4)
                End If


        End Select
    End Sub

    

    Protected Sub dsSummary_Selected(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles dsSummary.Selected
        _NumberOfAccounts = e.AffectedRows.ToString
    End Sub

    Protected Sub gvSummary_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvSummary.Sorting
        RaiseEvent GridSorting(sender, e)
    End Sub
End Class
