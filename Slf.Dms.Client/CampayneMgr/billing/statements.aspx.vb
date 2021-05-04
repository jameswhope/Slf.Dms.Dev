Imports AnalyticsHelper
Imports System.Data
Imports System.Web.Services
Imports System.Data.SqlClient
Imports System.IO

Partial Class billing_statements
    Inherits System.Web.UI.Page
    <WebMethod()> _
    Public Shared Function CreateSendStatements(ids As String) As String
        Dim result As String = "CreateSendStatements"
        Try

            'list of invoice id's to create statements for
            Dim invIDs As String() = ids.Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
            'holds result messages
            Dim lstProcessed As New List(Of String)

            For Each id As String In invIDs
                Dim CustomerID As String = String.Empty
                Dim AmountDue As String = String.Empty
                Dim Emailed As String = String.Empty
                Dim Mailed As String = String.Empty
                'get invoice info
                Dim ssqlInv As String = String.Format("stp_billing_getInvoice {0}", id)
                Using dt As DataTable = SqlHelper.GetDataTable(ssqlInv, CommandType.Text)
                    For Each inv As DataRow In dt.Rows
                        CustomerID = inv("customerid").ToString
                        AmountDue = inv("InvoiceAmount").ToString
                        Emailed = inv("SendInvoice").ToString
                        Mailed = inv("PrintInvoice").ToString
                        lstProcessed.Add(String.Format("{0} - {1}", inv("name").ToString, FormatCurrency(AmountDue, 2)))
                        Exit For
                    Next
                End Using

                'generate invoice pdf
                Dim statementFile As String = HttpContext.Current.Server.MapPath(BillingHelper.CreateStatement(id))
                If Not String.IsNullOrEmpty(statementFile) Then
                    If Mailed = True Then
                        'send pdf to printer


                    End If


                    If Emailed = True Then
                        'email pdf
                        Dim billToEmail As String = "ugreenridge@lexxiom.com"
                        Dim statementBody As String = "Your statement is attached."
                        Dim att As New List(Of String)
                        att.Add(statementFile)
                        emailHelper.SendMessage("Billing@identifyle.com", billToEmail, String.Format("Statement - {0}", Now.ToShortDateString), statementBody, att)
                    End If
                End If

                'insert statement
                Dim ssql As String = "stp_billing_InsertStatement"
                Dim params As New List(Of SqlParameter)
                params.Add(New SqlParameter("BillingInvoiceID", id))
                params.Add(New SqlParameter("CustomerID", CustomerID))
                params.Add(New SqlParameter("AmountDue", AmountDue))
                params.Add(New SqlParameter("Sent", Now))
                params.Add(New SqlParameter("Paid", DBNull.Value.ToString))
                params.Add(New SqlParameter("Emailed", Emailed))
                params.Add(New SqlParameter("Mailed", Mailed))
                params.Add(New SqlParameter("FilePath", statementFile))
                params.Add(New SqlParameter("userid", HttpContext.Current.User.Identity.Name))
                SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
            Next
            result = String.Format("<strong>Statements created for:</strong><br/>{0}", Join(lstProcessed.ToArray, "<br/>"))

        Catch ex As Exception
            Return ex.Message.ToString
        End Try
        Return result
    End Function
    Protected Sub btnRefresh_Click(sender As Object, e As System.EventArgs) Handles btnRefresh.Click
        BindData()
    End Sub
    Private Sub SetDates()
        'This week
        txtStart.Text = RoundDate(Now, -1, DateUnit.Week).ToString("MM/dd/yyyy")
        txtEnd.Text = RoundDate(Now, 1, DateUnit.Week).ToString("MM/dd/yyyy")

        ddlPeriodType.Items.Clear()

        ddlPeriodType.Items.Add(New ListItem("This Week", RoundDate(Now, -1, DateUnit.Week).ToString("MM/dd/yyyy") & "," & RoundDate(Now, 1, DateUnit.Week).ToString("MM/dd/yyyy")))
        ddlPeriodType.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("MM/dd/yyyy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("MM/dd/yyyy")))
        ddlPeriodType.Items.Add(New ListItem("Last Week", RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("MM/dd/yyyy") & "," & RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("MM/dd/yyyy")))
        ddlPeriodType.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("MM/dd/yyyy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("MM/dd/yyyy")))
        ddlPeriodType.Items.Add(New ListItem("Custom", "Custom"))

        ddlPeriodType.Attributes("onchange") = "SetDates(this);"
        ddlPeriodType.SelectedIndex = 0
    End Sub

    Protected Sub billing_statements_Load(sender As Object, e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            SetDates()
            BindData()
        End If
    End Sub
    Private Sub BindData()

        If Not String.IsNullOrEmpty(txtStart.Text) Then
            dsStatements.SelectParameters("start").DefaultValue = txtStart.Text
        End If
        If Not String.IsNullOrEmpty(txtEnd.Text) Then
            dsStatements.SelectParameters("end").DefaultValue = txtEnd.Text
        End If

        dsStatements.SelectParameters("amount").DefaultValue = DBNull.Value.ToString


        dsStatements.DataBind()
        gvStatements.DataBind()
    End Sub

    Protected Sub ddlPeriodType_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles ddlPeriodType.SelectedIndexChanged
        BindData()
    End Sub

    Protected Sub gvStatements_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvStatements.RowDataBound

        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim rowview As DataRowView = TryCast(e.Row.DataItem, DataRowView)

                Using lnk As LinkButton = TryCast(e.Row.FindControl("lnkPreview"), LinkButton)
                    lnk.OnClientClick = String.Format("return PreviewStatement({0});", rowview("BillingInvoiceID").ToString)
                End Using
                Using lnk As LinkButton = TryCast(e.Row.FindControl("lnkEdit"), LinkButton)
                    lnk.OnClientClick = String.Format("return EditDeliveryMethod({0});", rowview("BillingInvoiceID").ToString)
                End Using


        End Select

    End Sub



End Class
