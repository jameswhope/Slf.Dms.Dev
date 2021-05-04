
Imports System.Data

Partial Class CustomTools_UserControls_DialerSchedule
    Inherits System.Web.UI.UserControl

    Public Property MatterId() As Integer
        Get
            Return Val(Me.hdnMatterId.Value.Trim)
        End Get
        Set(ByVal value As Integer)
            Me.hdnMatterId.Value = value
        End Set
    End Property

    Public Property Client() As Integer
        Get
            Return Val(Me.hdnDialerClientId.Value.Trim)
        End Get
        Set(ByVal value As Integer)
            Me.hdnDialerClientId.Value = value
        End Set
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Me.IsPostBack Then
           ShowEditMode(False)
        End If
    End Sub

    Public Sub LoadDateTime()
        Dim dt As DataTable
        If Me.MatterId = 0 Then
            dt = DialerHelper.GetClientDialerResumeAfterDate(Client)
        Else
            dt = DialerHelper.GetMatterDialerResumeAfterDate(Me.MatterId)
        End If

        Dim d As Nullable(Of DateTime) = Nothing
        If dt.Rows.Count > 0 Then
            If Not dt.Rows(0)("dialerresumeafter") Is DBNull.Value Then d = dt.Rows(0)("dialerresumeafter")
        End If
        If d.HasValue Then
            Me.lnkDialerResumeAfter.Text = d.Value.ToShortDateString & " " & d.Value.ToShortTimeString
        Else
            Me.lnkDialerResumeAfter.Text = "Not set"
        End If
    End Sub

    Protected Sub btnSet24_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSet24.Click
        Try
            Dim NextContactDate As DateTime = Now.AddDays(1)
            SaveNewDialerDate(NextContactDate)
        Catch ex As Exception
            ShowJsExceptionMessage(ex)
        End Try
    End Sub

    Private Sub SaveNewDialerDate(ByVal d As DateTime)
        If Me.MatterId = 0 Then
            DialerHelper.UpdateDialerRetryDate(Client, d)
        Else
            DialerHelper.UpdateMatterRetryDate(MatterId, d)
        End If
        Me.lnkDialerResumeAfter.Text = d.ToShortDateString & " " & d.ToShortTimeString
    End Sub

    Protected Sub lnkDialerResumeAfter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDialerResumeAfter.Click
        ShowEditMode(True)
    End Sub

    Private Sub ShowEditMode(ByVal Edit As Boolean)
        Me.trRetryafter.Visible = Not Edit
        Me.trRetryAfterEdit.Visible = Edit
        If Me.lnkDialerResumeAfter.Text.Trim.ToLower = "not set" OrElse Val(Client) = 0 Then
            Me.txtDialerAfter.Text = ""
            Me.txtDialerTimeAfter.Text = ""
        Else
            Dim d As DateTime = Me.lnkDialerResumeAfter.Text
            Me.txtDialerAfter.Text = d.ToShortDateString
            Me.txtDialerTimeAfter.Text = d.ToShortTimeString
        End If
    End Sub

    Protected Sub btnDialerRetrySave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDialerRetrySave.Click
        Try
            If txtDialerAfter.Text.Trim.Length = 0 OrElse Not IsDate(txtDialerAfter.Text.Trim) Then Throw New Exception("Invalid Date")
            If txtDialerTimeAfter.Text.Trim.Length = 0 Then Throw New Exception("Invalid Time")
            Dim d As DateTime = Me.txtDialerAfter.Text & " " & Me.txtDialerTimeAfter.Text
            SaveNewDialerDate(d)
            ShowEditMode(False)
        Catch ex As Exception
            ShowJsExceptionMessage(ex)
        End Try
    End Sub

    Protected Sub btnDialerRetryCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDialerRetryCancel.Click
        ShowEditMode(False)
    End Sub

    Private Sub ShowJsExceptionMessage(ByVal ex As Exception)
        ScriptManager.RegisterClientScriptBlock(Me.Page, GetType(Page), "errorupddialertime", String.Format("alert('{0}');", ex.Message.Replace("'", "")), True)
    End Sub
End Class
