Option Explicit On

Imports LocalHelper

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports SharedFunctions

Imports Slf.Dms.Records
Imports System.Collections.Generic
Imports System.Data
Imports System.Linq
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.IO

Partial Class processing_CheckRegister_default
    Inherits System.Web.UI.Page

#Region "Variables"

    Public Shadows ClientID As Integer
    Private UserID As Integer

    Private TransactionList As New List(Of RegisterTransaction)

#End Region

#Region "Structures"
    Public Structure RegisterTransaction
        Public FirmRegisterId As Integer
        Public RegisterId As Integer
        Public FirmId As Integer
        Public RegisterDate As Date
        Public SerialNumber As Object
        Public Amount As Double
        Public [Description] As String
        Public ClearedVoidedDate As Nullable(Of DateTime)
        Public RequestedType As String
        Public Cleared As Boolean
        Public Void As Boolean
        Public DataType As String
        Public FirmName As String
        Public ClientDetail As String
        Public ClientId As Integer

        Public Sub New(ByVal _FirmRegisterId As Integer, ByVal _FirmId As Integer, ByVal _RegisterId As Integer, _
            ByVal _Date As Date, ByVal _CheckNumber As Object, ByVal _Amount As Double, ByVal _Description As String, _
            ByVal _FirmName As String, ByVal _ClientDetail As String, ByVal _ClearedDate As Nullable(Of DateTime), ByVal _Reconciled As Boolean, _
            ByVal _DataType As String, ByVal _Void As Boolean, ByVal _RequestedType As String, ByVal _ClientId As Integer)

            Me.Amount = _Amount
            Me.SerialNumber = _CheckNumber
            Me.[Description] = _Description
            Me.RegisterDate = _Date
            Me.ClearedVoidedDate = _ClearedDate
            Me.FirmId = _FirmId
            Me.FirmRegisterId = _FirmRegisterId
            Me.RegisterId = _RegisterId
            Me.RequestedType = _RequestedType
            Me.Cleared = _Reconciled
            Me.DataType = _DataType
            Me.Void = _Void
            Me.ClientDetail = _ClientDetail
            Me.FirmName = _FirmName
            Me.ClientId = _ClientId
        End Sub
    End Structure
#End Region

#Region "Events"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)

        If Session("UserID") Is Nothing Then
            Session("UserID") = UserID
        End If

        If Not IsPostBack Then
            ViewState("SortDir") = "ASC"
        End If

        LoadRegisterEntries()
        SetRollups()
        txtSearch.Attributes("onkeypress") = "javascript:onlyDigits();"

        If TransactionList.Count > 0 Then
            tdDeleteConfirm.Style.Value = "display:inline"
        End If

    End Sub
    Protected Sub chkHideBouncedVoided_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkHideBouncedVoided.CheckedChanged
        If TransactionList.Count > 0 Then
            Dim filteredList As List(Of RegisterTransaction)

            filteredList = Me.GetBindingData()
            Me.BindDataToGrid(filteredList)
        End If
    End Sub

    Protected Sub gvTransactions_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvTransactions.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                Dim srcString As String
                If ViewState("SortDir").ToString().Equals("DESC") Then
                    srcString = "~/images/sort-desc.png"
                Else
                    srcString = "~/images/sort-asc.png"
                End If

                For Each dataCell As DataControlFieldHeaderCell In e.Row.Cells
                    If Not String.IsNullOrEmpty(dataCell.ContainingField.SortExpression) Then
                        Dim img As New HtmlImage()
                        img.Src = srcString
                        dataCell.Controls.Add(img)
                        dataCell.HorizontalAlign = HorizontalAlign.Center
                    End If
                Next
        End Select
    End Sub
    Protected Sub gvTransactions_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvTransactions.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim bVoid As Boolean = CType(e.Row.FindControl("hdnVoid"), HtmlInputHidden).Value
            Dim bCleared As Boolean = CType(e.Row.FindControl("hdnReconciled"), HtmlInputHidden).Value
            Dim requestType As String = CType(e.Row.FindControl("hdnRequest"), HtmlInputHidden).Value

            If requestType.ToLower().Equals("settlement") Then
                CType(e.Row.FindControl("imgRequest"), HtmlImage).Src = "~/images/16x16_entryType.png"
            Else
                CType(e.Row.FindControl("imgRequest"), HtmlImage).Src = "~/images/16x16_cancel2.png"
            End If

            e.Row.Cells(5).Text = FormatCurrency(e.Row.Cells(5).Text, 2)
            If e.Row.Cells(7).Text <> "&nbsp;" Then
                e.Row.Cells(7).Text = FormatDateTime(e.Row.Cells(7).Text, DateFormat.ShortDate)
            End If

            If bCleared Then
                e.Row.Style.Add("background-color", "#C8F5C8")
            ElseIf bVoid Then
                e.Row.Style.Add("background-color", "#F5C8C8")
            Else
                e.Row.Style.Add("background-color", "#F5F58F")
            End If

            e.Row.Attributes("onmouseover") = "javascript:setMouseOverColor(this);"
            e.Row.Attributes("onmouseout") = "javascript:setMouseOutColor(this);"
        End If
    End Sub

    Protected Sub lnkFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkFilter.Click
        Dim filteredList As List(Of RegisterTransaction)
        
        filteredList = Me.GetBindingData()
        Me.BindDataToGrid(filteredList)
    End Sub

    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        Dim sw As New StringWriter
        Dim htw As New HtmlTextWriter(sw)
        Dim table As New System.Web.UI.WebControls.Table
        Dim tr As New System.Web.UI.WebControls.TableRow
        Dim cell As TableCell
        Dim filteredList As List(Of RegisterTransaction) = Me.GetBindingData()
        Dim ds As DataSet = Me.GetDataSet(filteredList)

        If ds.Tables(0).Columns.Count > 0 Then
            ds.Tables(0).Columns.Remove("FirmId")
            ds.Tables(0).Columns.Remove("RegisterId")
            ds.Tables(0).Columns.Remove("FirmRegisterId")
        End If

        For i As Integer = 0 To ds.Tables(0).Columns.Count - 1
            cell = New TableCell
            cell.Text = ds.Tables(0).Columns(i).ColumnName
            tr.Cells.Add(cell)
        Next
        table.Rows.Add(tr)

        For Each row As DataRow In ds.Tables(0).Rows
            tr = New TableRow
            For i As Integer = 0 To ds.Tables(0).Columns.Count - 1
                cell = New TableCell
                cell.Attributes.Add("class", "entryFormat")
                cell.Text = row.Item(i).ToString
                tr.Cells.Add(cell)
            Next
            table.Rows.Add(tr)
        Next

        table.RenderControl(htw)

        HttpContext.Current.Response.Clear()
        HttpContext.Current.Response.ContentType = "application/ms-excel"
        HttpContext.Current.Response.AddHeader("content-disposition", "attachment; filename=CheckRegister.xls")
        HttpContext.Current.Response.Write(sw.ToString)
        HttpContext.Current.Response.End()

    End Sub
    Protected Sub gvTransactions_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvTransactions.PageIndexChanging
        gvTransactions.PageIndex = e.NewPageIndex

        Dim filteredList As List(Of RegisterTransaction)

        filteredList = Me.GetBindingData()
        Me.BindDataToGrid(filteredList)
    End Sub
    Protected Sub gvTransactions_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvTransactions.Sorting
        Dim filteredList As List(Of RegisterTransaction)

        filteredList = Me.GetBindingData()

        Dim ds As New DataSet()
        tdDeleteConfirm.Style.Value = "display:inline"

        ds = Me.GetDataSet(filteredList)

        If Not IsNothing(ds) Then
            If ds.Tables.Count > 0 Then
                If ds.Tables(0).Rows.Count > 0 Then
                    Dim dataView As DataView = New DataView(ds.Tables(0))

                    Dim sortExp As String = "[" & e.SortExpression & "]"

                    If ViewState("SortDir") = "ASC" Then
                        sortExp += " DESC"
                        ViewState("SortDir") = "DESC"
                    Else
                        sortExp += " ASC"
                        ViewState("SortDir") = "ASC"
                    End If

                    dataView.Sort = sortExp
                    Dim dtSort As DataTable = dataView.ToTable
                    gvTransactions.DataSource = dtSort
                    gvTransactions.DataBind()
                End If
            End If
        End If

        hdnRegister.Value = filteredList.Count

        If Not filteredList.Count > 0 Then
            tdDeleteConfirm.Style.Value = "display:none"
        End If
    End Sub
    Protected Sub lnkSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSearch.Click
        
        Dim filteredList As List(Of RegisterTransaction)

        filteredList = (From tr In TransactionList Where tr.SerialNumber = CInt(txtSearch.Text)).ToList()

        Me.BindDataToGrid(filteredList)
    End Sub
    Public Overrides Sub VerifyRenderingInServerForm(ByVal control As Control)

    End Sub

#End Region

#Region "Utilities"
    Private Sub SetRollups()
        Dim CommonTasks As List(Of String) = Master.CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""BankReconciliation.aspx"" ><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_transaction.png") & """ align=""absmiddle""/>Bank Reconciliation</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""javascript:ReprintCheck();"" ><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_print.png") & """ align=""absmiddle""/>Re-Print Checks</a>")
    End Sub
    Private Sub LoadRegisterEntries()
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "stp_GetFirmRegister"
        cmd.CommandType = CommandType.StoredProcedure


        Dim ds As New DataSet
        Dim sqlDA As New SqlDataAdapter(cmd)
        sqlDA.Fill(ds)

        If Not IsNothing(ds) Then
            If ds.Tables.Count > 0 Then
                If ds.Tables(0).Rows.Count > 0 Then
                    gvTransactions.DataSource = ds
                    gvTransactions.DataBind()

                    Me.AddRowsToStructure(ds.Tables(0).Rows)
                End If
            End If
        End If

        If gvTransactions.Rows.Count > 5 Then
            dvTransactions.Style("overflow") = "auto"
        End If

        gvTransactions.Visible = gvTransactions.Rows.Count > 0
        pnlNoEntries.Visible = gvTransactions.Rows.Count = 0
        hdnRegister.Value = gvTransactions.Rows.Count
    End Sub

    Private Sub AddRowsToStructure(ByVal rows As DataRowCollection)
        Dim StartDate As Date
        Dim EndDate As Date
        For Each row As DataRow In rows
            TransactionList.Add(New RegisterTransaction(row("FirmRegisterId"), row("FirmId"), row("RegisterId"), row("ProcessedDate"), _
                                row("CheckNumber"), row("Amount"), row("Detail"), row("FirmName"), row("ClientDetails"), _
                                IIf(IsDBNull(row("ClearedDate")), New Nullable(Of DateTime), row("ClearedDate")), row("Cleared"), row("DataType"), row("Void"), row("RequestedType"), row("ClientId")))
        Next

        If TransactionList.Count > 0 Then
            StartDate = (From t In TransactionList _
            Group t By t.FirmRegisterId Into g = Group _
            Select MaxDate = g.Min(Function(t) t.RegisterDate))(0)

            EndDate = (From t In TransactionList _
                Group t By t.FirmRegisterId Into g = Group _
                Select MaxDate = g.Max(Function(t) t.RegisterDate) Order By MaxDate Descending)(0)

            txtStartDate.Value = StartDate
            txtEndDate.Value = EndDate
        Else
            txtStartDate.Value = DateTime.MinValue
            txtEndDate.Value = DateTime.MaxValue
        End If
    End Sub

    Private Sub BindDataToGrid(ByVal dataList As List(Of RegisterTransaction))
        Dim ds As New DataSet()
        tdDeleteConfirm.Style.Value = "display:inline"

        ds = Me.GetDataSet(dataList)
        gvTransactions.DataSource = ds.Tables(0).DefaultView
        gvTransactions.DataBind()
        hdnRegister.Value = dataList.Count

        If Not dataList.Count > 0 Then
            tdDeleteConfirm.Style.Value = "display:none"
        End If
    End Sub
    Private Function GetDataSet(ByVal dataList As List(Of RegisterTransaction)) As DataSet
        Dim ds As New DataSet()
        ds.Tables.Add()
        ds.Tables(0).Columns.Add("FirmRegisterId")
        ds.Tables(0).Columns.Add("FirmId")
        ds.Tables(0).Columns.Add("RegisterId")
        ds.Tables(0).Columns.Add("ProcessedDate")
        ds.Tables(0).Columns.Add("CheckNumber")
        ds.Tables(0).Columns.Add("Amount")
        ds.Tables(0).Columns.Add("Detail")
        ds.Tables(0).Columns.Add("RequestedType")
        ds.Tables(0).Columns.Add("ClearedDate")
        ds.Tables(0).Columns.Add("Cleared")
        ds.Tables(0).Columns.Add("DataType")
        ds.Tables(0).Columns.Add("Void")
        ds.Tables(0).Columns.Add("ClientDetails")
        ds.Tables(0).Columns.Add("FirmName")
        ds.Tables(0).Columns.Add("ClientId")

        For Each item In DataList
            ds.Tables(0).Rows.Add(item.FirmRegisterId, item.FirmId, item.RegisterId, item.RegisterDate.ToString("MM/dd/yyyy"), _
                                item.SerialNumber, item.Amount, item.Description, item.RequestedType, item.ClearedVoidedDate, _
                                item.Cleared, item.DataType, item.Void, item.ClientDetail, item.FirmName, item.ClientId)
        Next

        Return ds
    End Function

    Private Function GetBindingData() As List(Of RegisterTransaction)
        Dim filteredList As List(Of RegisterTransaction)
        Dim lawfirms As New Lexxiom.ImportClients.LawFirmList
        'get all lawfirms with id greater than 2
        Dim qryfimrs = From firm In lawfirms.LawFirms _
                       Where firm.Id > 2 _
                       Select firm.Id

        Dim firmSelected As Integer() = IIf(ddlFirm.SelectedValue = 3, qryfimrs.ToArray(), New Integer() {ddlFirm.SelectedValue})
        Dim hideVoid As Boolean = chkHideBouncedVoided.Checked
        Dim EndDate As DateTime
        Dim StartDate As DateTime

        If String.IsNullOrEmpty(hdnEnd.Value) Or hdnEnd.Value.Equals(DateTime.MinValue) Then
            EndDate = CDate(System.Data.SqlTypes.SqlDateTime.MaxValue)
        Else
            EndDate = CDate(hdnEnd.Value)
        End If

        If String.IsNullOrEmpty(hdnStart.Value) Or hdnStart.Value.Equals(DateTime.MinValue) Then
            StartDate = CDate(System.Data.SqlTypes.SqlDateTime.MinValue)
        Else
            StartDate = CDate(hdnStart.Value)
        End If

        If ddlFirm.SelectedValue <> 0 Then
            filteredList = (From tr In TransactionList Where firmSelected.Contains(tr.FirmId) And tr.RegisterDate.Date >= StartDate.Date _
                                                And tr.RegisterDate.Date <= EndDate.Date).ToList()
        Else
            filteredList = (From tr In TransactionList Where tr.RegisterDate.Date >= StartDate.Date And _
                                                tr.RegisterDate.Date <= EndDate.Date).ToList()
        End If

        If hideVoid Then
            filteredList = (From r In filteredList Where r.Void <> True).ToList()
        End If

        txtStartDate.Value = hdnStart.Value
        txtEndDate.Value = hdnEnd.Value

        Return filteredList
    End Function
    
#End Region

End Class