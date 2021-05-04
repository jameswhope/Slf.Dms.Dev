Imports System.Data.SqlClient
Imports System.Data

Partial Class portals_buyer_Default
    Inherits System.Web.UI.Page
    Private BuyerID As Integer
    Private Userid As Integer
    Private Sub LoadBuyerInfo()
        Using cu As UserHelper.UserObj = UserHelper.GetUserObject(Userid)
            Select Case cu.UserTypeId
                Case 1, 6
                    BuyerID = cu.UserTypeUniqueID
                Case Else
                    Response.Redirect(ResolveUrl("~/login.aspx"))
            End Select
        End Using
        Dim ssql As String = "SELECT * from tblBuyers where buyerid = @buyerid"
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("BuyerID", BuyerID))
        Using dt As DataTable = SqlHelper.GetDataTable(ssql, Data.CommandType.Text, params.ToArray)
            For Each dr As DataRow In dt.Rows
                lblName.Text = dr("Buyer").ToString
                lblAcctMgr.Text = dr("AccountManager").ToString
                If Not String.IsNullOrEmpty(dr("Address").ToString) Then
                    lblAddress.Text = String.Format("{0}<br/>{1}, {2}  {3}<br/>{4}", _
                                                    dr("Address").ToString, _
                                                    dr("City").ToString, _
                                                    dr("StateAbbrev").ToString, _
                                                    dr("ZipCode").ToString, _
                                                    dr("Country").ToString)
                Else
                    lblAddress.Text = "None Listed<br/><br/><br/>"
                End If
                Exit For
            Next
        End Using
    End Sub

    Protected Sub portals_buyer_Default_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Userid = Page.User.Identity.Name
        If Not IsPostBack Then
            LoadBuyerInfo()
        End If
    End Sub
End Class
