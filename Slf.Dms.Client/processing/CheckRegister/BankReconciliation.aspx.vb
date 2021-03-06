Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.Collections.Generic
Imports System.Data
Imports System.Drawing
Imports System.IO
Imports System.Data.OleDb
Imports System.Data.SqlClient
Imports System.Reflection
Imports System.Linq
Imports System.Xml.Linq


Partial Class processing_CheckRegister_BankReconciliation
    Inherits System.Web.UI.Page
#Region "Variables"
    Public Shadows ClientID As Integer
    Private UserID As Integer
    Private columnDict As New Dictionary(Of String, Type)
    Private _directoryPath As String
    Private _fileName As String
    Public tabIndex As Int16 = 0
    Private dsMaster As New DataSet

    Public Property DirectoryPath() As String
        Get
            Return _directoryPath
        End Get
        Set(ByVal value As String)
            _directoryPath = value
        End Set
    End Property

    Public Property FileName() As String
        Get
            Return _fileName
        End Get
        Set(ByVal value As String)
            _fileName = value
        End Set
    End Property
#End Region

#Region "Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)

        If Session("UserID") Is Nothing Then
            Session("UserID") = UserID
        End If

        Me.SetProcessPendingCount()
        Master.SetUpLegend(False)
    End Sub
    Protected Sub lnkProcess_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkProcess.Click
        dvError.Style.Add("display", "none")
        tdError.InnerHtml = ""

        Dim filePath = Me.GetUploadedFilePath(txtPath.PostedFile.FileName)

        If FileIsOpen(filePath) Then
            dvError.Style.Add("display", "inline")
            tdError.InnerHtml = "File in use! Please close the file and try again."
        Else
            txtPath.PostedFile.SaveAs(filePath)
            hdnFilePath.Value = filePath

            AssignFileName()
            If Me.ValidateExcel() Then
                dvError.Style.Add("display", "inline")
                tdError.InnerHtml = "File Validated Successfully."
            End If
        End If
    End Sub
    Protected Sub lnkValidate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkValidate.Click
        tdError.InnerHtml = ""
        dvError.Style.Add("display", "none")
        hdnTotalClearedAmt.Value = "0"
        hdnExceptionAmount.Value = "0"

        Me.CompareDataSets()

        If Not dsMaster Is Nothing AndAlso dsMaster.Tables.Count > 0 Then
            UpdateExceptionAmount()
            Me.BindDataGrids()
            tabIndex = 0
        End If
    End Sub
    Protected Sub lnkClearChecks_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClearChecks.Click
        UpdateDataset()

        Dim clearedXml As New XElement("ClearChecks")

        For Each row As GridViewRow In gvCleared.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chk_selectRecord")

                If chk.Checked Then
                    Dim PaymentId As String = CType(row.FindControl("hdnPaymenId"), HtmlInputHidden).Value
                    Dim FirmRegisterId As String = CType(row.FindControl("hdnFirmRegisterId"), HtmlInputHidden).Value
                    Dim RegisterId As String = CType(row.FindControl("hdnRegisterId"), HtmlInputHidden).Value
                    Dim FirmId As String = CType(row.FindControl("hdnFirmId"), HtmlInputHidden).Value
                    Dim checkAmount As Double = CDbl(CType(row.FindControl("hdnChkAmount"), HtmlInputHidden).Value)
                    Dim FeeId As Integer = CInt(CType(row.FindControl("hdnFeeId"), HtmlInputHidden).Value)
                    Dim FeeAmount As Double = CDbl(CType(row.FindControl("hdnFeeAmount"), HtmlInputHidden).Value)
                    Dim AdjFeeAmount As Double = CDbl(CType(row.FindControl("hdnAdjustedFee"), HtmlInputHidden).Value)
                    Dim SettAmount As Double = CDbl(CType(row.FindControl("hdnSettAmount"), HtmlInputHidden).Value)
                    Dim AdjSettAmount As Double = CDbl(CType(row.FindControl("hdnAdjustedSett"), HtmlInputHidden).Value)
                    Dim dataType As String = CType(row.FindControl("hdnDataType"), HtmlInputHidden).Value
                    Dim originalDataType As String = row.Cells(7).Text
                    Dim adjustedCheckAmount As Double = CDbl(row.Cells(3).Text)
                    Dim adjustedRegisterId As Integer = 0

                    Dim originalAmount As Double = IIf(originalDataType.ToLower().Equals("debits"), Math.Abs(checkAmount) * -1, checkAmount)
                    Dim adjustedAmount As Double = IIf(dataType.ToLower().Equals("debits"), Math.Abs(adjustedCheckAmount) * -1, adjustedCheckAmount)
                    Dim originalFeeAmt As Double = IIf(originalDataType.ToLower().Equals("debits"), Math.Abs(FeeAmount) * -1, FeeAmount)
                    Dim adjustedFeeAmt As Double = IIf(dataType.ToLower().Equals("debits"), Math.Abs(AdjFeeAmount) * -1, AdjFeeAmount)
                    Dim originalSettAmount As Double = IIf(originalDataType.ToLower().Equals("debits"), Math.Abs(SettAmount) * -1, SettAmount)
                    Dim adjustedSettAmount As Double = IIf(dataType.ToLower().Equals("debits"), Math.Abs(AdjSettAmount) * -1, AdjSettAmount)
                    Dim _ClientId As Integer = CInt(DataHelper.FieldLookup("tblRegister", "ClientId", "RegisterId= " & RegisterId))
                    Dim _AccountId As Integer = CInt(DataHelper.FieldLookup("tblRegister", "AccountId", "RegisterId= " & RegisterId))
                    Dim element As New XElement("ClearCheck")
                    Dim AdjustedFeeId As Integer = 0

                    If originalAmount = adjustedAmount Then
                        'Clear Register
                        RegisterHelper.Clear(RegisterId, UserID, DateTime.Now, True)

                        If FeeId <> 0 Then
                            RegisterHelper.Clear(FeeId, UserID, DateTime.Now, True)
                        End If
                        'Clear Firm Register
                        element.Add(New XAttribute("FirmRegisterId", FirmRegisterId))
                    Else
                        If originalSettAmount <> adjustedSettAmount Then
                            'Void Register
                            RegisterHelper.Void(RegisterId, UserID, DateTime.Now, True)
                            'Add a new amount for SettlementAmount
                            adjustedRegisterId = RegisterHelper.InsertDebit(_ClientId, _AccountId, DateTime.Now, row.Cells(4).Text, "Settlement", adjustedSettAmount, Nothing, 18, UserID)
                            RegisterHelper.Clear(adjustedRegisterId, UserID, DateTime.Now, True)
                        Else
                            RegisterHelper.Clear(RegisterId, UserID, DateTime.Now, True)
                        End If

                        adjustedRegisterId = IIf(adjustedRegisterId = 0, RegisterId, adjustedRegisterId)

                        If FeeId <> 0 Then
                            If originalFeeAmt <> adjustedFeeAmt Then
                                RegisterHelper.Void(FeeId, UserID, DateTime.Now, True)

                                If adjustedFeeAmt <> 0 Then
                                    AdjustedFeeId = RegisterHelper.InsertFee(adjustedRegisterId, _ClientId, _AccountId, DateTime.Now, "Client Withdrawal", adjustedFeeAmt, 28, Nothing, Nothing, Nothing, UserID, False)
                                    RegisterHelper.Clear(AdjustedFeeId, UserID, DateTime.Now, True)
                                Else
                                    RegisterHelper.InsertFee(adjustedRegisterId, _ClientId, _AccountId, DateTime.Now, "Overnight Fee", (15) * -1, 6, Nothing, Nothing, Nothing, UserID, False)
                                End If
                            Else
                                RegisterHelper.Clear(FeeId, UserID, DateTime.Now, True)
                            End If
                        Else
                            If adjustedFeeAmt <> 0 Then
                                'void Overnight fee
                                Dim overnightId() As Integer = DataHelper.FieldLookupIDs("tblRegister", "RegisterId", "RegisterSetId = " & RegisterId & " and EntryTypeId = 6")

                                If Not overnightId Is Nothing AndAlso overnightId.Length > 0 Then
                                    RegisterHelper.Void(overnightId(0), UserID, DateTime.Now, True)
                                End If

                                ' Amount As Client Withdrawal
                                AdjustedFeeId = RegisterHelper.InsertFee(adjustedRegisterId, _ClientId, _AccountId, DateTime.Now, "Client Withdrawal", adjustedFeeAmt, 28, Nothing, Nothing, Nothing, UserID, False)
                                RegisterHelper.Clear(AdjustedFeeId, UserID, DateTime.Now, True)
                            End If
                        End If

                        RegisterHelper.Rebalance(_ClientId)
                        'Generate Voided Check
                        SettlementMatterHelper.VoidSettlementAmount(PaymentId, RegisterId, CInt(row.Cells(4).Text), checkAmount, UserID)

                        'Add a new entry as cleared
                        SettlementMatterHelper.AddNewSettlementAmountAsCleared(PaymentId, adjustedRegisterId, IIf(AdjustedFeeId = 0, FeeId, AdjustedFeeId), FirmId, CInt(row.Cells(4).Text), adjustedCheckAmount, UserID, row.Cells(5).Text, row.Cells(6).Text, dataType, FirmRegisterId)
                    End If

                    clearedXml.Add(element)
                End If
            End If
        Next

        Using connection As IDbConnection = ConnectionFactory.Create()
            connection.Open()

            Using cmd As IDbCommand = connection.CreateCommand()
                cmd.CommandText = "stp_ClearFirmRegister"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "ClearXml", clearedXml.ToString())
                DatabaseHelper.AddParameter(cmd, "UserId", UserID)
                cmd.ExecuteNonQuery()
            End Using
        End Using

        For Each row As GridViewRow In gvExceptionReport.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Dim BankUpload As Integer = CType(row.FindControl("hdnUploadId"), HtmlInputHidden).Value

                SettlementMatterHelper.UpdateBankUploadAsProcessed(BankUpload, UserID)
                Exit For
            End If
        Next

        For Each row As GridViewRow In gvExceptionReport.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Dim chkAmount = CType(row.FindControl("chk_RejectTransaction"), HtmlInputCheckBox)

                If chkAmount.Checked Then
                    Dim BankRegisterId As Integer = CType(row.FindControl("hdnBankRegisterId"), HtmlInputHidden).Value

                    SettlementMatterHelper.SetBankRegisterAsRejected(BankRegisterId)
                End If
            End If
        Next

        Response.Redirect("~/processing/CheckRegister/default.aspx")
    End Sub
    Protected Sub lnkAddToClear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAddToClear.Click
        UpdateDataset()
        If Not dsMaster Is Nothing AndAlso dsMaster.Tables.Count > 0 AndAlso dsMaster.Tables(0).Rows.Count > 0 Then

            For Each row As GridViewRow In gvFirmReport.Rows
                If row.RowType = DataControlRowType.DataRow Then
                    Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chk_selectFirm")

                    If chk.Checked Then
                        Dim RegisterId As String = CType(row.FindControl("hdnReportRegisterId"), HtmlInputHidden).Value
                        Dim FirmRegisterId As String = CType(row.FindControl("hdnReportFirmRegister"), HtmlInputHidden).Value
                        Dim FirmId As String = CType(row.FindControl("hdnReportFirm"), HtmlInputHidden).Value
                        Dim adjSettAmount = CDbl(CType(row.FindControl("txtAmount"), TextBox).Text)
                        Dim adjFeeAmount = CDbl(CType(row.FindControl("txtFeeAmount"), TextBox).Text)
                        Dim FeeAmount = CDbl(CType(row.FindControl("hdnReportFeeAmount"), HtmlInputHidden).Value)
                        Dim SettAmount = CDbl(CType(row.FindControl("hdnReportSettAmount"), HtmlInputHidden).Value)
                        Dim dataType As String = CType(row.FindControl("ddlDataType"), DropDownList).SelectedItem.Text
                        Dim chkAmount As Double = CType(row.FindControl("hdnReportAmount"), HtmlInputHidden).Value
                        Dim adjCheckAmount As Double = (adjFeeAmount + adjSettAmount)
                        Dim FeeId As Double = CType(row.FindControl("hdnReportFeeId"), HtmlInputHidden).Value
                        Dim OriginalDataType As String = CType(row.FindControl("hdnReportDataType"), HtmlInputHidden).Value

                        dsMaster.Tables("FirmRegister").LoadDataRow(New Object() {FirmRegisterId, RegisterId, FeeId, FirmId, row.Cells(1).Text, row.Cells(2).Text, row.Cells(4).Text, row.Cells(5).Text, row.Cells(6).Text, OriginalDataType, adjCheckAmount, chkAmount, FeeAmount, adjFeeAmount, SettAmount, adjSettAmount, dataType, 1, "C"}, True)
                    End If
                End If
            Next

            Me.BindDataGrids()

            tabIndex = 1
        End If
    End Sub
    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        Dim sw As New StringWriter
        Dim htw As New HtmlTextWriter(sw)
        Dim table As System.Web.UI.WebControls.Table
        Dim tr As New System.Web.UI.WebControls.TableRow
        Dim cell As TableCell
        Dim exportedFileName As String

        UpdateDataset()
        If Not dsMaster Is Nothing AndAlso dsMaster.Tables.Count > 0 Then
            Dim firmCleared As EnumerableRowCollection(Of DataRow)
            Dim copyTable As DataTable
            If tsReconcile.SelectedIndex = 0 Then
                firmCleared = From notCounted In dsMaster.Tables("FirmRegister").AsEnumerable() Where _
                             notCounted("Counted") = 1 Select notCounted
                exportedFileName = "ClearedChecks"
            ElseIf tsReconcile.SelectedIndex = 1 Then
                firmCleared = From notCounted In dsMaster.Tables("FirmRegister").AsEnumerable() Where _
                             notCounted("Counted") = 0 Select notCounted
                exportedFileName = "OutstandingChecks"
            Else
                firmCleared = From notCounted In dsMaster.Tables("BankRegister").AsEnumerable() Where _
                             notCounted("Counted") = 0 Select notCounted
                exportedFileName = "ExceptionReport"
            End If

            If firmCleared.Count() > 0 Then
                copyTable = firmCleared.CopyToDataTable()
                table = New Table()
                For i As Integer = 0 To copyTable.Columns.Count - 1
                    cell = New TableCell
                    cell.Text = copyTable.Columns(i).ColumnName
                    tr.Cells.Add(cell)
                Next
                table.Rows.Add(tr)

                For Each row As DataRow In copyTable.Rows
                    tr = New TableRow
                    For i As Integer = 0 To copyTable.Columns.Count - 1
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
                HttpContext.Current.Response.AddHeader("content-disposition", "attachment; filename=" & exportedFileName & ".xls")
                HttpContext.Current.Response.Write(sw.ToString)
                HttpContext.Current.Response.End()
            End If
        End If
        tabIndex = tsReconcile.SelectedIndex
    End Sub

    Public Overrides Sub VerifyRenderingInServerForm(ByVal control As Control)

    End Sub

#End Region

#Region "DataGrid Events"
    Protected Sub gvCleared_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvCleared.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.Cells(3).Text = FormatCurrency(CDbl(e.Row.Cells(3).Text), 2)

            Dim amount As Double = hdnTotalClearedAmt.Value
            Dim rowAmount As Double = IIf(e.Row.Cells(7).Text.ToLower().Equals("debits"), Math.Abs(CDbl(e.Row.Cells(3).Text)) * -1, CDbl(e.Row.Cells(3).Text))
            amount += rowAmount
            hdnTotalClearedAmt.Value = amount

            e.Row.Attributes("onmouseover") = "javascript:setMouseOverColor(this);"
            e.Row.Attributes("onmouseout") = "javascript:setMouseOutColor(this);"
        End If
    End Sub

    Protected Sub gvFirmReport_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvFirmReport.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim txtAmount = CType(e.Row.FindControl("txtAmount"), TextBox)
            Dim txtFeeAmount = CType(e.Row.FindControl("txtFeeAmount"), TextBox)
            txtAmount.Text = FormatCurrency(CDbl(txtAmount.Text), 2)
            txtFeeAmount.Text = FormatCurrency(CDbl(txtFeeAmount.Text), 2)
            txtAmount.Style.Add("text-align", "right")
            txtFeeAmount.Style.Add("text-align", "right")
            Dim dataType As String = CType(e.Row.FindControl("hdnReportDataType"), HtmlInputHidden).Value
            Dim delMethod As String = CType(e.Row.FindControl("hdnDelivery"), HtmlInputHidden).Value
            CType(e.Row.FindControl("ddlDataType"), DropDownList).SelectedValue = dataType
            e.Row.Cells(1).Text = String.Format("{0:MM/dd/yyyy}", CDate(e.Row.Cells(1).Text))
            txtFeeAmount.ReadOnly = IIf(delMethod.Equals("P"), False, True)

            txtAmount.Attributes("onkeypress") = "AllowOnlyNumbers();"
            txtFeeAmount.Attributes("onkeypress") = "AllowOnlyNumbers();"
            e.Row.Attributes("onmouseover") = "javascript:setMouseOverColor(this);"
            e.Row.Attributes("onmouseout") = "javascript:setMouseOutColor(this);"
        End If
    End Sub
    Protected Sub gvExceptionReport_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvExceptionReport.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim rowAmount As Double = IIf(e.Row.Cells(5).Text.ToLower().Equals("debits"), Math.Abs(CDbl(e.Row.Cells(1).Text)) * -1, CDbl(e.Row.Cells(1).Text))
            Dim chkAmount = CType(e.Row.FindControl("chk_RejectTransaction"), HtmlInputCheckBox)
            Dim rejected As Boolean = CBool(CType(e.Row.FindControl("hdnRejected"), HtmlInputHidden).Value)

            chkAmount.Checked = rejected
            chkAmount.Attributes.Add("onclick", "javascript:ExcludeAmount(" & rowAmount & "," & chkAmount.ClientID & ");")
            e.Row.Attributes("onmouseover") = "javascript:setMouseOverColor(this);"
            e.Row.Attributes("onmouseout") = "javascript:setMouseOutColor(this);"
        End If
    End Sub
#End Region

#Region "Validate Excel"
    Private Function ValidateCell(ByVal eRange As Object, ByVal colName As String) As Boolean
        If eRange Is Nothing Then
            Return True
        End If
        If Not columnDict.ContainsKey(colName) Then
            Return True
        End If
        If Not columnDict.Item(colName).Equals(GetType(String)) Then
            Dim result As Object
            Dim Param(1) As Object
            Param(0) = eRange.ToString()
            Param(1) = result
            Dim type() As Type = {GetType(String), columnDict.Item(colName)}

            For Each m As MethodInfo In columnDict.Item(colName).GetMethods()
                If m.Name.Equals("TryParse") And m.GetParameters().Length = 2 Then
                    If Not m.Invoke(columnDict.Item(colName), Param) Then
                        Return False
                    End If
                End If
            Next
        End If

        Return True
    End Function

    Private Function ValidateExcel() As Boolean
        Dim ds As New DataSet()

        Try
            Using objDataConn As New OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + DirectoryPath + ";Extended Properties=""text;HDR=YES;FMT=Delimited(;)""")
                Try
                    objDataConn.Open()

                    Using objDataAdapter As New OleDbDataAdapter("SELECT * FROM [" + FileName + "]", objDataConn)
                        ds = New DataSet()
                        objDataAdapter.Fill(ds)

                    End Using
                Catch ex As OleDbException
                    dvError.Style.Add("display", "inline")
                    tdError.InnerHtml = "Microsoft.ACE failed to initialize. " & ex.Message & ". Please contact your system administrator."
                    Return False
                End Try

            End Using
        Catch ex As OleDbException
            dvError.Style.Add("display", "inline")
            tdError.InnerHtml = "Please copy from the main sheet into a new sheet to get rid of blank rows, then delete the original sheet and try again."
            Return False
        End Try

        If ds.Tables(0).Columns.Count = 0 Then
            dvError.Style.Add("display", "inline")
            tdError.InnerHtml = "There is no data in the sheet. Select a valid sheet"
            Return False
        End If

        If ds.Tables(0).Rows.Count = 0 Then
            dvError.Style.Add("display", "inline")
            tdError.InnerHtml = "There are no rows in the sheet. Select a valid sheet"
            Return False
        End If

        If ddlFirm.SelectedValue = 3 Then
            Me.PopulateBofADictionary()
        Else
            Me.PopulateBBTDictionary()
        End If

        For Each key In columnDict.Keys
            If Not ds.Tables(0).Columns.Contains(key.ToString()) Then
                dvError.Style.Add("display", "inline")
                tdError.InnerHtml = "The column named " & key.ToString() & " does not exist in the file. Upload a valid file"
                Return False
            End If
        Next

        For Each row As DataRow In ds.Tables(0).Rows
            For i As Integer = 0 To ds.Tables(0).Columns.Count - 1
                If Not Me.ValidateCell(row(i), ds.Tables(0).Columns(i).ColumnName) Then
                    dvError.Style.Add("display", "inline")
                    tdError.InnerHtml = "The data in Row " & (ds.Tables(0).Rows.IndexOf(row) + 1).ToString() & " and Column " & ds.Tables(0).Columns(i).ColumnName & " is invalid. Make Changes and try again"
                    Return False
                End If
            Next
        Next

        Me.InsertExcelDataToDatabase(ds)

        Return True
    End Function

    Private Sub InsertExcelDataToDatabase(ByVal ds As DataSet)
        Dim uploadId As Integer = SettlementMatterHelper.InsertBankUpload(ddlFirm.SelectedItem.Text, UserID)
        SettlementMatterHelper.UpdateBankUpload(ddlFirm.SelectedItem.Text, uploadId, UserID)

        Dim dTable As DataTable = Me.CreateDataTable(New String() {"Rejected", "BAICode", "Description", "Amount", "DataType", "CustomerRef", "Reconciled", "BankUploadId", "ProcessedDate"}, "BankData")
        Dim checkNumber As Integer = 0

        For Each row As DataRow In ds.Tables(0).Rows
            If ddlFirm.SelectedValue = 3 Then
                dTable.LoadDataRow(New Object() {False, CInt(row.Item("BAI Code")), row.Item("Description"), CDbl(row.Item("Amount")), row.Item("Data Type"), CInt(row.Item("Customer Reference")), False, uploadId, CDate(row.Item("As Of"))}, True)
            Else
                If Not IsDBNull(row.Item("Customer Reference")) Then
                    checkNumber = CInt(row.Item("Customer Reference"))
                End If
                dTable.LoadDataRow(New Object() {False, CInt(row.Item("BAITRNCODE")), row.Item("Description"), CDbl(row.Item(Me.FileName.Replace(".", "#") & ".Amount")), IIf(row.Item("DR/CR").ToString().Equals("D"), "DEBITS", "CREDITS"), checkNumber, False, uploadId, CDate(row.Item("POSTEDDTTM"))}, True)
            End If
        Next
        'Insert into Database
        Using connection As SqlConnection = ConnectionFactory.Create()
            connection.Open()

            Using bulkCopy As SqlBulkCopy = New SqlBulkCopy(connection, SqlBulkCopyOptions.Default, Nothing)
                bulkCopy.BatchSize = 500
                bulkCopy.DestinationTableName = "tblBankReconciliationInfo"
                Try
                    bulkCopy.WriteToServer(dTable)
                Finally
                    bulkCopy.Close()
                End Try
            End Using
        End Using
    End Sub

    Private Sub SetProcessPendingCount()
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        cmd.CommandText = "select * from tblBankUpload where Processed = 0"
        cmd.CommandType = CommandType.Text

        Using cmd.Connection
            cmd.Connection.Open()

            Using reader As SqlDataReader = cmd.ExecuteReader()
                While reader.Read()
                    If reader("BankAccountName").ToString().Equals("The Seidaman Law Firm") Then
                        hdnSeidaman.Value = 1
                    ElseIf reader("BankAccountName").ToString().Equals("The Palmer Firm, P.C.") Then
                        hdnPalmer.Value = 1
                    ElseIf reader("BankAccountName").ToString().Equals("Bank Of America Accounts") Then
                        hdnBofa.Value = 1
                    End If
                End While
            End Using
        End Using
    End Sub
#End Region

#Region "Compare Datasets"
    Private Sub BindDataGrids()
        If Not dsMaster Is Nothing AndAlso Not dsMaster.Tables("FirmRegister") Is Nothing Then
            hdnTotalClearedAmt.Value = 0
            Dim firmCleared = From notCounted In dsMaster.Tables("FirmRegister").AsEnumerable() Where _
                             notCounted("Counted") = 1 Select notCounted
            If firmCleared.Count() > 0 Then
                gvCleared.DataSource = firmCleared.CopyToDataTable()
            Else
                gvCleared.DataSource = Nothing
            End If

            gvCleared.DataBind()

            Dim firmExceptions = From notCounted In dsMaster.Tables("FirmRegister").AsEnumerable() Where _
                             notCounted("Counted") = 0 Select notCounted

            If firmExceptions.Count() Then
                gvFirmReport.DataSource = firmExceptions.CopyToDataTable()
            Else
                gvFirmReport.DataSource = Nothing
            End If
            gvFirmReport.DataBind()

        End If

        If gvCleared.Rows.Count > 5 Then
            dvCleared.Style("overflow") = "auto"
            dvCleared.Style("height") = "100%"
        End If

        gvCleared.Visible = gvCleared.Rows.Count > 0
        pnlNoRecords.Visible = gvCleared.Rows.Count = 0
        hdnRecordCount.Value = gvCleared.Rows.Count
        pnlTotalCleared.Visible = gvCleared.Rows.Count > 0
        lblTotalCleared.Text = FormatCurrency(hdnTotalClearedAmt.Value)

        If gvFirmReport.Rows.Count > 5 Then
            dvFirmReport.Style("overflow") = "auto"
            dvFirmReport.Style("height") = "100%"
        End If

        gvFirmReport.Visible = gvFirmReport.Rows.Count > 0
        pnlNoFirmReport.Visible = gvFirmReport.Rows.Count = 0
        hdnReportCount.Value = gvFirmReport.Rows.Count

        If Not dsMaster Is Nothing AndAlso Not dsMaster.Tables("BankRegister") Is Nothing Then
            Dim BankException = From notCounted In dsMaster.Tables("BankRegister").AsEnumerable() Where _
                             notCounted("Counted") = 0 Select notCounted

            If BankException.Count() > 0 Then
                gvExceptionReport.DataSource = BankException.CopyToDataTable()
            Else
                gvExceptionReport.DataSource = Nothing
            End If
            gvExceptionReport.DataBind()
        End If

        If gvExceptionReport.Rows.Count > 5 Then
            dvExceptionReport.Style("overflow") = "auto"
            dvExceptionReport.Style("height") = "100%"
        End If

        gvExceptionReport.Visible = gvExceptionReport.Rows.Count > 0
        pnlNoBankReport.Visible = gvExceptionReport.Rows.Count = 0
        hdnExceptionCount.Value = gvExceptionReport.Rows.Count
        pnlTotalAmount.Visible = gvExceptionReport.Rows.Count > 0
        lblTotalException.Text = FormatCurrency(hdnExceptionAmount.Value, 2)

        pnlNoProcess.Style.Add("display", "none")
        Me.LoadTabStrips()

    End Sub
    Private Sub CompareDataSets()
        Dim compareDS = Me.CreateFirmRegisterDataSet()
        Dim ds = Me.CreateBankRegisterDataSet()
        Dim dsMasterData As New DataSet()

        If ds Is Nothing Or ds.Tables.Count = 0 Or ds.Tables(0).Rows.Count = 0 Then
            dvError.Style.Add("display", "inline")
            tdError.InnerHtml = "There are no entries uploaded to Process. Upload a new file to process"
        Else
            For Each row As DataRow In ds.Tables(0).Rows
                Dim copyRow As DataRow = row
                Dim compare = From entry In compareDS.Tables(0).AsEnumerable() Where _
                            entry("DataType").ToString().ToUpper() = copyRow("DataType").ToString().ToUpper() And _
                            CDbl(entry("CheckAmount").ToString()) = CDbl(copyRow("Amount").ToString()) And _
                            entry("CheckNumber").ToString() = copyRow("CustomerRef").ToString() And _
                            CInt(entry("Counted").ToString()) = 0 Select entry

                If compare.Count() > 0 Then
                    Dim compareTable = compare.CopyToDataTable()
                    compareDS.Tables(0).Rows.Find(compareTable.Rows(0)("FirmRegisterId"))("Counted") = 1
                    row("Counted") = 1
                End If
            Next

            dsMasterData.Tables.Add("FirmRegister").Load(compareDS.CreateDataReader())
            dsMasterData.Tables.Add("BankRegister").Load(ds.CreateDataReader())
        End If

        dsMaster = dsMasterData
    End Sub
    Private Sub UpdateDataset()
        Me.CompareDataSets()

        For Each row As GridViewRow In gvCleared.Rows
            Dim FirmRegisterId As String = CType(row.FindControl("hdnFirmRegisterId"), HtmlInputHidden).Value
            Dim RegisterId As String = CType(row.FindControl("hdnRegisterId"), HtmlInputHidden).Value
            Dim FirmId As String = CType(row.FindControl("hdnFirmId"), HtmlInputHidden).Value
            Dim checkAmt As Double = CDbl(CType(row.FindControl("hdnChkAmount"), HtmlInputHidden).Value)
            Dim FeeId As Integer = CInt(CType(row.FindControl("hdnFeeId"), HtmlInputHidden).Value)
            Dim FeeAmount As Double = CDbl(CType(row.FindControl("hdnFeeAmount"), HtmlInputHidden).Value)
            Dim AdjFeeAmount As Double = CDbl(CType(row.FindControl("hdnAdjustedFee"), HtmlInputHidden).Value)
            Dim SettAmount As Double = CDbl(CType(row.FindControl("hdnSettAmount"), HtmlInputHidden).Value)
            Dim AdjSettAmount As Double = CDbl(CType(row.FindControl("hdnAdjustedSett"), HtmlInputHidden).Value)
            Dim dataType As String = CType(row.FindControl("hdnDataType"), HtmlInputHidden).Value
            dsMaster.Tables("FirmRegister").LoadDataRow(New Object() {FirmRegisterId, RegisterId, FeeId, FirmId, row.Cells(1).Text, row.Cells(2).Text, row.Cells(4).Text, row.Cells(5).Text, row.Cells(6).Text, dataType, CDbl(row.Cells(3).Text), checkAmt, FeeAmount, AdjFeeAmount, SettAmount, AdjSettAmount, row.Cells(7).Text, 1, "C"}, True)
        Next

        For Each row As GridViewRow In gvExceptionReport.Rows
            Dim chkReject = CType(row.FindControl("chk_RejectTransaction"), HtmlInputCheckBox)

            If chkReject.Checked Then
                Dim BankRegisterId As String = CType(row.FindControl("hdnBankRegisterId"), HtmlInputHidden).Value
                Dim UploadId As String = CType(row.FindControl("hdnUploadId"), HtmlInputHidden).Value
                dsMaster.Tables("BankRegister").LoadDataRow(New Object() {BankRegisterId, UploadId, row.Cells(7).Text, True, row.Cells(3).Text, row.Cells(4).Text, CDbl(row.Cells(1).Text), row.Cells(6).Text, row.Cells(5).Text, row.Cells(2).Text, False}, True)
            End If
        Next

        UpdateExceptionAmount()
    End Sub
    
    Private Function CreateFirmRegisterDataSet() As DataSet
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        cmd.CommandText = "stp_GetFirmRegisterDetailsByProcessedDate"
        DatabaseHelper.AddParameter(cmd, "FirmId", ddlFirm.SelectedValue)
        DatabaseHelper.AddParameter(cmd, "StartDate", txtStartDate.Value)
        DatabaseHelper.AddParameter(cmd, "EndDate", txtEndDate.Value)
        cmd.CommandType = CommandType.StoredProcedure

        Dim compareDS As New DataSet
        Dim sqlDA As New SqlDataAdapter(cmd)
        sqlDA.Fill(compareDS)
        compareDS.Tables(0).PrimaryKey = New DataColumn() {compareDS.Tables(0).Columns("FirmRegisterId")}

        Return compareDS
    End Function
    Private Function CreateBankRegisterDataSet() As DataSet
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        cmd.CommandText = "stp_GetBankRegisterDetails"
        DatabaseHelper.AddParameter(cmd, "AccountName", ddlFirm.SelectedItem.Text)
        cmd.CommandType = CommandType.StoredProcedure

        Dim compareDS As New DataSet
        Dim sqlDA As New SqlDataAdapter(cmd)
        sqlDA.Fill(compareDS)
        compareDS.Tables(0).PrimaryKey = New DataColumn() {compareDS.Tables(0).Columns("BankRegisterId")}

        Return compareDS
    End Function
#End Region

#Region "Utilities"
    Private Sub PopulateBofADictionary()
        columnDict.Clear()
        columnDict.Add("As Of", GetType(DateTime))
        columnDict.Add("Data Type", GetType(String))
        columnDict.Add("BAI Code", GetType(Integer))
        columnDict.Add("Description", GetType(String))
        columnDict.Add("Amount", GetType(Double))
        columnDict.Add("Customer Reference", GetType(Integer))
    End Sub
    Private Sub PopulateBBTDictionary()
        columnDict.Clear()
        columnDict.Add("DR/CR", GetType(String))
        columnDict.Add("BAITRNCODE", GetType(Integer))
        columnDict.Add("Description", GetType(String))
        columnDict.Add("POSTEDDTTM", GetType(DateTime))
        columnDict.Add(Me.FileName.Replace(".", "#") & ".Amount", GetType(Double))
        columnDict.Add("Customer Reference", GetType(Nullable(Of Integer)))
    End Sub

    Private Sub LoadTabStrips()
        tsReconcile.TabPages.Clear()

        If hdnRecordCount.Value <> "" And hdnRecordCount.Value <> "0" Then
            tsReconcile.TabPages.Add(New Slf.Dms.Controls.TabPage("Cleared&nbsp;Checks&nbsp;Report&nbsp;&nbsp;<font color='blue'>(" & hdnRecordCount.Value.ToString() & ")</font>", phClearedReport.ClientID))
        Else
            tsReconcile.TabPages.Add(New Slf.Dms.Controls.TabPage("Cleared&nbsp;Checks&nbsp;Report", phClearedReport.ClientID))
        End If

        If hdnReportCount.Value <> "" And hdnReportCount.Value <> "0" Then
            tsReconcile.TabPages.Add(New Slf.Dms.Controls.TabPage("Exception&nbsp;Report&nbsp;For&nbsp;Firm&nbsp;Register&nbsp;&nbsp;<font color='blue'>(" & hdnReportCount.Value.ToString() & ")</font>", phFirmReport.ClientID))
        Else
            tsReconcile.TabPages.Add(New Slf.Dms.Controls.TabPage("Exception&nbsp;Report&nbsp;For&nbsp;Firm&nbsp;Register", phFirmReport.ClientID))
        End If

        If hdnExceptionCount.Value <> "" And hdnExceptionCount.Value <> "0" Then
            tsReconcile.TabPages.Add(New Slf.Dms.Controls.TabPage("Exception&nbsp;Report&nbsp;For&nbsp;Bank&nbsp;Statement&nbsp;&nbsp;<font color='blue'>(" & hdnExceptionCount.Value.ToString() & ")</font>", phBankReport.ClientID))
        Else
            tsReconcile.TabPages.Add(New Slf.Dms.Controls.TabPage("Exception&nbsp;Report&nbsp;For&nbsp;Bank&nbsp;Statement", phBankReport.ClientID))
        End If

    End Sub
    Private Function GetUploadedFilePath(ByVal filePath As String) As String

        Dim fName As String = Path.GetFileNameWithoutExtension(filePath)
        Dim extension As String = Path.GetExtension(filePath)

        Dim brFolder As String = System.Configuration.ConfigurationManager.AppSettings("BRDirectory")
        If Directory.Exists(brFolder & "\" & System.Web.HttpContext.Current.Session.SessionID) = False Then
            Directory.CreateDirectory(brFolder & "\" & System.Web.HttpContext.Current.Session.SessionID)
        End If
        brFolder += "\" & System.Web.HttpContext.Current.Session.SessionID & "\"
        Dim randomNumber As New Random(1)

        Dim sFileName As String = brFolder & fName.Replace(".", "_") & randomNumber.Next() & "_BR" & extension

        If File.Exists(sFileName) Then
            File.Delete(sFileName)
        End If

        Return sFileName
    End Function
    Private Function FileIsOpen(ByVal path As String) As Boolean
        Dim fsFile As FileStream

        Try
            fsFile = New FileStream(path, FileMode.Open)
        Catch ex As System.IO.IOException
            Return False
        End Try

        fsFile.Close()
        fsFile.Dispose()

        Return True
    End Function
    Private Function CreateDataTable(ByVal columnNames() As String, ByVal tableName As String) As DataTable
        Dim dTable As New DataTable(tableName)

        For Each name In columnNames
            dTable.Columns.Add(New DataColumn(name))
        Next

        Return dTable
    End Function
    Private Sub AssignFileName()
        Dim paths = hdnFilePath.Value.Split("\")
        Dim pathcount As Integer = paths.Length
        Dim iRemove As String = hdnFilePath.Value.IndexOf(paths(pathcount - 1))
        Me.DirectoryPath = hdnFilePath.Value.Remove(iRemove, paths(pathcount - 1).Length)
        Me.FileName = paths(pathcount - 1)
    End Sub
    Private Sub UpdateExceptionAmount()
        Dim amount As Double = 0
        For Each row As DataRow In dsMaster.Tables("BankRegister").Rows
            If Not CBool(row("Rejected")) Then
                amount += IIf(row("DataType").ToString().ToLower().Equals("debits"), (CDbl(row("Amount")) * -1), CDbl(row("Amount")))
            End If
        Next

        hdnExceptionAmount.Value = amount
    End Sub
#End Region


End Class
