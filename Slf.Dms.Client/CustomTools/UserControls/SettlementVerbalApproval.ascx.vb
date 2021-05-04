Imports ININ.IceLib.Interactions

Partial Class CustomTools_UserControls_SettlementVerbalApproval
    Inherits System.Web.UI.UserControl

    Private _currentInteraction As Interaction
    Private _userId As Integer = 0
    Private _DocTypeId As String = "9074"
    Public Event Submitted(ByVal Approved As Boolean, ByVal RecordingId As Integer)
    Public Event Cancelled()
    Public Event Errors(ByVal Ex As Exception)

    Public ReadOnly Property CallId() As String
        Get
            Return hdnCallId.Value
        End Get
    End Property

    Public Property ReferenceType() As String
        Get
            Return hdnReferenceType.Value
        End Get
        Set(ByVal value As String)
            hdnReferenceType.Value = value
        End Set
    End Property

    Public Property ReferenceId() As Integer
        Get
            Return hdnRefId.Value
        End Get
        Set(ByVal value As Integer)
            hdnRefId.Value = value
        End Set
    End Property

    Public Property CallResolutionId() As Integer
        Get
            Return hdnCallResolutionId.Value
        End Get
        Set(ByVal value As Integer)
            hdnCallResolutionId.Value = value
        End Set
    End Property

    Public Property SettlementId() As Integer
        Get
            Return hdnSettlementId.Value
        End Get
        Set(ByVal value As Integer)
            hdnSettlementId.Value = value
            Me.LanguageId = DialerHelper.GetClientLanguageForSett(value)
        End Set
    End Property

    Public Property IsPopup() As Boolean
        Get
            Return CBool(hdnIsPopup.Value)
        End Get
        Set(ByVal value As Boolean)
            hdnIsPopup.Value = value.ToString
        End Set
    End Property

    Public Property LanguageId() As Integer
        Get

            Return hdnLanguageId.Value
        End Get
        Set(ByVal value As Integer)
            hdnLanguageId.Value = value
            SetLanguage(value)
        End Set
    End Property

    Private Function IsValidForm() As Boolean
        return  Me.rdNo.Checked orelse Me.rdYes.Checked 
    End Function

    Public Sub Submit()
        Try
            If IsValidForm() Then
                'Create Record
                Dim recId As Integer = CallControlsHelper.InsertCallRecording(Me.hdnCallId.Value, "", "", hdnReferenceType.Value.Trim, CInt(hdnRefId.Value), _DocTypeId, _userId)
                If CallResolutionId > 0 Then DialerHelper.UpdateCallResolution(CallResolutionId, Nothing, recId, _userId)
                If SettlementId > 0 Then DialerHelper.ApproveSettlement(SettlementId, rdYes.Checked, "", "verbal", "", "", "", "", "", _userId)
                'Stop Recording
                RaiseEvent Submitted(rdYes.Checked, recId)
                ScriptManager.RegisterStartupScript(Me.Page, GetType(Page), "persistrecording", String.Format("CloseRecording('1','{0}', '{1}', '{2}');", hdnIsPopup.Value.ToLower, recId.ToString, IIf(rdYes.Checked, "1", "0")), True)
            Else
                Throw New Exception("Question needs to get answered")
            End If
        Catch ex As Exception
            ShowError(ex)
        End Try
    End Sub

    Public Sub Cancel()
        RaiseEvent Cancelled()
        ScriptManager.RegisterStartupScript(Me.Page, GetType(Page), "cancelrecording", String.Format("CloseRecording('0','{0}','','');", hdnIsPopup.Value.ToLower), True)
    End Sub

    Public Sub CreateRecordingCall(ByVal RefType As String, ByVal refId As Integer)
        Me.ReferenceType = RefType
        Me.ReferenceId = refId
        CreateRecordingCall()
    End Sub

    Public Sub CreateRecordingCall()
        Try
            Dim interactionId As String
            _currentInteraction = Session("currentInteraction")
            If Not _currentInteraction Is Nothing AndAlso Not _currentInteraction.IsDisconnected AndAlso Not _currentInteraction.StateDescription.Trim.ToLower = "dialing" Then
                If Not _currentInteraction.IsRecording Then
                    StartRecording()
                    interactionId = _currentInteraction.CallIdKey
                    hdnCallId.Value = interactionId
                Else
                    DisableScreen()
                    Throw New Exception("Sorry, You cannot start this process because the current call is recording already.")
                End If
            Else
                DisableScreen()
                Throw New Exception("Sorry, You cannot start this process because there is no current call.")
            End If
        Catch ex As Exception
            ShowError(ex)
        End Try
    End Sub

    Private Sub DisableScreen()
        Me.btnSubmit.Visible = False
        Me.tdContent.Visible = False
    End Sub

    Private Sub StartRecording()
        Try
            _currentInteraction.Record(True, False)
        Catch ex As Exception
            CallControlsHelper.InsertCallMessageLog("Start Recording Error: " & ex.Message, _UserID)
            Throw
        End Try
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        _userId = Drg.Util.DataAccess.DataHelper.Nz_int(Page.User.Identity.Name)

        If Me.hdnIsPopup.Value <> "" Then
            tblRec.Attributes.Remove("width")
        Else
            tblRec.Attributes.Add("width", "100%")
        End If

        If Not Me.IsPostBack Then
            hdnLanguageId.Value = "1"
            hdnReferenceType.Value = "Matter"
            Me.btnSubmit.Attributes.Add("onmouseover", "this.className='btn_hover';")
            Me.btnCancel.Attributes.Add("onmouseover", "this.className='btn_hover';")
            Me.btnSubmit.Attributes.Add("onmouseout", "this.className='btn';")
            Me.btnCancel.Attributes.Add("onmouseout", "this.className='btn';")
        End If
    End Sub

    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        Submit()
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Cancel()
    End Sub

    Private Sub ShowError(ByVal ex As Exception)
        lblMessage.Text = ex.Message
        lblMessage.ForeColor = System.Drawing.Color.Red
        'lblMessage.CssClass = "Message"
        RaiseEvent Errors(ex)
    End Sub

    Private Sub SetLanguage(ByVal LanguageId As Integer)
        Select Case LanguageId
            Case 1
                lblQuestion1.Text = "1-Would you like to give me your verbal authorization to settle this account?"
                rdYes.Text = "Yes = Accept"
                rdNo.Text = "No - Reject"
            Case 2
                lblQuestion1.Text = "1-Me da Usted su autorización para proceder con este arreglo para esta cuenta?"
                rdYes.Text = "Sí = Acceptar"
                rdNo.Text = "No - Rechazar"
        End Select
    End Sub
End Class
