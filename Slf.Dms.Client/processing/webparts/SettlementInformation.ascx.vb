Imports LexxiomWebPartsControls
Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataHelpers
Imports Drg.Util.DataAccess
Imports GridViewHelper
Partial Class processing_webparts_SettlementInformation
    Inherits System.Web.UI.UserControl

#Region "View Comms modules"
#Region "Declares"
    Private SettlementID As Integer
    Private Information As SettlementMatterHelper.SettlementInformation
    Public DataClientID As String = ""
    Public AccountID As String
    Public TaskId As Integer
    Public ContextSensitive As String
#End Region

#Region "Events"

#Region "HistoryGridview"
    Protected Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowDataBound
        Select Case e.Row.RowType

            Case DataControlRowType.DataRow
                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#f3f3f3'; ")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#ffffff'; this.style.textDecoration = 'none';")
        End Select
    End Sub
    
#End Region
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            If Not Request.QueryString("id") Is Nothing Then
                TaskId = Integer.Parse(Request.QueryString("id"))
                SettlementID = SettlementMatterHelper.GetSettlementFromTask(TaskId)

                Information = SettlementMatterHelper.GetSettlementInformation(SettlementID)

                BindGrid(SettlementID)
            End If
        End If
    End Sub

#End Region

#Region "Subs/Funcs"
    Public Sub BindGrid(ByVal SettlementID As Integer)
        Me.SqlDataSource1.SelectCommandType = SqlDataSourceCommandType.StoredProcedure
        Me.SqlDataSource1.SelectCommand = "stp_GetSettlementRoadmap"

        Me.SqlDataSource1.SelectParameters.Clear()
        Me.SqlDataSource1.SelectParameters.Add("SettlementId", SettlementID)
        Me.SqlDataSource1.DataBind()

        Me.GridView1.DataBind()

    End Sub
#End Region
#End Region


    Protected Sub SqlDataSource1_Selecting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceSelectingEventArgs) Handles SqlDataSource1.Selecting
        e.Command.CommandTimeout = 120
    End Sub
End Class