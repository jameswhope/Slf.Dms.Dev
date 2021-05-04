Imports System.Data
Imports Drg.Util.DataAccess

Partial Class mobile_iphone_default
    Inherits System.Web.UI.Page

    '<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
    '<meta name="apple-touch-fullscreen" content="YES" />

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            FinancialCommission()
            'FinancialDeposits()
        End If
    End Sub

#Region "Financial Tab"

    Private Sub FinancialCommission()
        Dim date1 As String = Format(Today, "M/d/yyyy")

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Statistic_Commission")
            DatabaseHelper.AddParameter(cmd, "date1", date1)
            DatabaseHelper.AddParameter(cmd, "date2", CDate(date1).AddDays(1).AddSeconds(-1))
            Using cmd.Connection
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    rptFeesPaid.DataSource = rd
                    rptFeesPaid.DataBind()
                End Using
            End Using
        End Using
    End Sub

    'Private Sub FinancialDeposits()
    '    Dim date1 As Date = CDate(Format(Today, "M/d/yyyy"))

    '    Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Statistic_Deposits")
    '        DatabaseHelper.AddParameter(cmd, "date1", date1)
    '        DatabaseHelper.AddParameter(cmd, "date2", date1.AddDays(1).AddSeconds(-1))
    '        Using cmd.Connection
    '            cmd.Connection.Open()
    '            Using rd As IDataReader = cmd.ExecuteReader()
    '                Repeater1.DataSource = rd
    '                Repeater1.DataBind()
    '            End Using
    '        End Using
    '    End Using
    'End Sub

#End Region

End Class
