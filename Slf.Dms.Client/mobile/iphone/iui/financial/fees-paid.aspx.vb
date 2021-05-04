Imports System.Data
Imports Drg.Util.DataAccess

Partial Class financial_fees_paid
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            LoadFeesPaid()
        End If
    End Sub

    Private Sub LoadFeesPaid()
        Dim date1 As String = Format(Today, "M/d/yyyy")

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Statistic_Commission")
            DatabaseHelper.AddParameter(cmd, "date1", date1)
            DatabaseHelper.AddParameter(cmd, "date2", CDate(date1).AddDays(1).AddSeconds(-1))
            Using cmd.Connection
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    Repeater1.DataSource = rd
                    Repeater1.DataBind()
                End Using
            End Using
        End Using
    End Sub
End Class
