Imports System.Data

Partial Class CallControlsAst_CallControlBarAst
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Session("CallControlsType") = "freepbx"
        'Hide the Phone book until it gets fixed.
        tdPhoneBook.Style("display") = "none"

        If Not Me.IsPostBack Then
            Me.hdnSIPInited.Value = "0"
            Me.hdnSIPRegistered.Value = "0"
            Me.txtLogs.Text = ""
            Dim UserId As Integer = CInt(Page.User.Identity.Name)
            Dim UserName As String = Drg.Util.DataAccess.DataHelper.FieldLookup("tbluser", "username", "userid = " & UserId)
            Me.hdnUserName.Value = CallControlsHelper.GetUserExt(UserName)
            Dim userPassword As String = ConnectionContext.GetUserPassword(UserName)
            If userPassword.Length = 0 Then userPassword = ConnectionContext.GetUserPassword2(UserName)
            Me.hdnPassword.Value = "lex" & Me.hdnUserName.Value & Me.hdnUserName.Value
            Me.hdnUserDisplayName.Value = UserName
            Dim ehostdomain As String = System.Configuration.ConfigurationManager.AppSettings("externalhostdomain").ToString
            If Me.Request.ServerVariables("SERVER_NAME").ToString.Contains(ehostdomain) Then
                Me.hdnProxyServer.Value = System.Configuration.ConfigurationManager.AppSettings("connectAsteriskE")
            Else
                Me.hdnProxyServer.Value = System.Configuration.ConfigurationManager.AppSettings("connectAsterisk")
            End If
            Me.hdnProxyPort.Value = "5060"
            Me.hdnRecordingPath.Value = System.Configuration.ConfigurationManager.AppSettings("recordingsPath")
            Me.pnlLines.Style("display") = "none"
            Me.LoadPresences()
            SelectUserPresence()
            'LoadCallHistory()
        End If
    End Sub

    Private Sub LoadPresences()
        Dim dt As Datatable = AsteriskHelper.GetAllPresences()
        Dim dv As New DataView(dt)
        dv.RowFilter = "ShowInList = 1"
        dv.Sort = "[Name] asc"
        Me.cboStatus.Items.Clear()
        Dim li As ListItem
        For Each drv As DataRowView In dv
            li = New ListItem(drv("Name"), drv("PresenceId"))
            li.Attributes.Add("Available", drv("Available").ToString)
            cboStatus.Items.Add(li)
        Next
    End Sub

    Private Sub SelectUserPresence()
        Dim dt As DataTable = AsteriskHelper.GetUserPresence(Me.hdnUserName.Value.Trim)
        Dim presenceid As Integer = 0
        Dim lastpresencedate As DateTime = Now
        If Not dt Is Nothing AndAlso dt.Rows.Count > 0 Then
            presenceid = dt.Rows(0)("PresenceId")
            lastpresencedate = dt.Rows(0)("lastmodified")
        End If
        If presenceid = 0 Then
            presenceid = 1
            AsteriskHelper.InsertUserPresence(Me.hdnUserName.Value, presenceid)
        End If
        cboStatus.SelectedIndex = cboStatus.Items.IndexOf(cboStatus.Items.FindByValue(presenceid))
        hdnTimeInStatus.Value = lastpresencedate.ToString
    End Sub

    Private Sub ChangeUserPresence()
        If Me.cboStatus.Value > 0 Then
            AsteriskHelper.UpdateUserPresence(Me.hdnUserName.Value, Me.cboStatus.Value)
            hdnTimeInStatus.Value = Now.ToString
        End If
    End Sub

    Protected Sub lnkSetPresence_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSetPresence.Click
        ChangeUserPresence()
    End Sub

    Private Function FormatDuration(ByVal Secs As Integer) As String
        Dim t As TimeSpan = TimeSpan.FromSeconds(Secs)
        Return t.ToString
    End Function

    Private Function FormatCLID(ByVal callerId As String) As String
        Dim clid As String() = callerId.Split("<")
        Return clid(0).Replace("""", "").Trim
    End Function

    Private Sub LoadCallHistory()
        Dim dt As DataTable = AsteriskHelper.GetHistory(hdnUserName.Value.Trim, 30)
        grdHistory.DataSource = dt
        grdHistory.DataBind()
    End Sub

    Protected Sub grdHistory_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdHistory.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim drv As DataRowView = CType(e.Row.DataItem, DataRowView)
            Dim lblStatus As Label = CType(e.Row.FindControl("lblstatus"), Label)
            lblStatus.Text = "&nbsp;" & Microsoft.VisualBasic.StrConv(drv("status").ToString, VbStrConv.ProperCase)
            Dim lblClid As Label = CType(e.Row.FindControl("lblClid"), Label)
            lblClid.Text = FormatCLID(drv("clid").ToString)
            Dim lblDuration As Label = CType(e.Row.FindControl("lblduration"), Label)
            lblDuration.Text = FormatDuration(drv("duration"))
            Dim lnk As LinkButton = CType(e.Row.FindControl("lnkMakeCall"), LinkButton)
            lnk.Text = drv("phonenumber").ToString
            lnk.Attributes.Add("onclick", String.Format("MakeOutboundCall('{0}'); return false;", drv("phonenumber")))
            Dim img As WebControls.Image = CType(e.Row.FindControl("imgStatus"), WebControls.Image)
            img.ImageAlign = ImageAlign.AbsMiddle
            Select Case drv("status").ToString.ToLower
                Case "received"
                    img.ImageUrl = "~/images/16x16_callin.png"
                Case "dialed"
                    img.ImageUrl = "~/images/16x16_callout.png"
                Case Else
                    img.ImageUrl = "~/images/16x16_exclamationpoint.png"
            End Select
        End If
    End Sub

    Protected Sub lnkReloadHistory_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkReloadHistory.Click
        LoadCallHistory()
    End Sub

    Protected Sub Page_Unload(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Unload
        If Not Session("AMIManager") Is Nothing Then
            Dim AMIManager As Asterisk.NET.Manager.ManagerConnection = CType(Session("AMIManager"), Asterisk.NET.Manager.ManagerConnection)
            AMIManager.Logoff()
            Session("AMIManager") = Nothing
        End If
    End Sub
End Class
