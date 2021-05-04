Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic


Partial Class negotiation_Default
    Inherits System.Web.UI.Page

#Region "Variables"
    Public UserID As Integer
    Private hDatesVer As New Hashtable
    Private hCompanyVer As New Hashtable
    Private hRepsVer As New Hashtable
#End Region

#Region "Page Events"
    Private Sub ShowActionRows(ByVal UserGroupID As Integer)
        Select Case UserGroupID
            Case 4,6,11,19
                trAttachSif.Style("display") = "block"
                trCheckByTel.Style("display") = "block"
                trSettOver.Style("display") = "block"
                trClientStip.Style("display") = "block"

            Case Else
                trAttachSif.Style("display") = "none"
                trCheckByTel.Style("display") = "none"
                trSettOver.Style("display") = "none"
                trClientStip.Style("display") = "none"

        End Select
    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        Dim ugID As String = DataHelper.FieldLookup("tblUser", "UserGroupID", "UserID = " & Page.User.Identity.Name)

        If Session("UserID") Is Nothing Then
            Session("UserID") = UserID
        End If

        If Not Page.IsPostBack Then
            divVerification.Visible = PermissionHelperLite.HasPermission(UserID, "Home-Verification-Verification History")
            divSwitchGroupBox.Visible = SwitchGroupHelper.UserHasGroups(UserID)
            lnkAttachSIFCnt.Text = String.Format("{0}", getAttachSIFCount)
            lnkChkByTelCnt.Text = String.Format("{0}", getChecksByPhoneCount)
            lblOverCnt.Text = String.Format("{0}", getOversCount)
            lblStipCnt.Text = String.Format("{0}", getStipulationsCount)
        End If

        ShowActionRows(ugID)


        AddStatRows()


      
    End Sub
    Private Sub AddStatRows()

        AddSettlementRejectedCount()
        AddSettlementAcceptedCount()

        Dim ssql As String = String.Format("stp_GetSettlementMatterStatusStats {0}", UserID)
        'String.Format("select  mc.MatterStatusCode, count(* )[Total] from tblsettlements s with(nolock) inner join tblmatter m with(nolock) on s.matterid = m.matterid inner join tblmatterstatuscode  mc with(nolock) on m.matterstatuscodeid = mc.matterstatuscodeid where s.createdby = {0} group by mc.MatterStatusCode order by mc.MatterStatusCode option (fast 100)", UserID)

        Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)
            For Each row As DataRow In dt.Rows
                Dim tr As New HtmlTableRow
                Dim td As New HtmlTableCell
                td.Align = "Left"
                td.InnerHtml = row("MatterStatusCode").ToString
                td.Attributes("className") = "entry2"
                tr.Cells.Add(td)

                td = New HtmlTableCell
                td.InnerHtml = ":"
                td.Attributes("className") = "entry2"
                tr.Cells.Add(td)

                td = New HtmlTableCell
                td.InnerHtml = row("Total").ToString
                td.Attributes("className") = "entry2"
                tr.Cells.Add(td)

                tblstats.Rows.Add(tr)
            Next
        End Using
    End Sub
    Private Sub AddSettlementRejectedCount()
        Dim iCnt As Integer = SqlHelper.ExecuteScalar(String.Format("select Count(*) from tblsettlements with(nolock) where createdby = {0} and status = 'r' and active = 1", UserID), CommandType.Text)

        Dim tr As New HtmlTableRow
        Dim td As New HtmlTableCell
        td.Align = "Left"
        td.InnerHtml = "Settlements Rejected"
        td.Attributes("className") = "entry2"
        tr.Cells.Add(td)

        td = New HtmlTableCell
        td.InnerHtml = ":"
        td.Attributes("className") = "entry2"
        tr.Cells.Add(td)

        td = New HtmlTableCell
        td.InnerHtml = iCnt
        td.Attributes("className") = "entry2"
        tr.Cells.Add(td)

        tblstats.Rows.Add(tr)

    End Sub
    Private Sub AddSettlementAcceptedCount()
        Dim iCnt As Integer = SqlHelper.ExecuteScalar(String.Format("select Count(*) from tblsettlements with(nolock) where createdby = {0} and active = 1 and status = 'a'", UserID), CommandType.Text)
        Dim tr As New HtmlTableRow
        Dim td As New HtmlTableCell
        td.Align = "Left"
        td.InnerHtml = "Settlements Accepted"
        td.Attributes("className") = "entry2"
        tr.Cells.Add(td)

        td = New HtmlTableCell
        td.InnerHtml = ":"
        td.Attributes("className") = "entry2"
        tr.Cells.Add(td)

        td = New HtmlTableCell
        td.InnerHtml = iCnt
        td.Attributes("className") = "entry2"
        tr.Cells.Add(td)

        tblstats.Rows.Add(tr)

    End Sub
    Private Function getChecksByPhoneCount() As Integer
        Dim myParams As New List(Of SqlParameter)
        myParams.Add(New SqlParameter("UserId", UserID))
        Using dt As DataTable = SqlHelper.GetDataTable("stp_GetCheckByPhoneProcessing", Data.CommandType.StoredProcedure, myParams.ToArray)
            getChecksByPhoneCount = dt.Rows.Count
        End Using

        Return getChecksByPhoneCount
    End Function
    Private Function getAttachSIFCount() As Integer
        Dim myParams As New List(Of SqlParameter)
        myParams.Add(New SqlParameter("UserId", UserID))
        myParams.Add(New SqlParameter("SearchTerm", "%"))
        Using dt As DataTable = SqlHelper.GetDataTable("stp_NegotiationsSearchGetSettlementsWaitingOnSIF", Data.CommandType.StoredProcedure, myParams.ToArray)
            getAttachSIFCount = dt.Rows.Count
        End Using

        Return getAttachSIFCount
    End Function
    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        If Not Me.IsPostBack AndAlso Not Page.Request("search") Is Nothing Then
            cscSearch.SearchClients(Page.Request("search"), "system")

        End If
    End Sub
    Private Function getOversCount() As Integer
        Using dt As DataTable = SqlHelper.GetDataTable("stp_GetSettlementOvers", Data.CommandType.StoredProcedure)
            getOversCount = dt.Rows.Count
        End Using

        Return getOversCount
    End Function
    Private Function getStipulationsCount() As Integer

        Using dt As DataTable = SqlHelper.GetDataTable("stp_GetSettlementStipulations", Data.CommandType.StoredProcedure)
            getStipulationsCount = dt.Rows.Count
        End Using

        Return getStipulationsCount
    End Function
#End Region

#Region "Other Events"
    Protected Sub rcRecentSearches_Search(ByVal terms As String, ByVal depth As String) Handles rcRecentSearches.Search
        cscSearch.SearchClients(terms, depth)
    End Sub

    Protected Sub cscSearch_Search(ByVal terms As String, ByVal depth As String) Handles cscSearch.Search
        srSearchResults.Requery(terms, depth, "")
    End Sub

    Protected Sub cscSearch_RecentSearches() Handles cscSearch.RecentSearches
        rcRecentSearches.LoadSearches()
    End Sub

    Protected Sub pncPendingNegotiations_MyAssignments(ByVal count As String) Handles pncPendingNegotiations.MyAssignments
        hMyAssignments.InnerHtml = "<img src='images/minimize_off.png' width='20' height='22' border='0' align='right' style='cursor: hand;' onclick='dyntog(div_availablenegotiations,this)' title='Click to Minimize the table' /> My Assignments (" & count & ")"
    End Sub

    Protected Sub gvVerificationHistory_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvVerificationHistory.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            'e.Row.Style("cursor") = "hand"
            e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#d3d3d3'; this.style.filter = 'alpha(opacity=75)';")
            e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = ''; this.style.filter = '';")

            Dim imgTreeDate As HtmlImage = TryCast(e.Row.Cells(0).FindControl("imgTreeDate"), HtmlImage)
            Dim imgTreeCompany As HtmlImage = TryCast(e.Row.FindControl("imgTreeCompany"), HtmlImage)
            Dim imgTreeRep As HtmlImage = TryCast(e.Row.FindControl("imgTreeRep"), HtmlImage)
            Dim row As System.Data.DataRowView = CType(e.Row.DataItem, Data.DataRowView)
            Dim transferred As String = CStr(row("completed")).Replace("/", "")
            Dim company As String = CStr(row("company"))
            Dim rep As String = CStr(row("rep"))

            If hDatesVer.Contains(transferred) Then
                If hCompanyVer.Contains(transferred & company) Then
                    If hRepsVer.Contains(transferred & company & rep) Then
                        e.Row.Attributes.Add("id", String.Format("tr_{0}_child{1}", transferred & company & rep, e.Row.RowIndex))
                        e.Row.Cells(5).Text = ""
                        e.Row.Cells(7).Text = ""
                        imgTreeRep.Visible = False
                    Else
                        hRepsVer.Add(transferred & company & rep, Nothing)
                        e.Row.Attributes.Add("id", String.Format("tr_{0}_child{1}", transferred & company, e.Row.RowIndex))
                        imgTreeRep.Attributes.Add("onclick", "toggleDocument('" & transferred & company & rep & "','" & gvVerificationHistory.ClientID & "', 4, '" & String.Format("tr_{0}_child{1}", transferred & company, e.Row.RowIndex) & "');")
                    End If
                    e.Row.Cells(3).Text = ""
                    imgTreeCompany.Visible = False
                Else
                    hCompanyVer.Add(transferred & company, Nothing)
                    e.Row.Attributes.Add("id", String.Format("tr_{0}_child{1}", transferred, e.Row.RowIndex))
                    imgTreeCompany.Attributes.Add("onclick", "toggleDocument('" & transferred & company & "','" & gvVerificationHistory.ClientID & "', 2, '" & String.Format("tr_{0}_child{1}", transferred, e.Row.RowIndex) & "');")
                    imgTreeRep.Visible = False
                End If
                e.Row.Style("display") = "none"
                e.Row.Cells(1).Text = ""
                imgTreeDate.Visible = False
            Else
                hDatesVer.Add(transferred, Nothing)
                e.Row.Attributes.Add("id", String.Format("tr_{0}_parent", transferred))
                imgTreeDate.Attributes.Add("onclick", "toggleDocument('" & transferred & "','" & gvVerificationHistory.ClientID & "', 0, '" & String.Format("tr_{0}_parent", transferred) & "');")
                imgTreeCompany.Visible = False
                imgTreeRep.Visible = False
            End If
        End If
    End Sub



#End Region


    Protected Sub lnkAttachSIF_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAttachSIF.Click
        'set navigation tab
        Response.Redirect("awaitingSIF.aspx")
    End Sub

    Protected Sub lnkChkByTel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChkByTel.Click
        'set navigation tab
        Response.Redirect("chkbyphone/default.aspx")
    End Sub

    Protected Sub lnkOver_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkOver.Click
        'set navigation tab
        Response.Redirect("managers/default.aspx")
    End Sub

    Protected Sub lnkStip_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkStip.Click
        'set navigation tab
        Response.Redirect("managers/default.aspx")
    End Sub
End Class