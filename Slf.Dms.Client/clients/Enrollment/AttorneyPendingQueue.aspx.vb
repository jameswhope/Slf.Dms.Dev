Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess
Imports System.Collections.Generic


Partial Class Clients_Enrollment_AttorneyPendingQueue
    Inherits System.Web.UI.Page

    Private _userid As Integer


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        _userid = DataHelper.Nz_int(Page.User.Identity.Name)

        If Request.QueryString("mobile") = "1" Then
            hdnNotab.Value = "1"
        End If

        If Not Page.IsPostBack Then
            LoadClients()
        End If
    End Sub

    Private Sub LoadClients()
        Dim ds As New DataSet
        Dim dv As DataView
        Dim companyid As Integer = -1 'This can be a selectable value
        ds = Me.GetPendingClients(companyid)
        ds.Relations.Add("Relation1", ds.Tables(0).Columns("leadapplicantid"), ds.Tables(1).Columns("leadapplicantid"))
        ds.Relations.Add("Hardship", ds.Tables(0).Columns("leadapplicantid"), ds.Tables(2).Columns("leadapplicantid"))
        dv = ds.Tables(0).DefaultView
        Accordion1.DataSource = dv
        Accordion1.DataBind()
        Accordion1.SelectedIndex = -1
        hPending.InnerHtml = String.Format("Pending Clients (<font color='blue'>{0}</font>)", ds.Tables(0).Rows.Count)
    End Sub

    Private Function GetPendingClients(ByVal companyID As Integer) As DataSet
        Dim params As New List(Of SqlParameter)
        If companyID > 0 Then
            params.Add(New SqlParameter("@companyid", companyID))
        End If
        
        params.Add(New SqlParameter("@userid", _userid))
        Return SqlHelper.GetDataSet("stp_PendingLeadsReport", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Function GetLSADocPath(ByVal LeadApplicantID As Integer) As String
        Dim params(0) As SqlParameter
        Dim tbl As DataTable
        Dim path As String = "#"

        params(0) = New SqlParameter("@leadapplicantid", LeadApplicantID)
        tbl = SqlHelper.GetDataTable("stp_GetLSADocInfoByLead", CommandType.StoredProcedure, params)

        If tbl.Rows.Count = 1 Then
            Dim leaddocpath As String = ConfigurationManager.AppSettings("LeadDocumentsDir").ToString
            Dim leaddocvirtualpath As String = ConfigurationManager.AppSettings("LeadDocumentsVirtualDir").ToString
            Dim ehostdomain As String = System.Configuration.ConfigurationManager.AppSettings("externalhostdomain").ToString
            If Me.Request.ServerVariables("SERVER_NAME").ToString.Contains(ehostdomain) Then
                leaddocpath = leaddocpath.ToString.Trim.Replace(leaddocpath, leaddocvirtualpath).Replace("\", "/")
            End If
            path = System.IO.Path.Combine(leaddocpath, String.Format("{0}.pdf", tbl.Rows(0)("DocumentId").ToString))
        End If
        Return path.Replace("\", "\\")
    End Function

End Class
