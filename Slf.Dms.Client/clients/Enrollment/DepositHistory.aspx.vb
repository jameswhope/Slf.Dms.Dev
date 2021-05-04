Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess
Imports System.Collections.Generic

Partial Class Clients_Enrollment_DepositHistory
    Inherits System.Web.UI.Page

    Private _userid As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        _userid = DataHelper.Nz_int(Page.User.Identity.Name)

        If Request.QueryString("mobile") = "1" Then
            hdnNotab.Value = "1"
        End If

        If Not Page.IsPostBack Then
            LoadGrid()
        End If

    End Sub

    Private Sub LoadGrid()

        gvrecordeddeposits.DataSource = SqlHelper.GetDataTable("stp_enrollment_depositdays", , )
        gvrecordeddeposits.DataBind()

    End Sub

    Protected Sub gvrecordeddeposits_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvrecordeddeposits.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim month As Integer = 0
            Select Case e.Row.Cells(0).Text
                Case "Jan"
                    month = 1
                Case "Feb"
                    month = 2
                Case "Mar"
                    month = 3
                Case "Apr"
                    month = 4
                Case "May"
                    month = 5
                Case "Jun"
                    month = 6
                Case "Jul"
                    month = 7
                Case "Aug"
                    month = 8
                Case "Sep"
                    month = 9
                Case "Oct"
                    month = 10
                Case "Nov"
                    month = 11
                Case "Dec"
                    month = 12
            End Select
            For i As Integer = 2 To 33
                Dim count As String = e.Row.Cells(i).Text
                Dim Asum As Decimal = 0.0
                Dim Csum As Decimal = 0.0
                Dim sum1 As String = ""
                Dim sum2 As String = ""
                count = count.Replace("]", "").Replace("$", "")
                Dim elements As String() = count.Split("[")
                count = elements(0)
                Asum = CDec(elements(1))
                sum1 = String.Format("{0:c0}", Asum)
                If i <> 33 Then
                    Csum = CDec(elements(2))
                    sum2 = String.Format("{0:c0}", Csum)
                    e.Row.Cells(i).Text = String.Format("<a href=""javascript:showModalPopup('{0}','{1}','{2}','');"">{3}</a>", e.Row.Cells(1).Text, month, i - 1, count + "<br/>[" + sum1 + "]" + "<br/>[" + sum2 + "]")
                Else
                    e.Row.Cells(i).Text = String.Format("<p>{3}</p>", e.Row.Cells(1).Text, month, i - 1, count + "<br/>[" + sum1 + "]")
                End If

            Next
        End If
    End Sub

    Protected Sub lnkLoadLeads_Click(sender As Object, e As EventArgs) Handles lnkLoadLeads.Click
        LoadLeads("")
        ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "jscompleteloadleads", "ModalPopupCompleted();", True)
    End Sub

    Private Sub LoadLeads(ByVal SortExpression As String)
        Dim params(2) As SqlParameter

        Dim day As Integer = hdnDay.Value
        Dim month As Integer = hdnMonth.Value
        Dim year As Integer = hdnYear.Value

        params(0) = New SqlParameter("@day", Day)
        params(1) = New SqlParameter("@month", Month)
        params(2) = New SqlParameter("@year", Year)

        Dim tbl As DataTable = SqlHelper.GetDataTable("stp_enrollment_depositdaydetail", CommandType.StoredProcedure, params)

        Dim dv As New DataView(tbl)

        Dim title As String = String.Format("Deposits For {0} {1}, {2}", MonthName(month, True), day, year)
        lblPopupTitle.Text = title

        gvLeads.DataSource = dv
        gvLeads.DataBind()

    End Sub
End Class
