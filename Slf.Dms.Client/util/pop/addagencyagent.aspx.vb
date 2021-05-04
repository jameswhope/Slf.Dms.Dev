Imports Lexxiom.BusinessServices
Imports System.Data

Partial Class util_pop_addagencyagent
    Inherits System.Web.UI.Page

    Private Sub FillDDLAgent()
        Dim bsAgency As New Agency
        Dim dt As DataTable = bsAgency.GetAllAgents
        Dim li As ListItem
        Dim FirstName As String = String.Empty
        Dim LastName As String = String.Empty
        For Each dr As DataRow In dt.Rows
            If Not dr("FirstName") Is DBNull.Value Then FirstName = dr("FirstName")
            If Not dr("LastName") Is DBNull.Value Then LastName = dr("LastName")
            li = New ListItem(FirstName & " " & LastName, dr("AgentId").ToString)
            li.Attributes.Add("FirstName", FirstName)
            li.Attributes.Add("LastName", LastName)
            Me.ddlAgent.Items.Add(li)
        Next
    End Sub

    Protected Sub form1_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles form1.Load
        If Not Me.IsPostBack Then
            Me.ddlAgent.Attributes.Add("onChange", "javascript:OnChangeAgent();")
            FillDDLAgent()
        End If
    End Sub

End Class
