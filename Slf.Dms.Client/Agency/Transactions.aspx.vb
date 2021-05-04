Imports Drg.Util.DataAccess
Imports System.Data.SqlClient
Imports System.Data

Partial Class Agency_Transactions
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            txtStartDate.Text = Format(DateAdd(DateInterval.Day, -1, Now), "M/d/yyyy")
            txtEndDate.Text = Format(Now, "M/d/yyyy")
            btnFilter_Click(Me, Nothing)
        End If
    End Sub

    Protected Sub btnFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFilter.Click
        Dim params(5) As SqlParameter
        Dim ds As DataSet
        Dim tblDates As DataTable
        Dim tblBatchIds As DataTable
        Dim tblScenarios As DataTable
        Dim row As DataRow
        Dim curDate, curID, curScen As String
        Dim li As ListItem

        curDate = ddlBatchDate.SelectedItem.Text
        curID = ddlBatchID.SelectedItem.Text
        curScen = ddlScenario.SelectedItem.Text

        params(0) = New SqlParameter("@userid", 996) 'DataHelper.Nz_int(Page.User.Identity.Name))
        params(1) = New SqlParameter("@startdate", txtStartDate.Text)
        params(2) = New SqlParameter("@enddate", txtEndDate.Text & " 23:59")
        If ddlBatchDate.SelectedIndex > 0 Then
            params(3) = New SqlParameter("@batchdate", ddlBatchDate.SelectedItem.Value)
        Else
            params(3) = New SqlParameter("@batchdate", DBNull.Value)
        End If
        If ddlBatchID.SelectedIndex > 0 Then
            params(4) = New SqlParameter("@batchid", ddlBatchID.SelectedItem.Value)
        Else
            params(4) = New SqlParameter("@batchid", DBNull.Value)
        End If
        If ddlScenario.SelectedIndex > 0 Then
            params(5) = New SqlParameter("@commstructid", ddlScenario.SelectedItem.Value)
        Else
            params(5) = New SqlParameter("@commstructid", DBNull.Value)
        End If

        ds = SqlHelper.GetDataSet("stp_GetTransactionsByUser", Data.CommandType.StoredProcedure, params)

        GridView1.DataSource = ds.Tables(0)
        GridView1.DataBind()

        tblDates = ds.Tables(1)
        row = tblDates.NewRow
        row(0) = "All"
        tblDates.Rows.InsertAt(row, 0)
        ddlBatchDate.DataSource = tblDates
        ddlBatchDate.DataTextField = "batchdate"
        ddlBatchDate.DataValueField = "batchdate"
        ddlBatchDate.DataBind()

        tblBatchIds = ds.Tables(2)
        row = tblBatchIds.NewRow
        row(0) = "All"
        tblBatchIds.Rows.InsertAt(row, 0)
        ddlBatchID.DataSource = tblBatchIds
        ddlBatchID.DataTextField = "commbatchid"
        ddlBatchID.DataValueField = "commbatchid"
        ddlBatchID.DataBind()

        tblScenarios = ds.Tables(3)
        row = tblScenarios.NewRow
        row(0) = "All"
        tblScenarios.Rows.InsertAt(row, 0)
        ddlScenario.DataSource = tblScenarios
        ddlScenario.DataTextField = "commstructid"
        ddlScenario.DataValueField = "commstructid"
        ddlScenario.DataBind()

        lblFound.Text = ds.Tables(0).Rows.Count & " transactions found."

        li = ddlBatchDate.Items.FindByText(curDate)
        li.Selected = True

        li = ddlBatchID.Items.FindByText(curID)
        li.Selected = True

        li = ddlScenario.Items.FindByText(curScen)
        li.Selected = True
    End Sub

    Protected Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#E3E3E3';")
            e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
        End If
    End Sub
End Class
