Imports System
Imports System.Data
Imports System.Data.SqlClient

Partial Class research_reports_clients_CompletedClients
    Inherits System.Web.UI.Page

    Protected Sub research_reports_clients_CompletedClients_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim dt As DataTable
        dt = SqlHelper.GetDataTable("stp_ActiveNClosedWithMoney", CommandType.StoredProcedure)
        Me.gvClients.DataSource = dt
        Me.gvClients.DataBind()
    End Sub
End Class
