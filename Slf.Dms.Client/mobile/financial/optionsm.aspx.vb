Imports LocalHelper
Imports System.Data
Imports System.Linq

Partial Class mobile_financial_optionsm
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
       
        With ddlCompany
            .DataSource = tbl
            .DataTextField = "shortconame"
            .DataValueField = "companyid"
            .DataBind()
        End With
        'Check all agencied
        Me.chkAttorneySelectALL.Checked = True
        For Each itm As ListItem In ddlCompany.Items
            itm.Selected = True
        Next
    End Sub

    Private Sub LoadAgencyList()
        Dim obj As New Drg.Util.DataHelpers.AgencyHelper
        Dim tbl As DataTable = obj.GetAgencies

        With ddlAgency
            .DataSource = tbl
            .DataTextField = "code"
            .DataValueField = "agencyid"
            .DataBind()
        End With
        'Check all agencied
        Me.chkAgencySelectAll.Checked = True
        For Each itm As ListItem In ddlAgency.Items
            itm.Selected = True
        Next
    End Sub

    Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        Dim companies As String = "0"
        Dim companynames As String = ""
        Dim agencies As String = "0"
        Dim agencynames As String = ""

        If chkAttorneySelectALL.Checked Then
            companies = "-1"
        Else
            Dim selectedcompanies = (From item As ListItem In ddlCompany.Items _
                                   Where item.Selected = True _
                                   Select item.Value).ToArray

            If selectedcompanies.Length > 0 Then
                companies = String.Join(",", selectedcompanies)
            End If
        End If

        If chkAgencySelectAll.Checked Then
            agencies = "-1"
        Else
            Dim selectedagencies = (From item As ListItem In ddlAgency.Items _
                                   Where item.Selected = True _
                                   Select item.Value).ToArray

            If selectedagencies.Length > 0 Then
                agencies = String.Join(",", selectedagencies)
            End If
        End If

        Dim url As String = Request.QueryString("page") & ".aspx" _
            & "?date1=" & txtTransDate1.Text _
            & "&date2=" & txtTransDate2.Text _
            & "&quick=" & ddlQuickPickDate.SelectedItem.Text _
            & "&c=" & companynames _
            & "&cid=" & companies _
            & "&a=" & agencynames _
            & "&aid=" & agencies

        Response.Redirect(url)
    End Sub
End Class
