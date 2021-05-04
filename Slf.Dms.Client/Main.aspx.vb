Imports System.Data
Imports Drg.Util.DataAccess

Partial Class Main
    Inherits System.Web.UI.Page

    Private _UserID As Integer
    Private _UserGroupId As Integer
    Private _bSearchOnPickup As Boolean = False

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        _UserID = CInt(Page.User.Identity.Name)
        Dim dt As DataTable = FreePBXHelper.GetUserData(_UserID)

        _UserGroupId = dt.Rows(0)("usergroupid")
        _bSearchOnPickup = dt.Rows(0)("searchonpickup")

        If Not Page.IsPostBack Then
            Dim defaultpage As String = "search.aspx"
            If Not dt.Rows(0)("defaultpage") Is DBNull.Value Then defaultpage = ResolveClientUrl(dt.Rows(0)("defaultpage"))
            iframe1.Attributes("src") = defaultpage
        End If
    End Sub

    Private Sub GotoUrl(ByVal url As String)
        If _bSearchOnPickup Then
            ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "GotoRecord", String.Format("GotoURL('{0}');", url), True)
        End If
    End Sub

    Private Sub MapCallRedirect(ByVal callid As Integer, ByVal url As String)
        ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "MapCallRecord", String.Format("MapCallRedirect('{0}','{1}',{2});", callid, url, IIf(_bSearchOnPickup, 1, 0)), True)
    End Sub

    Private Function CleanPhoneNumber(ByVal phone As String) As String
        Dim p As String = phone.Trim.Replace("+", "")
        If p.Length > 10 Then p = Right(p, 10)
        Return p
    End Function

    Private Sub AutoSearch(ByVal PhoneNumber As String)

        PhoneNumber = CleanPhoneNumber(PhoneNumber)
        Dim DID As String = AsteriskHelper.GetIncomingDID(PhoneNumber)
        Dim reftype As String = ""
        Dim defaultpage As String = ""
        If DID.Trim.Length > 0 Then
            Dim dtdepartment As DataTable = FreePBXHelper.GetDepartmentByDID(DID)
            If Not dtdepartment Is Nothing AndAlso dtdepartment.Rows.Count > 0 Then
                If Not dtdepartment.Rows(0)("reftype") Is DBNull.Value Then reftype = dtdepartment.Rows(0)("reftype").ToString.Trim
                If Not dtdepartment.Rows(0)("defaultpage") Is DBNull.Value Then defaultpage = dtdepartment.Rows(0)("defaultpage").ToString.Trim
            End If
        End If

        Dim refid As Integer = 0
        Dim callid As Integer = 0
        Select Case reftype.ToLower
            Case "lead"
                refid = FreePBXHelper.SearchLeadByPhone(PhoneNumber)
                If refid > 0 Then
                    callid = FreePBXHelper.InsertCall(PhoneNumber, True, _UserID, "", reftype.ToUpper, refid, 0)
                    Dim leadcallid = FreePBXHelper.InsertLeadDialerCall(refid, PhoneNumber, _UserID, callid)
                    defaultpage = String.Format("~/clients/enrollment/newenrollment2.aspx?id={0}&cmid={1}", refid, leadcallid)
                End If

            Case "client"
                refid = FreePBXHelper.SearchClientByPhone(PhoneNumber)
                If refid > 0 Then
                    callid = FreePBXHelper.InsertCall(PhoneNumber, True, _UserID, "", reftype.ToUpper, refid, 0)
                    defaultpage = String.Format("~/clients/client/default.aspx?id={0}", refid)
                End If

        End Select

        If callid = 0 Then callid = FreePBXHelper.InsertCall(PhoneNumber, True, _UserID, "", "", Nothing, 0)
        If defaultpage.Trim.Length = 0 Then defaultpage = "~/search.aspx"
        MapCallRedirect(callid, ResolveClientUrl(defaultpage))

    End Sub

    Protected Sub lnkAfterPickup_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAfterPickup.Click
        AutoSearch(Me.hdnPhoneNumber.Value.Trim)
    End Sub


    Protected Sub lnkSignOut_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSignOut.Click
        Session.RemoveAll()
        Session.Abandon()
        FormsAuthentication.SignOut()
        FormsAuthentication.RedirectToLoginPage()
    End Sub
End Class
