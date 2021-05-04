Imports System.Web.Services
Imports System.Data.SqlClient
Imports System.Data

Partial Class billing_payments
    Inherits System.Web.UI.Page
    <WebMethod()> _
    Public Shared Function FindCustomer(invoiceid As String) As String
        Dim result As New List(Of String)

        Try

            Dim ssql As String = String.Format("select customerid,[amt]=(select sum(Quantity * Price) from tblBilling_InvoiceLines where  BillingInvoiceID = {0}) from tblbilling_invoice where BillingInvoiceID = {0}", invoiceid)
            Using dt As DataTable = SqlHelper.GetDataTable(ssql, Data.CommandType.Text)
                For Each dr As DataRow In dt.Rows
                    Dim custID As String = dr("customerid").ToString
                    Dim amt As String = dr("amt").ToString
                    If Not String.IsNullOrEmpty(custID) Then
                        result.Add(custID)
                    End If
                    If Not String.IsNullOrEmpty(amt) Then
                        result.Add(FormatNumber(amt, 2))
                    End If
                Next
            End Using

            'Dim ssql As String = String.Format("select customerid from tblbilling_invoice where BillingInvoiceID = {0}", invoiceid)
            'result = SqlHelper.ExecuteScalar(ssql, Data.CommandType.Text)
            'If String.IsNullOrEmpty(result) Then
            '    result = "Invoice not found!"
            'End If
        Catch ex As Exception
            Return ex.Message.ToString
        End Try
        Return Newtonsoft.Json.JsonConvert.SerializeObject(result)
    End Function
    <WebMethod()> _
    Public Shared Function SavePayment(invoiceid As String, _
                                       customerid As String, _
                                       paymentdate As String, _
                                       paymentamount As String, _
                                       paymentmethodid As String, _
                                       refnum As String, _
                                       memo As String) As String

        Dim result As String = "SavePayment"

        Try
            Dim ssql As String = "stp_billing_InsertPayment"
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("customerid", customerid))
            params.Add(New SqlParameter("InvoiceID", invoiceid))
            params.Add(New SqlParameter("amount", paymentamount))
            params.Add(New SqlParameter("paymentmethodid", paymentmethodid))
            params.Add(New SqlParameter("referencenumber", refnum))
            params.Add(New SqlParameter("memo", memo))
            params.Add(New SqlParameter("userid", HttpContext.Current.User.Identity.Name))
            SqlHelper.ExecuteNonQuery(ssql, Data.CommandType.StoredProcedure, params.ToArray)
        Catch ex As Exception
            Return ex.Message.ToString
        End Try
        Return result
    End Function
    Protected Sub btnRefresh_Click(sender As Object, e As System.EventArgs) Handles btnRefresh.Click

    End Sub

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            txtDate.Text = FormatDateTime(Now, vbShortDate)
            LoadInvoice()
        End If
    End Sub
    Private Sub LoadInvoice()
        If Not IsNothing(Request.QueryString("invid")) Then
            Dim invid As String = Request.QueryString("invid")
            Dim ssql As String = String.Format("select customerid,[amt]=(select sum(Quantity * Price) from tblBilling_InvoiceLines where  BillingInvoiceID = {0}) from tblbilling_invoice where BillingInvoiceID = {0}", invid)
            Using dt As DataTable = SqlHelper.GetDataTable(ssql, Data.CommandType.Text)
                For Each dr As DataRow In dt.Rows
                    Dim custID As String = dr("customerid").ToString
                    Dim amt As String = dr("amt").ToString
                    If Not String.IsNullOrEmpty(custID) Then
                        ddlCustomers.SelectedValue = custID
                    End If
                    If Not String.IsNullOrEmpty(amt) Then
                        txtAmount.Text = FormatNumber(amt, 2)
                    End If
                Next
            End Using
            

        End If
    End Sub
End Class
