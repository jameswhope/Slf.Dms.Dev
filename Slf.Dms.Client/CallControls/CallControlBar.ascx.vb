Imports ININ.IceLib.Connection
Imports ININ.IceLib.Interactions
Imports ININ.IceLib.People
Imports IceSession = ININ.IceLib.Connection.Session
Imports System.Collections
Imports System.Collections.Generic
Imports System.Collections.ObjectModel

Partial Class CallControls_CallControlBar
    Inherits System.Web.UI.UserControl

    Private _uInfo As UserInfo
    Private _iceSession As ININ.IceLib.Connection.Session
    Private _InteractionsManager As InteractionsManager
    Private _InteractionQueue As InteractionQueue

    Private _peopleMan As PeopleManager
    Private _currentStatus As String = String.Empty
    Private _userStatuses As UserStatusList

    Private _currentInteraction As Interaction
    Private _interactionList As Dictionary(Of String, Interaction)

    Public Event BeforeTransfer()
    Public Event AfterTransfer()
    Public Event BeforeDisconnect()
    Public Event AfterDisconnect()
    Public Event BeforePickup()
    Public Event AfterPickup(ByVal args As CallEventArgs)
    Public Event BeforeHold()
    Public Event AfterHold()
    Public Event BeforeMute()
    Public Event AfterMute()
    Public Event BeforeVoiceMail()
    Public Event AfterVoiceMail()
    Public Event BeforeRecord()
    Public Event AfterRecord()
    Public Event AfterMakeCall(ByVal CallIdKey As String, ByVal PhoneNumber As String)
    Public Event AfterCIDCallMade(ByVal CallIdKey As String, ByVal CallMadeId As Integer, ByVal LeadId As Integer)
    Public Event AfterDialerINCallMade(ByVal CallIdKey As String, ByVal CallMadeId As Integer, ByVal ClientId As Integer)
    Public Event OnSearching(ByVal args As CallEventArgs)

    Private Sub GetSessionData()
        _iceSession = Session("IceSession")
        _uInfo = Session("IceUserInfo")
        _InteractionQueue = Session("InteractionQueue")
        _peopleMan = Session("IcePeopleMan")
        _userStatuses = Session("IceUserStatusList")
        _currentStatus = Session("IceUserStatus")
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        GetSessionData()

        If Not Me.IsPostBack Then _iceSession = Nothing

        If _iceSession Is Nothing Then
            Startup()
        Else
            If _iceSession.ConnectionState = ConnectionState.Up Then
                GetInteractions()
                _currentInteraction = Session("CurrentInteraction")
            End If
        End If

        UpdateButtons()

    End Sub

    Private Sub Startup()
        _interactionList = New Dictionary(Of String, Interaction)
        SaveInteractions()
        CreateSession()

        If Not _iceSession Is Nothing Then
            LoadUserStatuses()
            SetCurrentStatus()
        End If
    End Sub

    Private Sub SaveInteractions()
        Session("InteractionList") = _interactionList
    End Sub

    Private Sub GetInteractions()
        _interactionList = CType(Session("InteractionList"), Dictionary(Of String, Interaction))
    End Sub

    Private Sub CreateSession()
        Try
            Dim UserId As Integer = Drg.Util.DataAccess.DataHelper.Nz_int(Page.User.Identity.Name)
            Dim UserName As String = Drg.Util.DataAccess.DataHelper.FieldLookup("tbluser", "username", "userid = " & UserId)
            Dim UserPassword As String = ConnectionContext.GetUserPassword(UserName)
            If UserPassword.Length = 0 Then UserPassword = ConnectionContext.GetUserPassword2(UserName)
            Dim IninServer As String = ConnectionContext.GetIninServer

            _uInfo = New UserInfo(UserId, UserName, UserPassword, IninServer)

            Session("IceUserInfo") = _uInfo

            StartSession()

            LogCallEvent("CreateSession", Nothing, Nothing)

         Catch ex As Exception
            LogException("[SM]Create Session: " & ex.Message & " " & Me.Context.Request("REMOTE_HOST"))
         End Try

    End Sub

    Private Sub StartSession()
        ' NO NEED TO CREATE A SESSION IF ONE EXISTS ALREADY
        ' ARE ALL FIELDS FILLED IN?

        ' CREATE SESSION
        _iceSession = New IceSession()
        Session("IceSession") = _iceSession

        If Not _uInfo.CanConnectionOccur() Then
            Throw New Exception("Cannot connect. Check user connection parameters")
        End If

        ' CREATE SESSION SETTINGS
        Dim sSettings As New SessionSettings()
        sSettings.ClassOfService = ClassOfService.General
        sSettings.ApplicationName = "WebCall"
        'sSettings.IsoLanguage = _Language
        sSettings.MachineName = ConnectionContext.GetMachineName(Me.Context)

        ' CREATE AUTHENTICATION SETTINGS
        Dim authSettings As New ICAuthSettings(_uInfo.Username, _uInfo.Password)

        ' CREATE HOST SETTINGS
        Dim hSettings As New HostSettings(New HostEndpoint(_uInfo.CICServer))

        ' CREATE STATION SETTINGS
        Dim staSettings As StationSettings = New WorkstationSettings(sSettings.MachineName, GetSupportedMedia())

        _iceSession.AutoReconnectEnabled = True

        _iceSession.Connect(sSettings, hSettings, authSettings, staSettings)

        If _iceSession.ConnectionState = ININ.IceLib.Connection.ConnectionState.Up Then
            SessionCreated()
        Else
            Throw New System.Exception("System could not connect")
        End If

        'SessionCreated()

    End Sub

    Protected Sub StopSession()

        If _iceSession IsNot Nothing AndAlso _iceSession.ConnectionState = ConnectionState.Up Then
            Try

                Interactions1.SetInteractionQueue(Nothing)
                _iceSession.Disconnect()
                _iceSession.Dispose()

                'LogMessage("Connection Closed")
            Catch ex As Exception
                LogException("[SM]Disconnect Error:  " & ex.Message)
            End Try
        End If

        Session("IceSession") = Nothing
        Session("IceUserInfo") = Nothing
        Session("InteractionQueue") = Nothing
        Session("InteractionList") = Nothing
        Session("IcePeopleMan") = Nothing
        Session("IceUserStatusList") = Nothing
        Session("IceUserStatus") = Nothing

    End Sub

    Private Sub SessionCreated()
        _InteractionsManager = InteractionsManager.GetInstance(_iceSession)
        _InteractionQueue = New InteractionQueue(_InteractionsManager, New QueueId(QueueType.MyInteractions, _iceSession.UserId))
        Session("InteractionQueue") = _InteractionQueue
        InitializeInteractionQueue()
        _peopleMan = PeopleManager.GetInstance(_iceSession)
        Session("IcePeopleMan") = _peopleMan
    End Sub

    Private Function GetCurrentSession() As Session
        Try
            _iceSession = Session("IceSession")
        Catch ex As Exception
            LogException("[SM]GetCurrentSession: " & ex.Message)
            Return Nothing
        End Try
    End Function

    Private Function GetSupportedMedia() As SupportedMedia
        Return (SupportedMedia.Call Or SupportedMedia.Chat Or SupportedMedia.Email Or SupportedMedia.Callback)
    End Function

    Private Sub InitializeInteractionQueue()
        Interactions1.SetInteractionQueue(_InteractionQueue)
        AddHandler Interactions1.InteractionAddedEvent, AddressOf InteractionQueue1_InteractionAdded
        AddHandler Interactions1.InteractionRemovedEvent, AddressOf InteractionQueue1_InteractionRemoved
        AddHandler Interactions1.InteractionChangedEvent, AddressOf InteractionQueue1_InteractionChanged
    End Sub

    Private Sub InteractionQueue1_InteractionAdded(ByVal objInteraction As Object, ByVal sInteractionId As String) Handles Interactions1.InteractionAddedEvent

        If Not _interactionList.ContainsKey(sInteractionId) Then
            _interactionList.Add(sInteractionId, objInteraction)
            SaveInteractions()
        End If

        If _currentInteraction Is Nothing OrElse _currentInteraction.State <> InteractionState.Connected Then
            _currentInteraction = CType(objInteraction, Interaction)
            Session("CurrentInteraction") = _currentInteraction
        End If

        UpdateButtons()
    End Sub

    Private Sub InteractionQueue1_InteractionRemoved(ByVal intCurrent As Object, ByVal sInteractionId As String) Handles Interactions1.InteractionRemovedEvent

        If _interactionList.ContainsKey(sInteractionId) Then
            _interactionList.Remove(sInteractionId)
            SaveInteractions()
        End If

        If Not _currentInteraction Is Nothing AndAlso _currentInteraction.InteractionId.ToString = sInteractionId Then
            _currentInteraction = Nothing
            Session("CurrentInteraction") = Nothing
        End If

        Try
            If _currentInteraction Is Nothing AndAlso _interactionList.Count > 0 Then
                For Each interCurrent As Interaction In _interactionList.Values
                    'If Not interCurrent.IsDisconnected Then
                    _currentInteraction = interCurrent
                    Session("CurrentInteraction") = _currentInteraction
                    Exit For
                    'End If
                Next
            End If
        Catch ex As Exception
            'ignore
        End Try

        UpdateButtons()
    End Sub

    Private Sub InteractionQueue1_InteractionChanged(ByVal objInteraction As Object, ByVal sInteractionId As String) Handles Interactions1.InteractionChangedEvent
        If Session("CurrentInteraction") Is Nothing Then
            Session("CurrentInteraction") = objInteraction
            UpdateButtons()
        End If
    End Sub

    Private Sub HandledAttributesChanged(ByVal attributesName As ReadOnlyCollection(Of String))
        If attributesName.Contains(InteractionAttributeName.Capabilities) Then
            UpdateButtons()
        End If
    End Sub

    Protected Sub Timer1_Tick(ByVal sender As Object, ByVal e As System.EventArgs) Handles Timer1.Tick
        Try
            UpdateButtons()
            upCallControls.Update()
            upCallControls1.Update()
            UpdMessage.Update()
            updInteractions.Update()
        Catch ex As Exception
            'LogException("[SM]Timer1_Tick: " & ex.Message)
        End Try
    End Sub

    Private Sub LogException(ByVal Message As String)
        Try
            ShowMessage(Message, True)
            CallControlsHelper.InsertCallMessageLog(Message, _uInfo.UserID)
        Catch ex As Exception
            'Do nothing
        End Try
    End Sub

    Private Sub LogCallEvent(ByVal EventName As String, ByVal CallIdKey As String, ByVal PhoneNumber As String)
        Try
            CallControlsHelper.InsertCallEvent(CallIdKey, PhoneNumber, EventName, _uInfo.UserID)
        Catch ex As Exception
            LogException("[SM]LogCallEvent: " & ex.Message)
        End Try
    End Sub

    Private Sub LogStatusChange(ByVal StatusName As String)
        Try
            CallControlsHelper.InsertStatusChangeLog(StatusName, _uInfo.UserID)
        Catch ex As Exception
            LogException("[SM]LogStatusChange: " & ex.Message)
        End Try
    End Sub

    Private Sub UpdateButtons()
        Try
            UpdateMakeCall()
            UpdateDisconnect()
            UpdatePickup()
            UpdateTransfer()
            UpdateHold()
            UpdateMute()
            UpdateVoiceMail()
            UpdateRecord()
            UpdateDialPad()
            UpdateCurrentInteraction()
            UpdateSessionButtons()
            RefreshInteractions()
            ShowAlerting()
        Catch ex As Exception
            'ignore
        End Try
    End Sub

    Private Sub UpdateCurrentInteraction()

        If _currentInteraction Is Nothing Then
            lblInteractionId.Text = "No Current Interaction"
        Else
            lblInteractionId.Text = "(" & _currentInteraction.StateDescription & ")"
            lblInteractionId.Text = IIf(_currentInteraction.Direction = InteractionDirection.Incoming, "From: ", "To: ") & _currentInteraction.RemoteName & " " & Format(_currentInteraction.Duration.Hours, "0#") & ":" & Format(_currentInteraction.Duration.Minutes, "0#") & ":" & Format(_currentInteraction.Duration.Seconds, "0#") & " (" & _currentInteraction.StateDescription & ") " & _currentInteraction.WorkgroupQueueDisplayName
        End If

    End Sub

    Public Sub UpdateSessionButtons()
        Dim connected As Boolean = _uInfo IsNot Nothing AndAlso _iceSession IsNot Nothing AndAlso _iceSession.ConnectionState = ININ.IceLib.Connection.ConnectionState.Up
        Me.btnDisconnectSession.Visible = Not connected
        Dim msg As String = "No Connected"
        If Not _iceSession Is Nothing Then
            If _iceSession.ConnectionStateMessage.Trim.Length > 0 Then msg = _iceSession.ConnectionStateMessage
        End If
        ShowMessage(msg, Not msg.ToLower.Contains("successfully"))
    End Sub

    Public Sub UpdateDisconnect()
        Try
            Dim connected As Boolean = _uInfo IsNot Nothing AndAlso _iceSession IsNot Nothing AndAlso _iceSession.ConnectionState = ININ.IceLib.Connection.ConnectionState.Up
            If connected AndAlso _currentInteraction IsNot Nothing AndAlso (_currentInteraction.Capabilities.ToString().Contains(InteractionCapabilities.Disconnect.ToString())) AndAlso Not _currentInteraction.IsDisconnected Then
                btnDisconnect.ImageUrl = "~/images/p_hangup.png"
            Else
                btnDisconnect.ImageUrl = "~/images/p_hangup_dis.png"
            End If
            If IsDialerINCall() Then
                btnDisconnect.Style.Add("display", "none")
                tdSepDisconnect.Style.Add("display", "none")
            Else
                btnDisconnect.Style.Add("display", "inline")
                tdSepDisconnect.Style.Add("display", "inline")
            End If
        Catch ex As Exception
            'LogException("[SM]UpdateDisconnect: " & ex.Message)
        End Try
    End Sub

    Public Sub UpdateMakeCall()
        Try
            Dim connected As Boolean = _uInfo IsNot Nothing AndAlso _iceSession IsNot Nothing AndAlso _iceSession.ConnectionState = ININ.IceLib.Connection.ConnectionState.Up
            If connected AndAlso (_currentInteraction Is Nothing OrElse _currentInteraction.IsDisconnected) Then
                btnMakeCall.ImageUrl = "~/images/phone2.png"
            Else
                btnMakeCall.ImageUrl = "~/images/phone_dis.png"
            End If
        Catch ex As Exception
            'LogException("[SM]UpdateMakeCall: " & ex.Message)
        End Try
    End Sub

    Public Sub UpdateDialPad()
        Try
            Dim connected As Boolean = _uInfo IsNot Nothing AndAlso _iceSession IsNot Nothing AndAlso _iceSession.ConnectionState = ININ.IceLib.Connection.ConnectionState.Up
            If connected AndAlso Not _currentInteraction Is Nothing AndAlso Not _currentInteraction.IsDisconnected Then
                btnDialPad.ImageUrl = "~/images/p_dialpad.png"
            Else
                btnDialPad.ImageUrl = "~/images/p_dialpad_dis.png"
            End If
        Catch ex As Exception
            'LogException("[SM]UpdateDialPad: " & ex.Message)
        End Try
    End Sub

    Public Sub UpdatePickup()
        Try
            Dim connected As Boolean = _uInfo IsNot Nothing AndAlso _iceSession IsNot Nothing AndAlso _iceSession.ConnectionState = ININ.IceLib.Connection.ConnectionState.Up
            If connected AndAlso Not _currentInteraction Is Nothing AndAlso _currentInteraction.Capabilities.ToString().Contains(InteractionCapabilities.Pickup.ToString()) AndAlso Not _currentInteraction.IsDisconnected Then
                btnPickup.ImageUrl = "~/images/p_pickup.png"
            Else
                btnPickup.ImageUrl = "~/images/p_pickup_dis.png"
            End If
        Catch ex As Exception
            'LogException("[SM]UpdatePickup: " & ex.Message)
        End Try
    End Sub

    Public Sub UpdateTransfer()
        Try
            Dim connected As Boolean = _uInfo IsNot Nothing AndAlso _iceSession IsNot Nothing AndAlso _iceSession.ConnectionState = ININ.IceLib.Connection.ConnectionState.Up
            If connected AndAlso Not _currentInteraction Is Nothing AndAlso _currentInteraction.Capabilities.ToString().Contains(InteractionCapabilities.Transfer.ToString()) AndAlso Not _currentInteraction.IsDisconnected Then
                btnTransfer.ImageUrl = "~/images/p_transfer.png"
            Else
                btnTransfer.ImageUrl = "~/images/p_transfer_dis.png"
            End If
        Catch ex As Exception
            'LogException("[SM]UpdateTransfer: " & ex.Message)
        End Try
    End Sub

    Private Sub UpdateHold()
        Try
            Dim connected As Boolean = _uInfo IsNot Nothing AndAlso _iceSession IsNot Nothing AndAlso _iceSession.ConnectionState = ININ.IceLib.Connection.ConnectionState.Up
            If connected AndAlso Not _currentInteraction Is Nothing AndAlso _currentInteraction.Capabilities.ToString().Contains(InteractionCapabilities.Hold.ToString()) AndAlso Not _currentInteraction.IsDisconnected Then
                If _currentInteraction.IsHeld Then
                    btnHold.ImageUrl = "~/images/p_hold_on.png"
                Else
                    btnHold.ImageUrl = "~/images/p_hold.png"
                End If
                If IsDialerINCall() Then
                    btnHold.Style.Add("display", "none")
                    tdSepHold.Style.Add("display", "none")
                Else
                    btnHold.Style.Add("display", "inline")
                    tdSepHold.Style.Add("display", "inline")
                End If
            Else
                btnHold.ImageUrl = "~/images/p_hold_dis.png"
            End If
        Catch ex As Exception
            'LogException("[SM]UpdateHold: " & ex.Message)
        End Try
    End Sub

    Private Sub UpdateMute()
        Try
            Dim connected As Boolean = _uInfo IsNot Nothing AndAlso _iceSession IsNot Nothing AndAlso _iceSession.ConnectionState = ININ.IceLib.Connection.ConnectionState.Up
            If connected AndAlso Not _currentInteraction Is Nothing AndAlso _currentInteraction.Capabilities.ToString().Contains(InteractionCapabilities.Mute.ToString()) AndAlso Not _currentInteraction.IsDisconnected Then
                If _currentInteraction.IsMuted Then
                    btnMute.ImageUrl = "~/images/p_mute_on.gif"
                Else
                    btnMute.ImageUrl = "~/images/p_mute.gif"
                End If
            Else
                btnMute.ImageUrl = "~/images/p_mute_dis.gif"
            End If
        Catch ex As Exception
            'LogException("[SM]UpdateMute: " & ex.Message)
        End Try
    End Sub

    Public Sub UpdateVoiceMail()
        Try
            Dim connected As Boolean = _uInfo IsNot Nothing AndAlso _iceSession IsNot Nothing AndAlso _iceSession.ConnectionState = ININ.IceLib.Connection.ConnectionState.Up
            If connected AndAlso Not _currentInteraction Is Nothing AndAlso _currentInteraction.Capabilities.ToString().Contains(InteractionCapabilities.Messaging.ToString()) AndAlso Not _currentInteraction.IsDisconnected Then
                btnVoiceMail.ImageUrl = "~/images/p_voicemail.gif"
            Else
                btnVoiceMail.ImageUrl = "~/images/p_voicemail_dis.gif"
            End If
            If IsDialerINCall() Then
                btnVoiceMail.Style.Add("display", "none")
                tdSepVoiceMail.Style.Add("display", "none")
            Else
                btnVoiceMail.Style.Add("display", "inline")
                tdSepVoiceMail.Style.Add("display", "inline")
            End If
        Catch ex As Exception
            'LogException("[SM]UpdateVoiceMail: " & ex.Message)
        End Try
    End Sub

    Public Sub UpdateRecord()
        Try
            Dim connected As Boolean = _uInfo IsNot Nothing AndAlso _iceSession IsNot Nothing AndAlso _iceSession.ConnectionState = ININ.IceLib.Connection.ConnectionState.Up
            If connected AndAlso Not _currentInteraction Is Nothing AndAlso _currentInteraction.Capabilities.ToString().Contains(InteractionCapabilities.Record.ToString()) AndAlso Not _currentInteraction.IsDisconnected Then
                If _currentInteraction.IsRecording Then
                    btnRecord.ImageUrl = "~/images/p_record_stop.png"
                Else
                    btnRecord.ImageUrl = "~/images/p_record.png"
                End If
            Else
                btnRecord.ImageUrl = "~/images/p_record_dis.png"
            End If
        Catch ex As Exception
            'LogException("[SM]UpdateVoiceMail: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnDisconnect_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnDisconnect.Click
        DisconnectCurrentCall()
    End Sub

    Private Sub DisconnectCurrentCall()
        Try
            If _currentInteraction IsNot Nothing AndAlso _currentInteraction.Capabilities.ToString().Contains(InteractionCapabilities.Disconnect.ToString()) AndAlso Not IsDialerINCall() Then
                RaiseEvent BeforeDisconnect()
                _currentInteraction.Disconnect()
                LogCallEvent("disconnect", _currentInteraction.CallIdKey, Nothing)
                RaiseEvent AfterDisconnect()
            End If
        Catch ex As Exception
            LogException("[SM]btnDisconnect_Click: " & ex.Message)
        End Try
    End Sub

    Private Sub DisconnectDialerCall()
        Try
            If _currentInteraction IsNot Nothing AndAlso _currentInteraction.Capabilities.ToString().Contains(InteractionCapabilities.Disconnect.ToString()) Then
                RaiseEvent BeforeDisconnect()
                _currentInteraction.Disconnect()
                LogCallEvent("disconnect", _currentInteraction.CallIdKey, Nothing)
                RaiseEvent AfterDisconnect()
            End If
        Catch ex As Exception
            LogException("[SM]btnDisconnect_Click: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnMakeCall_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnMakeCall.Click
        Try
            Dim target As String = txtNumber.Text.Trim.Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "")
            txtNumber.Text = target
            If target.Length > 0 AndAlso _iceSession.ConnectionState = ININ.IceLib.Connection.ConnectionState.Up Then
                _InteractionsManager = InteractionsManager.GetInstance(_iceSession)
                Dim bIsLead As Boolean = (hdnCallContolLeadId.Value.Trim.Length > 0)
                Dim parms As CallInteractionParameters = New CallInteractionParameters(target, CallMadeStage.Allocated)
                Dim CustomAni As String = ""
                If bIsLead Then
                    CustomAni = CallControlsHelper.GetLeadCustomAni(target)
                    If CustomAni.Length = 0 Then CustomAni = "8003041785"
                End If
                If CustomAni.Length > 0 Then parms.AdditionalAttributes.Add("CustomAni", CustomAni)
                Dim intCurrent As CallInteraction = _InteractionsManager.MakeCall(parms)
                If Not intCurrent.IsWatching Then intCurrent.StartWatching(CallConstants._NecessaryAttributes)
                _currentInteraction = intCurrent
                Session("CurrentInteraction") = _currentInteraction
                LogCallEvent("makecall", intCurrent.CallIdKey, target)
                If bIsLead Then InsertLeadNote(hdnCallContolLeadId.Value, String.Format("Call made to phone number {0} on {1} by {2}.", txtNumber.Text, Now.ToString, _uInfo.Username))
                RaiseEvent AfterMakeCall(intCurrent.CallIdKey, target)
            End If
        Catch ex As Exception
            LogException("[SM]btnMakeCall_Click: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnCIDDialerMakeCall_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCIDDialerMakeCall.Click
        Try
            DisconnectDialerCall()
            Dim CallMadeId As Integer = CInt(hdnDialerCallId.Value.Trim)
            Dim dtDialerCall As System.Data.DataTable = DialerHelper.GetLeadDialerCallById(CallMadeId)
            Dim target As String = dtDialerCall.Rows(0)("PhoneNumber").Trim.Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "")
            Dim Leadid As Integer = dtDialerCall.Rows(0)("LeadApplicantId")
            txtNumber.Text = target
            If target.Length > 0 AndAlso _iceSession.ConnectionState = ININ.IceLib.Connection.ConnectionState.Up Then
                _InteractionsManager = InteractionsManager.GetInstance(_iceSession)
                Dim parms As CallInteractionParameters = New CallInteractionParameters(target, CallMadeStage.Allocated)
                Dim AppointmentId As Integer = CIDAppointmentHelper.GetAppointmentIdByCallMade(CallMadeId)
                Dim CustomAni As String = ""
                CustomAni = CallControlsHelper.GetLeadCustomAni(target)
                If CustomAni.Length = 0 Then CustomAni = "8003041785"
                If CustomAni.Length > 0 Then parms.AdditionalAttributes.Add("CustomAni", CustomAni)
                parms.AdditionalAttributes.Add("CallMadeId", CallMadeId)
                parms.AdditionalAttributes.Add("LeadId", Leadid)
                parms.AdditionalAttributes.Add("IsCIDDialerOutCall", "yes")
                If AppointmentId > 0 Then
                    parms.AdditionalAttributes.Add("AppoinmentId", AppointmentId)
                End If
                Dim intCurrent As CallInteraction = _InteractionsManager.MakeCall(parms)
                If Not intCurrent.IsWatching Then intCurrent.StartWatching(CallConstants._NecessaryAttributes)
                'intCurrent.SetStringAttribute("IsCIDDialerOutCall", "yes")
                _currentInteraction = intCurrent
                Session("CurrentInteraction") = _currentInteraction
                LogCallEvent("makecall", intCurrent.CallIdKey, target)
                If AppointmentId > 0 Then
                    CIDAppointmentHelper.UpdateLeadAppointment(AppointmentId, "", Nothing, Nothing, "", 1, intCurrent.CallIdKey, _uInfo.UserID, Now, Nothing, _uInfo.UserID)
                End If
                InsertLeadNote(Leadid, String.Format("Dialer call made to phone number {0} on {1} by {2}.", txtNumber.Text, Now.ToString, _uInfo.Username))
                RaiseEvent AfterCIDCallMade(intCurrent.CallIdKey, CallMadeId, Leadid)
            End If
        Catch ex As Exception
            LogException("[SM]btnCIDDialerMakeCall_Click: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnDialerINMakeCall_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDialerINMakeCall.Click
        Try
            DisconnectDialerCall()
            Dim CallMadeId As Integer = CInt(hdnDialerCallId.Value.Trim)
            DialerHelper.UpdateCallMade(CallMadeId, 0, Nothing, Now, _uInfo.UserID, Now, _uInfo.UserID, "")
            Dim dtDialerCall As System.Data.DataTable = DialerHelper.GetDialerCall(CallMadeId)
            Dim target As String = dtDialerCall.Rows(0)("Phone").Trim.Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "")
            Dim Clientid As Integer = dtDialerCall.Rows(0)("ClientId")
            txtNumber.Text = target
            If target.Length > 0 AndAlso _iceSession.ConnectionState = ININ.IceLib.Connection.ConnectionState.Up Then
                _InteractionsManager = InteractionsManager.GetInstance(_iceSession)
                Dim parms As CallInteractionParameters = New CallInteractionParameters(target, CallMadeStage.Allocated)
                Dim CustomAni As String = "5555555"
                If CustomAni.Length > 0 Then parms.AdditionalAttributes.Add("CustomAni", CustomAni)
                parms.AdditionalAttributes.Add("CallMadeId", CallMadeId)
                parms.AdditionalAttributes.Add("ClientId", Clientid)
                parms.AdditionalAttributes.Add("IsDialerInOutCall", "yes")
                Dim intCurrent As CallInteraction = _InteractionsManager.MakeCall(parms)
                If Not intCurrent.IsWatching Then intCurrent.StartWatching(CallConstants._NecessaryAttributes)
                _currentInteraction = intCurrent
                Session("CurrentInteraction") = _currentInteraction
                LogCallEvent("makecall", intCurrent.CallIdKey, target)
                Drg.Util.DataHelpers.NoteHelper.InsertNote(String.Format("Dialer call made to phone number {0} on {1} by {2}.", txtNumber.Text, Now.ToString, _uInfo.Username), _uInfo.UserID, Clientid)
                RaiseEvent AfterDialerINCallMade(intCurrent.CallIdKey, CallMadeId, Clientid)
            End If
        Catch ex As Exception
            LogException("[SM]btnDialerINMakeCall_Click: " & ex.Message)
        End Try
    End Sub

    Protected Sub lnkDialPad_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDialPad.Click
        Try
            Dim target As String = hdnDialPad.Value.Trim
            If target.Length > 0 AndAlso _iceSession.ConnectionState = ININ.IceLib.Connection.ConnectionState.Up Then
                If _currentInteraction IsNot Nothing Then
                    CType(_currentInteraction, CallInteraction).PlayDigits(target)
                    LogCallEvent("dialpad", _currentInteraction.CallIdKey, Nothing)
                End If
            End If
        Catch ex As Exception
            LogException("[SM]btnDialPad_Click: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnPickup_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnPickup.Click
        DoPickup()
    End Sub

    Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnSearch.Click
        Try
            If _currentInteraction IsNot Nothing Then
                Dim args As New CallEventArgs(_currentInteraction.CallIdKey)
                Dim ani As String = _currentInteraction.RemoteAddress
                If ani.Length > 10 Then ani = ani.Substring(ani.Length - 10, 10)
                args.RemoteNumber = ani

                'Get Client Id
                Try
                    If _currentInteraction.GetStringAttribute("Custom_ATTR_ClientId").Trim.Length > 0 Then
                        args.ClientId = _currentInteraction.GetStringAttribute("Custom_ATTR_ClientId").Trim
                    End If
                Catch ex As Exception
                    'ignore
                End Try

                'Get WorkGroup Queue
                Try
                    If _currentInteraction.GetStringAttribute("WorkgroupQueueName").Trim.Length > 0 Then
                        args.WorkgroupQueue = _currentInteraction.GetStringAttribute("WorkgroupQueueName").Trim
                    End If
                Catch ex As Exception
                    'ignore
                End Try

                RaiseEvent OnSearching(args)
            End If
        Catch ex As Exception
            LogException("[SM]On Search: " & ex.Message)
        End Try
    End Sub

    Private Function IsCIDDialerCall() As Boolean
        Try
            Return (_currentInteraction.GetStringAttribute("IsCIDDialerCall") = "yes")
        Catch ex As Exception
            Return False
        End Try
    End Function

    Private Function IsCIDDialerOutCall() As Boolean
        Try
            Return (_currentInteraction.GetStringAttribute("IsCIDDialerOutCall") = "yes")
        Catch ex As Exception
            Return False
        End Try
    End Function

    Private Function IsDialerINCall() As Boolean
        Try
            Return False
            'Return (_currentInteraction.GetStringAttribute("IsDialerINCall") = "yes" OrElse _currentInteraction.GetStringAttribute("IsCIDDialerCall") = "yes")
        Catch ex As Exception
            Return False
        End Try
    End Function

    Private Sub DoPickup()
        Try
            If _currentInteraction IsNot Nothing AndAlso _currentInteraction.Capabilities.ToString().Contains(InteractionCapabilities.Pickup.ToString()) Then
                RaiseEvent BeforePickup()
                _currentInteraction.Pickup()
                LogCallEvent("pickup", _currentInteraction.CallIdKey, Nothing)
                Dim args As New CallEventArgs(_currentInteraction.CallIdKey)

                Try
                    args.IntercomParty = _currentInteraction.GetStringAttribute("Eic_IntercomParty")
                Catch ex As Exception
                    'ignore  
                End Try

                Try
                    args.IsDialerCall = _currentInteraction.GetStringAttribute("IsDialerCall") = "yes"
                Catch ex As Exception
                    args.IsDialerCall = False
                End Try

                Try
                    args.IsDialerINCall = _currentInteraction.GetStringAttribute("IsDialerINCall") = "yes"
                Catch ex As Exception
                    args.IsDialerINCall = False
                End Try

                Try
                    Dim sd As String = _currentInteraction.GetStringAttribute("IsCIDDialerCall")
                    args.IsCIDDialerCall = (sd = "yes")
                Catch ex As Exception
                    args.IsCIDDialerCall = False
                End Try

                Try
                    args.DialerCallMadeId = CInt(_currentInteraction.GetStringAttribute("CallMadeId"))
                Catch ex As Exception
                    'ignore  
                End Try

                Try
                    args.AppointmentId = CInt(_currentInteraction.GetStringAttribute("AppointmentId"))
                Catch ex As Exception
                    args.AppointmentId = 0
                End Try

                Dim ani As String = _currentInteraction.RemoteAddress
                If ani.Length > 10 Then ani = ani.Substring(ani.Length - 10, 10)
                args.RemoteNumber = ani

                'Get Client Id
                Try
                    If _currentInteraction.GetStringAttribute("Custom_ATTR_ClientID").Trim.Length > 0 Then
                        args.ClientId = _currentInteraction.GetStringAttribute("Custom_ATTR_ClientID").Trim
                    End If
                Catch ex As Exception
                    'ignore
                End Try

                'Get WorkGroup Queue
                Try
                    If _currentInteraction.WorkgroupQueueName.Trim.Length > 0 Then
                        args.WorkgroupQueue = _currentInteraction.WorkgroupQueueName.Trim
                    End If
                Catch ex As Exception
                    'ignore
                End Try

                RaiseEvent AfterPickup(args)
            End If
        Catch ex As Exception
            LogException("[SM]btnPickup_Click: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnTransfer_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnTransfer.Click
        DoTransfer()
    End Sub

    Private Sub DoTransfer()
        Try
            Dim target As String = txtTransfer.Text.Trim.Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "")
            txtTransfer.Text = target
            If target.Length > 0 AndAlso _currentInteraction IsNot Nothing AndAlso _currentInteraction.Capabilities.ToString().Contains(InteractionCapabilities.Transfer.ToString()) Then
                RaiseEvent BeforeTransfer()
                _currentInteraction.BlindTransfer(target)
                LogCallEvent("transfer", _currentInteraction.CallIdKey, target)
                RaiseEvent AfterTransfer()
            End If
        Catch ex As Exception
            LogException("[SM]btnTransfer_Click: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnHold_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnHold.Click
        Try
            If _currentInteraction IsNot Nothing AndAlso _currentInteraction.Capabilities.ToString().Contains(InteractionCapabilities.Hold.ToString()) Then
                RaiseEvent BeforeHold()
                _currentInteraction.Hold(Not _currentInteraction.IsHeld)
                LogCallEvent("hold", _currentInteraction.CallIdKey, Nothing)
                RaiseEvent AfterHold()
            End If
        Catch ex As Exception
            LogException("[SM]btnHold_Click: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnMute_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnMute.Click
        Try
            If _currentInteraction IsNot Nothing AndAlso _currentInteraction.Capabilities.ToString().Contains(InteractionCapabilities.Mute.ToString()) Then
                RaiseEvent BeforeMute()
                _currentInteraction.Mute(Not _currentInteraction.IsMuted)
                LogCallEvent("mute", _currentInteraction.CallIdKey, Nothing)
                RaiseEvent AfterMute()
            End If
        Catch ex As Exception
            LogException("[SM]btnMute_Click: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnVoiceMail_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnVoiceMail.Click
        Try
            If _currentInteraction IsNot Nothing AndAlso _currentInteraction.Capabilities.ToString().Contains(InteractionCapabilities.Messaging.ToString()) Then
                RaiseEvent BeforeVoiceMail()
                _currentInteraction.Voicemail()
                LogCallEvent("voicemail", _currentInteraction.CallIdKey, Nothing)
                RaiseEvent AfterVoiceMail()
            End If
        Catch ex As Exception
            LogException("[SM]btnVoiceMail_Click: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnTransferVoiceMail_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnTransferVoiceMail.Click
        Try
            Dim target As String = txtTransfer.Text.Trim.Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "")
            txtTransfer.Text = target
            If target.Length > 0 AndAlso _currentInteraction IsNot Nothing AndAlso _currentInteraction.Capabilities.ToString().Contains(InteractionCapabilities.Transfer.ToString()) Then
                _currentInteraction.TransferToVoicemail(target)
                LogCallEvent("transfertovoicemail", _currentInteraction.CallIdKey, target)
            End If
        Catch ex As Exception
            LogException("[SM]btnTransferVoiceMail_Click: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnTransferPark_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnTransferPark.Click
        Try
            Dim target As String = txtTransfer.Text.Trim.Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "")
            txtTransfer.Text = target
            If target.Length > 0 AndAlso _currentInteraction IsNot Nothing AndAlso _currentInteraction.Capabilities.ToString().Contains(InteractionCapabilities.Park.ToString()) Then
                _currentInteraction.Park(target)
                LogCallEvent("park", _currentInteraction.CallIdKey, target)
            End If
        Catch ex As Exception
            LogException("[SM]btnTransferPark_Click: " & ex.Message)
        End Try
    End Sub

    Protected Sub CreateConference(ByVal Interactions As CallInteraction())
        Try
            _InteractionsManager = InteractionsManager.GetInstance(_iceSession)
            Dim conference As InteractionConference = _InteractionsManager.MakeNewConference(Interactions)
            'Session("CurrentInteraction") = _currentInteraction
            LogCallEvent("conference", conference.ConferenceId.Id, Nothing)
        Catch ex As Exception
            LogException("[SM]Create Conference: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnRecord_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnRecord.Click
        DoRecord("")
    End Sub


    Private Function GetRecordingId() As String
        Dim recIntId As String = String.Empty
        Dim interQ As InteractionQueue = _InteractionQueue
        Try
            Dim inters As System.Collections.ObjectModel.ReadOnlyCollection(Of Interaction) = interQ.GetContents()
            Dim recInt As RecorderInteraction
            For Each inter As Interaction In inters
                If TypeOf inter Is RecorderInteraction Then
                    recInt = CType(inter, RecorderInteraction)
                    recIntId = recInt.CallIdKey.ToString
                End If
            Next
        Catch ex As Exception
            LogException("Retrieving Recorded Call Id: " & ex.Message)
        End Try
        Return recIntId
    End Function

    Private Sub DoRecord(ByVal action As String)
        Try
            If _currentInteraction IsNot Nothing AndAlso _currentInteraction.Capabilities.ToString().Contains(InteractionCapabilities.Record.ToString()) Then
                RaiseEvent BeforeRecord()
                Select Case action.ToLower
                    Case "start"
                        _currentInteraction.Record(True, False)
                    Case "stop"
                        _currentInteraction.Record(False, False)
                    Case Else
                        _currentInteraction.Record(Not _currentInteraction.IsRecording, False)
                End Select
                LogCallEvent("record " & action, _currentInteraction.CallIdKey, Nothing)
                RaiseEvent AfterRecord()
            End If
        Catch ex As Exception
            LogException("[SM]btnRecord_Click " & action & ex.Message)
        End Try
    End Sub

    Protected Sub ddlUserStatus_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlUserStatus.SelectedIndexChanged
        If ddlUserStatus.SelectedIndex <> -1 Then
            _currentStatus = ddlUserStatus.SelectedItem.Text
            Session("IceUserStatus") = _currentStatus
            ChangeStatus(ddlUserStatus.SelectedValue)
        End If
    End Sub

    Private Sub SetCurrentStatus()
        If Not _iceSession Is Nothing AndAlso Not _userStatuses Is Nothing Then
            Dim currentStatus As UserStatus = _userStatuses(_iceSession.UserId)
            _currentStatus = currentStatus.StatusMessageDetails.MessageText
            Session("IceUserStatus") = _currentStatus
        End If

    End Sub

    Private Sub LoadUserStatuses()
        Try
            If _peopleMan Is Nothing Then Return

            _userStatuses = New UserStatusList(_peopleMan)

            Session("IceUserStatusList") = _userStatuses

            If Not _userStatuses.IsWatching Then _userStatuses.StartWatching(New String() {_iceSession.UserId})
            AddHandler _userStatuses.WatchedObjectsChanged, AddressOf UserStatus_Changed

            Dim statusList As New Dictionary(Of String, CallUserStatus)

            Dim statuses As New StatusMessageList(_peopleMan)
            If Not statuses.IsWatching() Then statuses.StartWatching()

            If Not statuses Is Nothing Then
                Dim status As CallUserStatus

                For Each msg As StatusMessageDetails In statuses.GetList
                    If msg.IsSelectableStatus OrElse msg.MessageText.ToLower.Contains("follow up") OrElse msg.MessageText.ToLower.Contains("acd - agent not answering") Then
                        status = New CallUserStatus(msg.Id, msg.MessageText)
                        statusList.Add(status.ID, status)
                    End If
                Next
            End If

            statusList.Add("Invalid Status", New CallUserStatus("-1", ""))
            ddlUserStatus.DataSource = statusList.Values
            ddlUserStatus.DataValueField = "Id"
            ddlUserStatus.DataTextField = "Description"
            ddlUserStatus.DataBind()

        Catch ex As Exception
            LogException("[SM]LoadUserStatus: " & ex.Message)
        End Try

    End Sub

    Private Sub ChangeStatus(ByVal StatusId As String)
        Try
            Dim statuses As New StatusMessageList(_peopleMan)
            If Not statuses.IsWatching() Then statuses.StartWatching()

            If statuses.IsValidStatus(StatusId) Then
                Dim Status As StatusMessageDetails = statuses(StatusId)
                Dim statusNew As New UserStatusUpdate(_peopleMan)
                statusNew.StatusMessageDetails = Status
                statusNew.UpdateRequest()
                LogStatusChange(StatusId)
            End If
        Catch ex As Exception
            LogException("[SM]ChangeStatus: " & ex.Message)
        End Try
    End Sub

    Private Sub UserStatus_Changed(ByVal sender As Object, ByVal e As WatchedObjectsEventArgs(Of ININ.IceLib.People.UserStatusProperty)) 'Handles _userStatuses.WatchedObjectsChanged
        If e.Changed(_iceSession.UserId).Contains(UserStatusProperty.StatusChanged) Then
            SetCurrentStatus()
        End If
    End Sub

    Private Sub DisconnectSession()
        Interactions1.SetInteractionQueue(Nothing)
        If _uInfo IsNot Nothing AndAlso _iceSession IsNot Nothing AndAlso _iceSession.ConnectionState = ConnectionState.Up Then
            Try
                _iceSession.Disconnect()
                'LogMessage("Connection Closed")
            Catch ex As Exception
                LogException("[SM]Disconnect Error:  " & ex.Message)
            End Try
        End If
    End Sub

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        If Not _currentStatus Is Nothing AndAlso (ddlUserStatus.SelectedIndex < 0 OrElse _currentStatus.ToLower <> ddlUserStatus.SelectedItem.Text.ToLower) Then
            ddlUserStatus.SelectedIndex = ddlUserStatus.Items.IndexOf(ddlUserStatus.Items.FindByText(_currentStatus))
            Me.upStatusChange.Update()
        End If
        If Not _iceSession Is Nothing AndAlso Not _userStatuses Is Nothing Then
            Dim currentStatus As UserStatus = _userStatuses.GetUserStatus(_iceSession.UserId)
            If currentStatus.StatusChangedHasValue Then
                Dim ts As TimeSpan = Now.Subtract(currentStatus.StatusChanged)
                Me.lblTimeInStatus.Text = String.Format("{0}d:{1:D2}:{2:D2}:{3:D2}", ts.Days, ts.Hours, ts.Minutes, ts.Seconds)
                Me.upTimeChange.Update()
            End If
        End If
    End Sub

    Private Sub ShowMessage(ByVal Msg As String, ByVal IsError As Boolean)
        Me.imgFace.Src = IIf(IsError, ResolveUrl("~/images/sad_face.gif"), ResolveUrl("~/images/happy_face.gif"))
        Me.imgFace.Attributes.Add("title", Msg)
    End Sub

    Protected Sub btnDisconnectSession_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDisconnectSession.Click
        Me.StopSession()
    End Sub

    Private Sub RefreshInteractions()
        Try
            Me.grdInteractions.DataSource = Me._interactionList.Values
            Me.grdInteractions.DataBind()


            If grdInteractions.DataKeys.Count > 0 AndAlso Not _currentInteraction Is Nothing AndAlso (Me.grdInteractions.SelectedIndex < 0 OrElse (Not grdInteractions.SelectedDataKey Is Nothing AndAlso (grdInteractions.SelectedDataKey.Value.ToString <> _currentInteraction.InteractionId.ToString))) Then
                For Each row As GridViewRow In grdInteractions.Rows
                    If grdInteractions.DataKeys(row.RowIndex).Value.ToString = _currentInteraction.InteractionId.ToString Then
                        grdInteractions.SelectedIndex = row.RowIndex
                        Exit For
                    End If
                Next
            End If
        Catch ex As Exception
            'ignore
        End Try

    End Sub

    Protected Sub grdInteractions_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles grdInteractions.RowCommand
        Me.grdInteractions.SelectedIndex = e.CommandArgument
        _currentInteraction = _interactionList(grdInteractions.SelectedDataKey.Value.ToString)
        Session("CurrentInteraction") = _currentInteraction
    End Sub

    Public Sub InsertLeadNote(ByVal LeadId As Integer, ByVal Note As String)
        Try
            CallControlsHelper.InsertLeadNote(Note, LeadId, _uInfo.UserID)
        Catch ex As Exception
            LogException("[SM]Insert Lead Note Error:  " & ex.Message)
        End Try
    End Sub

    Private Function ActivateRinger() As Boolean
        If Not Me.Request.Cookies("CallControls") Is Nothing AndAlso Me.Request.Cookies("CallControls")("RingAlert").ToString = "yes" Then
            Me.ImgBell.ImageUrl = "~/images/bell_yes.gif"
            Me.ImgBell.ToolTip = "Turn ringer off"
            Return True
        Else
            Me.ImgBell.ImageUrl = "~/images/bell_no.gif"
            Me.ImgBell.ToolTip = "Turn ringer on"
            Return False
        End If
    End Function

    Private Sub ShowAlerting()
        Dim ringerOn As Boolean = ActivateRinger()

        Dim litvalue As New StringBuilder
        Dim countAlerts As Integer = 0
        Dim isdialer As Boolean = False
        If Not _interactionList Is Nothing Then
            For Each inter As Interaction In _interactionList.Values
                If inter.StateDescription.ToLower = "alerting" Then
                    Try
                        If inter.GetStringAttribute("IsCIDDialerCall") = "yes" OrElse inter.GetStringAttribute("IsDialerINCall") = "yes" Then
                            isdialer = True
                        End If
                        litvalue.AppendFormat("<img id='img{0}' src='{1}' title='Incoming call from {2}' onclick=""directPickup('{0}');"" style='width: 16px; height: 16px; cursor: hand;'/>", inter.InteractionId.ToString, ResolveUrl("~/images/RingPhone.gif"), inter.RemoteName)
                        countAlerts += 1
                    Catch ex As Exception
                        'Error
                    End Try
                End If
            Next
        End If

        If ringerOn AndAlso countAlerts > 0 Then

            Try
                If countAlerts > 0 Then
                    If (_currentInteraction Is Nothing OrElse _currentInteraction.IsDisconnected OrElse _currentInteraction.State = InteractionState.Alerting) Then
                        'Ring if no current on a call
                        countAlerts = 1
                    Else
                        countAlerts = 2
                    End If
                End If
            Catch ex As Exception
                'Do Nothing
            End Try


            Select Case countAlerts
                Case 0
                    'Do Nothing
                Case 1
                    If isdialer Then
                        litvalue.Insert(0, String.Format("<embed src='{0}' autostart='true' loop='false' visible='false' width='0' height='0'></embed>", ResolveUrl("~/CallControls/sounds/beeep.wav")))
                    Else
                        litvalue.Insert(0, String.Format("<embed src='{0}' autostart='true' loop='false' visible='false' width='0' height='0'></embed>", ResolveUrl("~/CallControls/sounds/RingIn.wav")))
                    End If
                Case Else
                    litvalue.Insert(0, String.Format("<embed src='{0}' autostart='true' loop='false' visible='false' width='0' height='0'></embed>", ResolveUrl("~/CallControls/sounds/beep.wav")))
            End Select
        End If

        'If ringerOn AndAlso countAlerts > 0 Then
        '    litvalue.Insert(0, String.Format("<embed src='{0}' autostart='true' loop='false' visible='false' width='0' height='0'></embed>", ResolveUrl("~/CallControls/sounds/RingIn.wav")))
        'End If

        Me.ltlAlerting.Text = litvalue.ToString

        If countAlerts > 0 Then
            ScriptManager.RegisterClientScriptBlock(Me.Page, GetType(Page), "startupactivate", "window.focus();", True)
        End If
    End Sub

    Protected Sub btnDirectPickup_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDirectPickup.Click
        Try
            _currentInteraction = _interactionList(Me.hdnDirectPickup.Value)
            Session("CurrentInteraction") = _currentInteraction
            DoPickup()
        Catch ex As Exception
            LogException("[SM]DirectPickup_Click: " & ex.Message)
        End Try
    End Sub

    Protected Sub ImgBell_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImgBell.Click
        ToggleRinger()
        ActivateRinger()
    End Sub

    Private Sub ToggleRinger()
        Dim ringbell As String = "no"
        If Not Me.Request.Cookies("CallControls") Is Nothing AndAlso Me.Request.Cookies("CallControls")("RingAlert").ToString = "no" Then
            ringbell = "yes"
        End If
        Dim cookie As New HttpCookie("CallControls")
        cookie.Values("RingAlert") = ringbell
        cookie.Expires = Now.AddYears(50)
        Me.Response.Cookies.Add(cookie)
    End Sub

    Protected Sub lnkStartRecord_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkStartRecord.Click
        DoRecord("start")
    End Sub

    Protected Sub lnkStopRecord_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkStopRecord.Click
        DoRecord("stop")
    End Sub

    Protected Sub lnkCompleteUWVerifCall_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCompleteUWVerifCall.Click
        Dim recInt As String = Me.GetRecordingId()
        DoRecord("stop")
        Try
            If recInt.Trim.Length > 0 AndAlso Me.hdnUWVerifId.Value.Trim.Length > 0 Then
                CallVerificationHelper.UpdateVerificationCall(CInt(Me.hdnUWVerifId.Value.Trim), Nothing, Nothing, recInt, "", "", "", "")
            End If
        Catch ex As Exception
            LogException("Could not write Verification Recording Id")
        Finally
            Me.hdnUWVerifId.Value = ""
        End Try

    End Sub

    Protected Sub lnkCompleteRecordingCall_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCompleteRecordingCall.Click
        Dim recInt As String = Me.GetRecordingId()
        DoRecord("stop")
        Try
            If recInt.Trim.Length > 0 AndAlso Me.hdnRecordingCallId.Value.Trim.Length > 0 Then
                CallControlsHelper.UpdateCallRecording(CInt(Me.hdnRecordingCallId.Value.Trim), recInt, "", "", 0, "")
            End If
        Catch ex As Exception
            LogException("Could not write Recording Id")
        Finally
            Me.hdnRecordingCallId.Value = ""
        End Try

    End Sub

    Protected Sub lnkSwitchRedirect_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSwitchRedirect.Click
        Me.Response.Redirect("~/Redirect.aspx")
    End Sub

   
    Protected Sub lnkConference_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkJoinToConference.Click
        Try
            Dim target As String = hdnLastInterId.Value.Trim
            If target.Length > 0 AndAlso _iceSession.ConnectionState = ININ.IceLib.Connection.ConnectionState.Up Then
                If _currentInteraction IsNot Nothing AndAlso _interactionList.ContainsKey(target) Then
                    Dim inter As Interaction = _interactionList.Item(target)
                    CreateConference(New CallInteraction() {_currentInteraction, inter})
                End If
            End If
        Catch ex As Exception
            LogException("[SM]btnConference_Click: " & ex.Message)
        End Try
    End Sub
End Class
