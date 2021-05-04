Imports System.Data
Imports Drg.Util.DataAccess

Partial Class admin_creditors_validationdetail
    Inherits System.Web.UI.Page

    Private prevCreditorID As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            LoadGrids()
        End If
    End Sub

    Private Sub LoadGrids()
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        Dim ds As DataSet

        cmd.CommandType = CommandType.Text
        cmd.CommandText = String.Format("exec stp_CreditorValidationDetail {0}", Request.QueryString("id"))
        ds = DatabaseHelper.ExecuteDataset(cmd)

        gvValidated.DataSource = ds.Tables(0)
        gvValidated.DataBind()

        gvApproved.DataSource = ds.Tables(1)
        gvApproved.DataBind()

        gvDuplicates.DataSource = ds.Tables(2)
        gvDuplicates.DataBind()

        lblName.Text = ds.Tables(3).Rows(0)("name")
        lblDept.Text = ds.Tables(3).Rows(0)("group")

        DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
    End Sub

    Protected Sub gvDuplicates_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDuplicates.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then RowDataBound(e.Row, gvDuplicates.DataKeys(e.Row.RowIndex))
    End Sub

    Protected Sub gvApproved_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvApproved.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then RowDataBound(e.Row, gvApproved.DataKeys(e.Row.RowIndex))
    End Sub

    Protected Sub gvValidated_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvValidated.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then RowDataBound(e.Row, gvValidated.DataKeys(e.Row.RowIndex))
    End Sub

    Private Sub RowDataBound(ByVal row As GridViewRow, ByVal dk As DataKey)
        If dk("Active") = "0" Then
            row.Style("color") = "#b9b9b9"
        End If
        If dk("CreditorID") = prevCreditorID AndAlso prevCreditorID <> "" Then
            Dim img As HtmlImage = CType(row.FindControl("imgIcon"), HtmlImage)
            img.Visible = False
            row.Cells(1).Text = "<img src='../../images/arrow_end.png' align='absmiddle'>&nbsp;" & row.Cells(1).Text
        End If
        If dk("Validated") = "1" Then
            row.Style("background-color") = "#D2FFD2"
            row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#C2EAC2';")
            row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#D2FFD2';")
        Else
            row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#ffffda';")
            row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
        End If
        prevCreditorID = dk("CreditorID")
    End Sub
End Class
