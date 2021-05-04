Imports System.Data
Imports Drg.Util.DataAccess

Partial Class mobile_financial_client_fees_and_paymentsm
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Dim date1, date2 As Date

            If Not IsDate(Request.QueryString("date1")) Then
                'default, today
                date1 = Format(Today, "M/d/yyyy")
                date2 = CDate(date1).AddDays(1).AddSeconds(-1)
                hOptions.InnerHtml = "Today"
            Else
                date1 = CDate(Request.QueryString("date1"))
                date2 = CDate(Request.QueryString("date2"))
                hOptions.InnerHtml = Request.QueryString("quick")
            End If

            Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Statistic_FeesAndPayments_2")
                DatabaseHelper.AddParameter(cmd, "date1", date1)
                DatabaseHelper.AddParameter(cmd, "date2", date2.AddDays(1).AddSeconds(-1))
                If Val(Request.QueryString("cid")) <> -1 Then
                    DatabaseHelper.AddParameter(cmd, "companyids", Request.QueryString("cid"))
                    hOptions.InnerHtml &= " :: " & Request.QueryString("c")
                End If
                If Val(Request.QueryString("aid")) <> -1 Then
                    DatabaseHelper.AddParameter(cmd, "agencyids", Request.QueryString("aid"))
                    hOptions.InnerHtml &= " :: " & Request.QueryString("a")
                End If
                Using cmd.Connection
                    cmd.Connection.Open()
                    Using rd As IDataReader = cmd.ExecuteReader()
                        Repeater1.DataSource = rd
                        Repeater1.DataBind()
                    End Using
                End Using
            End Using
        End If
    End Sub
End Class
