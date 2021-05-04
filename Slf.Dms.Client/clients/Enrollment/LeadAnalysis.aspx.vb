Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Collections
Imports System.Net
Imports System.Collections.Generic
Imports System.Linq
Imports System.Text
Imports iTextSharp.text
Imports iTextSharp.text.pdf
Imports iTextSharp.text.html.simpleparser
Imports iTextSharp.text.html
Imports System.Text.RegularExpressions

Partial Class Clients_Enrollment_LeadAnalysis
    Inherits System.Web.UI.Page

    Private convPct As Double
    Private total_eligible As Integer
    Private total_enrolled As Integer
    Private total_deficiency As Integer
    Private avg_eligible As Double
    Private avg_enrolled As Double

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            If Day(Now) < 5 Then
                txtFrom.Text = DateAdd(DateInterval.Month, -1, CDate(Month(Today) & "/1/" & Year(Today)))
                txtTo.Text = DateAdd(DateInterval.Day, -1, CDate(Month(Today) & "/1/" & Year(Today)))
            Else
                txtFrom.Text = CDate(Month(Today) & "/1/" & Year(Today))
                txtTo.Text = Format(Now, "M/d/yyyy")
            End If
        End If
    End Sub

    Private Sub GetLeads()
        Dim dsLeads As DataSet = GetLeadAnalysis()
        Dim dsAllLeads As DataSet
        Dim row As DataRow

        If Not lbStatus.Items(0).Selected Then
            dsAllLeads = GetLeadAnalysis(True)
            dsLeads.Tables(0).ImportRow(dsAllLeads.Tables(0).Rows(0))
            row = dsLeads.Tables(0).NewRow
            row(0) = 0 'place holder
            convPct = Val(dsLeads.Tables(0).Rows(0)(0)) / Val(dsLeads.Tables(0).Rows(1)(0))
            dsLeads.Tables(0).Rows.Add(row)
            dsLeads.Tables(0).AcceptChanges()
        End If

        GridView2.DataSource = dsLeads.Tables(0)
        GridView2.DataBind()

        'Demographics
        gvAccountTypes.DataSource = dsLeads.Tables(1)
        gvAccountTypes.DataBind()

        gvTypeOfDebt.DataSource = dsLeads.Tables(2)
        gvTypeOfDebt.DataBind()

        gvZipCodes.DataSource = dsLeads.Tables(3)
        gvZipCodes.DataBind()

        gvFICO.DataSource = BuildPctTable(dsLeads.Tables(4))
        gvFICO.DataBind()

        gvAge.DataSource = BuildPctTable(dsLeads.Tables(5))
        gvAge.DataBind()

        gvSalutation.DataSource = BuildPctTable(dsLeads.Tables(6))
        gvSalutation.DataBind()

        gvReasons.DataSource = dsLeads.Tables(7)
        gvReasons.DataBind()

        gvBehind.DataSource = dsLeads.Tables(8)
        gvBehind.DataBind()

        gvHardship.DataSource = dsLeads.Tables(9)
        gvHardship.DataBind()

        gvIncome.DataSource = BuildPctTable(dsLeads.Tables(10))
        gvIncome.DataBind()

        gvTopCreditors.DataSource = dsLeads.Tables(11)
        gvTopCreditors.DataBind()

        gvDepositMethod.DataSource = BuildPctTable(dsLeads.Tables(12))
        gvDepositMethod.DataBind()

        gvMonthlyFee.DataSource = dsLeads.Tables(13)
        gvMonthlyFee.DataBind()

        gvDepositToDebt.DataSource = BuildPctTable(dsLeads.Tables(14))
        gvDepositToDebt.DataBind()

        If Not IsDBNull(dsLeads.Tables(18).Rows(0)(0)) Then
            avg_eligible = Val(dsLeads.Tables(18).Rows(0)(0))
            avg_enrolled = Val(dsLeads.Tables(18).Rows(0)(1))
        End If

        gvEnrolled.DataSource = dsLeads.Tables(15)
        gvEnrolled.DataBind()

        gvIncomeTypes.DataSource = dsLeads.Tables(16)
        gvIncomeTypes.DataBind()

        gvFailed3PV.DataSource = dsLeads.Tables(17)
        gvFailed3PV.DataBind()

        If dsLeads.Tables(19).Rows.Count = 1 Then
            lblMedianEligible.Text = CInt(dsLeads.Tables(19).Rows(0)(0))
        Else
            lblMedianEligible.Text = ""
        End If

        If dsLeads.Tables(20).Rows.Count = 1 Then
            lblMedianEnrolled.Text = CInt(dsLeads.Tables(20).Rows(0)(0))
        Else
            lblMedianEnrolled.Text = ""
        End If

        lblMedianFee.Text = ""
        If dsLeads.Tables(21).Rows.Count = 1 Then
            If Not IsDBNull(dsLeads.Tables(21).Rows(0)(0)) Then
                lblMedianFee.Text = FormatCurrency(Val(dsLeads.Tables(21).Rows(0)(0)))
            End If
        End If

        If dsLeads.Tables(22).Rows.Count = 1 Then
            lblMedianDebtEligible.Text = FormatCurrency(Val(dsLeads.Tables(22).Rows(0)(0)))
        Else
            lblMedianDebtEligible.Text = ""
        End If

        gvDeposits.DataSource = BuildPctTable(dsLeads.Tables(23))
        gvDeposits.DataBind()
    End Sub

    Private Function BuildPctTable(ByVal tblSource As DataTable) As DataTable
        Dim tbl As New DataTable
        Dim row As DataRow

        tbl.Columns.Add("Description")
        tbl.Columns.Add("Count")
        tbl.Columns.Add("Pct", GetType(Decimal))
        tbl.AcceptChanges()

        For i As Integer = 0 To tblSource.Columns.Count - 2 Step 2
            If Not IsDBNull(tblSource.Rows(0)(i + 1)) Then
                row = tbl.NewRow
                row(0) = tblSource.Columns(i).ColumnName
                row(1) = tblSource.Rows(0)(i).ToString
                row(2) = Val(tblSource.Rows(0)(i + 1))
                tbl.Rows.Add(row)
            End If
        Next

        Return tbl
    End Function

    Private Function GetLeadAnalysis(Optional ByVal bAllStatuses As Boolean = False) As DataSet
        Dim params As New List(Of SqlParameter)
        Dim ds As DataSet
        Dim where As String
        Dim bJoinToClients As Boolean
        Dim bJoinToDeposits As Boolean

        where = String.Format(" and (l.created between '{0}' and '{1} 23:59')", txtFrom.Text, txtTo.Text)
        where &= String.Format(" and (a.totaldebt between {0} and {1})", Val(txtTotalDebtMin.Text), Val(txtTotalDebtMax.Text))

        If CInt(txtIncomeMin.Text) <> 0 Or CInt(txtIncomeMax.Text) <> 100000 Then
            where &= String.Format(" and (h.monthlyincome between {0} and {1})", txtIncomeMin.Text, txtIncomeMax.Text)
        End If

        If Not bAllStatuses Then
            GetSelectedIDs(lbStatus, "l.statusid", where)
        End If
        GetSelectedIDs(lbCompany, "l.companyid", where)
        GetSelectedIDs(lbState, "l.stateid", where)
        'GetSelectedIDs(lbFronters, "o.origrepid", where)
        'GetSelectedIDs(lbFronters, "ec.closerid", where)
        GetSelectedProductIDs(where)

        If lbClientStatus.SelectedIndex > 0 Then
            bJoinToClients = True
            If lbClientStatus.SelectedIndex > 1 Then
                where &= " and cl.currentclientstatusid = " & lbClientStatus.Items(lbClientStatus.SelectedIndex).Value
            End If
        End If

        If lbMonthlyFee.SelectedIndex > 0 Then
            bJoinToClients = True
            where &= " and cl.maintfee = " & lbMonthlyFee.SelectedItem.Value
            'where &= " and a.maintenancefeecap = " & lbMonthlyFee.SelectedItem.Value
        End If

        If lbDeposits.SelectedIndex > 0 Then
            bJoinToClients = True
            bJoinToDeposits = True
            If lbDeposits.SelectedIndex = 1 Then
                where &= " and cd.deposits = 0"
            Else
                where &= " and cd.deposits >= " & lbDeposits.SelectedItem.Value
            End If
        End If

        params.Add(New SqlParameter("@where", where))
        params.Add(New SqlParameter("@jointoclients", bJoinToClients))
        params.Add(New SqlParameter("@jointodeposits", bJoinToDeposits))
        ds = SqlHelper.GetDataSet("stp_enrollment_leadAnalysis", CommandType.StoredProcedure, params.ToArray)

        Return ds
    End Function

    Private Sub GetSelectedProductIDs(ByRef where As String)
        Dim ids As String = ""

        If lbProduct.Items.Count > 1 Then
            If lbProduct.Items(0).Selected Then
                For i As Integer = 1 To lbProduct.Items.Count - 1
                    If Len(ids) = 0 Then
                        ids = lbProduct.Items(i).Value
                    Else
                        ids &= "," & lbProduct.Items(i).Value
                    End If
                Next
            Else
                For i As Integer = 1 To lbProduct.Items.Count - 1
                    If lbProduct.Items(i).Selected Then
                        If Len(ids) = 0 Then
                            ids = lbProduct.Items(i).Value
                        Else
                            ids &= "," & lbProduct.Items(i).Value
                        End If
                    End If
                Next
            End If
        End If

        If Len(ids) > 0 Then
            where &= String.Format(" and l.productid in ({0})", ids)
        End If
    End Sub

    Private Sub GetSelectedIDs(ByVal listbox1 As ListBox, ByVal column As String, ByRef where As String)
        Dim ids As String = ""

        For Each li As UI.WebControls.ListItem In listbox1.Items
            If li.Selected Then
                If li.Text = "All" Then
                    ids = ""
                    Exit For
                Else
                    If Len(ids) = 0 Then
                        ids &= String.Format("'{0}'", li.Value)
                    Else
                        ids &= String.Format(",'{0}'", li.Value)
                    End If
                End If
            End If
        Next

        If Len(ids) > 0 Then
            where &= String.Format(" and {0} in ({1})", column, ids)
        End If
    End Sub

    Protected Sub btnFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFilter.Click
        GetLeads()
    End Sub

    Protected Sub GridView2_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView2.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            If e.Row.RowIndex = 2 Then
                e.Row.Cells(0).Text = FormatPercent(convPct, 4)
                e.Row.Style("background-color") = "#dcdcdc"
            End If
        End If
    End Sub

    Protected Sub lbStatus_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbStatus.DataBound
        lbStatus.Items(0).Selected = True
        GetLeads()
    End Sub

    Protected Sub lbFronters_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbFronters.DataBound
        lbFronters.Items(0).Selected = True
    End Sub

    Protected Sub lbClosers_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbClosers.DataBound
        lbClosers.Items(0).Selected = True
    End Sub

    Protected Sub lbState_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbState.DataBound
        lbState.Items(0).Selected = True
    End Sub

    Protected Sub lbCompany_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbCompany.DataBound
        lbCompany.Items(0).Selected = True
    End Sub

    Protected Sub lbStatusGroup_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbStatusGroup.DataBound
        lbStatusGroup.Items(0).Selected = True
    End Sub

    Protected Sub lbVendor_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbVendor.DataBound
        lbVendor.Items(0).Selected = True
    End Sub

    Protected Sub lbStatusGroup_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbStatusGroup.SelectedIndexChanged
        Dim tblStatus As DataTable

        For i As Integer = 0 To lbStatus.Items.Count - 1
            lbStatus.Items(i).Selected = False
        Next

        If lbStatusGroup.Items(0).Selected Then
            For i As Integer = 1 To lbStatusGroup.Items.Count - 1
                lbStatusGroup.Items(i).Selected = False
            Next
            lbStatus.Items(0).Selected = True
        Else
            For Each li As UI.WebControls.ListItem In lbStatusGroup.Items
                If li.Selected Then
                    tblStatus = SqlHelper.GetDataTable("select statusid from tblleadstatus where statusgroupid = " & li.Value)
                    For Each row As DataRow In tblStatus.Rows
                        For Each liStatus As UI.WebControls.ListItem In lbStatus.Items
                            Dim ids() As String = Split(liStatus.Value, "|")
                            If ids(0) = row(0) Then
                                liStatus.Selected = True
                            End If
                        Next
                    Next
                End If
            Next
        End If
    End Sub

    Protected Sub lbVendor_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbVendor.SelectedIndexChanged
        Dim ids As String

        lbProduct.Items.Clear()

        If lbVendor.Items(0).Selected Then 'All
            For i As Integer = 1 To lbVendor.Items.Count - 1
                lbVendor.Items(i).Selected = False
            Next
        Else
            For Each li As UI.WebControls.ListItem In lbVendor.Items
                If li.Selected Then
                    If Len(ids) = 0 Then
                        ids = li.Value
                    Else
                        ids &= "," & li.Value
                    End If
                End If
            Next

            If Len(ids) > 0 Then
                lbProduct.DataSource = SqlHelper.GetDataTable(String.Format("select productid, productdesc from tblleadproducts where vendorid in ({0}) order by vendorid, productdesc", ids))
                lbProduct.DataBind()
            End If
        End If

        lbProduct.Items.Insert(0, New UI.WebControls.ListItem("All", "-1"))
        lbProduct.Items(0).Selected = True
    End Sub

    Private Sub Export()
        Dim attachment As String = "attachment; filename=demographics.pdf"
        Dim document As New iTextSharp.text.Document()
        Dim sw As New StringWriter()
        Dim tw As New HtmlTextWriter(sw)

        Response.ClearContent()
        Response.AddHeader("content-disposition", attachment)
        Response.ContentType = "application/pdf"

        'iTextSharp.text.pdf.PdfWriter.GetInstance(document, New FileStream(Environment.GetFolderPath(Environment.SpecialFolder.Desktop) & "\sample2.pdf", FileMode.Create))
        iTextSharp.text.pdf.PdfWriter.GetInstance(document, Response.OutputStream)

        document.Add(New Header(iTextSharp.text.html.Markup.HTML_ATTR_STYLESHEET, "C:\Users\jhernandez\Documents\Visual Studio 2008\Lexxiom Projects\Slf.Dms.Dev\Slf.Dms.Client\Clients\Enrollment\Enrollment.css"))
        document.Open()

        'Dim sr As New StringReader(sw.ToString())
        Dim htmlworker As New iTextSharp.text.html.simpleparser.HTMLWorker(document)

        'htmlworker.Style.LoadTagStyle("table", "cellpadding", "0")
        'htmlworker.Style.LoadTagStyle("table", "cellspacing", "0")
        htmlworker.Style.LoadTagStyle("th", "style", "font-size:8px")
        htmlworker.Style.LoadTagStyle("td", "style", "font-size:8px")

        For Each Control In divDemo.Controls
            If TypeOf Control Is GridView Then
                TryCast(Control, GridView).RenderControl(tw)
            ElseIf TypeOf Control Is HtmlGenericControl Then
                tw.WriteLine("<br/><br/>" & TryCast(Control, HtmlGenericControl).InnerText)
            End If
        Next

        Dim sr As New StringReader(sw.ToString())
        htmlworker.Parse(sr)

        document.Close()

        Response.Write(document)
        Response.[End]()
    End Sub

    Public Overrides Sub VerifyRenderingInServerForm(ByVal control As Control)
        'needed to prevent Control 'ctl00_cphBody_gvAccountTypes' of type 'GridView' must be placed inside a form tag with runat=server. 
    End Sub

    Protected Sub lnkExportToPDF_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExportToPDF.Click
        Export()
    End Sub

    Protected Sub gvEnrolled_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvEnrolled.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            total_eligible += CInt(e.Row.Cells(1).Text)
            total_enrolled += CInt(e.Row.Cells(2).Text)
            total_deficiency += CInt(e.Row.Cells(3).Text)
        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(0).Text = FormatNumber(avg_eligible, 1)
            e.Row.Cells(1).Text = total_eligible
            e.Row.Cells(2).Text = total_enrolled
            e.Row.Cells(3).Text = total_deficiency
            e.Row.Cells(4).Text = FormatNumber(avg_enrolled, 1)
            e.Row.Cells(5).Text = FormatPercent(total_enrolled / total_eligible, 1)
        End If
    End Sub

End Class