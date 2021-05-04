Imports System.Data
Imports Drg.Util.DataAccess
Imports ININ.IceLib.Interactions

Partial Class Negotiation_Main3
    Inherits System.Web.UI.Page

    Private _UserGroupId As Integer
    Private _bSearchOnPickup As Boolean = False

    Private Sub AfterPickup(ByVal args As CallEventArgs) Handles CallControlBar1.AfterPickup
        Search(args)
    End Sub

    Private Sub CallToolBarEvents() Handles CallControlBar1.AfterDisconnect, CallControlBar1.BeforeTransfer

    End Sub

    Private Sub OnSearchingSearch(ByVal args As CallEventArgs) Handles CallControlBar1.OnSearching
        Search(args)
    End Sub

    Private Overloads Sub Search(ByVal args As CallEventArgs)
        Dim ClientId As Integer = 0
        If args.ClientId.Trim.Length > 0 AndAlso Int32.TryParse(args.ClientId, ClientId) AndAlso _bSearchOnPickup AndAlso CallControlsHelper.ExistsClient(ClientId) Then
            GotoClient(args.CallIdKey, ClientId)
        Else
            'Check for CID Dialer call
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
            'Search(args.CallIdKey, args.RemoteNumber)
        End If
    End Sub

    Private Overloads Sub Search(ByVal CallIdKey As String, ByVal RemoteAddress As String)
        'Dont use this section
        'Detect is call is from Dialer
        'Dim dtCallMade As DataTable = DialerHelper.GetDialerCall(CallIdKey)
        'If Not dtCallMade Is Nothing AndAlso dtCallMade.Rows.Count > 0 Then
        '    If Not DialerHelper.CallPickedUp(CallIdKey) Then
        '        'Register the first call picked up
        '        Dim userid As Integer = CInt(Page.User.Identity.Name)
        '        DialerHelper.UpdateCallMade(dtCallMade.Rows(0)("CallMadeId"), 1, Nothing, Now, userid, Now, userid, "")
        '    End If
        '    'Redirect to Dialer Client Issues page
        '    ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "DialerPickup", String.Format("GotoURL('DialerCall.aspx?id={0}&callid={1}');", dtCallMade.Rows(0)("ClientId"), dtCallMade.Rows(0)("CallMadeId")), True)
        'ElseIf _bSearchOnPickup Then
        '    'Search Client By Phone (No Dialer)
        '    Dim dtClients As DataTable = CallControlsHelper.GetClientSearches(RemoteAddress)
        '    If dtClients.Rows.Count = 1 Then
        '        Dim clientid As Integer = dtClients.Rows(0)("ClientId")
        '        GotoClient(CallIdKey, clientid)
        '    ElseIf dtClients.Rows.Count > 1 Then
        '        'Let the user select the client
        '        ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "SearchClient", String.Format("SearchClient('{0}','{1}','{2}');", CallIdKey, RemoteAddress, ""), True)
        '    End If
        'End If
    End Sub

    Private Sub GotoClient(ByVal CallIdKey As String, ByVal ClientId As Integer)
        Dim url As String = String.Format("GotoURL('clients/client/?id={0}');", ClientId.ToString)
        CallControlsHelper.InsertCallClient(CallIdKey, ClientId)
        ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "GotoClient", url, True)
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        _UserGroupId = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserGroupId", "UserId = " & DataHelper.Nz_int(Page.User.Identity.Name)))
        _bSearchOnPickup = (DataHelper.FieldLookup("tblUserGroup", "SearchOnPickup", "UserGroupID = " & _UserGroupId).ToLower = "true")
    End Sub

    Protected Sub CallControlBar1_AfterDialerInCallMade(ByVal CallIdKey As String, ByVal CallMadeId As Integer, ByVal ClientId As Integer) Handles CallControlBar1.AfterDialerINCallMade
        Dim userid As Integer = CInt(Page.User.Identity.Name)
        DialerHelper.UpdateCallMade(CallMadeId, 0, Nothing, Nothing, 0, Now, userid, CallIdKey)
        ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "DialerPickup", String.Format("GotoURL('DialerCall.aspx?id={0}&callid={1}');", ClientId, CallMadeId), True)
    End Sub


End Class
