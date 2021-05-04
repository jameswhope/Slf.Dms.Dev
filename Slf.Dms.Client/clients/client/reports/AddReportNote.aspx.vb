Imports System.Data.SqlClient
Imports Drg.Util.DataAccess
Imports System.Collections.Generic
Imports System.Data
Imports Drg.Util.DataHelpers
Imports System.IO
Imports ReportsHelper
Partial Class Clients_client_reports_AddReportNote
    Inherits System.Web.UI.Page

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init

        AutoNoteWizardControl1.UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        AutoNoteWizardControl1.DataClientID = Request.QueryString("id")


    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

       

    End Sub
End Class

