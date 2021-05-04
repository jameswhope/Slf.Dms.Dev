Imports System
Imports System.Data
Imports System.Collections.Generic

Namespace negotiation.SettlementExceptions
    Partial Class negotiation_SettlementExceptions_SettlementExceptions
        Inherits System.Web.UI.Page

        Private UserID As Integer

        Protected Sub lnkClear_Click(ByVal sender As Object, ByVal e As EventArgs)
            Throw New NotImplementedException()
        End Sub

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            Dim Supervisor As Boolean
            Dim DepartmentHead As Boolean
            Dim Team As List(Of String)
            Dim Group As String
            Dim RepName As String
            Dim tbl As DataTable

            'Get the possible types of users and their realtionships
            UserID = Integer.Parse(Page.User.Identity.Name)
            tbl = GetTeams()
            DepartmentHead = IsDepartmentHead(UserID, tbl)
            Supervisor = IsSupervisor(UserID, tbl)
            Group = GetGroup(tbl, UserID)
            Team = TeamMembers(tbl, Group)
            RepName = GetRepName(UserID, tbl)

            'Grab the data and bind it to the grid.
            GetTheData(DepartmentHead, Supervisor, RepName, Group)

        End Sub

        Protected Function GetTeams() As DataTable
            Dim tbl As New DataTable
            tbl = PermissionHelperLite.NegotiationTeams()
            Return tbl
        End Function

        Protected Function IsSupervisor(ByVal UserID As Integer, ByVal tbl As DataTable) As Boolean
            Dim row As DataRow() = tbl.Select("UserID = " & UserID)
            If row.Length > 0 Then
                Return row(0).Item("IsSupervisor")
            End If
        End Function

        Protected Function GetGroup(ByVal tbl As DataTable, ByVal UserID As Integer) As String
            Dim row As DataRow() = tbl.Select("UserID = " & UserID)
            If row.Length > 0 Then
                Return row(0).Item("GroupName")
            End If
            Return ""
        End Function

        Protected Function TeamMembers(ByVal tbl As DataTable, ByVal Group As String) As List(Of String)
            Dim rows As DataRow() = tbl.Select("GroupName = '" & Group & "'")
            Dim Members As New List(Of String)
            For Each r As DataRow In rows
                Members.Add(r.Item("UserName"))
            Next
            Return Members
        End Function

        Protected Function IsDepartmentHead(ByVal UserID As Integer, ByVal tbl As DataTable) As Boolean
            Dim row As DataRow() = tbl.Select("UserID = " & UserID)
            If row.Length > 0 Then
                Select Case row(0).Item("UserID")
                    Case 379, 1357, 832
                        Return True
                    Case Else
                        Return False
                End Select
            End If
        End Function

        Protected Function GetRepName(ByVal UserID As Integer, ByVal tbl As DataTable) As String
            Dim row As DataRow() = tbl.Select("UserID = " & UserID)
            If row.Length > 0 Then
                Return row(0).Item("UserName").ToString
            End If
            Return ""
        End Function

        Protected Sub GetTheData(ByVal DepartmentHead As Boolean, ByVal Supervisor As Boolean, ByVal RepName As String, ByVal GroupName As String) 'As DataSource

            Me.dsExpired.SelectCommand = "stp_ExpiredSettlements"

            dsExpired.SelectParameters.Clear()

            'Set the parameters based on who is asking for the data in the Negotiations department
            If DepartmentHead Then
                dsExpired.SelectParameters.Clear()
            ElseIf Supervisor Then
                dsExpired.SelectParameters.Add("GroupName", GroupName)
            ElseIf RepName.Length > 0 Then
                dsExpired.SelectParameters.Add("RepName", RepName)
            Else
                dsExpired.SelectParameters.Add("GroupName", "NA")
            End If
            dsExpired.DataBind()
            'Bind the data and we're out
            Me.gvExpiredReport.DataBind()

        End Sub

        Protected Sub dsExpired_Selected(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles dsExpired.Selected
            e.Command.CommandTimeout = 90
        End Sub
    End Class
End Namespace