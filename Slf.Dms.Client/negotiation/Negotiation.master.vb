Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Partial Class negotiation_Negotiation
    Inherits MasterPage

    Private UserID As String

    Public Sub UpdateSIFCount()
        lblAttachSIF.Text = String.Format("Attach SIF (<font color='blue'>{0}</font>)", getAttachSIFCount)
    End Sub

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            'UpdateSIFCount()
            'lblChkbyphone.Text = String.Format("Checks By Phone (<font color='blue'>{0}</font>)", getChecksByPhoneCount)
            If SettlementProcessingHelper.IsManager(UserID) Then
                'tdMgrSep.Visible = True
                'tdMgr.Visible = True
                'lblMgrApproval.Text = String.Format("Manager Approval (<font color='blue'>{0}</font>)", getManagersCount)
            End If
            If PermissionHelperLite.HasPermission(UserID, "Settlement Processing-Open Settlements") Or PermissionHelperLite.HasPermission(UserID, "Settlement Processing-My Open Settlements") Then
                'tdProc.Visible = True
                'tdProcSep.Visible = True
            End If
        End If
    End Sub

    Private Function getAttachSIFCount() As Integer
        Dim myParams As New List(Of SqlParameter)
        myParams.Add(New SqlParameter("UserId", UserID))
        myParams.Add(New SqlParameter("SearchTerm", "%"))
        Using dt As DataTable = SqlHelper.GetDataTable("stp_NegotiationsSearchGetSettlementsWaitingOnSIF", Data.CommandType.StoredProcedure, myParams.ToArray)
            getAttachSIFCount = dt.Rows.Count
        End Using

        Return getAttachSIFCount
    End Function

    Private Function getChecksByPhoneCount() As Integer
        Dim myParams As New List(Of SqlParameter)
        myParams.Add(New SqlParameter("UserId", UserID))
        Using dt As DataTable = SqlHelper.GetDataTable("stp_GetCheckByPhoneProcessing", Data.CommandType.StoredProcedure, myParams.ToArray)
            getChecksByPhoneCount = dt.Rows.Count
        End Using

        Return getChecksByPhoneCount
    End Function

    Private Function getManagersCount() As Integer
        Using dt As DataTable = SqlHelper.GetDataTable("stp_settlements_getSettlementsWaitingForManagerApproval", Data.CommandType.StoredProcedure)
            getManagersCount = dt.Rows.Count
        End Using

        Return getManagersCount
    End Function
   
End Class