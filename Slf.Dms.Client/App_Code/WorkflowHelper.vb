Imports System.IO
Imports System.Net
Imports System.Xml
Imports System.Data

Imports Microsoft.VisualBasic
Imports System.Collections.Generic
Imports System.Data.SqlClient

Public Class WorkflowHelper
    Public Shared Function GetWorkflowTasks(ByVal workflowName As String) As DataTable
        Return SqlHelper.GetDataTable(String.Format("stp_workflow_GetWorkflowTasks '{0}'", workflowName), CommandType.Text)
    End Function
    Public Shared Function ResolveTask(ByVal taskId As Integer, ByVal LoggedInUser As Integer, ByVal resolutionID As Integer) As Boolean
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("taskID", taskId))
        params.Add(New SqlParameter("userid", LoggedInUser))
        params.Add(New SqlParameter("taskresolutionID", resolutionID))
        Try
            SqlHelper.ExecuteNonQuery("stp_workflow_resolveTask", CommandType.StoredProcedure, params.ToArray)
            Return True
        Catch ex As Exception
            Return False
        End Try
    End Function
    Public Shared Function InsertTask(ByVal workflowtaskid As Integer, ByVal ParentTaskId As Integer, ByVal workflowstepname As String, _
                                ByVal SettlementDueDate As String, ByVal LoggedInUser As Integer, ByVal SettlementMatterID As Integer) As Integer
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("TaskTypeId", workflowtaskid))
        params.Add(New SqlParameter("ParentTaskId", ParentTaskId))
        params.Add(New SqlParameter("Description", workflowstepname))
        params.Add(New SqlParameter("Due", SettlementDueDate))
        params.Add(New SqlParameter("userID", LoggedInUser))
        params.Add(New SqlParameter("matterid", SettlementMatterID))
        Return SqlHelper.ExecuteScalar("stp_workflow_insertTask", CommandType.StoredProcedure, params.ToArray)
    End Function
    Public Shared Function Workflow_CreateClientStipulationSettlement(ByVal SettlementDueDate As String, ByVal SettlementMatterID As String, ByVal UserID As String, ByVal bNeedsManagerApproval As Boolean) As Integer
        Dim parentID As Integer = 0
        Dim currentID As Integer = 0
        'use clientstip workflow

        If bNeedsManagerApproval Then
            'insert manager tasks for overs
            parentID = WorkflowHelper.InsertTask(74, 0, "Manager must approve settlement shortage.", SettlementDueDate, UserID, SettlementMatterID)
            currentID = parentID
        End If

        Using dt As DataTable = WorkflowHelper.GetWorkflowTasks("Client Stipulation Settlement")
            For i As Integer = 0 To dt.Rows.Count - 1
                'insert task
                parentID = WorkflowHelper.InsertTask(dt.Rows(i).Item("workflowtaskid").ToString, parentID, dt.Rows(i).Item("workflowstepname").ToString, SettlementDueDate, UserID, SettlementMatterID)
                If currentID = 0 Then
                    SqlHelper.ExecuteNonQuery(String.Format("update tblmatter set currenttaskid = {0}, mattersubstatusid = {1} where matterid = {2}", parentID, dt.Rows(i).Item("workflowtaskid").ToString, SettlementMatterID), CommandType.Text)
                    currentID = parentID
                End If
            Next
        End Using

        'return current task id
        Return currentID

    End Function
    Public Shared Function Workflow_CreateStandardSettlement(ByVal SettlementDueDate As String, ByVal SettlementMatterID As String, ByVal UserID As String, ByVal bNeedsManagerApproval As Boolean) As Integer
        Dim parentID As Integer = 0
        Dim currentID As Integer = 0
        'use standrd workflow
        If bNeedsManagerApproval Then
            'insert manager tasks for overs
            parentID = WorkflowHelper.InsertTask(74, 0, "Manager must approve settlement shortage.", SettlementDueDate, UserID, SettlementMatterID)
            currentID = parentID
        End If

        Using dt As DataTable = WorkflowHelper.GetWorkflowTasks("Standard Settlement")
            For i As Integer = 0 To dt.Rows.Count - 1
                'insert task
                parentID = WorkflowHelper.InsertTask(dt.Rows(i).Item("workflowtaskid").ToString, parentID, dt.Rows(i).Item("workflowstepname").ToString, SettlementDueDate, UserID, SettlementMatterID)
                If currentID = 0 Then
                    SqlHelper.ExecuteNonQuery(String.Format("update tblmatter set currenttaskid = {0}, mattersubstatusid = {1} where matterid = {2}", parentID, dt.Rows(i).Item("workflowtaskid").ToString, SettlementMatterID), CommandType.Text)
                    currentID = parentID
                End If
            Next
        End Using

        Return parentID

    End Function
    Public Shared Function Workflow_CreatePaymentArrangementSettlement(ByVal SettlementDueDate As String, ByVal SettlementMatterID As String, ByVal UserID As String, ByVal bNeedsManagerApproval As Boolean) As Integer
        Dim parentID As Integer = 0
        Dim currentID As Integer = 0
        'use payment workflow
        If bNeedsManagerApproval Then
            'insert manager tasks for overs
            parentID = WorkflowHelper.InsertTask(74, 0, "Manager must approve settlement shortage.", SettlementDueDate, UserID, SettlementMatterID)
            currentID = parentID
        End If
        Using dt As DataTable = WorkflowHelper.GetWorkflowTasks("Payment Arrangement Settlement")
            For i As Integer = 0 To dt.Rows.Count - 1
                'insert task
                parentID = WorkflowHelper.InsertTask(dt.Rows(i).Item("workflowtaskid").ToString, parentID, dt.Rows(i).Item("workflowstepname").ToString, SettlementDueDate, UserID, SettlementMatterID)
                If currentID = 0 Then
                    SqlHelper.ExecuteNonQuery(String.Format("update tblmatter set currenttaskid = {0}, mattersubstatusid = {1} where matterid = {2}", parentID, dt.Rows(i).Item("workflowtaskid").ToString, SettlementMatterID), CommandType.Text)
                    currentID = parentID
                End If
            Next
        End Using
        Return parentID
    End Function
End Class