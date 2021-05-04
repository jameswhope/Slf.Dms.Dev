Imports System.Data

Partial Class admin_checkscan_checksprocessed
    Inherits System.Web.UI.Page
    Public UserID As Integer
    <Services.WebMethod()> _
    Public Shared Function ReturnCheck(checkid As String, reason As String) As String
        Dim result As String = "Returned!"
        Try

            result = String.Format("<div>{0}", ICLHelper.ReturnCheck(checkid, reason, HttpContext.Current.User.Identity.Name))

        Catch ex As Exception
            Return ex.Message.ToString
        End Try
        Return result
    End Function
    Private Sub BindGrids()

        dsAllChecks.SelectParameters("from").DefaultValue = String.Format("{0} 12:00 AM", txtFrom.Text)
        dsAllChecks.SelectParameters("to").DefaultValue = String.Format("{0} 11:59 PM", txtTo.Text)
        dsAllChecks.DataBind()
        gvAllChecks.DataBind()

        gvAllChecks.DataBind()



    End Sub

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        UserID = Drg.Util.DataAccess.DataHelper.Nz_int(Page.User.Identity.Name)
        If Not IsPostBack Then
            loadDates()
            BindGrids()
        End If
        ApplySecurity()
    End Sub

    Private Sub ApplySecurity()
        Dim intUserRole As Integer = Drg.Util.DataHelpers.UserHelper.GetUserRole(UserID)

        Select Case intUserRole
            Case 6, 11, 27 'Admin, Sys Admin
                'do nothing
                pageMSG.Style("display") = "none"
                pageCNT.Style("display") = "block"

            Case Else
                'apply security features here.
                pageMSG.Controls.Add(New LiteralControl("<div class=""warning"">YOU ARE NOT AUTHORIZED TO VIEW THIS RESOURCE!<div>"))
                pageCNT.Style("display") = "none"
        End Select

    End Sub
    Protected Sub ddlRange_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlRange.SelectedIndexChanged
        setDates()
        BindGrids()
    End Sub
    Private Sub setDates()
        txtFrom.Enabled = False
        txtTo.Enabled = False

        Select Case ddlRange.SelectedItem.Value.ToLower
            Case "today"
                txtFrom.Text = Now.ToShortDateString
                txtTo.Text = Now.ToShortDateString
            Case "yesterday"
                txtFrom.Text = DateAdd("d", -1, Now).ToShortDateString
                txtTo.Text = DateAdd("d", -1, Now).ToShortDateString
            Case "lw"
                txtFrom.Text = DateAdd("d", -7, DateAdd("d", 0 - Now.DayOfWeek, Now)).ToShortDateString
                txtTo.Text = DateAdd("w", -1, DateAdd("d", 0 - Now.DayOfWeek, Now)).ToShortDateString
            Case "wtd"
                txtFrom.Text = DateAdd("d", 0 - Now.DayOfWeek, Now).ToShortDateString
                txtTo.Text = Now.ToShortDateString

            Case "mtd"
                txtFrom.Text = Now.AddDays(-1 * (Now.Day - 1)).ToShortDateString
                txtTo.Text = Now.ToShortDateString
            Case "ytd"
                txtFrom.Text = New DateTime(Now.Year, 1, 1).ToShortDateString()
                txtTo.Text = Now.ToShortDateString

            Case Else
                txtFrom.Text = Now.ToShortDateString
                txtTo.Text = Now.ToShortDateString
                txtFrom.Enabled = True
                txtTo.Enabled = True
        End Select
    End Sub
    Private Sub loadDates()

        ddlRange.Items.Add(New ListItem("Today", "today"))
        ddlRange.Items.Add(New ListItem("This Week", "wtd"))
        ddlRange.Items.Add(New ListItem("This Month", "mtd"))
        ddlRange.Items.Add(New ListItem("This Year", "ytd"))
        ddlRange.Items.Add(New ListItem("Yesterday", "yesterday"))
        ddlRange.Items.Add(New ListItem("Last Week", "lw"))
        ddlRange.Items.Add(New ListItem("Custom", "custom"))

        txtFrom.Text = Now.ToShortDateString
        txtTo.Text = Now.ToShortDateString

        txtFrom.Enabled = False
        txtTo.Enabled = False

    End Sub
    Protected Sub gvAllChecks_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvAllChecks.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                GridViewHelper.styleGridviewRows(e)
                Dim rowview As DataRowView = TryCast(e.Row.DataItem, DataRowView)
                Dim chk As CheckBox = TryCast(e.Row.FindControl("chkMissing"), CheckBox)
                If Not IsNothing(chk) Then
                    Select Case rowview("MissingProcessingRegisterID").ToString
                        Case 1
                            chk.Checked = True
                        Case Else
                            chk.Checked = False
                    End Select
                End If
                Dim status As String = rowview("processstatus").ToString
                Using lnk As LinkButton = TryCast(e.Row.FindControl("lnkRejectCheck"), LinkButton)
                    If Not status.ToLower.Contains("accepted") Then
                        For Each c As TableCell In e.Row.Cells
                            c.BackColor = System.Drawing.Color.Salmon
                        Next
                        lnk.OnClientClick = String.Format("return ReturnCheck('{0}','{1}')", rowview("check21id").ToString, _
                                                          rowview("ProcessStatus").ToString)
                        lnk.Style("display") = "block"
                    Else
                        lnk.Style("display") = "none"
                    End If
                End Using
                Using lnk As LinkButton = TryCast(e.Row.FindControl("lnkClientName"), LinkButton)
                    lnk.Attributes.Add("dcid", rowview("clientid").ToString)
                    AddHandler lnk.Click, AddressOf lnkClientName_Click
                End Using
                
        End Select
    End Sub
    Protected Sub lnkView_Click(sender As Object, e As System.EventArgs) Handles lnkView.Click
        BindGrids()
    End Sub
    Protected Sub lnkClientName_Click(sender As Object, e As System.EventArgs)
        Dim dcid As String = TryCast(sender, LinkButton).Attributes("dcid").ToString

        Response.Redirect(String.Format("../../clients/client/?id={0}", dcid))

    End Sub
End Class
