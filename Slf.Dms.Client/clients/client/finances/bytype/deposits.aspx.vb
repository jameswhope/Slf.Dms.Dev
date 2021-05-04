Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic
Imports iTextSharp.text.pdf
Imports iTextSharp.text
Imports System.IO


Partial Class clients_client_finances_bytype_deposits
    Inherits System.Web.UI.Page
    Public chapterFont As iTextSharp.text.Font = FontFactory.GetFont(FontFactory.HELVETICA, 12, iTextSharp.text.Font.BOLDITALIC)
    Public fntNormalText As iTextSharp.text.Font = FontFactory.GetFont(FontFactory.HELVETICA, 8, iTextSharp.text.Font.NORMAL)
    Public sectionFont As iTextSharp.text.Font = FontFactory.GetFont(FontFactory.HELVETICA, 10, iTextSharp.text.Font.BOLDITALIC)
    Public subsectionFont As iTextSharp.text.Font = FontFactory.GetFont(FontFactory.HELVETICA, 9, iTextSharp.text.Font.NORMAL)
    Public bf As BaseFont = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED)
    Private Const INT_newTableWidth As Integer = 100
    Private Const INT_newTablePadding As Integer = 2
#Region "Variables"

    Private UserID As Integer
    Public Shadows ClientID As Integer
    Private qs As QueryStringCollection
    Private total As Decimal

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            ClientID = DataHelper.Nz_int(qs("id"), 0)

            LoadTabStrips()

            If Not IsPostBack Then

                Requery()

                Dim cName As String = ClientHelper.GetDefaultPersonName(ClientID)
                lnkClient.InnerText = cName
                lnkClient.HRef = "~/clients/client/?id=" & ClientID

            End If

            SetRollups()

        End If

    End Sub
    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = Master.CommonTasks
        If Master.UserEdit Then
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href="""" onclick=""Record_AddTransaction();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_transaction.png") & """ align=""absmiddle""/>Add transaction</a>")
        End If
    End Sub
    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

        tsMain.TabPages(1).Selected = True

    End Sub
    Private Sub LoadTabStrips()

        tsMain.TabPages.Clear()

        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("<span id=""tabCaption0"">Payments</span>", dvPanel0.ClientID, "./?id=" & ClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("<span id=""tabCaption1"">Deposits</span>", dvPanel0.ClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("<span id=""tabCaption2"">Credits</span>", dvPanel0.ClientID, "credits.aspx?id=" & ClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("<span id=""tabCaption3"">Fees&nbsp;Assessed</span>", dvPanel0.ClientID, "feesassessed.aspx?id=" & ClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("<span id=""tabCaption4"">Fee&nbsp;Adjustments</span>", dvPanel0.ClientID, "feeadjustments.aspx?id=" & ClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("<span id=""tabCaption5"">Debits</span>", dvPanel0.ClientID, "debits.aspx?id=" & ClientID))

    End Sub
    Private Sub Requery()

        dsDeposits.SelectParameters("clientid").DefaultValue = ClientID
        dsDeposits.DataBind()
        gvDeposits.DataBind()

    End Sub
    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""idonly""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function

    Protected Sub gvDeposits_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDeposits.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                GridViewHelper.AddSortImage(sender, e)
        End Select
    End Sub

    Protected Sub gvDeposits_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDeposits.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#D6E7F3';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")

        End Select

        If e.Row.RowType = DataControlRowType.DataRow And e.Row.DataItem IsNot Nothing Then
            If IsDBNull(DataBinder.Eval(e.Row.DataItem, "Void")) And IsDBNull(DataBinder.Eval(e.Row.DataItem, "Bounce")) Then
                total += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "Amount"))
            End If
        End If
        lblAmount.Text = Decimal.Round(total, 2).ToString("C")
    End Sub

   
   
    Private Function BuildPdf_FromDataTable(ByVal titleText As String, _
                                            ByVal dt As DataTable, _
                                            ByVal ListOfColumns As List(Of String), _
                                            Optional ByVal ColumnWidths As Single() = Nothing) As String
        Dim pdfFilePath As String = String.Format("{0}\ClientDocs\{1}_Deposits.pdf", SharedFunctions.DocumentAttachment.CreateDirForClient(ClientID), Format(Now, "yyyy_MM_dd"))

        Dim doc As iTextSharp.text.Document = Nothing
        Dim writer As PdfWriter = Nothing
        Try

            doc = New iTextSharp.text.Document()
            writer = PdfWriter.GetInstance(doc, New FileStream(pdfFilePath, FileMode.Create))

            Dim header As New HeaderFooter(New Phrase(titleText, New iTextSharp.text.Font(iTextSharp.text.Font.HELVETICA, 18, iTextSharp.text.Font.BOLDITALIC)), False)
            header.Border = iTextSharp.text.Rectangle.NO_BORDER
            header.Alignment = Element.ALIGN_JUSTIFIED
            doc.Header = header
            doc.Open()

            Dim table As New Table(9) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = INT_newTablePadding, .Width = INT_newTableWidth, .CellsFitPage = True}

            ' set *column* widths
            If Not IsNothing(ColumnWidths) Then
                table.Widths = ColumnWidths
            End If

            Using dtDataToUse As DataTable = dt
                ' create the *table* header row
                For i As Integer = 0 To dtDataToUse.Columns.Count - 1
                    Dim colName As String = dtDataToUse.Columns(i).ColumnName
                    If ListOfColumns.Contains(colName) Then
                        Dim cell As New Cell(New Phrase(colName, fntNormalText))
                        cell.Header = True
                        cell.HorizontalAlignment = Element.ALIGN_CENTER
                        cell.BackgroundColor = New iTextSharp.text.Color(255, 255, 255)
                        table.AddCell(cell)
                    End If

                Next
                table.EndHeaders()

                For Each dr As DataRow In dtDataToUse.Rows
                    For Each col As DataColumn In dtDataToUse.Columns
                        Dim colName As String = col.ColumnName
                        Dim colVal As String = dr(colName).ToString
                        If ListOfColumns.Contains(colName) Then

                            Select Case colName.ToLower
                                Case "TransactionDate".ToLower
                                    colVal = FormatDateTime(colVal, DateFormat.ShortDate)
                                Case "isfullypaid".ToLower
                                    colVal = IIf(colVal = "True", "YES", "NO")
                                Case "bounce".ToLower, "void".ToLower, "hold".ToLower
                                    colVal = IIf(IsDBNull(dr(colName)), "NO", "YES")
                                Case "clear".ToLower
                                    colVal = IIf(IsDBNull(dr(colName)), "YES", "NO")
                                Case "Amount".ToLower
                                    colVal = FormatCurrency(colVal, 2)
                            End Select
                            Dim cell As New Cell(New Phrase(colVal, fntNormalText))
                            cell.HorizontalAlignment = Element.ALIGN_CENTER
                            table.AddCell(cell)
                        End If
                    Next
                Next
            End Using
            doc.Add(table)

            doc.NewPage()
            doc.Close()
        Catch ex As Exception

        Finally
            If doc IsNot Nothing Then
                doc.Close()
            End If
            writer = Nothing
        End Try
        Return pdfFilePath
    End Function
    Protected Sub lnkPrint_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles lnkPrint.Click
        Dim colList As New List(Of String)("TransactionDate,CheckNumber,Amount,IsFullyPaid,Void,Bounce,Hold,Clear,ImportID".Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries))
        Dim c = New Single() {0.12, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1}
        Dim clientDepFileName As String = BuildPdf_FromDataTable(String.Format("{0} - Deposits As Of {1}", lnkClient.InnerText, Now.ToString), TryCast(dsDeposits.Select(DataSourceSelectArguments.Empty), DataView).ToTable, colList, c)

        Page.ClientScript.RegisterClientScriptBlock(Me.GetType, "test", String.Format("window.open('\\{0}');", clientDepFileName.Replace("\\", "\").Replace("/", "\").Replace("\", "\\")), True)


    End Sub
End Class
