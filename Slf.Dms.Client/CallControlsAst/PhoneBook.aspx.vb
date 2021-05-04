Imports System.Data

Partial Class CallControlsAst_PhoneBook
    Inherits System.Web.UI.Page

    Private AMIManager As Asterisk.NET.Manager.ManagerConnection

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        AMIManager = Session("AMIManager")
        If AMIManager Is Nothing Then
            Dim amiserver As String = System.Configuration.ConfigurationManager.AppSettings("AMIServer")
            Dim amiuser As String = System.Configuration.ConfigurationManager.AppSettings("AMIUser")
            Dim amipwd As String = System.Configuration.ConfigurationManager.AppSettings("AMIPwd")
            Dim amiport As String = "5038"
            AMIManager = New Asterisk.NET.Manager.ManagerConnection(amiserver, amiport, amiuser, amipwd)
            AMIManager.Login(120)
            Session("AMIManager") = AMIManager
        End If
    End Sub

    Protected Sub Timer1_Tick(ByVal sender As Object, ByVal e As System.EventArgs) Handles Timer1.Tick
        LoadDirectory()
    End Sub

    Private Sub LoadDirectory()
        Dim dt As DataTable = AsteriskHelper.GetDirectory(txtFirstName.Text.Trim, txtLastName.Text.Trim, txtExtension.Text.Trim, txtDepartment.Text.Trim, txtStatus.Text.Trim)
        grdExtensions.DataSource = dt
        grdExtensions.DataBind()
    End Sub

    Protected Sub grdExtensions_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdExtensions.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim drv As DataRowView = CType(e.Row.DataItem, DataRowView)
            Dim ext As String = String.Empty
            Dim firstName As String = String.Empty
            Dim lastName As String = String.Empty
            If Not drv("ext") Is DBNull.Value Then ext = drv("ext").ToString.Trim()
            If Not drv("firstname") Is DBNull.Value Then firstName = drv("firstname").ToString.Trim()
            If Not drv("lastname") Is DBNull.Value Then lastName = drv("lastname").ToString.Trim()
            Dim lnkExt As LinkButton = CType(e.Row.FindControl("lnkExtension"), LinkButton)
            lnkExt.Text = ext
            If ext.Length > 0 Then
                lnkExt.Attributes.Add("onclick", String.Format("window.top.MakeCall_NextLine('{0}','{1} {2}', ''); return false;", ext.ToString, firstName, lastName))
                Dim imgTransfer As ImageButton = CType(e.Row.FindControl("imgTransfer"), ImageButton)
                Dim imgVoiceMail As ImageButton = CType(e.Row.FindControl("imgVoiceMail"), ImageButton)
                imgTransfer.Attributes.Add("onclick", String.Format("window.top.TransferTo('{0}'); return false;", ext))
                imgVoiceMail.Attributes.Add("onclick", "window.top.SendToVoiceMail(); return false;")
            End If
            Dim lblTimeInStatus As Label = CType(e.Row.FindControl("lblTimeInStatus"), Label)
            lblTimeInStatus.Text = TimeSpan.FromSeconds(drv("secs")).ToString()
            Dim lblOnthePhone As Label = e.Row.FindControl("lblOnThePhone")
            Dim lblLoggedIn As Label = e.Row.FindControl("lblLoggedIn")
            If ext.Length > 0 Then
                Dim action = New Asterisk.NET.Manager.Action.ExtensionStateAction()
                action.Exten = ext
                Dim resp As Asterisk.NET.Manager.Response.ManagerResponse = AMIManager.SendAction(action)
                If Not resp Is Nothing And resp.IsSuccess Then
                    Dim Status As Integer = -1
                    If TypeOf resp Is Asterisk.NET.Manager.Response.ExtensionStateResponse Then
                        Status = CType(resp, Asterisk.NET.Manager.Response.ExtensionStateResponse).Status
                    End If
                    Select Case Status
                        Case -1 'Not found
                            e.Row.Visible = False
                        Case 0 'Idle
                            lblOnthePhone.Text = "No"
                            lblLoggedIn.Text = "Yes"
                            e.Row.Visible = Not Me.chkOnthePhone.Checked
                        Case 1 'InUse 
                            lblOnthePhone.Text = "Yes"
                            lblLoggedIn.Text = "Yes"
                        Case 2 'Busy
                            lblOnthePhone.Text = "Busy"
                            lblLoggedIn.Text = "Yes"
                        Case 4 'Not available
                            lblOnthePhone.Text = "No"
                            lblLoggedIn.Text = "No"
                            e.Row.Visible = Not Me.chkOnthePhone.Checked AndAlso Not Me.chkLoggedIn.Checked
                        Case 8 'Ringing
                            lblOnthePhone.Text = "Ringing"
                            lblLoggedIn.Text = "Yes"
                        Case 16 'Onhold
                            lblOnthePhone.Text = "On Hold"
                            lblLoggedIn.Text = "Yes"
                        Case Else 'Dont Know'
                            lblOnthePhone.Text = "Error"
                            lblLoggedIn.Text = "Error"
                    End Select
                Else
                    e.Row.Visible = False
                End If
            Else
                e.Row.Visible = False
            End If
        End If
    End Sub

End Class
