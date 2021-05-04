Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.Data
Imports System.Data.SqlClient
Imports LocalHelper
Imports System.Configuration

Partial Class research_reports_financial_commission_AntillaPayout
    Inherits System.Web.UI.Page

    Private UserID As Integer
    Private NetPayments As Double

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            txtTransDate1.Text = Format(DateAdd(DateInterval.Day, -(Now.Day - 1), Now), "MM/dd/yy")
            txtTransDate2.Text = Format(Now, "MM/dd/yy")
        End If
    End Sub

    Protected Sub lnkRequery_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRequery.Click
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_AntillaCommRpt")
            Using cmd.Connection
                Dim da As SqlDataAdapter
                Dim ds As New DataSet
                cmd.CommandTimeout = 180
                DatabaseHelper.AddParameter(cmd, "startdate", txtTransDate1.Text)
                DatabaseHelper.AddParameter(cmd, "enddate", txtTransDate2.Text & " 23:59")
                da = New SqlDataAdapter(cmd)
                da.Fill(ds)
                gvAntilla.DataSource = ds.Tables(0)
                gvAntilla.DataBind()
            End Using
        End Using

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_AntillaTotals")
            Using cmd.Connection
                Dim da As SqlDataAdapter
                Dim ds As New DataSet
                cmd.CommandTimeout = 180
                DatabaseHelper.AddParameter(cmd, "startdate", txtTransDate1.Text)
                DatabaseHelper.AddParameter(cmd, "enddate", txtTransDate2.Text & " 23:59")
                da = New SqlDataAdapter(cmd)
                da.Fill(ds)
                Me.TotalClientFees.Text = txtTransDate1.Text & " - " & txtTransDate2.Text
                'Me.TotalClientFees.Text = Format(ds.Tables(0).Rows(0).Item(0), "$#,##0.00")
                Me.TotalDueAgent.Text = Format(ds.Tables(0).Rows(0).Item(1), "$#,##0.00")
            End Using
        End Using

    End Sub

    Protected Sub gvAntilla_PageIndexChanging(ByVal sender As Object, ByVal e As GridViewPageEventArgs) Handles gvAntilla.PageIndexChanging
        gvAntilla.PageIndex = e.NewPageIndex
    End Sub

End Class
