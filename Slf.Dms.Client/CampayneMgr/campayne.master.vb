Imports System.Data

Partial Class campayne
    Inherits System.Web.UI.MasterPage

    #Region "Fields"

    Private userid As Integer

    #End Region 'Fields

    #Region "Methods"

    Protected Overloads Sub OnPreRenderComplete(ByVal e As EventArgs)
    End Sub

    Protected Sub Page_Init(sender As Object, e As System.EventArgs) Handles Me.Init
        userid = Page.User.Identity.Name
        Dim u As UserHelper.UserObj = UserHelper.GetUserObject(userid)
        Select Case u.UserTypeId
            Case 5
                Response.Redirect("portals/affiliate/")
            Case 6
                Response.Redirect("portals/buyer/")
            Case 7
                Response.Redirect("portals/advertiser/")
        End Select
    End Sub

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Dim u As UserHelper.UserObj = UserHelper.GetUserObject(userid)

        BuildSiteMenu(u)
    End Sub

    Protected Sub lnkLogout_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkLogout.Click
        Session.Clear()
        Session.Abandon()
        FormsAuthentication.SignOut()
        Response.Redirect(ResolveUrl("login.aspx"))
    End Sub

    Private Sub BuildSiteMenu(ByVal u As UserHelper.UserObj)
        Select Case u.UserTypeId
            Case 1
                'turn on everything
                liReports.Style("display") = "block"
                turnOffMenuAndItems(liReports, "block")

                liBuyers.Style("display") = "block"
                turnOffMenuAndItems(liBuyers, "block")

                liPublishing.Style("display") = "block"
                turnOffMenuAndItems(liPublishing, "block")

                liUsers.Style("display") = "block"
                turnOffMenuAndItems(liUsers, "block")

                liAdmin.Style("display") = "block"
                turnOffMenuAndItems(liAdmin, "block")

                liExternal.Style("display") = "block"
                turnOffMenuAndItems(liExternal, "block")

                liBilling.Style("display") = "block"
                turnOffMenuAndItems(liBilling, "block")
            Case 2
                liReports.Style("display") = "block"
                turnOffMenuAndItems(liReports, "block")
                RevenueSnapshot.Style("display") = "none"

                liBuyers.Style("display") = "block"
                turnOffMenuAndItems(liBuyers, "block")

                liPublishing.Style("display") = "block"
                turnOffMenuAndItems(liPublishing, "block")

                liUsers.Style("display") = "block"
                turnOffMenuAndItems(liUsers, "block")

                liAdmin.Style("display") = "block"
                turnOffMenuAndItems(liAdmin, "block")

                liExternal.Style("display") = "block"
                turnOffMenuAndItems(liExternal, "block")

                liBilling.Style("display") = "block"
                turnOffMenuAndItems(liBilling, "block")

            Case 8
                'display reports tab
                liReports.Style("display") = "block"
                callstats.Style("display") = "block"
                DialerDispositions.Style("display") = "block"
                VicidialReports.Style("display") = "block"

                'display users tab
                liUsers.Style("display") = "block"
                Groups.Style("display") = "block"

                'display admin tab
                liAdmin.Style("display") = "block"
                AssignLead.Style("display") = "block"

                'turn off
                liBuyers.Style("display") = "none"
                liPublishing.Style("display") = "none"
                liExternal.Style("display") = "none"
                liBilling.Style("display") = "none"
            Case Else
                'turn off
                liReports.Style("display") = "none"
                liBuyers.Style("display") = "none"
                liPublishing.Style("display") = "none"
                liUsers.Style("display") = "none"
                liAdmin.Style("display") = "none"
                liExternal.Style("display") = "none"
                liUsers.Style("display") = "none"
                liBilling.Style("display") = "none"
                Response.Redirect("login.aspx")
        End Select
    End Sub

    Private Sub turnOffMenuAndItems(menuList As Control, displayString As String)
        For Each ctl As Control In menuList.Controls
            If TypeOf ctl Is HtmlGenericControl Then
                TryCast(ctl, HtmlGenericControl).Style("display") = displayString
            End If
        Next
    End Sub

    #End Region 'Methods

End Class