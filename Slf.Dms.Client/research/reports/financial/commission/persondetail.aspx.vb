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

Partial Class research_reports_financial_commission_persondetail
    Inherits PermissionPage

    Structure CommissionPersonEntry
        Public EntryType As String
        Public Percent As String
        Public Amount As Single
    End Structure


#Region "Variables"

    Private UserID As Integer
    Private CommBatchIDs As String
    Private ClientID As Integer
    Private CommRecID As String
    Private qs As QueryStringCollection

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then
            CommBatchIDs = qs("commissionbatchids")
            ClientID = CInt(qs("currentclientidentry"))
            CommRecID = qs("commrecid")

            Requery()
        End If

    End Sub
    Private Sub Requery()
        Dim tempEntry As CommissionPersonEntry
        Dim CommissionPerson As New List(Of CommissionPersonEntry)
        Dim totalForClient As Single = 0

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_ReportGetCommissionBatchTransfersByClient")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "CommBatchIDs", CommBatchIDs)
                DatabaseHelper.AddParameter(cmd, "CommRecID", CommRecID)
                DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        tempEntry = New CommissionPersonEntry
                        tempEntry.EntryType = DatabaseHelper.Peel_string(rd, "EntryType")
                        tempEntry.Percent = Math.Round(DatabaseHelper.Peel_float(rd, "Percent") * 100, 2).ToString() + "%"
                        tempEntry.Amount = DatabaseHelper.Peel_float(rd, "Amount")

                        totalForClient += tempEntry.Amount

                        CommissionPerson.Add(tempEntry)
                    End While
                End Using
            End Using
        End Using

        tdTotal.InnerHtml = "Total For Client: " + totalForClient.ToString("c")
        rpPerson.DataSource = CommissionPerson
        rpPerson.DataBind()

        Session("xls_batchdetail_list_person") = CommissionPerson

        tbPerson.Visible = True
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
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlBodyPerson, c, "Research-Reports-Financial-Commission-Person Details")
    End Sub
End Class
