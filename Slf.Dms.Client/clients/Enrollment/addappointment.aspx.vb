Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data
Imports System.Data.SqlClient



Partial Class Enrollment_addappointment
    Inherits System.Web.UI.Page

#Region "Variables"

    Private _UserID As Integer
    Private _AddMode As Boolean
    Private _AppointmentID As Integer = -1
    Private _LeadApplicantID As Integer = 0

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        _UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        _AppointmentID = GetAppointmentId()
        _LeadApplicantID = GetLeadApplicantId()
        'Are we adding a new record?
        If _AppointmentID = -1 Then
            _AddMode = True
        End If

        If Not IsPostBack Then
            LoadTimeZones()
            LoadData()
        End If

    End Sub

    Private Function GetAppointmentId() As Integer
        Try
            Return CInt(Request.QueryString("aid"))
        Catch ex As Exception
            Return -1
        End Try
    End Function

    Private Function GetLeadApplicantId() As Integer
        Try
            Return CInt(Request.QueryString("lid"))
        Catch ex As Exception
            Return -1
        End Try
    End Function

    Private Sub LoadData()
        'Setup the call
        If Not _AddMode Then
            LoadRecord()
        Else 'we're inserting a new appointment
            CreateRecord()
            lblStatus.Text = "(New)"
        End If
    End Sub

    Private Sub LoadRecord()
        Dim dt As DataTable = CIDAppointmentHelper.GetLeadAppointment(_AppointmentID)
        If dt.Rows.Count > 0 Then
            LoadRecord(dt.Rows(0))
        Else
            ClearRecord()
            trSave.Visible = False
            'Throw Error Record does not exist
        End If
    End Sub

    Private Sub LoadRecord(ByVal dr As DataRow)
        Me.txtPhone.Value = dr("PhoneNumber")
        Me.AppDate.Value = CDate(dr("AppointmentDate")).ToShortDateString
        Me.AppTime.Value = CDate(dr("AppointmentDate")).ToShortTimeString
        Me.ddlTimeZone.SelectedIndex = Me.ddlTimeZone.Items.IndexOf(Me.ddlTimeZone.Items.FindByValue(dr("TimeZoneId")))
        UpdateTime(AppTime, AppLeadTime, True)
        If Not dr("AppointmentNote") Is DBNull.Value Then Me.txtNote.Text = dr("AppointmentNote")
        Me.lblCreated.Text = String.Format("{0} by {1}", CDate(dr("Created")), dr("createdbyuser"))
        Me.lblModified.Text = String.Format("{0} by {1}", CDate(dr("LastModified")), dr("lastmodifiedbyuser"))
        Me.lblStatus.Text = dr("StatusName")
        EnableRecord(dr("appointmentstatusid") = LeadAppointmentStatus.Pending)
    End Sub

    Private Sub ClearRecord()
        Dim defaultzoneindex As Integer = 5
        Me.AppDate.Value = ""
        Me.txtPhone.Value = ""
        Me.AppLeadTime.Value = ""
        Me.AppTime.Value = ""
        Me.txtNote.Text = ""
        Me.ddlTimeZone.SelectedIndex = defaultzoneindex
    End Sub

    Private Sub EnableRecord(ByVal bEnable As Boolean)
        Me.AppDate.Enabled = bEnable
        Me.txtPhone.Enabled = bEnable
        Me.AppLeadTime.Enabled = bEnable
        Me.AppTime.Enabled = bEnable
        Me.txtNote.Enabled = bEnable
        Me.ddlTimeZone.Enabled = bEnable
        Me.btnToday.Visible = bEnable
        Me.trSave.Visible = bEnable
    End Sub

    Private Sub CreateRecord()
        ClearRecord()
        Dim dt As DataTable = CIDAppointmentHelper.GetLeadDefaultData(_LeadApplicantID)
        If dt.Rows.Count > 0 Then
            Dim dr As DataRow = dt.Rows(0)
            If Not dr("LeadPhone") Is DBNull.Value Then Me.txtPhone.Value = SmartDebtorHelper.CleanPhoneNumber(dr("LeadPhone"))
            If Not dr("LeadName") Is DBNull.Value Then Me.txtNote.Text = "Appointment call with " & dr("LeadName")
            'Calculate default Time zone
            If Not dr("TimeZoneId") Is DBNull.Value AndAlso dr("TimeZoneId") > 0 Then
                Me.ddlTimeZone.SelectedIndex = Me.ddlTimeZone.Items.IndexOf(Me.ddlTimeZone.Items.FindByValue(dr("TimeZoneId")))
            Else
                'Get time zone by phone
                If txtPhone.Value.ToString.Length > 0 Then
                    Dim areacode As String = CallControlsHelper.GetAreaCode(txtPhone.Value.ToString.Trim)
                    If areacode.Trim.Length > 0 Then
                        Dim dtz As DataTable = CIDAppointmentHelper.GetTimeZoneforAreaCode(areacode)
                        If dtz.Rows.Count > 0 Then
                            Dim drz As DataRow = dtz.Rows(0)
                            If Not drz("defaultTimeZone") Is DBNull.Value AndAlso drz("defaultTimeZone") > 0 Then
                                Me.ddlTimeZone.SelectedIndex = Me.ddlTimeZone.Items.IndexOf(Me.ddlTimeZone.Items.FindByValue(drz("defaultTimeZone")))
                            End If
                        End If
                    End If
                End If
            End If
        End If
    End Sub

    Private Sub LoadTimeZones()
        Me.ddlTimeZone.DataSource = CIDAppointmentHelper.GetTimeZones()
        Me.ddlTimeZone.DataTextField = "Name"
        Me.ddlTimeZone.DataValueField = "TimeZoneId"
        Me.ddlTimeZone.DataBind()
    End Sub

    Protected Sub btnToday_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnToday.Click
        Me.AppDate.Value = Today
    End Sub

    Protected Sub AppTime_ValueChange(ByVal sender As Object, ByVal e As Infragistics.WebUI.WebDataInput.ValueChangeEventArgs) Handles AppTime.ValueChange
        UpdateTime(AppTime, AppLeadTime, True)
    End Sub

    Protected Sub AppLeadTime_ValueChange(ByVal sender As Object, ByVal e As Infragistics.WebUI.WebDataInput.ValueChangeEventArgs) Handles AppLeadTime.ValueChange
        UpdateTime(AppLeadTime, AppTime, False)
    End Sub

    Private Sub UpdateTime(ByVal t1 As Infragistics.WebUI.WebDataInput.WebDateTimeEdit, ByVal t2 As Infragistics.WebUI.WebDataInput.WebDateTimeEdit, ByVal IsLocal As Boolean)
        If t1.Text.Trim.Length > 0 Then
            Dim myUtc As Integer = -8
            Dim utc As Integer = CIDAppointmentHelper.GetUTC(Me.ddlTimeZone.SelectedValue)
            If IsLocal Then
                t2.Value = CDate(t1.Value).AddHours(utc - myUtc)
            Else
                t2.Value = CDate(t1.Value).AddHours(myUtc - utc)
            End If
        Else
            t2.Text = ""
        End If
    End Sub

    Protected Sub ddlTimeZone_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlTimeZone.SelectedIndexChanged
        UpdateTime(AppTime, AppLeadTime, True)
    End Sub

    Protected Sub lnkSaveAppointment_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveAppointment.Click
        dvError.Visible = False
        If IsValidAppointment() Then
            Try
                If _AddMode Then
                    InsertAppointment()
                Else
                    UpdateAppointment()
                End If
                CloseWindow()
            Catch ex As Exception
                ShowError(ex.Message)
            End Try
        End If
    End Sub

    Private Function IsValidAppointment() As Boolean
        Dim bValid As Boolean = True
        Try
            'Date not entered
            If AppDate.Text.ToString.Length = 0 Then Throw New Exception("Please enter a Date.")
            'Local time not entered
            If AppTime.Text.ToString.Length = 0 Then Throw New Exception("Please enter a Time.")
            'Phone Number not entered
            If txtPhone.Value.ToString.Trim.Length = 0 Then Throw New Exception("Please enter a phone number.")
            'Invalid Phone Number
            If txtPhone.Value.ToString.Trim.Length < 7 Then Throw New Exception("Invalid phone number.")
            'Date and Time older than now
            Dim AppointmentDate As DateTime = DateTime.Parse(String.Format("{0} {1}", Me.AppDate.Text.Trim, AppTime.Text.Trim))
            If AppointmentDate < Now.AddMinutes(5) Then Throw New Exception("Appointment Date and Time must be at least 5 mins from now.")
            'Only only one pending appointment allowed
            If _AddMode AndAlso CIDAppointmentHelper.GetPendingAppointmentCount(_LeadApplicantID) > 0 Then Throw New Exception("There is a pending appointment created already.")
        Catch ex As Exception
            bValid = False
            ShowError(ex.Message)
        End Try
        Return bValid
    End Function

    Private Sub CloseWindow()
        ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "closeWnd", "window.close();", True)
    End Sub

    Private Sub InsertAppointment()
        Dim AppointmentDate As DateTime = CDate(String.Format("{0} {1}", Me.AppDate.Text.Trim, AppTime.Text.Trim))
        CIDAppointmentHelper.InsertLeadAppointment(_LeadApplicantID, txtPhone.Value.trim, AppointmentDate, Me.ddlTimeZone.SelectedValue, Me.txtNote.Text.Trim, LeadAppointmentStatus.Pending, _UserID)
    End Sub

    Private Sub UpdateAppointment()
        Dim AppointmentDate As DateTime = CDate(String.Format("{0} {1}", Me.AppDate.Text.Trim, AppTime.Text.Trim))
        CIDAppointmentHelper.UpdateLeadAppointment(_AppointmentID, txtPhone.Value.Trim, AppointmentDate, ddlTimeZone.SelectedValue, txtNote.Text.Trim, Nothing, "", Nothing, Nothing, Nothing, _UserID)
    End Sub

    Private Sub ShowError(ByVal Msg As String)
        Me.dvError.Style("display") = "block"
        Me.lblError.Text = Msg
        Me.dvError.Visible = True
    End Sub

End Class