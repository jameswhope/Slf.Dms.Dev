Imports System.Data.SqlClient
Imports System.Data

Partial Class portals_advertiser_Default
    Inherits System.Web.UI.Page
    Private userID As Integer
    Private AdvertiserID As Integer

    Protected Sub portals_advertiser_Default_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        userID = Page.User.Identity.Name
        If Not IsPostBack Then
            loadAdvertiserInfo()
        End If
    End Sub
    Private Sub loadAdvertiserInfo()
        Using cu As UserHelper.UserObj = UserHelper.GetUserObject(userID)
            Select Case cu.UserTypeId
                Case 1, 7
                    AdvertiserID = cu.UserTypeUniqueID
                Case Else
                    Response.Redirect(ResolveUrl("~/login.aspx"))
            End Select
        End Using

        Dim ssql As String = "stp_advertisers_select"
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("AdvertiserID", AdvertiserID))
        Using dt As DataTable = SqlHelper.GetDataTable(ssql, Data.CommandType.StoredProcedure, params.ToArray)
            For Each dr As DataRow In dt.Rows
                lblName.Text = dr("Name").ToString
                lblAcctMgr.Text = dr("AccountManager").ToString
                If Not String.IsNullOrEmpty(dr("Street").ToString) Then
                    lblAddress.Text = String.Format("{0}<br/>{1}, {2}  {3}<br/>{4}", _
                                                    dr("Street").ToString, _
                                                    dr("City").ToString, _
                                                    dr("State").ToString, _
                                                    dr("Zip").ToString, _
                                                    dr("Country").ToString)
                Else
                    lblAddress.Text = "None Listed<br/><br/><br/>"
                End If
                lblWebsite.Text = IIf(String.IsNullOrEmpty(dr("website").ToString), "None Listed", dr("website").ToString)
                Exit For
            Next
        End Using

    End Sub
End Class
