Imports System.Data
Imports System.Web.Services
Imports UserHelper
Imports System.Data.SqlClient

Partial Class admin_users
    Inherits System.Web.UI.Page

#Region "Methods"
    <WebMethod()> _
    Public Shared Function SendNotice(userids As String, type As String, msg As String, userid As String) As String

        Dim result As String = "Notices Sent!!!"
        Dim iCnt As Integer = 0
        Try
            For Each User As String In userids.Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
                PortalHelper.PortalNotification.InsertNotification(User, msg, type, userid)
                iCnt += 1
            Next
            result = String.Format("{0} Notice(s) Sent!", iCnt)
        Catch ex As Exception
            result = ex.Message.ToString
        End Try

        Return result
    End Function
    <WebMethod()> _
    Public Shared Function GetUsers() As String
        Dim result As String = String.Empty
        Dim ssql As String = "SELECT u.UserId, u.FirstName + ' ' +  u.LastName[FullName] FROM tblUser u WHERE (ISNULL(u.Active, 0) = 1) and usertypeid in (5,6,7) order by u.FirstName"

        Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)
            For Each dr As DataRow In dt.Rows
                Dim chk As String = "<p><input id=""chk{0}"" value=""{0}"" type=""checkbox"" />{1}</p>"
                chk = String.Format(chk, dr("userid").ToString, dr("fullname").ToString)
                result += chk
            Next

        End Using

        Return result
    End Function
    <WebMethod()> _
    Public Shared Function GetCompany(roleid As String) As String
        Dim result As String = "Save user"
        Dim lst As New List(Of ItemPair)

        Using dt As DataTable = SqlHelper.GetDataTable(String.Format("stp_users_getRoleIdentity {0}", roleid), CommandType.Text)
            For Each dr As DataRow In dt.Rows
                lst.Add(New ItemPair(dr("uniqueid").ToString, dr("Name").ToString))
            Next
        End Using

        Return Newtonsoft.Json.JsonConvert.SerializeObject(lst)
    End Function
    <WebMethod()> _
    Public Shared Function SaveUser(currentuser As UserObj) As String
        'Public Shared Function SaveUser(userid As String, firstname As String, lastname As String, ext As String, role As String, company As String, group As String, active As String, spanish As String, username As String, password As String) As String
        Dim result As String = "Save user"

        Dim uid As String = UserHelper.SaveUser(currentuser)

        'only for new users
        If currentuser.UserId = -1 Then
            Dim sentByID As String = HttpContext.Current.User.Identity.Name
            Select Case currentuser.UserTypeId
                Case 5
                    PortalHelper.PortalNotification.InsertNotification(uid, "<h1>Welcome to the Affiliate Portal!</h1>", PortalHelper.PortalNotification.enumTypeNotification.pnInfo, sentByID)
                    PortalHelper.PortalNotification.InsertNotification(uid, "<h2>Your New portal is up! Get to know it...</h2><br/><br/><ul><li>Summary - Provides a summary of key information needed.</li><li>Offers - List of current offers running.</li><li>Reports - Breakdown of key data.</li><li>Downloads - Access to the unsubscribe list.</li></ul>'", PortalHelper.PortalNotification.enumTypeNotification.pnInfo, sentByID)
                Case 6
                    PortalHelper.PortalNotification.InsertNotification(uid, "<h1>Welcome to the Buyer Portal!</h1>", PortalHelper.PortalNotification.enumTypeNotification.pnInfo, sentByID)
                    PortalHelper.PortalNotification.InsertNotification(uid, "<h2>Your New portal is up! Get to know it...</h2><br/><br/><ul><li>Summary - Provides a summary of key information needed.</li></ul>", PortalHelper.PortalNotification.enumTypeNotification.pnInfo, sentByID)
                Case 7
                    PortalHelper.PortalNotification.InsertNotification(uid, "<h1>Welcome to the Advertiser Portal!</h1>", PortalHelper.PortalNotification.enumTypeNotification.pnInfo, sentByID)
                    PortalHelper.PortalNotification.InsertNotification(uid, "<h2>Your New portal is up! Get to know it...</h2><br/><br/><ul><li>Summary - Provides a summary of key information needed.</li></ul>", PortalHelper.PortalNotification.enumTypeNotification.pnInfo, sentByID)
            End Select
        End If

        SqlHelper.ExecuteNonQuery(String.Format("delete from tblUserWebsitesX where userid = {0}", uid), CommandType.Text)
        For Each Web As String In currentuser.UserOwnedWebsites
            Dim ssql As String = "stp_users_InsertWebsite"
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("userid", uid))
            params.Add(New SqlParameter("Website", Web))
            SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
        Next

        Return result
    End Function
    <WebMethod()> _
    Public Shared Function LoadUser(userid As String) As String
        Dim uObj As UserHelper.UserObj = Nothing
        Try
            uObj = UserHelper.GetUserObject(userid)
            uObj.UserOwnedWebsites = UserHelper.GetUserWebsites(userid)
        Catch ex As Exception

        End Try

        Return Newtonsoft.Json.JsonConvert.SerializeObject(uObj)
    End Function
    <WebMethod()> _
    Public Shared Function ResetPassword(userid As String, newpassword As String) As String
        Dim result As String = "Password successfully reset! <br/> User will have to change on next log in."
        Try
            If String.IsNullOrEmpty(newpassword) Then
                Return "Password cannot be blank"
            End If

            If Len(newpassword) < 5 Then
                Return "Password cannot be less than 5 characters!"
            End If

            UserHelper.ResetPassword(userid, newpassword)

        Catch ex As Exception
            result = ex.Message
        End Try

        Return result
    End Function

    Public Sub SetPagerButtonStates(ByVal gridView As GridView, ByVal gvPagerRow As GridViewRow, ByVal page As Page)
        Dim pageIndex As Integer = gridView.PageIndex
        Dim pageCount As Integer = gridView.PageCount

        Dim btnFirst As LinkButton = TryCast(gvPagerRow.FindControl("btnFirst"), LinkButton)
        Dim btnPrevious As LinkButton = TryCast(gvPagerRow.FindControl("btnPrevious"), LinkButton)
        Dim btnNext As LinkButton = TryCast(gvPagerRow.FindControl("btnNext"), LinkButton)
        Dim btnLast As LinkButton = TryCast(gvPagerRow.FindControl("btnLast"), LinkButton)
        Dim lblNumber As Label = TryCast(gvPagerRow.FindControl("lblNumber"), Label)

        lblNumber.Text = pageCount.ToString()

        btnFirst.Enabled = btnPrevious.Enabled = (pageIndex <> 0)
        btnLast.Enabled = btnNext.Enabled = (pageIndex < (pageCount - 1))

        btnPrevious.Enabled = (pageIndex <> 0)
        btnNext.Enabled = (pageIndex < (pageCount - 1))

        If btnNext.Enabled = False Then
            btnNext.Attributes.Remove("CssClass")
        End If
        Dim ddlPageSelector As DropDownList = DirectCast(gvPagerRow.FindControl("ddlPageSelector"), DropDownList)
        ddlPageSelector.Items.Clear()

        For i As Integer = 1 To gridView.PageCount
            ddlPageSelector.Items.Add(i.ToString())
        Next

        ddlPageSelector.SelectedIndex = pageIndex

        'Used delegates over here
        AddHandler ddlPageSelector.SelectedIndexChanged, AddressOf pageSelector_SelectedIndexChanged
    End Sub

    Public Sub pageSelector_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ddl As DropDownList = TryCast(sender, DropDownList)
        Using gv As GridView = ddl.Parent.Parent.Parent.Parent
            If Not IsNothing(gv) Then
                gv.PageIndex = ddl.SelectedIndex
                gv.DataBind()
            End If
        End Using
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsNothing(ViewState("filterExpression")) Then
            dsUsers.FilterExpression = ViewState("filterExpression")
        Else
            dsUsers.FilterExpression = ""
        End If
        If Not IsPostBack Then
            dsUsers.DataBind()
            gvUsers.DataBind()
        End If

    End Sub

    Protected Sub gvUsers_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvUsers.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Pager
                SetPagerButtonStates(gvUsers, e.Row, Me.Page)

        End Select
    End Sub

    Protected Sub gvUsers_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvUsers.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim rowview As DataRowView = TryCast(e.Row.DataItem, DataRowView)
                Dim lnk As LinkButton = TryCast(e.Row.FindControl("lnkShowDialog"), LinkButton)
                lnk.OnClientClick = String.Format("return ShowDialog('{0}');", rowview("userid").ToString)
        End Select
    End Sub

    Protected Sub gvUsers_RowUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdatedEventArgs) Handles gvUsers.RowUpdated
    End Sub

    Protected Sub lnkFilterClear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkFilterClear.Click
        txtFilter.Text = ""
        BindData("")
    End Sub

    Protected Sub lnkFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkFilter.Click
        Dim filtExp As String = String.Format("firstname like '{0}%' or lastname like '{0}%' or name like '%{0}%' ", txtFilter.Text)
        BindData(filtExp)
    End Sub

    Private Sub BindData(ByVal filtExp As String)
        ViewState("filterExpression") = filtExp
        dsUsers.FilterExpression = filtExp
        dsUsers.DataBind()
        gvUsers.DataBind()
    End Sub


#End Region 'Methods
    Public Structure ItemPair
        Public ItemID As String
        Public ItemName As String
        Sub New(id As String, name As String)
            ItemID = id
            ItemName = name
        End Sub
    End Structure

    Protected Sub admin_users_PreRender(sender As Object, e As System.EventArgs) Handles Me.PreRender
        GridViewHelper.AddJqueryUI(gvUsers)
    End Sub
End Class