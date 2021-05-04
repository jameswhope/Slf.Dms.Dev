Imports System.Data
Imports Drg.Util.DataAccess

Partial Class Clients_Enrollment_EditMarkets
    Inherits System.Web.UI.Page

    Private UserID As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Not Page.IsPostBack Then
            LoadMarkets()
        End If
    End Sub

    Private Sub LoadMarkets()
        gvList.DataSource = SmartDebtorHelper.GetMarkets
        gvList.DataBind()
    End Sub

    Protected Sub btnCombine_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCombine.Click
        Dim intLeadMarketID As Integer
        Dim chkMarket As CheckBox
        Dim ids As String = ""
        Dim aIds() As String

        For Each row As GridViewRow In gvList.Rows
            If row.RowType = DataControlRowType.DataRow Then
                intLeadMarketID = CInt(gvList.DataKeys(row.RowIndex).Value)
                chkMarket = CType(row.FindControl("chkMarket"), CheckBox)
                If chkMarket.Checked Then
                    If Len(ids) = 0 Then
                        ids = CStr(intLeadMarketID)
                    Else
                        ids &= "," & CStr(intLeadMarketID)
                    End If
                End If
            End If
        Next

        aIds = ids.Split(",")

        If aIds.Length > 1 Then
            SmartDebtorHelper.CombineMarkets(aIds)
            lblMsgs.Text = "Markets saved. " & Now
            LoadMarkets()
        Else
            lblMsgs.Text = "<font color='red'>No markets selected. At least 2 markets must be selected to combine.</font>"
        End If
    End Sub

    Protected Sub btnRename_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRename.Click
        Dim intLeadMarketID As Integer
        Dim txtMarket As TextBox

        For Each row As GridViewRow In gvList.Rows
            If row.RowType = DataControlRowType.DataRow Then
                intLeadMarketID = CInt(gvList.DataKeys(row.RowIndex).Value)
                txtMarket = CType(row.FindControl("txtMarket"), TextBox)
                SmartDebtorHelper.RenameMarket(intLeadMarketID, txtMarket.Text, UserID)
            End If
        Next

        lblMsgs.Text = "Markets saved. " & Now
    End Sub
End Class
