Imports Drg.Util.DataAccess
Imports System.Data
Imports System.Data.SqlClient
Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Xml

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://service.lexxiom.com/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class RGRHelper
    Inherits System.Web.Services.WebService

    Protected Enum ResultCode As Integer
        GOOD = 0
        [ERROR] = 1
        DUPLICATE = 2
        FAILSTATE = 3
    End Enum

    <WebMethod()> _
    Public Function SendLeads(ByVal xml As String) As String
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        Dim result As ResultCode = ResultCode.GOOD
        Dim xmlDoc As New XmlDocument
        Dim xmlNode As XmlNode
        Dim HomePhone As String
        Dim WorkPhone As String
        Dim StateID As String
        Dim TotalDebt As Integer
        Dim LeadApplicantID As Integer
        Dim RepID As Integer
        Dim EmailID As Integer
        Dim CompanyID As Integer
        Dim Email As String
        Dim FullName As String
        Dim VendorCode As String = ""
        Dim ProductID As Integer
        Dim ProductCode As String
        Dim Cost As Double = 0
        Dim AffiliateID As Integer
        Dim AssignRep As Boolean = True
        Dim MonthlyIncome As Double
        Dim BankAccount As String

        Try
            cmd.Connection.Open()
            xml = Trim(xml)
            xml = xml.Replace("&", "and") 'names coming in as Dave & Kim
            If Not xml.Contains("<Lead>") Then
                xml = "<Lead>" & xml & "</Lead>" ' xml has no root node (RGR)
            End If
            xmlDoc.LoadXml(xml)
            xmlNode = xmlDoc.SelectSingleNode("Lead")

            HomePhone = xmlNode.SelectSingleNode("Home_Phone").InnerText.Replace("-", "").Replace("(", "").Replace(")", "").Replace(" ", "")
            If Len(Trim(HomePhone)) = 10 Then
                HomePhone = "(" & Left(HomePhone, 3) & ") " & Mid(HomePhone, 4, 3) & "-" & Mid(HomePhone, 7, 4)
            Else
                HomePhone = ""
            End If

            VendorCode = xmlNode.SelectSingleNode("Vendor_ID").InnerText.ToUpper
            ProductCode = xmlNode.SelectSingleNode("product_id").InnerText.ToUpper
            ProductID = ProductIDLookup(VendorCode, ProductCode, Cost)
            If Not IsNothing(xmlNode.SelectSingleNode("Monthly_Income")) Then
                MonthlyIncome = Val(xmlNode.SelectSingleNode("Monthly_Income").InnerText)
            End If
            If Not IsNothing(xmlNode.SelectSingleNode("Bank_Account")) Then
                BankAccount = xmlNode.SelectSingleNode("Bank_Account").InnerText
            End If
            AffiliateID = AffiliateIDLookup(xmlNode.SelectSingleNode("Rcid").InnerText, ProductID)

            If ProductCode = "BLOLT" Then
                AssignRep = False
            End If

            If Not DataHelper.RecordExists("tblLeadApplicant", String.Format("LeadPhone='{0}'", HomePhone)) Then
                Email = xmlNode.SelectSingleNode("Email_Address").InnerText
                FullName = xmlNode.SelectSingleNode("First").InnerText & " " & xmlNode.SelectSingleNode("Last").InnerText

                DatabaseHelper.AddParameter(cmd, "LeadName", FullName)
                DatabaseHelper.AddParameter(cmd, "FullName", FullName)
                DatabaseHelper.AddParameter(cmd, "FirstName", xmlNode.SelectSingleNode("First").InnerText)
                DatabaseHelper.AddParameter(cmd, "LastName", xmlNode.SelectSingleNode("Last").InnerText)
                DatabaseHelper.AddParameter(cmd, "Address1", xmlNode.SelectSingleNode("Street_Address").InnerText)
                DatabaseHelper.AddParameter(cmd, "City", xmlNode.SelectSingleNode("City").InnerText)
                DatabaseHelper.AddParameter(cmd, "Email", Email)
                DatabaseHelper.AddParameter(cmd, "LeadZip", xmlNode.SelectSingleNode("Zip").InnerText)
                DatabaseHelper.AddParameter(cmd, "ZipCode", xmlNode.SelectSingleNode("Zip").InnerText)
                DatabaseHelper.AddParameter(cmd, "Rcid", xmlNode.SelectSingleNode("Rcid").InnerText)
                DatabaseHelper.AddParameter(cmd, "RgrId", xmlNode.SelectSingleNode("Id").InnerText)
                DatabaseHelper.AddParameter(cmd, "CellPhone", "")
                DatabaseHelper.AddParameter(cmd, "FaxNumber", "")
                DatabaseHelper.AddParameter(cmd, "LeadSourceID", 5) 'Internet
                DatabaseHelper.AddParameter(cmd, "CreatedByID", 1265)
                DatabaseHelper.AddParameter(cmd, "LastModifiedByID", 1265)
                DatabaseHelper.AddParameter(cmd, "StatusID", 16) 'New

                If AssignRep Then
                    RepID = GetRepID()
                    If RepID > 0 Then
                        DatabaseHelper.AddParameter(cmd, "RepID", RepID)
                    End If
                End If

                DatabaseHelper.AddParameter(cmd, "ProductID", ProductID)
                DatabaseHelper.AddParameter(cmd, "Cost", Cost)
                DatabaseHelper.AddParameter(cmd, "AffiliateID", AffiliateID)
                DatabaseHelper.AddParameter(cmd, "HomePhone", HomePhone)
                DatabaseHelper.AddParameter(cmd, "LeadPhone", HomePhone)

                WorkPhone = xmlNode.SelectSingleNode("Work_Phone").InnerText.Replace("-", "")
                If Len(Trim(WorkPhone)) > 0 Then
                    WorkPhone = "(" & Left(WorkPhone, 3) & ") " & Mid(WorkPhone, 4, 3) & "-" & Mid(WorkPhone, 7, 4)
                    DatabaseHelper.AddParameter(cmd, "BusinessPhone", WorkPhone)
                Else
                    DatabaseHelper.AddParameter(cmd, "BusinessPhone", "")
                End If

                StateID = DataHelper.FieldLookup("tblState", "StateID", String.Format("Abbreviation='{0}'", xmlNode.SelectSingleNode("State").InnerText))
                If IsNumeric(StateID) Then
                    DatabaseHelper.AddParameter(cmd, "StateID", CInt(StateID))
                End If

                CompanyID = GetCompanyID(StateID)

                If CompanyID > 0 Then
                    DatabaseHelper.AddParameter(cmd, "CompanyID", CompanyID)

                    DatabaseHelper.BuildInsertCommandText(cmd, "tblLeadApplicant", "LeadApplicantID", SqlDbType.Int)
                    cmd.ExecuteNonQuery()
                    LeadApplicantID = DataHelper.Nz_int(cmd.Parameters("@LeadApplicantID").Value)

                    If IsNumeric(xmlNode.SelectSingleNode("CreditCard_Debt").InnerText) Then
                        TotalDebt = CInt(xmlNode.SelectSingleNode("CreditCard_Debt").InnerText)
                    End If

                    If LeadApplicantID > 0 Then
                        InsertLeadCalculator(LeadApplicantID, TotalDebt)
                        LeadRoadmapHelper.InsertRoadmap(LeadApplicantID, 16, 0, "Applicant Created.", 1265)
                        InsertLeadHardship(LeadApplicantID, MonthlyIncome, BankAccount)

                        If AssignRep Then
                            'these methods are not hydra specific
                            EmailID = HydraHelper.InsertLeadEmail(LeadApplicantID, Email, "Initial", "We received your request", RepID)
                            HydraHelper.SendThankYouEmail(Email, RepID, CompanyID, EmailID)
                            If RepID > 0 Then
                                UpdateLeadLastAssignedTo(RepID)
                                HydraHelper.SendRepNotification(RepID, FullName)
                            End If
                        End If

                        SqlHelper.ExecuteNonQuery(String.Format("insert tblRGRData (status,xmlstring,vendorcode,productid,affiliateid,lead_id,home_phone) values ('GOOD','{0}','{1}',{2},{3},'{4}','{5}')", xml.Replace("'", "''"), VendorCode, ProductID, AffiliateID, xmlNode.SelectSingleNode("Id").InnerText, xmlNode.SelectSingleNode("Home_Phone").InnerText), CommandType.Text)
                    End If
                Else
                    SqlHelper.ExecuteNonQuery(String.Format("insert tblRGRData (status,xmlstring,vendorcode,productid,affiliateid,lead_id,home_phone) values ('FAILSTATE','{0}','{1}',{2},{3},'{4}','{5}')", xml.Replace("'", "''"), VendorCode, ProductID, AffiliateID, xmlNode.SelectSingleNode("Id").InnerText, xmlNode.SelectSingleNode("Home_Phone").InnerText), CommandType.Text)
                    result = ResultCode.FAILSTATE
                End If
            Else
                SqlHelper.ExecuteNonQuery(String.Format("insert tblRGRData (status,xmlstring,vendorcode,productid,affiliateid,lead_id,home_phone) values ('DUPLICATE','{0}','{1}',{2},{3},'{4}','{5}')", xml.Replace("'", "''"), VendorCode, ProductID, AffiliateID, xmlNode.SelectSingleNode("Id").InnerText, xmlNode.SelectSingleNode("Home_Phone").InnerText), CommandType.Text)
                result = ResultCode.DUPLICATE
            End If
        Catch ex As Exception
            SqlHelper.ExecuteNonQuery(String.Format("insert tblRGRData (status,xmlstring,vendorcode,productid,affiliateid,exception) values ('ERROR','{0}','{1}',{2},{3},'{4}')", xml.Replace("'", "''"), VendorCode, ProductID, AffiliateID, ex.Message.Replace("'", "''")), CommandType.Text)
            result = ResultCode.ERROR
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return CStr(result)
    End Function

    Private Sub InsertLeadCalculator(ByVal LeadApplicantID As Integer, ByVal TotalDebt As Double)
        Dim params(1) As SqlParameter
        params(0) = New SqlParameter("LeadApplicantID", LeadApplicantID)
        params(1) = New SqlParameter("TotalDebt", TotalDebt)
        SqlHelper.ExecuteNonQuery("stp_InsertLeadCalculator", CommandType.StoredProcedure, params)
    End Sub

    Private Sub InsertLeadHardship(ByVal LeadApplicantID As Integer, ByVal Income As Double, ByVal BankAccount As String)
        SqlHelper.ExecuteNonQuery(String.Format("insert tblleadhardship (leadapplicantid,monthlyincome,bankaccount) values ({0},{1},'{2}')", LeadApplicantID, Income, BankAccount), CommandType.Text)
    End Sub

    Private Function GetCompanyID(ByVal StateID As Integer) As Integer
        Dim companyID As Integer = CInt(SqlHelper.ExecuteScalar("select companyid from tblState where stateid = " & StateID, CommandType.Text))
        Return companyID
    End Function

    Private Function GetRepID() As Integer
        Dim repID As Object = SqlHelper.ExecuteScalar("select top 1 userid from tblrgrreps order by lastleadassignedto", CommandType.Text)
        If Not IsNothing(repID) Then
            If IsNumeric(repID) Then
                Return CInt(repID)
            End If
        End If
    End Function

    Private Sub UpdateLeadLastAssignedTo(ByVal RepID As Integer)
        SqlHelper.ExecuteNonQuery("update tblrgrreps set lastleadassignedto=getdate() where userid=" & RepID, CommandType.Text)
    End Sub

    Private Function ProductIDLookup(ByVal VendorCode As String, ByVal ProductCode As String, ByRef Cost As Double) As Integer
        Dim tbl As DataTable
        Dim ProductID As Integer = -1
        Dim params As New Collections.Generic.List(Of SqlParameter)

        Try
            params.Add(New SqlParameter("vendorcode", VendorCode))
            params.Add(New SqlParameter("productcode", ProductCode))
            tbl = SqlHelper.GetDataTable("stp_ProductIDLookup", CommandType.StoredProcedure, params.ToArray)
            ProductID = CInt(tbl.Rows(0)(0))
            Cost = CDbl(tbl.Rows(0)(1))
        Catch ex As Exception
            'do nothing
        End Try

        Return ProductID
    End Function

    Private Function AffiliateIDLookup(ByVal AffiliateCode As String, ByVal ProductID As Integer) As Integer
        Dim params(1) As SqlParameter
        Dim codes() As String = Split(AffiliateCode, "-")

        params(0) = New SqlParameter("@AffiliateCode", codes(0))
        params(1) = New SqlParameter("@ProductID", ProductID)

        Return CInt(SqlHelper.ExecuteScalar("stp_LeadAffiliateIDLookup", CommandType.StoredProcedure, params))
    End Function
End Class
