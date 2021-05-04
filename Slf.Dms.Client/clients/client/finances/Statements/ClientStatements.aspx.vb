Imports GrapeCity.ActiveReports
Imports System
Imports System.Data
Imports Drg.Util.DataAccess
Imports Drg.Util.Helpers

Partial Class Clients_client_finances_Statements_ClientStatement
    Inherits System.Web.UI.Page

    Private qs As QueryStringCollection
    Private Shadows ClientID As Integer
    Private AccountNumber As String
    Private UserID As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim rpt As New ClientStatement
        Dim rptT As New Transactions
        Dim rptC As New rptCreditors
        Dim dsPersonal As DataSet
        Dim vMonth As String
        Dim vYear As String
        Dim sh As New StatementHelper

        qs = LoadQueryString()

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Not qs Is Nothing Then
            ClientID = qs("id")
            vMonth = qs("m")
            vYear = qs("y")

            dsPersonal = sh.GrabTheData

            rpt.DataSource = dsPersonal.Tables(0)
            rptT.DataSource = dsPersonal.Tables(1)
            rptC.DataSource = dsPersonal.Tables(2)
        End If

        rpt.Run(True)
        WebViewer1.ReportName = ""
        WebViewer1.Report = rpt
        WebViewer1.DataBind()
        WebViewer1.Visible = True
        rpt.Document.Print(False, True, True)

    End Sub

    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""idonly""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function

End Class
