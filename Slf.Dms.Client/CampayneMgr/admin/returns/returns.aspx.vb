Imports System.Data
Imports System.Data.OleDb
Imports System.Data.SqlClient
Imports System.IO

Imports ReturnsHelper

Partial Class admin_returns
    Inherits System.Web.UI.Page

#Region "Fields"

    Private _buyers As New Dictionary(Of Integer, String)
    Private _userid As Integer

#End Region 'Fields

#Region "Properties"

    Public Property Buyers() As Dictionary(Of Integer, String)
        Get
            If IsNothing(ViewState("_buyers")) Then
                ViewState("_buyers") = New Dictionary(Of Integer, String)
            End If

            Return ViewState("_buyers")
        End Get
        Set(ByVal value As Dictionary(Of Integer, String))
            ViewState("_buyers") = value
        End Set
    End Property

    Public Property CurrentFilePath() As String
        Get
            Return ViewState("_CurrentFilePath")
        End Get
        Set(ByVal value As String)
            ViewState("_CurrentFilePath") = value
        End Set
    End Property

    Public Property Userid() As Integer
        Get
            Return _userid
        End Get
        Set(ByVal value As Integer)
            _userid = value
        End Set
    End Property

#End Region 'Properties

#Region "Methods"

    Protected Sub PageIndexChanging(ByVal sender As Object, ByVal e As GridViewPageEventArgs)
        Dim FolderPath As String = ConfigurationManager.AppSettings("AdminDocumentPath")
        Dim Extension As String = Path.GetExtension(CurrentFilePath)
        If IsNothing(ViewState("gvDataSource")) Then
            Import_To_Grid(CurrentFilePath, Extension)
        Else
            gvReturns.DataSource = ViewState("gvDataSource")
        End If

        gvReturns.PageIndex = e.NewPageIndex
        gvReturns.DataBind()
    End Sub

    Protected Sub admin_returns_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Userid = CInt(Page.User.Identity.Name)
        If Not IsPostBack Then
            ViewState("gvDataSource") = Nothing
            ViewState("ReturnSort") = "asc"
            pnlBuyer.Style("display") = "block"
            pnlUpload.Style("display") = "none"
            pnlProcess.Style("display") = "none"
            BindBuyers()
        End If
    End Sub

    Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        ViewState("gvDataSource") = Nothing
        Dim FolderPath As String = ConfigurationManager.AppSettings("AdminDocumentPath")
        Dim Extension As String = Path.GetExtension(CurrentFilePath)
        Import_To_Grid(CurrentFilePath, Extension)
    End Sub

    Protected Sub btnReset_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnReset.Click
        ViewState("gvDataSource") = Nothing
        CurrentFilePath = ""
        hdnFile.Value = ""
        Response.Redirect("returns.aspx")
    End Sub

    Protected Sub btnUpload_Click(ByVal sender As Object, ByVal e As EventArgs)
        If fuReturns.HasFile Then
            Dim FileName As String = Path.GetFileName(fuReturns.PostedFile.FileName)
            Dim Extension As String = Path.GetExtension(fuReturns.PostedFile.FileName)
            Dim FolderPath As String = ConfigurationManager.AppSettings("AdminDocumentPath")
            CurrentFilePath = FolderPath + FileName
            If Not IO.File.Exists(CurrentFilePath) Then
                hdnFile.Value = CurrentFilePath
                fuReturns.SaveAs(CurrentFilePath)
                Import_To_Grid(CurrentFilePath, Extension)
            Else
                'file exists already
                ShowToastFromCodeBehind(String.Format("A file with the same name as {0} already exists.  Try another filename please!", FileName))
            End If

        End If
    End Sub

    Protected Sub gvReturns_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvReturns.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                Dim tc As New TableCell
                tc.Wrap = False
                tc.Text = "Our Lead ID"
                e.Row.Cells.Add(tc)

                tc = New TableCell
                tc.Wrap = False
                tc.Text = "Returned Date"
                e.Row.Cells.Add(tc)

            Case DataControlRowType.DataRow
                Dim bDoNothing = False
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)

                Try
                    Dim buyerid As Integer = rblBuyer.SelectedItem.Value
                    Dim ssql As String = "stp_returns_FindLead"
                    Dim ddl As DropDownList = TryCast(e.Row.FindControl("ddlReturns"), DropDownList)
                    Dim leadid As String = Nothing
                    Dim leadStatus As String = Nothing
                    Dim returnStatus As String = ""
                    Dim first As String = Nothing
                    Dim last As String = Nothing
                    Dim phone As String = Nothing
                    Dim email As String = Nothing

                    Select Case buyerid
                        Case 521
                            leadStatus = rowView(3)
                            If Not IsDBNull(rowView(0)) Then
                                first = rowView(0)
                            End If
                            If Not IsDBNull(rowView(1)) Then
                                last = rowView(1)
                            End If
                            If Not IsDBNull(rowView(4)) Then
                                phone = rowView(4)
                            End If
                        Case 501
                            leadStatus = rowView(1)
                            If Not IsDBNull(rowView(5)) Then
                                phone = rowView(5)
                            End If

                        Case 515
                            leadStatus = rowView(4)
                            If Not IsDBNull(rowView(2)) Then
                                email = rowView(2)
                            End If
                            If Not IsDBNull(rowView(3)) Then
                                phone = rowView(3)
                            End If
                        Case 524
                            leadStatus = rowView(1).ToString
                            Dim sname As String() = rowView(0).ToString.Split(New Char() {" "}, StringSplitOptions.RemoveEmptyEntries)
                            If sname.GetUpperBound(0) >= 1 Then
                                first = sname(0)
                                last = sname(1)
                            End If

                        Case 528
                            leadStatus = rowView(4).ToString
                            If Not IsDBNull(rowView(1)) Then
                                first = rowView(1).ToString
                            End If
                            If Not IsDBNull(rowView(2)) Then
                                last = rowView(2).ToString
                            End If
                            If Not IsDBNull(rowView(3)) Then
                                email = rowView(3).ToString
                            End If
                        Case Else
                            bDoNothing = True
                    End Select

                    If Not bDoNothing Then
                        'find leadid
                        Dim params As New List(Of SqlParameter)
                        params.Add(New SqlParameter("first", IIf(String.IsNullOrEmpty(first), DBNull.Value, first)))
                        params.Add(New SqlParameter("last", IIf(String.IsNullOrEmpty(last), DBNull.Value, last)))
                        params.Add(New SqlParameter("phone", IIf(String.IsNullOrEmpty(phone), DBNull.Value, phone)))
                        params.Add(New SqlParameter("email", IIf(String.IsNullOrEmpty(email), DBNull.Value, email)))
                        leadid = SqlHelper.ExecuteScalar(ssql, CommandType.StoredProcedure, params.ToArray)
                        If String.IsNullOrEmpty(leadid) Then
                            leadid = "LEAD NOT FOUND"
                        End If

                        Dim leadTag As String = String.Format("{0}:{1}", leadid, leadStatus)
                        Dim hdn As HiddenField = e.Row.FindControl("hdnLeadID")
                        If Not IsNothing(hdn) Then
                            hdn.Value = leadTag
                        End If

                        Dim tc As New TableCell
                        Dim lbl As New Label
                        lbl.Text = leadid
                        lbl.CssClass = "leadClass"
                        lbl.ID = String.Format("lblLead_{0}", leadid)
                        tc.Controls.Add(lbl)
                        e.Row.Cells.Add(tc)
                        e.Row.Attributes.Add("tag", leadTag)

                        tc = New TableCell
                        tc.Wrap = False
                        tc.CssClass = "tdReturnDate"
                        If IsNumeric(leadid) Then
                            tc.Controls.Add(New LiteralControl("Finding Return...<img src=""../../images/ajax-loader.gif"" alt=""loading..."" height=""20"" width=""20"" />"))
                        End If
                        e.Row.Cells.Add(tc)

                        e.Row.Cells(1).Wrap = False
                    End If
                Catch ex As Exception
                    pnlProcess.GroupingText = "This doesn't appear to be the correct file for this buyer!!!"
                End Try

            Case DataControlRowType.Footer, DataControlRowType.Pager
                Dim tc As New TableCell
                tc.Text = ""
                e.Row.Cells.Add(tc)

                tc = New TableCell
                tc.Text = ""
                e.Row.Cells.Add(tc)

        End Select
    End Sub

    Protected Sub gvReturns_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvReturns.Sorting
        Dim FolderPath As String = ConfigurationManager.AppSettings("AdminDocumentPath")
        Dim Extension As String = Path.GetExtension(CurrentFilePath)

        If IsNothing(ViewState("gvDataSource")) Then
            Import_To_Grid(CurrentFilePath, Extension)
        Else
            Using dt As DataTable = TryCast(ViewState("gvDataSource"), DataTable)
                dt.DefaultView.Sort = String.Format("{0} {1}", e.SortExpression, ViewState("ReturnSort").ToString)
                ViewState("gvDataSource") = dt
                gvReturns.DataSource = dt
                gvReturns.DataBind()
            End Using
        End If

        If ViewState("ReturnSort") = "asc" Then
            ViewState("ReturnSort") = "desc"
        Else
            ViewState("ReturnSort") = "asc"
        End If
    End Sub

    Protected Sub rblBuyer_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles rblBuyer.SelectedIndexChanged
        Dim bb As String() = Buyers.Item(rblBuyer.SelectedItem.Value).Split(";")
        divColumnOrder.InnerHtml = String.Format("<p><span class=""ui-icon ui-icon-info"" style=""float: left; margin-right: .3em;""></span><strong>Column Order :</strong> <i>{0}</i>.<p>", bb(1))

        pnlUpload.Style("display") = "block"
    End Sub

    Private Sub BindBuyers()
        Buyers.Add(528, "Accelerex;TimeIn,FirstName,LastName,Email,ValidationNote")
        Buyers.Add(524, "CollegeBound;Student Name,Status,Request Date")
        Buyers.Add(501, "1on1(CareerInstitute);DATE AND HOUR,DISPOSITION,TALK TIME,AGENT,TIME,ANI,DNIS")
        Buyers.Add(521, "myFootPath;FirstName,LastName,LeadID,Status,PhoneNumber")
        Buyers.Add(515, "Platform;LeadID,AffiliateTrackingCode,Email,Phone,InvalidReasonCode")
        'Buyers.Add(523, "TotalAttorneys;LeadID,AffiliateTrackingCode,Email,Phone,InvalidReasonCode")

        For Each buyer As KeyValuePair(Of Integer, String) In buyers
            Dim bb As String() = buyer.Value.Split(New Char() {";"}, StringSplitOptions.RemoveEmptyEntries)
            rblBuyer.Items.Add(New ListItem(String.Format("<span><b>{0}</b></span>", bb(0)), buyer.Key))
        Next
    End Sub

    Private Sub Import_To_Grid(ByVal FilePath As String, ByVal Extension As String, Optional ByVal sortColumn As String = Nothing)
        Dim bb As String() = Buyers(rblBuyer.SelectedValue).Split(New Char() {";"}, StringSplitOptions.RemoveEmptyEntries)
        Dim buyerSheetColumns As String() = Nothing
        buyerSheetColumns = bb(1).Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)

        Dim conStr As String = ""
        Select Case Extension
            Case ".xls"
                'Excel 97-03
                conStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties=""Excel 12.0;HDR=YES"";"
                Exit Select
            Case ".xlsx"
                'Excel 07
                conStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties=""Excel 12.0 Xml;HDR=YES;IMEX=1"";"
                Exit Select
        End Select
        conStr = [String].Format(conStr, FilePath, 1)
        Dim connExcel As New OleDbConnection(conStr)
        Dim cmdExcel As New OleDbCommand()
        Dim oda As New OleDbDataAdapter()
        Dim dt As New DataTable()
        cmdExcel.Connection = connExcel
        connExcel.Open()
        Dim dtExcelSchema As DataTable
        dtExcelSchema = connExcel.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, Nothing)
        Dim SheetName As String = dtExcelSchema.Rows(0)("TABLE_NAME").ToString()
        connExcel.Close()
        Dim sheetNames As New List(Of String)

        If dtExcelSchema Is Nothing OrElse dtExcelSchema.Rows.Count = 0 Then
            Dim msg As String = "Could Not Determine File Worksheets"
        Else
            For Each drSheet As DataRow In dtExcelSchema.Rows
                'xlsx files put an extra table in the results called _xlnm#_FilterDatabase
                'xls files put an extra table in the results called <tablename>$_
                'Some printer formatting tables can show up.  Checking if a table ends w/ $ or $' seems to fix this
                If Not drSheet.Item("Table_Name").ToString() = "_xlnm#_FilterDatabase" AndAlso _
                Not drSheet.Item("Table_Name").ToString().EndsWith("_") AndAlso _
                (drSheet.Item("Table_Name").ToString().EndsWith("$") Or _
                drSheet.Item("Table_Name").ToString().EndsWith("$'")) Then
                    sheetNames.Add(drSheet.Item("Table_Name").ToString())
                End If

            Next
        End If

        Dim goodRows As DataTable = Nothing
        Dim bClone As Boolean = True

        For Each sh As String In sheetNames

            'Read Data from First Sheet
            connExcel.Open()
            'add sql string to seelct only the columns we need
            Dim ssql As String = ""
            Select Case rblBuyer.SelectedItem.Value
                Case 515
                    ssql = String.Format("SELECT LeadID, AffiliateTrackingCode,  Email, Phone,  InvalidReasonCode From [{0}]", sh)
                Case 528
                    ssql = String.Format("SELECT timein,  FirstName, LastName, Email ,  validationnote From [{0}]", sh)
                Case Else
                    ssql = String.Format("SELECT * From [{0}]", sh)
            End Select
            cmdExcel.CommandText = ssql
            oda.SelectCommand = cmdExcel
            oda.Fill(dt)
            connExcel.Close()
            If bClone Then
                goodRows = dt.Clone
            End If
            bClone = False

            For i As Integer = 0 To dt.Rows(0).ItemArray.GetUpperBound(0)
                For ib As Integer = 0 To buyerSheetColumns.Count - 1
                    Try
                        If buyerSheetColumns(ib).Replace(" ", "").ToLower = dt.Rows(0).ItemArray(i).Replace(" ", "").ToString.ToLower Then
                            goodRows.Columns(ib).ColumnName = dt.Rows(0).ItemArray(i).ToString
                            Exit For
                        End If
                    Catch ex As Exception
                        Continue For
                    End Try

                Next
            Next

            For Each dr As DataRow In dt.Rows
                Dim bValid As Boolean = True

                If bValid Then
                    Try
                        goodRows.Rows.Add(dr.ItemArray)
                    Catch ex As Exception
                        Continue For
                    End Try

                End If
            Next

        Next

        If IsNothing(ViewState("ReturnSort")) Then
            ViewState("ReturnSort") = "ASC"
        End If

        If Not IsNothing(sortColumn) Then
            goodRows.DefaultView.Sort = String.Format("{0} {1}", sortColumn, ViewState("ReturnSort").ToString)
        End If

        Dim bCorrectSheetForBuyer As Boolean = False
        For Each col As String In buyerSheetColumns
            If goodRows.Columns.Contains(col) Then
                bCorrectSheetForBuyer = True
            End If
        Next

        If bCorrectSheetForBuyer Then
            gvReturns.DataSource = goodRows.DefaultView 'goodRows
            gvReturns.DataBind()

            ViewState("gvDataSource") = TryCast(gvReturns.DataSource, DataView).ToTable

            pnlBuyer.Style("display") = "none"
            pnlUpload.Style("display") = "none"
            pnlProcess.Style("display") = "block"
            pnlProcess.GroupingText = String.Format("Process Return(s) for {0}", rblBuyer.SelectedItem.Text)
        Else
            ShowToastFromCodeBehind(String.Format("The selected file does not match {0} file format!", bb(0)))
            Try
                File.Delete(FilePath)
            Catch ex As Exception

            End Try
        End If
    End Sub

    Private Sub ShowToastFromCodeBehind(ByVal msgText As String, Optional msgType As String = "success", Optional bSticky As Boolean = False)
        Dim sb As New StringBuilder()
        sb.Append("$(function() { ")
        sb.AppendFormat("   showToast('{0}', '{1}',{2});", msgText, msgType, bSticky.ToString.ToLower)
        sb.Append("});")

        Dim sm As ScriptManager = ScriptManager.GetCurrent(Page)
        If sm.IsInAsyncPostBack Then
            ScriptManager.RegisterStartupScript(Page, Me.GetType, "myscript", sb.ToString(), True)
        End If
    End Sub

#End Region 'Methods



End Class