Imports System.Data
Partial Class Clients_Enrollment_Main3
    Inherits System.Web.UI.Page

    Protected Sub CallControlBar1_AfterCIDCallMade(ByVal CallIdKey As String, ByVal CallMadeId As Integer, ByVal LeadId As Integer) Handles CallControlBar1.AfterCIDCallMade
        Dim userid As Integer = CInt(Page.User.Identity.Name)
        DialerHelper.UpdateLeadCallMade(CallMadeId, "", "", userid, CallIdKey, Nothing)
        ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "CIDDialAfterCallMade", String.Format("CIDDialAfterCallMade('{0}', '{1}');", LeadId, CallMadeId), True)
    End Sub

    Protected Sub CallControlBar1_AfterDialerInCallMade(ByVal CallIdKey As String, ByVal CallMadeId As Integer, ByVal ClientId As Integer) Handles CallControlBar1.AfterDialerINCallMade
        Dim userid As Integer = CInt(Page.User.Identity.Name)
        DialerHelper.UpdateCallMade(CallMadeId, 0, Nothing, Nothing, 0, Now, userid, CallIdKey)
        ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "AfterDialerInCallMade", String.Format("GotoURL('DialerCall.aspx?id={0}&callid={1}');", ClientId, CallMadeId), True)
    End Sub

    Private Sub AfterPickup(ByVal args As CallEventArgs) Handles CallControlBar1.AfterPickup
        Search(args)
    End Sub

    Private Sub CallToolBarEvents() Handles CallControlBar1.AfterDisconnect, CallControlBar1.BeforeTransfer
        'CID only
        ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "CallToolBarEvents", "CallToolBarEvents();", True)
    End Sub

    Private Overloads Sub Search(ByVal args As CallEventArgs)
        If args.IsCIDDialerCall Then
            If args.AppointmentId > 0 Then
                Dim dtCIDAppt As DataTable = CIDAppointmentHelper.GetLeadAppointment(args.AppointmentId)
                If Not dtCIDAppt Is Nothing AndAlso dtCIDAppt.Rows.Count > 0 AndAlso dtCIDAppt.Rows(0)("CallIdKey") Is DBNull.Value Then
                    ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "CIDDialerAfterPickupAppointment", String.Format("CIDDialerAfterPickupAppointment('{0}','{1}','{2}');", dtCIDAppt.Rows(0)("LeadApplicantId"), args.DialerCallMadeId, args.AppointmentId), True)
                    Return
                End If
            Else
                Dim CallMadeId As Integer = args.DialerCallMadeId
                Dim dtCIDCallMade As DataTable = DialerHelper.GetLeadDialerCallById(CallMadeId)
                If Not dtCIDCallMade Is Nothing AndAlso dtCIDCallMade.Rows.Count > 0 AndAlso dtCIDCallMade.Rows(0)("OutboundCallKey") Is DBNull.Value Then
                    ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "CIDDialAfterPickup", "CIDDialAfterPickup('" & CallMadeId & "');", True)
                    Return
                End If
            End If
        ElseIf args.IsDialerINCall Then
            Dim CallMadeId As Integer = args.DialerCallMadeId
            Dim dtCallMade As DataTable = DialerHelper.GetDialerCall(CallMadeId)
            If Not dtCallMade Is Nothing AndAlso dtCallMade.Rows.Count > 0 AndAlso dtCallMade.Rows(0)("OutboundCallKey") Is DBNull.Value Then
                ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "DialINAfterPickup", "DialINAfterPickup('" & CallMadeId & "');", True)
                Return
            End If
        End If
        Search(args.CallIdKey, args.RemoteNumber)
    End Sub

    Private Overloads Sub Search(ByVal CallIdKey As String, ByVal RemoteAddress As String)
        ''BEGIN COMMENT OUT. CALL PROGRESS DETECTION DIALER. 
        'Dim dtCallMade As DataTable = DialerHelper.GetDialerCall(CallIdKey)
        'If Not dtCallMade Is Nothing AndAlso dtCallMade.Rows.Count > 0 Then
        '    If Not DialerHelper.CallPickedUp(CallIdKey) Then
        '        'Register the first call picked up
        '        Dim userid As Integer = CInt(Page.User.Identity.Name)
        '        DialerHelper.UpdateCallMade(dtCallMade.Rows(0)("CallMadeId"), 1, Nothing, Now, userid, Now, userid, "")
        '    End If
        '    'Redirect to Dialer Client Issues page
        '    ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "DialerPickup", String.Format("GotoURL('DialerCall.aspx?id={0}&callid={1}');", dtCallMade.Rows(0)("ClientId"), dtCallMade.Rows(0)("CallMadeId")), True)
        '    Return
        'End If
        ''END COMMENT OUT. CALL PROGRESS DETECTION DIALER
        ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "AfterPickup", "AfterPickup('" & CallIdKey & "','" & RemoteAddress & "');", True)
    End Sub

   

End Class
