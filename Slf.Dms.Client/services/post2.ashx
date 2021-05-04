<%@ WebHandler Language="VB" Class="post2" %>

Imports Drg.Util.DataAccess
Imports System
Imports System.Web
Imports System.Data
Imports System.Data.SqlClient

Imports System.Collections.Generic



Public Class post2 : Implements IHttpHandler

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
        ERROR_UUID = 10
    End Enum

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        Dim rawcmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        Dim result As ResultCode = ResultCode.GOOD
        Dim HomePhone As String = ""
        Dim AltPhone As String = ""
        Dim StateID As String
        Dim LeadApplicantID As Integer
        Dim RepID As Integer
        Dim EmailID As Integer
        Dim CompanyID As Integer
        Dim Email As String = ""
        Dim FirstName As String = "Not Available"
        Dim LastName As String = "Not Available"
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
        Dim TotalDebt As Integer = 0
        Dim Campaign As String = ""
        Dim SrcUrl As String = ""
        Dim LeadId As String = ""
        Dim BuyerOfferXRefId As String = ""
        Dim uniqueGUID As String = ""
        Dim rawData As String = context.Request.RawUrl()

        Try
            rawcmd.Connection.Open()
            DatabaseHelper.AddParameter(rawcmd, "rawdata", rawData)
            DatabaseHelper.BuildInsertCommandText(rawcmd, "tblErrorLog")
            rawcmd.ExecuteNonQuery()
            rawcmd.Connection.Close()
        Catch ex As Exception

        End Try


        Try
            cmd.Connection.Open()

            'VendorCode
            If Not IsNothing(context.Request.Form("vendor")) Then
                VendorCode = context.Request.Form("vendor")
            ElseIf Not IsNothing(context.Request.QueryString("vendor")) Then
                VendorCode = context.Request.QueryString("vendor")
            End If

            If VendorCode = "" Then
                result = ResultCode.ERROR_VENDOR
                GoTo invalidrequest
            End If

            'UUID
            If Not IsNothing(context.Request.Form("UUID")) Then
                uniqueGUID = context.Request.Form("UUID")
            ElseIf Not IsNothing(context.Request.QueryString("UUID")) Then
                uniqueGUID = context.Request.QueryString("UUID")
            End If

            If uniqueGUID = "" Then
                result = ResultCode.ERROR_UUID
                GoTo invalidrequest
            End If

            'ProductCode
            If Not IsNothing(context.Request.Form("product")) Then
                ProductCode = context.Request.Form("product")
            ElseIf Not IsNothing(context.Request.QueryString("product")) Then
                ProductCode = context.Request.QueryString("product")
            End If

            If ProductCode = "" Then
                result = ResultCode.ERROR_PRODUCT
                GoTo invalidrequest
            End If

            'Email
            If Not IsNothing(context.Request.Form("email")) Then
                Email = context.Request.Form("email")
            ElseIf Not IsNothing(context.Request.QueryString("email")) Then
                Email = context.Request.QueryString("email")
            End If

            'If Email = "" Then
            '    result = ResultCode.ERROR_EMAIL
            '    GoTo invalidrequest
            'End If

            'FirstName
            If Not IsNothing(context.Request.Form("first")) Then
                FirstName = context.Request.Form("first")
            ElseIf Not IsNothing(context.Request.QueryString("first")) Then
                FirstName = context.Request.QueryString("first")
            End If

            'LastName
            If Not IsNothing(context.Request.Form("last")) Then
                LastName = context.Request.Form("last")
            ElseIf Not IsNothing(context.Request.QueryString("last")) Then
                LastName = context.Request.QueryString("last")
            End If

            'If FirstName = "" OrElse LastName = "" Then
            '    result = ResultCode.ERROR_NAME
            '    GoTo invalidrequest
            'End If

            'Phone
            If Not IsNothing(context.Request.Form("phone")) Then
                HomePhone = context.Request.Form("phone")
                If Len(Trim(HomePhone)) = 10 Then
                    HomePhone = "(" & Left(HomePhone, 3) & ") " & Mid(HomePhone, 4, 3) & "-" & Mid(HomePhone, 7, 4)
                Else
                    result = ResultCode.ERROR_PHONE
                    GoTo invalidrequest
                End If
            ElseIf Not IsNothing(context.Request.QueryString("phone")) Then
                HomePhone = context.Request.QueryString("phone")
                If Len(Trim(HomePhone)) = 10 Then
                    HomePhone = "(" & Left(HomePhone, 3) & ") " & Mid(HomePhone, 4, 3) & "-" & Mid(HomePhone, 7, 4)
                Else
                    result = ResultCode.ERROR_PHONE
                    GoTo invalidrequest
                End If
            End If

            'AltPhone
            If Not IsNothing(context.Request.Form("altphone")) Then
                AltPhone = context.Request.Form("altphone")
                If Len(Trim(AltPhone)) = 10 Then
                    AltPhone = "(" & Left(AltPhone, 3) & ") " & Mid(AltPhone, 4, 3) & "-" & Mid(AltPhone, 7, 4)
                End If
            ElseIf Not IsNothing(context.Request.QueryString("altphone")) Then
                AltPhone = context.Request.QueryString("altphone")
                If Len(Trim(AltPhone)) = 10 Then
                    AltPhone = "(" & Left(AltPhone, 3) & ") " & Mid(AltPhone, 4, 3) & "-" & Mid(AltPhone, 7, 4)
                End If
            End If

            'Address
            If Not IsNothing(context.Request.Form("address1")) Then
                Address = context.Request.Form("address1")
            ElseIf Not IsNothing(context.Request.QueryString("address1")) Then
                Address = context.Request.QueryString("address1")
            End If

            'City
            If Not IsNothing(context.Request.Form("city")) Then
                City = context.Request.Form("city")
            ElseIf Not IsNothing(context.Request.QueryString("city")) Then
                City = context.Request.QueryString("city")
            End If

            'State
            If Not IsNothing(context.Request.Form("state")) Then
                State = context.Request.Form("state")
            ElseIf Not IsNothing(context.Request.QueryString("state")) Then
                State = context.Request.QueryString("state")
            End If

            'Zip
            If Not IsNothing(context.Request.Form("zip")) Then
                ZipCode = context.Request.Form("zip")
                If Len(Trim(ZipCode)) <> 5 Then
                    Zipcode = ""
                End If
            ElseIf Not IsNothing(context.Request.QueryString("zip")) Then
                ZipCode = context.Request.QueryString("zip")
                If Len(Trim(ZipCode)) <> 5 Then
                    Zipcode = ""
                End If
            End If

            'Campaign
            If Not IsNothing(context.Request.Form("campaign")) Then
                Campaign = context.Request.Form("campaign")
            ElseIf Not IsNothing(context.Request.QueryString("campaign")) Then
                Campaign = context.Request.QueryString("campaign")
            End If

            'Source URL
            If Not IsNothing(context.Request.Form("sourceurl")) Then
                SrcUrl = context.Request.Form("sourceurl")
            ElseIf Not IsNothing(context.Request.QueryString("sourceurl")) Then
                SrcUrl = context.Request.QueryString("sourceurl")
            End If

            ProductID = ProductIDLookup(VendorCode, ProductCode, Cost)
            AffiliateID = AffiliateIDLookup("", ProductID)

            'If ProductCode = "BLOLT" Then
            AssignRep = False
            'End If

            If Not DataHelper.RecordExists("tblLeadApplicant", String.Format("LeadPhone='{0}' and Created > dateadd(d,-60,getdate())", HomePhone)) Then

                FullName = FirstName + " " + LastName

                DatabaseHelper.AddParameter(cmd, "LeadName", FullName)
                DatabaseHelper.AddParameter(cmd, "FullName", FullName)
                DatabaseHelper.AddParameter(cmd, "FirstName", FirstName)
                DatabaseHelper.AddParameter(cmd, "LastName", LastName)
                DatabaseHelper.AddParameter(cmd, "Address1", Address)
                DatabaseHelper.AddParameter(cmd, "City", City)
                DatabaseHelper.AddParameter(cmd, "Email", Email)
                DatabaseHelper.AddParameter(cmd, "LeadZip", ZipCode)
                DatabaseHelper.AddParameter(cmd, "ZipCode", ZipCode)
                DatabaseHelper.AddParameter(cmd, "Rcid", AffiliateID)
                DatabaseHelper.AddParameter(cmd, "RgrId", "-1")
                DatabaseHelper.AddParameter(cmd, "CellPhone", AltPhone)
                DatabaseHelper.AddParameter(cmd, "FaxNumber", "")
                DatabaseHelper.AddParameter(cmd, "LeadSourceID", 5) 'Internet
                DatabaseHelper.AddParameter(cmd, "CreatedByID", 1265)
                DatabaseHelper.AddParameter(cmd, "LastModifiedByID", 1265)
                DatabaseHelper.AddParameter(cmd, "StatusID", 16) 'New
                DatabaseHelper.AddParameter(cmd, "SourceCampaign", Campaign)
                DatabaseHelper.AddParameter(cmd, "SourceUrl", SrcUrl)
                DatabaseHelper.AddParameter(cmd, "SourceLeadId", LeadId)
                DatabaseHelper.AddParameter(cmd, "SourceContractId", BuyerOfferXRefId)
                DatabaseHelper.AddParameter(cmd, "DialerRetryAfter", DateAdd(DateInterval.Minute, 0, Now))

                If AssignRep Then
                    RepID = GetRepID()
                    If RepID > 0 Then
                        DatabaseHelper.AddParameter(cmd, "RepID", RepID)
                    End If
                End If

                DatabaseHelper.AddParameter(cmd, "ProductID", ProductID)
                DatabaseHelper.AddParameter(cmd, "PaperLeadCode", uniqueGUID)
                DatabaseHelper.AddParameter(cmd, "Cost", Cost)
                DatabaseHelper.AddParameter(cmd, "AffiliateID", AffiliateID)
                DatabaseHelper.AddParameter(cmd, "HomePhone", HomePhone)
                DatabaseHelper.AddParameter(cmd, "LeadPhone", HomePhone)

                StateID = DataHelper.FieldLookup("tblState", "StateID", String.Format("Abbreviation='CA'", State))
                If IsNumeric(StateID) Then
                    DatabaseHelper.AddParameter(cmd, "StateID", CInt(StateID))
                    CompanyID = GetCompanyID(StateID)
                Else
                    CompanyID = 4 'Mossler, default
                End If

                If CompanyID > 0 Then
                    DatabaseHelper.AddParameter(cmd, "CompanyID", CompanyID)

                    DatabaseHelper.BuildInsertCommandText(cmd, "tblLeadApplicant", "LeadApplicantID", SqlDbType.Int)
                    cmd.ExecuteNonQuery()
                    LeadApplicantID = DataHelper.Nz_int(cmd.Parameters("@LeadApplicantID").Value)

                    If LeadApplicantID > 0 Then
                        If Not IsNothing(context.Request.Form("debt")) Then
                            TotalDebt = context.Request.Form("debt")
                        ElseIf Not IsNothing(context.Request.QueryString("debt")) Then
                            TotalDebt = context.Request.QueryString("debt")
                        End If
                        InsertLeadCalculator(LeadApplicantID, TotalDebt)
                        LeadRoadmapHelper.InsertRoadmap(LeadApplicantID, 16, 0, "Applicant Created.", 1265)
                        InsertLeadHardship(LeadApplicantID, 0, "")

                        If AssignRep Then
                            'these methods are not hydra specific
                            EmailID = HydraHelper.InsertLeadEmail(LeadApplicantID, Email, "Initial", "We received your request", RepID)
                            HydraHelper.SendThankYouEmail(Email, RepID, CompanyID, EmailID)
                            If RepID > 0 Then
                                UpdateLeadLastAssignedTo(RepID)
                                HydraHelper.SendRepNotification(RepID, FullName)
                            End If
                        End If

                        SqlHelper.ExecuteNonQuery(String.Format("insert tblRGRData (status,xmlstring,vendorcode,productid,affiliateid,lead_id,home_phone) values ('GOOD','{0}','{1}',{2},{3},'{4}','{5}')", context.Request.Url.PathAndQuery, VendorCode, ProductID, AffiliateID, "", HomePhone), CommandType.Text)
                    End If
                Else
                    SqlHelper.ExecuteNonQuery(String.Format("insert tblRGRData (status,xmlstring,vendorcode,productid,affiliateid,lead_id,home_phone) values ('FAILSTATE','{0}','{1}',{2},{3},'{4}','{5}')", context.Request.Url.PathAndQuery, VendorCode, ProductID, AffiliateID, "", HomePhone), CommandType.Text)
                    result = ResultCode.FAILSTATE
                End If
            Else
                LeadApplicantID = SqlHelper.ExecuteScalar(String.Format("insert tblRGRData (status,xmlstring,vendorcode,productid,affiliateid,lead_id,home_phone) values ('DUPLICATE','{0}','{1}',{2},{3},'{4}','{5}'); select LeadApplicantID from tblLeadApplicant where LeadPhone='{5}'", context.Request.Url.PathAndQuery, VendorCode, ProductID, AffiliateID, "", HomePhone), CommandType.Text)
                result = ResultCode.DUPLICATE
            End If
invalidrequest:
        Catch ex As Exception
            SqlHelper.ExecuteNonQuery(String.Format("insert tblRGRData (status,xmlstring,vendorcode,productid,affiliateid,exception) values ('ERROR','{0}','{1}',{2},{3},'{4}')", context.Request.Url.PathAndQuery, VendorCode, ProductID, AffiliateID, ex.Message.Replace("'", "''")), CommandType.Text)
            result = ResultCode.ERROR
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

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

    Private Sub InsertLeadCalculator(Optional ByVal LeadApplicantID As Integer = 23483, Optional ByVal TotalDebt As Double = 100000)
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("LeadApplicantID", LeadApplicantID))
        params.Add(New SqlParameter("TotalDebt", TotalDebt))
        SqlHelper.ExecuteNonQuery("stp_InsertLeadCalculator", CommandType.StoredProcedure, params.ToArray)
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