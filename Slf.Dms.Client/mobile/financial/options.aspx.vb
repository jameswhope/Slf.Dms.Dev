Imports LocalHelper
Imports System.Data

Partial Class mobile_financial_options
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            LoadCompanyList()
            LoadAgencyList()

            txtTransDate1.Text = Now.ToString("MM/dd/yy")
            txtTransDate2.Text = Now.ToString("MM/dd/yy")

            ddlQuickPickDate.Items.Clear()

            ddlQuickPickDate.Items.Add(New ListItem("Today", Now.ToString("MM/dd/yy") & "," & Now.ToString("MM/dd/yy")))
            ddlQuickPickDate.Items.Add(New ListItem("This Week", RoundDate(Now, -1, DateUnit.Week).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Week).ToString("MM/dd/yy")))
            ddlQuickPickDate.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("MM/dd/yy")))
            ddlQuickPickDate.Items.Add(New ListItem("This Year", RoundDate(Now, -1, DateUnit.Year).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Year).ToString("MM/dd/yy")))

            ddlQuickPickDate.Items.Add(New ListItem("Yesterday", Now.AddDays(-1).ToString("MM/dd/yy") & "," & Now.AddDays(-1).ToString("MM/dd/yy")))
            ddlQuickPickDate.Items.Add(New ListItem("Last Week", RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("MM/dd/yy") & "," & RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("MM/dd/yy")))
            ddlQuickPickDate.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("MM/dd/yy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("MM/dd/yy")))
            ddlQuickPickDate.Items.Add(New ListItem("Last Year", RoundDate(Now.AddYears(-1), -1, DateUnit.Year).ToString("MM/dd/yy") & "," & RoundDate(Now.AddYears(-1), 1, DateUnit.Year).ToString("MM/dd/yy")))

            ddlQuickPickDate.Items.Add(New ListItem("Custom", "Custom"))

            ddlQuickPickDate.Attributes("onchange") = "SetDates(this);"

            Dim page As String = Request.QueryString("page").Replace("-", " ")
            page = StrConv(page, VbStrConv.ProperCase)
            hPage.InnerHtml = page
        End If
    End Sub

    Private Sub LoadCompanyList()
        Dim obj As New Drg.Util.DataHelpers.CompanyHelper
        Dim tbl As DataTable = obj.CompanyList
        Dim row As DataRow = tbl.NewRow
        row("shortconame") = " -- ALL --"
        row("companyid") = -1
        tbl.Rows.InsertAt(row, 0)
        With ddlCompany
            .DataSource = tbl
            .DataTextField = "shortconame"
            .DataValueField = "companyid"
            .DataBind()
        End With
    End Sub

    Private Sub LoadAgencyList()
        Dim obj As New Drg.Util.DataHelpers.AgencyHelper
        Dim tbl As DataTable = obj.GetAgencies
        Dim row As DataRow = tbl.NewRow
        row("code") = " -- ALL --"
        row("agencyid") = -1
        tbl.Rows.InsertAt(row, 0)
        With ddlAgency
            .DataSource = tbl
            .DataTextField = "code"
            .DataValueField = "agencyid"
            .DataBind()
        End With
    End Sub

    Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        Dim url As String = Request.QueryString("page") & ".aspx" _
            & "?date1=" & txtTransDate1.Text _
            & "&date2=" & txtTransDate2.Text _
            & "&quick=" & ddlQuickPickDate.SelectedItem.Text _
            & "&c=" & ddlCompany.SelectedItem.Text _
            & "&cid=" & ddlCompany.SelectedItem.Value _
            & "&a=" & ddlAgency.SelectedItem.Text _
            & "&aid=" & ddlAgency.SelectedItem.Value

        Response.Redirect(url)
    End Sub
End Class
