Option Explicit On

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports Drg.Util.Helpers

Imports Slf.Dms.Controls
Imports Slf.Dms.Records

Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing

Partial Class clients_client_reports_Report
    Inherits System.Web.UI.Page

#Region "Variables"
    Private UserID As Integer
    Public ClientID As Integer
    Public Reports As String
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = CInt(Request.QueryString("user"))
        Reports = CStr(Request.QueryString("reports"))
        Dim bShowWizard As Integer = CInt(Request.QueryString("showwizard"))
        Dim bPrintPOA As Integer = CInt(Request.QueryString("printpoa"))
        Dim POAPath As String = Request.QueryString("poapath")

        If Not IsPostBack Then
            If Request.QueryString("clientid") Is Nothing Then
                ClientID = -1
            Else
                ClientID = CInt(Request.QueryString("clientid"))
            End If
        End If

        Session("clients_client_reports_clientid") = ClientID
        Session("clients_client_reports_userid") = UserID
        Session("clients_client_reports_reports") = Reports

        Response.Cookies("clientReportInfo")("clients_client_reports_clientid") = ClientID
        Response.Cookies("clientReportInfo")("clients_client_reports_userid") = UserID
        Response.Cookies("clientReportInfo")("clients_client_reports_reports") = Reports
        Response.Cookies("clientReportInfo").Expires = DateTime.Now.AddHours(1)

        If bShowWizard = 1 Then
            Dim strQuery As String = "?id=" & ClientID & "&reports=" & Reports.Replace("'", "%27")
            ClientScript.RegisterStartupScript(Me.GetType(), "ShowWizard", "<script>window.showModalDialog('AddReportNote.aspx" & strQuery & "',window,'dialogWidth=550px;dialogHeight=455px;');</script>")
        End If

        '2.16.10.ug.code to popup client poa when printing LOR for Data entry
        If bPrintPOA = 1 Then
            Dim uGroup As Integer = -1
            If Integer.TryParse(UserHelper.GetUserRole(UserID), uGroup) Then
                Select Case uGroup
                    Case 11, 5
                        POAPath = LocalHelper.GetVirtualDocFullPath(POAPath)
                        ClientScript.RegisterStartupScript(Me.GetType(), "POAAlert", "<script>javascript:OpenDocument('" & POAPath & "');</script>")
                    Case Else   'do nothing

                End Select
                
            End If
        End If

    End Sub

End Class