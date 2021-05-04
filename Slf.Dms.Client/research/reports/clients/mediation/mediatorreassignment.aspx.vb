Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Collections.Generic
Imports LocalHelper

Imports System.Deployment
Imports System.Threading
Imports System.Windows.Forms
Imports System.IO
Imports System.Security.Cryptography
Imports System.Drawing
Partial Class research_reports_clients_mediation_mediatorreassignment
    Inherits PermissionPage


#Region "Variables"
    Private UserID As Integer

    Private Property Setting(ByVal s As String) As String
        Get
            Return Session(Me.UniqueID & "_" & s)
        End Get
        Set(ByVal value As String)
            Session(Me.UniqueID & "_" & s) = value
        End Set
    End Property
    Private Function GetSetting(ByVal s As String, ByVal d As String) As String
        Dim v As String = Setting(s)
        If String.IsNullOrEmpty(v) Then
            Return d
        Else
            Return v
        End If
    End Function
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Not IsPostBack Then
            LoadMediators()
        End If


        Requery()

    End Sub

    Public Sub LoadMediators()

        ddlUserID.Items.Clear()

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.CommandText = "select u.userid,firstname + ' ' + lastname as fullname from tbluser u inner join tbluserposition up on u.userid=up.userid where up.positionid=4"
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read
                        Dim UserID As Integer = DatabaseHelper.Peel_int(rd, "UserID")
                        Dim Name As String = DatabaseHelper.Peel_string(rd, "fullname")

                        ddlUserID.Items.Add(New ListItem(Name, UserID))
                    End While
                End Using
            End Using
        End Using
    End Sub

    Public Sub Requery()
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Report_MediatorReassignment")
        DatabaseHelper.AddParameter(cmd, "UserID", ddlUserID.SelectedValue)
        grdResults.DataCommand = cmd

        Dim cmdAssignment As IDbCommand = ConnectionFactory.CreateCommand("stp_report_mediatorreassignment_fulfillment")
        DatabaseHelper.AddParameter(cmdAssignment, "UserID", ddlUserID.SelectedValue)
        Session("research_reports_clients_mediation_mediatorassignment_alph_aspx___Page_cmd") = cmdAssignment
    End Sub
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlBody, c, "Research-Reports-Clients-Mediation-Mediator Reassignment")
    End Sub

    Protected Sub lnkRequery_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRequery.Click
        grdResults.Reset(True)
        Requery()
    
    End Sub
End Class
