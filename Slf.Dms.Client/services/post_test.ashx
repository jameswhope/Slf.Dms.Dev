<%@ WebHandler Language="VB" Class="post_test" %>

Imports Drg.Util.DataAccess
Imports System
Imports System.Web
Imports System.Data
Imports System.Data.SqlClient

Public Class post_test : Implements IHttpHandler
    
    Protected Enum ResultCode As Integer
        GOOD = 0
        [ERROR] = 1
        DUPLICATE = 2
        FAILSTATE = 3
        ERROR_NAME = 4
        ERROR_VENDOR = 5
        ERROR_PRODUCT = 6
        ERROR_PHONE = 7
        ERROR_EMAIL = 8
        ERROR_RETURNED = 9
    End Enum
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        Dim result As ResultCode = ResultCode.GOOD
        Dim HomePhone As String = ""
        Dim AltPhone As String = ""
        Dim StateID As String
        Dim LeadApplicantID As Integer
        Dim RepID As Integer
        Dim EmailID As Integer
        Dim CompanyID As Integer
        Dim Email As String = ""
        Dim FirstName As String = ""
        Dim LastName As String = ""
        Dim FullName As String = ""
        Dim Address As String = ""
        Dim City As String = ""
        Dim State As String = ""
        Dim ZipCode As String = ""
        Dim VendorCode As String = ""
        Dim ProductID As Integer
        Dim ProductCode As String = ""
        Dim Cost As Double = 0
        Dim AffiliateID As Integer
        Dim AssignRep As Boolean = True
        Dim TotalDebt As Integer = 10000
        Dim Campaign As String = ""
        Dim SrcUrl As String = ""
        Dim LeadId As String = ""
        Dim BuyerOfferXRefId As String = ""

        Dim respType As String = ""
        If Not IsNothing(context.Request.QueryString("respType")) Then
            respType = context.Request.QueryString("respType")
        End If
        If respType.Equals("xml") Then
            context.Response.Write(String.Format("<result><status>{0}</status><leadapplicantid>{1}</leadapplicantid><error></error></result>", [Enum].GetName(GetType(ResultCode), result), LeadApplicantID))
        Else
            'result = ResultCode.ERROR_RETURNED
            context.Response.Write([Enum].GetName(GetType(ResultCode), result))
        End If
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class