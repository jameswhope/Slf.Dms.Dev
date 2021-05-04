Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Services

Partial Class billing_Invoice
    Inherits System.Web.UI.Page

#Region "Fields"

    Private _Action As String
    Private _InvoiceId As String
    Private _InvoiceTotal As Double

#End Region 'Fields

#Region "Properties"

    Public Property Action() As String
        Set(value As String)
            _Action = value
        End Set
        Get
            If String.IsNullOrEmpty(_Action) Then
                _Action = "add"
            End If
            Return _Action
        End Get
    End Property

    Public Property InvoiceID() As String
        Set(value As String)
            _InvoiceId = value
        End Set
        Get
            If String.IsNullOrEmpty(_InvoiceId) Then
                _InvoiceId = -1
            End If
            Return _InvoiceId
        End Get
    End Property

#End Region 'Properties

#Region "Methods"
    <WebMethod()> _
    Public Shared Function SaveInvoice(invoiceid As String, _
                                       name As String, _
                                       descr As String, _
                                       customerid As String, _
                                       statusid As String, _
                                       invdate As String, _
                                       duedate As String, _
                                       msg As String, _
                                       memo As String, _
                                       printinvoice As String, _
                                       sendinvoice As String) As String

        Dim result As String = "SaveInvoice"
        If String.IsNullOrEmpty(customerid) Then
            Return "You must select a customer!"
        End If
        If String.IsNullOrEmpty(statusid) Then
            statusid = 1
        End If

        Try

            Dim ssql As String = "stp_billing_InsertUpdateInvoice"
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("BillingInvoiceID", invoiceid))
            params.Add(New SqlParameter("Name", HttpUtility.UrlDecode(name)))
            params.Add(New SqlParameter("Description", HttpUtility.UrlDecode(descr)))
            params.Add(New SqlParameter("CustomerID", customerid))
            params.Add(New SqlParameter("StatusID", statusid))
            params.Add(New SqlParameter("DueDate", duedate))
            params.Add(New SqlParameter("PrintInvoice", printinvoice))
            params.Add(New SqlParameter("SendInvoice", sendinvoice))
            params.Add(New SqlParameter("Message", HttpUtility.UrlDecode(msg)))
            params.Add(New SqlParameter("Memo", HttpUtility.UrlDecode(memo)))
            params.Add(New SqlParameter("userid", HttpContext.Current.User.Identity.Name))
            SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
            result = "Invoice Saved!"
        Catch ex As Exception
            Return ex.Message.ToString
        End Try
        Return result
    End Function
    <WebMethod()> _
    Public Shared Function PrintInvoice(invoiceid As String, boolpreview As String) As String

        Dim result As String = "PrintInvoice"
        
        Try
            Dim bPreview As Boolean = CBool(boolpreview)
            result += " " & bPreview

        Catch ex As Exception
            Return ex.Message.ToString
        End Try
        Return result
    End Function
    <WebMethod()> _
    Public Shared Function SendInvoice(invoiceid As String, customerid As String) As String

        Dim result As String = "SendInvoice"

        Try

        Catch ex As Exception
            Return ex.Message.ToString
        End Try
        Return result
    End Function
    <WebMethod()> _
    Public Shared Function GetCampaignPrice(campaignid As String) As String
        Dim result As String = "0.00"
        Try
            Dim ssql As String = String.Format("SELECT cost from vw_Campaigns where CampaignID={0}", campaignid)
            result = SqlHelper.ExecuteScalar(ssql, CommandType.Text)
            result = FormatNumber(result, 2)

        Catch ex As Exception
            Return ex.Message.ToString
        End Try

        Return result
    End Function
    <WebMethod()> _
    Public Shared Function DeleteLineItem(lineid As String) As String
        Dim result As String = ""
        Try
            Dim ssql As String = "stp_billing_DeleteInvoiceLine"
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("BillingInvoiceLineID", lineid))
            params.Add(New SqlParameter("userid", HttpContext.Current.User.Identity.Name))
            SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
            result = "Line Item Deleted!"
        Catch ex As Exception
            Return ex.Message.ToString
        End Try
        Return result
    End Function
    <WebMethod()> _
    Public Shared Function InsertUpdateInvoiceLine(invoiceid As String, billinginvoicelineid As String, campaignid As String, _
                                               description As String, notes As String, quantity As String, price As String, _
                                               total As String) As String
        Dim result As String = "InsertUpdateInvoiceLine"
        Try
            If String.IsNullOrEmpty(invoiceid) Then
                invoiceid = -1
            End If
            If String.IsNullOrEmpty(campaignid) Then
                campaignid = -1
            End If
            Dim ssql As String = "stp_billing_InsertUpdateInvoiceLine"
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("BillingInvoiceID", invoiceid))
            params.Add(New SqlParameter("BillingInvoiceLineID", billinginvoicelineid))
            params.Add(New SqlParameter("campaignid", campaignid))
            params.Add(New SqlParameter("description", description))
            params.Add(New SqlParameter("notes", notes))
            params.Add(New SqlParameter("quantity", Integer.Parse(quantity)))
            params.Add(New SqlParameter("price", Double.Parse(price.Replace("$", ""))))
            params.Add(New SqlParameter("userid", HttpContext.Current.User.Identity.Name))

            If invoiceid = -1 Then
                Return "You must create and save an invoice first before creating line items!"
            End If
            If campaignid = -1 Then
                Return "You must create and save an invoice first before creating line items!"
            End If

            SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
            result = "Line Item Added!"
        Catch ex As Exception
            Return ex.Message.ToString
        End Try

        Return result
    End Function

    Public Sub ShowMsg(msgtext As String, Optional msgType As String = "warning", Optional bSticky As Boolean = False)
        ClientScript.RegisterStartupScript(Me.GetType, "loadmsg", String.Format("showToast('{0}','{1}',{2});", msgtext, msgType, bSticky.ToString.ToLower), True)
    End Sub

    Protected Sub billing_CreateInvoice_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not IsNothing(Request.QueryString("invid")) Then
            InvoiceID = Request.QueryString("invid")
        End If
        If Not IsNothing(Request.QueryString("t")) Then
            Action = Request.QueryString("t")
        End If

        Dim mtext As String = String.Format("<div class=""info"">{0} : invoice ID {1}</div>", Action, InvoiceID)

        If Not IsPostBack Then
            loadInvoice()

            bindData()
        End If
    End Sub

    Protected Sub btnRefresh_Click(sender As Object, e As System.EventArgs) Handles btnRefresh.Click
        _InvoiceTotal = "0"
        gvInvoices.DataBind()
    End Sub

    Protected Sub ddlCustomers_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles ddlCustomers.SelectedIndexChanged
        Dim custID As String = ddlCustomers.SelectedItem.Value
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("customerid", custID))
        Using dtCust As DataTable = SqlHelper.GetDataTable("stp_billing_getCustomerBillTo", CommandType.StoredProcedure, params.ToArray)
            For Each dr As DataRow In dtCust.Rows
                txtBilling.Text = IIf(IsDBNull(dr("fullname")), "", String.Format("ATTN: {0}", dr("fullname").ToString)) & vbCrLf
                txtBilling.Text += IIf(IsDBNull(dr("street")), "", String.Format("{0}", dr("street").ToString)) & vbCrLf
                txtBilling.Text += IIf(IsDBNull(dr("City")), "", String.Format("{0}, {1} {2}", dr("City").ToString, dr("state").ToString, dr("zip").ToString)) & vbCrLf
            Next
        End Using
        gvInvoices.DataBind()
    End Sub

    Protected Sub ddlTerms_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles ddlTerms.SelectedIndexChanged
        Dim val As String = ddlTerms.SelectedValue
        txtDueDate.Text = FormatDateTime(Now.AddDays(val), vbShortDate)
        bindData()
    End Sub
    
    Protected Sub gvInvoices_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvInvoices.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim rowview As DataRowView = TryCast(e.Row.DataItem, DataRowView)
                _InvoiceTotal += Double.Parse(rowview("total").ToString)

                Dim lineId As String = rowview("BillingInvoiceLineID").ToString
                If lineId = -1 Then
                    e.Row.Visible = False
                End If

                Using txt As TextBox = TryCast(e.Row.FindControl("txtQuantity"), TextBox)
                    txt.Attributes.Add("onblur", "return CalcLineTotal(this,true);")
                End Using
                Using txt As TextBox = TryCast(e.Row.FindControl("txtPrice"), TextBox)
                    txt.Attributes.Add("onblur", "return CalcLineTotal(this,true);")
                End Using


                Using lnk As LinkButton = TryCast(e.Row.FindControl("btnSave"), LinkButton)
                    lnk.OnClientClick = String.Format("return updateRowData({0},this);", lineId)
                End Using
                Using lnk As LinkButton = TryCast(e.Row.FindControl("btnDelete"), LinkButton)
                    Select Case lineId
                        Case -1
                            lnk.Visible = False
                        Case Else
                            lnk.OnClientClick = String.Format("return DeleteRowData({0});", lineId.ToString)
                    End Select

                End Using

                Using ddl As DropDownList = TryCast(e.Row.FindControl("ddlCampaigns"), DropDownList)
                    ddl.Attributes.Add("onchange", "return getCampaignPrice(this);")
                End Using

            Case DataControlRowType.Footer
                Dim tbl As Table = e.Row.Parent
                Dim row As New GridViewRow(-1, -1, DataControlRowType.DataRow, DataControlRowState.Normal)
                row.CssClass = "ui-state-highlight ui-corner-all"
                row.Style("font-size") = "16pt"
                row.Style("font-weight") = "bold"

                Dim totCellText As New TableCell
                totCellText.ColumnSpan = 5
                totCellText.HorizontalAlign = HorizontalAlign.Right
                totCellText.Text = "TOTAL"
                row.Cells.Add(totCellText)

                Dim totCell As New TableCell
                totCell.HorizontalAlign = HorizontalAlign.Right
                totCell.Text = FormatCurrency(_InvoiceTotal, 2)
                row.Cells.Add(totCell)

                totCell = New TableCell
                totCell.HorizontalAlign = HorizontalAlign.Right
                totCell.Text = ""
                row.Cells.Add(totCell)

                tbl.Rows.AddAt(tbl.Rows.Count, row)

                Using ddl As DropDownList = TryCast(e.Row.FindControl("ddlCampaigns"), DropDownList)
                    ddl.Attributes.Add("onchange", "return getCampaignPrice(this);")
                End Using
                Using txt As TextBox = TryCast(e.Row.FindControl("txtQuantity"), TextBox)
                    txt.Attributes.Add("onblur", "return CalcLineTotal(this,true);")
                End Using
                Using lnk As LinkButton = TryCast(e.Row.FindControl("btnSave"), LinkButton)
                    lnk.OnClientClick = String.Format("return updateRowData(-1,this);")
                End Using
        End Select
    End Sub

    Private Sub LoadBillTo(ByVal custID As String)
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("customerid", custID))
        Using dtCust As DataTable = SqlHelper.GetDataTable("stp_billing_getCustomerBillTo", CommandType.StoredProcedure, params.ToArray)
            For Each dr As DataRow In dtCust.Rows
                txtBilling.Text = String.Format("ATTN: {0}", dr("fullname").ToString) & vbCrLf
                txtBilling.Text += String.Format("{0}", dr("street").ToString) & vbCrLf
                txtBilling.Text += String.Format("{0}, {1} {2}", dr("City").ToString, dr("state").ToString, dr("zip").ToString) & vbCrLf
            Next
        End Using
    End Sub

    Private Sub LoadCustomers()
        Using dt As DataTable = SqlHelper.GetDataTable("stp_billing_getCustomers", CommandType.Text)
            For Each dr As DataRow In dt.Rows
                Dim li As New ListItem(dr("Customer").ToString, dr("CustomerID").ToString)
                ddlCustomers.Items.Add(li)
            Next
        End Using
    End Sub

    Private Sub LoadInvoiceTerms(ByVal sDueDate As String, ByVal sInvDate As String)
        Dim iDiff As Integer = DateDiff(DateInterval.Day, CDate(sInvDate), CDate(sDueDate))
        Select Case iDiff
            Case 30
                ddlTerms.SelectedValue = 30
            Case 15
                ddlTerms.SelectedValue = 15
            Case 0
                ddlTerms.SelectedValue = 0
            Case Else
                ddlTerms.SelectedValue = -1
        End Select

        If sDueDate < Now Then
            txtDueDate.BackColor = System.Drawing.Color.LightSalmon
            ShowMsg("Late Invoice", "warning", True)
        End If

    End Sub

    Private Sub bindData()
        dsInvoices.SelectParameters("invoiceId").DefaultValue = _InvoiceId
        dsInvoices.DataBind()
        gvInvoices.DataBind()
    End Sub

    Private Sub loadInvoice()
        Select Case InvoiceID
            Case -1
                txtInvoiceDate.Text = FormatDateTime(Now, vbShortDate)
                ddlTerms.SelectedValue = 0
                txtDueDate.Text = FormatDateTime(Now, vbShortDate)
                ShowMsg("Create New Invoice!", "notice", False)
            Case Else
                Dim custID As String = String.Empty
                Dim params As New List(Of SqlParameter)
                params.Add(New SqlParameter("invoiceid", InvoiceID))
                Using dt As DataTable = SqlHelper.GetDataTable("stp_billing_getInvoice", CommandType.StoredProcedure, params.ToArray)
                    For Each dr As DataRow In dt.Rows
                        Dim sDueDate As String = FormatDateTime(CDate(dr("duedate").ToString), vbShortDate)
                        Dim sInvDate As String = FormatDateTime(CDate(dr("created").ToString), vbShortDate)
                        custID = dr("customerid").ToString

                        chkToBePrinted.Checked = dr("printinvoice").ToString
                        chkToBeSent.Checked = dr("Sendinvoice").ToString

                        If String.IsNullOrEmpty(txtInvoiceDate.Text) Then
                            txtInvoiceDate.Text = sInvDate
                        End If
                        If String.IsNullOrEmpty(txtDueDate.Text) Then
                            txtDueDate.Text = sDueDate
                        End If

                        txtInvName.Text = dr("name").ToString
                        txtInvDescr.Text = dr("description").ToString

                        LoadInvoiceTerms(sDueDate, sInvDate)

                        ddlStatus.SelectedValue = dr("StatusID").ToString
                        ddlCustomers.SelectedValue = custID

                        txtCustomerMsg.Text = dr("message").ToString
                        txtMemo.Text = dr("memo").ToString

                    Next

                End Using
                ddlCustomers.Enabled = False
                LoadBillTo(custID)
                'ShowMsg("Invoice Loaded!", "success", False)
        End Select
    End Sub

#End Region 'Methods

End Class