<%@ WebHandler Language="VB" Class="depositdaysagoxls" %>

Imports System
Imports System.Collections
Imports System.Collections.Specialized
Imports System.Collections.Generic
Imports System.Data
Imports System.Web
Imports System.Web.UI
imports Drg.Util.DataAccess
Imports Drg.Util.Helpers

Public Class depositdaysagoxls
    Implements IHttpHandler, IRequiresSessionState
	 Protected Structure Result
        Dim ClientID As Integer
        Dim RegisterID As Integer
        Dim AgencyName As String
        Dim ClientName As String
        Dim AccountNumber As String
        Dim ClientStatusName As String
        Dim DepositMethod As String
        Dim TransactionDate As DateTime
        Dim DepositDay As Integer
        Dim DepositAmount As Single
        Dim DaysAgo As Single
        Dim NeverDeposited As Boolean
        Dim Amount As Single
        Dim Bounce As Boolean
        Dim Void As Boolean
        Dim ACH As Boolean

        Dim Street As String
        Dim Street2 As String
        Dim City As String
        Dim State As String
        Dim Zip As String
        Dim HomePhone As String
        Dim WorkPhone As String
    End Structure
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Try
            
			Dim cmd As IDbCommand = CommandHelper.DeepClone(CType(context.Session("xls_DepositDaysAgo_cmd"), IDbCommand))
			cmd.CommandText = "stp_Report_DaysAgo_Xls"
            			
			context.Response.ContentType = "application/vnd.ms-excel"
			context.Response.AddHeader("Content-Disposition", "filename=DepositDaysAgo.xls")
         
			Dim writer As New HtmlTextWriter(context.Response.Output)
            
			WriteContent(cmd, writer)
         
			writer.Close()
		Catch e As Exception
		End Try
    End Sub
	
	Private Sub WriteContent(ByVal cmd As IDbCommand, ByVal writer As HtmlTextWriter)
		Dim Results As New List(Of Result)

		Dim sb As New StringBuilder

		Using cmd
			Using cmd.Connection
				cmd.Connection.Open()
				Using rd As IDataReader = cmd.ExecuteReader
                  
					While rd.Read()
						Dim r As New Result

                        r.ClientID = DatabaseHelper.Peel_int(rd, "ClientID")
                        r.AgencyName = DatabaseHelper.Peel_string(rd, "AgencyName")
                        r.ClientName = DatabaseHelper.Peel_string(rd, "ClientName")
                        r.AccountNumber = DatabaseHelper.Peel_string(rd, "AccountNumber")
                        r.ClientStatusName = DatabaseHelper.Peel_string(rd, "ClientStatusName")
                        r.DepositMethod = DatabaseHelper.Peel_string(rd, "DepositMethod")
                        If String.IsNullOrEmpty(r.DepositMethod) Then r.DepositMethod = "Check"
                        r.DepositDay = DatabaseHelper.Peel_int(rd, "DepositDay")
                        r.DepositAmount = DatabaseHelper.Peel_float(rd, "DepositAmount")

                        r.Street = DatabaseHelper.Peel_string(rd, "Street")
                        r.Street2 = DatabaseHelper.Peel_string(rd, "Street2")
                        r.City = DatabaseHelper.Peel_string(rd, "City")
                        r.State = DatabaseHelper.Peel_string(rd, "StateName")
                        r.Zip = DatabaseHelper.Peel_string(rd, "ZipCode")
                        r.HomePhone = DatabaseHelper.Peel_string(rd, "HomePhone")
                        r.WorkPhone = DatabaseHelper.Peel_string(rd, "WorkPhone")

                        r.NeverDeposited = rd.IsDBNull(rd.GetOrdinal("registerid"))
                        If Not r.NeverDeposited Then
                            r.RegisterID = DatabaseHelper.Peel_int(rd, "RegisterID")
                            r.Amount = DatabaseHelper.Peel_float(rd, "Amount")
                            r.Bounce = Not rd.IsDBNull(rd.GetOrdinal("Bounce"))
                            r.Void = Not rd.IsDBNull(rd.GetOrdinal("Void"))
                            r.ACH = Not rd.IsDBNull(rd.GetOrdinal("AchYear"))
                            r.DaysAgo = DatabaseHelper.Peel_float(rd, "DaysAgo")
                            r.TransactionDate = DatabaseHelper.Peel_date(rd, "TransactionDate")
                        End If

                        Results.Add(r)
					End While
				End Using
			End Using
		End Using
		writer.Write(BuildXls(Results))
	End Sub
	
	Private Function BuildXls(ByVal Results As List(Of Result)) As String
		Dim sbXls As New StringBuilder

		sbXls.Append("<table border=""1"">")
		sbXls.Append("<tr><td>Agency</td><td>Name</td><td>Street</td><td>Street 2</td><td>City</td><td>State</td><td>Zip</td><td>Home Phone</td><td>Work Phone</td>")
		sbXls.Append("<td>Acct No.</td><td>Status</td><td>Method</td><td>Day</td><td>Amount</td><td>Days Ago</td><td>Date</td><td>Amount</td><td>B</td><td>V</td><td>ACH</td></tr>")

		For Each r As Result In Results
			sbXls.Append("<tr><td>")
			sbXls.Append(r.AgencyName)
			sbXls.Append("</td><td>")
			sbXls.Append(r.ClientName)
			sbXls.Append("</td><td>")

			sbXls.Append(r.Street)
			sbXls.Append("</td><td>")
			sbXls.Append(r.Street2)
			sbXls.Append("</td><td>")
			sbXls.Append(r.City)
			sbXls.Append("</td><td>")
			sbXls.Append(r.State)
			sbXls.Append("</td><td>")
			sbXls.Append(r.Zip)
			sbXls.Append("</td><td>")
			sbXls.Append(LocalHelper.FormatPhone(r.HomePhone))
			sbXls.Append("</td><td>")
			sbXls.Append(LocalHelper.FormatPhone(r.WorkPhone))
			sbXls.Append("</td><td>")

			sbXls.Append(r.AccountNumber)
			sbXls.Append("</td><td>")
			sbXls.Append(r.ClientStatusName)
			sbXls.Append("</td><td>")
			sbXls.Append(r.DepositMethod)
			sbXls.Append("</td><td>")
			sbXls.Append(r.DepositDay)
			sbXls.Append("</td><td>")
			sbXls.Append(r.DepositAmount.ToString("c"))
			sbXls.Append("</td>")
			
			if r.NeverDeposited then
			sbxls.Append("<td colspan=""6"">Never Deposited")
			else
			sbxls.Append("<td>")
						sbXls.Append(Math.Round(r.DaysAgo, 2))
			sbXls.Append("</td><td>")
			sbXls.Append(r.TransactionDate.ToString("MM/dd/yyyy"))
			sbXls.Append("</td><td>")
			sbXls.Append(r.Amount.ToString("c"))
			sbXls.Append("</td><td>")
			sbXls.Append(LocalHelper.GetBoolString(r.Bounce))
			sbXls.Append("</td><td>")
			sbXls.Append(LocalHelper.GetBoolString(r.Void))
			sbXls.Append("</td><td>")
			sbXls.Append(LocalHelper.GetBoolString(r.ACH))
end if
			sbXls.Append("</td></a></tr>")
		Next
		sbXls.Append("</table>")
		Return sbXls.ToString()
	End Function

	Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
		Get
			Return False
		End Get
	End Property
End Class