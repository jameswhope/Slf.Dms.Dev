Imports System.ComponentModel
Imports System.Data
Imports System.Data.SqlClient
Imports System.Reflection

Imports DataManagerHelper

Imports Microsoft.VisualBasic

Public Class BuyerHelper

    #Region "Methods"
    Public Shared Sub InsertContractZipFilters(bxID As Integer, zipfilepath As String)


        Using sr As New IO.StreamReader(zipfilepath)
            Dim line As String
            ' Read and display the lines from the file until the end 
            ' of the file is reached.
            Do
                line = sr.ReadLine()
                Try
                    'insert zip
                    If IsNumeric(line) Then
                        Dim ssql As String = "stp_buyer_insertContractZipCode"
                        Dim params As New List(Of SqlParameter)
                        params.Add(New SqlParameter("BuyerOfferXrefID", bxID))
                        params.Add(New SqlParameter("ZipCode", line))
                        SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
                    End If
                Catch ex As Exception
                    Continue Do
                End Try
            Loop Until line Is Nothing
        End Using
    End Sub

    Public Shared Sub InsertContact(ByVal conType As cmService.enumDocumentType, ByVal contact As ContactObject)
        Dim ssql As String = Nothing
        Dim paramName As String = Nothing
        Dim params As New List(Of SqlParameter)

        Select Case conType
            Case cmService.enumDocumentType.BuyerDocument
                ssql = "stp_buyer_InsertUpdateContact"
                paramName = "BuyerID"
                params.Add(New SqlParameter("Billing", contact.Billing))
            Case cmService.enumDocumentType.AdvertiserDocument
                ssql = "stp_advertisers_InsertUpdateContact"
                paramName = "advertiserID"
            Case cmService.enumDocumentType.AffiliateDocument
                ssql = "stp_Affiliate_InsertUpdateContact"
                paramName = "Affiliateid"
                params.Add(New SqlParameter("Billing", contact.Billing))
        End Select
        If Not IsNothing(ssql) Then
            params.Add(New SqlParameter("ContactID", contact.ContactID))
            params.Add(New SqlParameter(paramName, contact.ParentID))
            params.Add(New SqlParameter("FullName", contact.FullName))
            params.Add(New SqlParameter("Email", contact.Email))
            params.Add(New SqlParameter("Phone", contact.Phone))
            params.Add(New SqlParameter("Notes", contact.Notes))
            SqlHelper.ExecuteNonQuery(ssql, Data.CommandType.StoredProcedure, params.ToArray)
        End If
       
    End Sub

    Public Shared Sub InsertUpdateBuyer(ByVal buyer As BuyersObject, ByVal loggedInUserID As Integer)
        Dim ssql As String = "stp_buyer_InsertUpdate"
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("BuyerID", buyer.BuyerID))
        params.Add(New SqlParameter("Buyer", buyer.Buyer))
        params.Add(New SqlParameter("buyercode", buyer.BuyerCode))
        params.Add(New SqlParameter("active", buyer.Active))

        If Not String.IsNullOrEmpty(buyer.BillingCycle) Then
            params.Add(New SqlParameter("BillingCycle", buyer.BillingCycle))
        End If
        If Not String.IsNullOrEmpty(buyer.AccountManager) Then
            params.Add(New SqlParameter("AccountManager", buyer.AccountManager))
        End If

        If Not String.IsNullOrEmpty(buyer.Address) Then
            params.Add(New SqlParameter("Address", buyer.Address))
        End If
        If Not String.IsNullOrEmpty(buyer.City) Then
            params.Add(New SqlParameter("City", buyer.City))
        End If

        If Not String.IsNullOrEmpty(buyer.State) Then
            params.Add(New SqlParameter("StateAbbrev", buyer.State))
        End If

        If Not String.IsNullOrEmpty(buyer.Zip) Then
            params.Add(New SqlParameter("ZipCode", buyer.Zip))
        End If
        If Not String.IsNullOrEmpty(buyer.Country) Then
            params.Add(New SqlParameter("Country", buyer.Country))
        End If
        If Not String.IsNullOrEmpty(buyer.Notes) Then
            params.Add(New SqlParameter("Notes", buyer.Notes))
        End If

        params.Add(New SqlParameter("UserID", loggedInUserID))

        SqlHelper.ExecuteNonQuery(ssql, Data.CommandType.StoredProcedure, params.ToArray)
    End Sub

    Public Shared Function getBuyer(ByVal buyerid As Integer) As BuyersObject
        Dim bo As BuyersObject = Nothing
        Using dt As DataTable = SqlHelper.GetDataTable(String.Format("stp_datamgr_getBuyers {0}", buyerid), Data.CommandType.Text)
            For Each b As DataRow In dt.Rows
                bo = New BuyersObject() With {.BuyerID = b("Buyerid").ToString, _
                                                       .Buyer = b("Buyer").ToString, _
                                                       .Active = b("active").ToString, _
                                                       .Created = b("Created").ToString, _
                                                       .BuyerCode = b("BuyerCode").ToString, _
                                                       .Address = b("Address").ToString, _
                                                       .City = b("City").ToString, _
                                                       .State = b("StateAbbrev").ToString, _
                                                       .Zip = b("zipcode").ToString, _
                                                       .Country = b("Country").ToString, _
                                                       .BillingCycle = b("BillingCycle").ToString, _
                                                       .AccountManager = b("AccountManager").ToString, _
                                                       .Notes = b("Notes").ToString}
            Next
        End Using
        Return bo
    End Function

    Public Shared Function getBuyerDeliverySchedule(ByVal BuyerOfferXrefID As Integer) As List(Of DeliveryScheduleObject)
        getBuyerDeliverySchedule = New List(Of DeliveryScheduleObject)

        Dim ssql As String = "stp_datamgr_getBuyerDeliverySchedule"
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("BuyerOfferXrefID", BuyerOfferXrefID))

        Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.StoredProcedure, params.ToArray)
            For Each dr As DataRow In dt.Rows
                getBuyerDeliverySchedule.Add(New DeliveryScheduleObject() With {.BuyerID = dr("buyerid").ToString, _
                                                                               .BuyerOfferXrefID = dr("BuyerOfferXrefID").ToString, _
                                                                               .Weekday = dr("Weekday").ToString, _
                                                                               .FromHour = dr("FromHour").ToString, _
                                                                               .ToHour = dr("ToHour").ToString, _
                                                                               .DailyCap = dr("DailyCap").ToString, _
                                                                               .Price = dr("Price").ToString, _
                                                                               .Exclusive = dr("Exclusive").ToString, _
                                                                               .Priority = dr("Priority").ToString})
            Next
        End Using
    End Function

    Public Shared Function getBuyerFilters(ByVal BuyerOfferXrefID As Integer) As List(Of FilterObject)
        getBuyerFilters = New List(Of FilterObject)
        Dim ssql As String = String.Format("SELECT top 1 excludedstates from tblBuyerOfferXref where BuyerOfferXrefID = {0}", BuyerOfferXrefID)
        Dim exStates As String = SqlHelper.ExecuteScalar(ssql, CommandType.Text)
        If Not String.IsNullOrEmpty(exStates) Then
            For Each s As String In exStates.Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
                getBuyerFilters.Add(New FilterObject() With {.FilterDescription = "Does Not Contain State", _
                                                                .FilterValue = s})
            Next
        End If
        ssql = String.Format("SELECT count(*)[zipcnt] from tblBuyerOfferXref_ZipCodes where BuyerOfferXrefID = {0} ", BuyerOfferXrefID)
        Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)
            For Each dr As DataRow In dt.Rows
                If dr("zipcnt").ToString > 0 Then
                    getBuyerFilters.Add(New FilterObject() With {.FilterDescription = "Does Contain ZipCode", _
                                                                .FilterValue = dr("zipcnt").ToString})
                End If
            Next
        End Using
    End Function

    Public Shared Function getBuyers(Optional ByVal sortField As String = "Buyer", Optional ByVal sortOrder As String = "ASC") As List(Of BuyersObject)
        getBuyers = New List(Of BuyersObject)
        Using dt As DataTable = SqlHelper.GetDataTable("stp_datamgr_getBuyers", Data.CommandType.Text)
            For Each b As DataRow In dt.Rows
                getBuyers.Add(New BuyersObject() With {.BuyerID = b("Buyerid").ToString, _
                                                       .Buyer = b("Buyer").ToString, _
                                                       .Active = b("active").ToString, _
                                                       .Created = b("Created").ToString, _
                                                       .BuyerCode = b("BuyerCode").ToString, _
                                                       .Address = b("Address").ToString, _
                                                       .City = b("City").ToString, _
                                                       .State = b("StateAbbrev").ToString, _
                                                       .Zip = b("zipcode").ToString, _
                                                       .Country = b("Country").ToString, _
                                                       .BillingCycle = b("BillingCycle").ToString, _
                                                       .AccountManager = b("AccountManager").ToString, _
                                                       .Notes = b("Notes").ToString})
            Next
        End Using
        If Not IsNothing(sortField) Then
            getBuyers.Sort(New BuyerComparer(sortField, sortOrder))
        End If
    End Function

    Public Shared Function GetTrafficTypes(BuyerOfferXrefID As Integer) As DataTable
        Return SqlHelper.GetDataTable("select TrafficTypeID from tblTrafficTypeXref where BuyerOfferXrefID = " & BuyerOfferXrefID)
    End Function

    Public Shared Function GetQuestions(BuyerOfferXrefID As Integer) As DataTable
        Return SqlHelper.GetDataTable("select QuestionPlainText + ' - ' + OptionText [Question] from tblQuestionBuyerXref where BuyerOfferXrefID = " & BuyerOfferXrefID)
    End Function

    Public Shared Function GetWebsites(BuyerOfferXrefID As Integer) As DataTable
        Return SqlHelper.GetDataTable("select WebsiteID from tblBuyerWebsites where Deleted is null and BuyerOfferXrefID = " & BuyerOfferXrefID)
    End Function

#End Region 'Methods

#Region "Nested Types"

    Public Class BuyerComparer
        Implements IComparer(Of BuyersObject)

#Region "Fields"

        Private ReadOnly _sortField As String
        Private ReadOnly _sortOrder As String

#End Region 'Fields

#Region "Constructors"

        Public Sub New(ByVal propertyName As String, ByVal order As String)
            _sortField = propertyName
            _sortOrder = If((String.IsNullOrEmpty(order) OrElse (Not order.Equals("ASC") AndAlso Not order.Equals("DESC"))), "ASC", order)
        End Sub

#End Region 'Constructors

#Region "Methods"

        Public Function Compare(ByVal x As BuyersObject, ByVal y As BuyersObject) As Integer Implements System.Collections.Generic.IComparer(Of BuyersObject).Compare
            Dim [property] As PropertyInfo = x.[GetType]().GetProperty(_sortField)
            If IsNothing([property]) Then
                Throw New ApplicationException("Invalid property " + _sortField)
            End If
            If _sortOrder.Equals("ASC") Then
                Return Comparer.DefaultInvariant.Compare([property].GetValue(x, Nothing), [property].GetValue(y, Nothing))
            Else
                Return Comparer.DefaultInvariant.Compare([property].GetValue(y, Nothing), [property].GetValue(x, Nothing))
            End If
        End Function

#End Region 'Methods

    End Class

    Public Class BuyerContractComparer
        Implements IComparer(Of BuyerContractObject)

#Region "Fields"

        Private ReadOnly _sortField As String
        Private ReadOnly _sortOrder As String

#End Region 'Fields

#Region "Constructors"

        Public Sub New(ByVal propertyName As String, ByVal order As String)
            _sortField = propertyName
            _sortOrder = If((String.IsNullOrEmpty(order) OrElse (Not order.Equals("ASC") AndAlso Not order.Equals("DESC"))), "ASC", order)
        End Sub

#End Region 'Constructors

#Region "Methods"

        Public Function Compare(ByVal x As BuyerContractObject, ByVal y As BuyerContractObject) As Integer Implements System.Collections.Generic.IComparer(Of BuyerContractObject).Compare
            Dim [property] As PropertyInfo = x.[GetType]().GetProperty(_sortField)
            If IsNothing([property]) Then
                Throw New ApplicationException("Invalid property " + _sortField)
            End If
            If _sortOrder.Equals("ASC") Then
                Return Comparer.DefaultInvariant.Compare([property].GetValue(x, Nothing), [property].GetValue(y, Nothing))
            Else
                Return Comparer.DefaultInvariant.Compare([property].GetValue(y, Nothing), [property].GetValue(x, Nothing))
            End If
        End Function

#End Region 'Methods

    End Class

    <DataObject(True)> _
    Public Class BuyerContractObject
        Implements IDisposable

#Region "Fields"

        Private _Active As Boolean
        Private _AgedMinutes As Integer
        Private _Buyer As String
        Private _BuyerActive As Boolean
        Private _BuyerCode As String
        Private _BuyerID As String
        Private _BuyerOfferXrefID As String
        Private _CakeCampaignId As String
        Private _CakePostKey As String
        Private _CallTransfer As Boolean
        Private _ContractName As String
        Private _ContractTypeID As Integer
        Private _Created As DateTime
        Private _DailyCap As String
        Private _DataTransfer As Boolean
        Private _DoCakePost As Boolean
        Private _DupAttempt As String
        Private _ExcludedStates As String
        Private _Exclusive As String
        Private _Instructions As String
        Private _MinDebt As String
        Private _MinutesBackForLeads As Integer
        Private _Offer As String
        Private _OfferActive As Boolean
        Private _OfferID As String
        Private _PointValue As String
        Private _InvoicePrice As Double
        Private _Price As Double
        Private _Priority As String
        Private _RealTimeMinutes As Integer
        Private _ServicePhoneNumber As String
        Private _Spanish As Boolean
        Private _Vertical As String
        Private _callcenter As Boolean
        Private _dataSQL As String
        Private _datasortdir As String
        Private _datasortfield As String
        Private _Trickle As Integer
        Private _throttle As Boolean
        Private _weight As Double
        Private _WebsiteTypeid As Integer
        Private _NoScrub As Boolean
        Private _ExcludeDNC As Boolean
        Private _WirelessOnly As Boolean
        Private _LandlineOnly As Boolean

#End Region 'Fields

#Region "Properties"

        Public Property ExcludeDNC() As Boolean
            Get
                Return _ExcludeDNC
            End Get
            Set(ByVal value As Boolean)
                _ExcludeDNC = value
            End Set
        End Property

        Public Property WirelessOnly() As Boolean
            Get
                Return _WirelessOnly
            End Get
            Set(ByVal value As Boolean)
                _WirelessOnly = value
            End Set
        End Property

        Public Property LandlineOnly() As Boolean
            Get
                Return _LandlineOnly
            End Get
            Set(ByVal value As Boolean)
                _LandlineOnly = value
            End Set
        End Property

        Public Property Active() As Boolean
            Get
                Return _Active
            End Get
            Set(ByVal value As Boolean)
                _Active = value
            End Set
        End Property

        Public Property AgedMinutes() As Integer
            Get
                Return _AgedMinutes
            End Get
            Set(value As Integer)
                _AgedMinutes = value
            End Set
        End Property

        Public Property Buyer() As String
            Get
                Return _Buyer
            End Get
            Set(ByVal value As String)
                _Buyer = value
            End Set
        End Property

        Public Property BuyerActive() As Boolean
            Get
                Return _BuyerActive
            End Get
            Set(ByVal value As Boolean)
                _BuyerActive = value
            End Set
        End Property

        Public Property BuyerCode() As String
            Get
                Return _BuyerCode
            End Get
            Set(ByVal value As String)
                _BuyerCode = value
            End Set
        End Property

        Public Property BuyerID() As String
            Get
                Return _BuyerID
            End Get
            Set(ByVal value As String)
                _BuyerID = value
            End Set
        End Property

        Public Property BuyerOfferXrefID() As String
            Get
                Return _BuyerOfferXrefID
            End Get
            Set(ByVal value As String)
                _BuyerOfferXrefID = value
            End Set
        End Property

        Public Property CakeCampaignId() As String
            Get
                Return _CakeCampaignId
            End Get
            Set(ByVal value As String)
                _CakeCampaignId = value
            End Set
        End Property

        Public Property CakePostKey() As String
            Get
                Return _CakePostKey
            End Get
            Set(ByVal value As String)
                _CakePostKey = value
            End Set
        End Property

        Public Property CallCenter() As Boolean
            Get
                Return _callcenter
            End Get
            Set(ByVal value As Boolean)
                _callcenter = value
            End Set
        End Property

        Public Property CallTransfer() As Boolean
            Get
                Return _CallTransfer
            End Get
            Set(ByVal value As Boolean)
                _CallTransfer = value
            End Set
        End Property

        Public Property ContractName() As String
            Get
                Return _ContractName
            End Get
            Set(ByVal value As String)
                _ContractName = value
            End Set
        End Property

        Public Property ContractTypeID() As Integer
            Get
                Return _ContractTypeID
            End Get
            Set(ByVal value As Integer)
                _ContractTypeID = value
            End Set
        End Property

        Public Property Created() As DateTime
            Get
                Return _Created
            End Get
            Set(ByVal value As DateTime)
                _Created = value
            End Set
        End Property

        Public Property DailyCap() As String
            Get
                Return _DailyCap
            End Get
            Set(ByVal value As String)
                _DailyCap = value
            End Set
        End Property

        Public Property DataSQL() As String
            Get
                Return _dataSQL
            End Get
            Set(ByVal value As String)
                _dataSQL = value
            End Set
        End Property

        Public Property DataSortDir() As String
            Get
                Return _datasortdir
            End Get
            Set(ByVal value As String)
                _datasortdir = value
            End Set
        End Property

        Public Property DataSortField() As String
            Get
                Return _datasortfield
            End Get
            Set(ByVal value As String)
                _datasortfield = value
            End Set
        End Property

        Public Property DataTransfer() As Boolean
            Get
                Return _DataTransfer
            End Get
            Set(ByVal value As Boolean)
                _DataTransfer = value
            End Set
        End Property

        Public Property DoCakePost() As Boolean
            Get
                Return _DoCakePost
            End Get
            Set(ByVal value As Boolean)
                _DoCakePost = value
            End Set
        End Property

        Public Property DupAttempt() As String
            Get
                Return _DupAttempt
            End Get
            Set(ByVal value As String)
                _DupAttempt = value
            End Set
        End Property

        Public Property ExcludedStates() As String
            Get
                Return _ExcludedStates
            End Get
            Set(ByVal value As String)
                _ExcludedStates = value
            End Set
        End Property

        Public Property Exclusive() As Boolean
            Get
                Return _Exclusive
            End Get
            Set(ByVal value As Boolean)
                _Exclusive = value
            End Set
        End Property

        Public Property Instructions() As String
            Get
                Return _Instructions
            End Get
            Set(ByVal value As String)
                _Instructions = value
            End Set
        End Property

        Public Property MinDebt() As String
            Get
                Return _MinDebt
            End Get
            Set(ByVal value As String)
                _MinDebt = value
            End Set
        End Property

        Public Property Offer() As String
            Get
                Return _Offer
            End Get
            Set(ByVal value As String)
                _Offer = value
            End Set
        End Property

        Public Property OfferActive() As Boolean
            Get
                Return _OfferActive
            End Get
            Set(ByVal value As Boolean)
                _OfferActive = value
            End Set
        End Property

        Public Property OfferID() As String
            Get
                Return _OfferID
            End Get
            Set(ByVal value As String)
                _OfferID = value
            End Set
        End Property

        Public Property PointValue() As String
            Get
                Return _PointValue
            End Get
            Set(ByVal value As String)
                If String.IsNullOrEmpty(value) Then
                    _PointValue = 0
                Else
                    _PointValue = value
                End If

            End Set
        End Property

        Public Property InvoicePrice() As Double
            Get
                Return _InvoicePrice
            End Get
            Set(ByVal value As Double)
                _InvoicePrice = value
            End Set
        End Property

        Public Property Price() As Double
            Get
                Return _Price
            End Get
            Set(ByVal value As Double)
                _Price = value
            End Set
        End Property

        Public Property Priority() As String
            Get
                Return _Priority
            End Get
            Set(ByVal value As String)
                _Priority = value
            End Set
        End Property

        Public Property MinutesBackForLeads() As Integer
            Get
                Return _MinutesBackForLeads
            End Get
            Set(value As Integer)
                _MinutesBackForLeads = value
            End Set
        End Property

        Public Property RealTimeMinutes() As Integer
            Get
                Return _RealTimeMinutes
            End Get
            Set(value As Integer)
                _RealTimeMinutes = value
            End Set
        End Property

        Public Property ServicePhoneNumber() As String
            Get
                Return _ServicePhoneNumber
            End Get
            Set(ByVal value As String)
                _ServicePhoneNumber = value
            End Set
        End Property

        Public Property Spanish() As Boolean
            Get
                Return _Spanish
            End Get
            Set(ByVal value As Boolean)
                _Spanish = value
            End Set
        End Property

        Public Property Trickle() As Integer
            Get
                Return _Trickle
            End Get
            Set(value As Integer)
                _Trickle = value
            End Set
        End Property

        Public Property Throttle() As Boolean
            Get
                Return _throttle
            End Get
            Set(ByVal value As Boolean)
                _throttle = value
            End Set
        End Property

        Public Property Vertical() As String
            Get
                Return _Vertical
            End Get
            Set(ByVal value As String)
                _Vertical = value
            End Set
        End Property

        Public Property WebsiteTypeid() As Integer
            Get
                Return _WebsiteTypeid
            End Get
            Set(ByVal value As Integer)
                _WebsiteTypeid = value
            End Set
        End Property

        Public Property Weight() As Double
            Get
                Return _weight
            End Get
            Set(ByVal value As Double)
                _weight = value
            End Set
        End Property

        Public Property NoScrub() As Boolean
            Get
                Return _NoScrub
            End Get
            Set(ByVal value As Boolean)
                _NoScrub = value
            End Set
        End Property

#End Region 'Properties

#Region "Methods"

        Public Shared Function getBuyerContracts(ByVal sortField As String, ByVal sortOrder As String, _
                                                 ByVal contractactive As Integer, _
                                                 ByVal showcallcenter As Integer, _
                                                 ByVal verticalid As Integer) As List(Of BuyerContractObject)
            Dim lst As List(Of BuyerContractObject) = getBuyerContracts(-1, contractactive, showcallcenter, verticalid)

            If Not IsNothing(sortField) Then
                lst.Sort(New BuyerContractComparer(sortField, sortOrder))
            End If
            Return lst
        End Function

        Public Shared Function getBuyerContracts(ByVal buyerID As Integer, _
                                                 ByVal bActive As Integer, _
                                                 ByVal bOnlyCallCenter As Integer, _
                                                 ByVal verticalid As Integer) As List(Of BuyerContractObject)

            getBuyerContracts = New List(Of BuyerContractObject)
            Dim ssql As String = "stp_buyer_getContracts"
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("buyerid", buyerID))
            If bActive <> -1 Then
                params.Add(New SqlParameter("active", bActive))
            End If
            If bOnlyCallCenter <> -1 Then
                params.Add(New SqlParameter("callcenter", bOnlyCallCenter))
            End If
            If verticalid <> -1 Then
                params.Add(New SqlParameter("verticalid", verticalid))
            End If

            Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.StoredProcedure, params.ToArray)
                For Each dr As DataRow In dt.Rows
                    Try
                        getBuyerContracts.Add(New BuyerContractObject() With {.BuyerID = dr("buyerid").ToString, _
                                                                                    .BuyerOfferXrefID = dr("BuyerOfferXrefID").ToString, _
                                                                                   .Buyer = dr("Buyer").ToString, _
                                                                                   .ContractName = dr("ContractName").ToString, _
                                                                                   .DataTransfer = dr("DataTransfer").ToString, _
                                                                                   .CallTransfer = dr("CallTransfer").ToString, _
                                                                                   .Instructions = dr("instructions").ToString, _
                                                                                   .ServicePhoneNumber = dr("ServicePhoneNumber").ToString, _
                                                                                   .ExcludedStates = dr("ExcludedStates").ToString, _
                                                                                   .DailyCap = dr("DailyCap").ToString, _
                                                                                   .Created = dr("Created").ToString, _
                                                                                   .Active = dr("Active").ToString, _
                                                                                   .MinDebt = dr("MinDebt").ToString, _
                                                                                   .Exclusive = dr("Exclusive").ToString, _
                                                                                   .PointValue = dr("PointValue").ToString, _
                                                                                   .Vertical = dr("Vertical").ToString, _
                                                                                   .Spanish = dr("Spanish").ToString, _
                                                                                   .InvoicePrice = Val(dr("InvoicePrice")), _
                                                                                   .Price = dr("Price").ToString, _
                                                                                   .BuyerCode = dr("BuyerCode").ToString, _
                                                                                   .BuyerActive = dr("BuyerActive").ToString, _
                                                                                   .OfferID = dr("OfferID").ToString, _
                                                                                   .Offer = dr("Offer").ToString, _
                                                                                   .OfferActive = dr("OfferActive").ToString, _
                                                                                   .Weight = dr("Weight").ToString, _
                                                                                   .DupAttempt = dr("DupAttempt").ToString, _
                                                                                   .Throttle = dr("Throttle").ToString, _
                                                                                   .DataSQL = dr("DataSQL").ToString, _
                                                                                   .DoCakePost = dr("DoCakePost").ToString, _
                                                                                   .CakePostKey = dr("CakePostKey").ToString, _
                                                                                   .CakeCampaignId = dr("CakeCampaignId").ToString, _
                                                                                   .CallCenter = dr("CallCenter").ToString, _
                                                                                   .DataSortField = dr("datasortfieldname").ToString, _
                                                                                   .DataSortDir = dr("datasortdirection").ToString, _
                                                                                   .ContractTypeID = dr("ContractTypeID").ToString, _
                                                                                   .WebsiteTypeid = dr("WebsiteTypeid").ToString, _
                                                                                   .Priority = dr("Priority").ToString, _
                                                                                   .ExcludeDNC = dr("ExcludeDNC"), _
                                                                                   .WirelessOnly = dr("WirelessOnly"), _
                                                                                   .LandlineOnly = dr("LandlineOnly")})
                    Catch ex As Exception
                        Throw
                    End Try
                Next
            End Using
        End Function

        Public Shared Function getBuyerContract(ByVal BuyerOfferXrefID As Integer) As BuyerContractObject
            Dim bco As BuyerContractObject = Nothing
            Dim ssql As String = "stp_datamgr_getContract"
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("BuyerOfferXrefID", BuyerOfferXrefID))

            Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.StoredProcedure, params.ToArray)
                For Each dr As DataRow In dt.Rows
                    Try
                        bco = New BuyerContractObject()
                        With bco
                            .BuyerID = dr("buyerid").ToString
                            .BuyerOfferXrefID = dr("BuyerOfferXrefID").ToString
                            .Buyer = dr("Buyer").ToString
                            .ContractName = dr("ContractName").ToString
                            .DataTransfer = dr("DataTransfer").ToString
                            .CallTransfer = dr("CallTransfer").ToString
                            .Instructions = dr("instructions").ToString
                            .ServicePhoneNumber = dr("ServicePhoneNumber").ToString
                            .ExcludedStates = dr("ExcludedStates").ToString
                            .DailyCap = dr("DailyCap").ToString
                            .Created = dr("Created").ToString
                            .Active = dr("Active").ToString
                            .MinDebt = dr("MinDebt").ToString
                            .Exclusive = dr("Exclusive").ToString
                            .PointValue = dr("PointValue").ToString
                            .Vertical = dr("Vertical").ToString
                            .Spanish = dr("Spanish").ToString
                            .InvoicePrice = Val(dr("InvoicePrice"))
                            .Price = dr("Price").ToString
                            .BuyerCode = dr("BuyerCode").ToString
                            .BuyerActive = dr("BuyerActive").ToString
                            .OfferID = dr("OfferID").ToString
                            .Offer = dr("Offer").ToString
                            .OfferActive = dr("OfferActive").ToString
                            .Weight = dr("Weight").ToString
                            .DupAttempt = dr("DupAttempt").ToString
                            .Throttle = dr("Throttle").ToString
                            .DataSQL = dr("DataSQL").ToString
                            .DoCakePost = dr("DoCakePost").ToString
                            .CakePostKey = dr("CakePostKey").ToString
                            .CakeCampaignId = dr("CakeCampaignId").ToString
                            .CallCenter = dr("CallCenter").ToString
                            .DataSortField = dr("datasortfieldname").ToString
                            .DataSortDir = dr("datasortdirection").ToString
                            .ContractTypeID = dr("ContractTypeID").ToString
                            .Priority = dr("Priority").ToString
                            .WebsiteTypeid = dr("WebsiteTypeid").ToString
                            .NoScrub = dr("NoScrub")
                            .ExcludeDNC = dr("ExcludeDNC")
                            .WirelessOnly = dr("WirelessOnly")
                            .LandlineOnly = dr("LandlineOnly")
                            '.MinutesBackForLeads = dr("MinutesBack")
                            '.AgedMinutes = dr("AgedMinutes")
                            '.RealTimeMinutes = dr("RealTimeMinutes")
                            '.Trickle = dr("Trickle")
                        End With
                    Catch ex As Exception
                        Throw
                    End Try
                    Exit For
                Next
            End Using
            Return bco
        End Function

#End Region 'Methods

        Private disposedValue As Boolean = False        ' To detect redundant calls

        ' IDisposable
        Protected Overridable Sub Dispose(ByVal disposing As Boolean)
            If Not Me.disposedValue Then
                If disposing Then
                    ' TODO: free other state (managed objects).
                End If

                ' TODO: free your own state (unmanaged objects).
                ' TODO: set large fields to null.
            End If
            Me.disposedValue = True
        End Sub

#Region " IDisposable Support "
        ' This code added by Visual Basic to correctly implement the disposable pattern.
        Public Sub Dispose() Implements IDisposable.Dispose
            ' Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
            Dispose(True)
            GC.SuppressFinalize(Me)
        End Sub
#End Region

    End Class

    <DataObject(True)> _
    Public Class BuyersObject

#Region "Fields"

        Private _AccountManager As String
        Private _Active As Boolean
        Private _Address As String
        Private _BillingCycle As String
        Private _Buyer As String
        Private _BuyerCode As String
        Private _BuyerID As Integer
        Private _City As String
        Private _Contacts As List(Of ContactObject)
        Private _Contracts As List(Of BuyerContractObject)
        Private _Country As String
        Private _Created As String
        Private _State As String
        Private _Zip As String
        Private _documents As List(Of DocumentObject)
        Private _Notes As String
#End Region 'Fields

#Region "Properties"

        Public Property AccountManager() As String
            Get
                Return _AccountManager
            End Get
            Set(ByVal value As String)
                _AccountManager = value
            End Set
        End Property

        Public Property Active() As Boolean
            Get
                Return _Active
            End Get
            Set(ByVal value As Boolean)
                _Active = value
            End Set
        End Property

        Public Property Address() As String
            Get
                Return _Address
            End Get
            Set(ByVal value As String)
                _Address = value
            End Set
        End Property

        Public Property BillingCycle() As String
            Get
                Return _BillingCycle
            End Get
            Set(ByVal value As String)
                _BillingCycle = value
            End Set
        End Property

        Public Property Buyer() As String
            Get
                Return _Buyer
            End Get
            Set(ByVal Value As String)
                _Buyer = Value
            End Set
        End Property

        Public Property BuyerCode() As String
            Get
                Return _BuyerCode
            End Get
            Set(ByVal Value As String)
                _BuyerCode = Value
            End Set
        End Property

        Public Property BuyerID() As Integer
            Get
                Return _BuyerID
            End Get
            Set(ByVal Value As Integer)
                _BuyerID = Value
            End Set
        End Property

        Public Property City() As String
            Get
                Return _City
            End Get
            Set(ByVal value As String)
                _City = value
            End Set
        End Property

        Public Property Contacts() As List(Of ContactObject)
            Get
                Return _Contacts
            End Get
            Set(ByVal value As List(Of ContactObject))
                _Contacts = value
            End Set
        End Property

        Public Property Contracts() As List(Of BuyerContractObject)
            Get
                Return _Contracts
            End Get
            Set(ByVal value As List(Of BuyerContractObject))
                _Contracts = value
            End Set
        End Property

        Public Property Country() As String
            Get
                Return _Country
            End Get
            Set(ByVal value As String)
                _Country = value
            End Set
        End Property

        Public Property Created() As String
            Get
                Return _Created
            End Get
            Set(ByVal value As String)
                _Created = value
            End Set
        End Property

        Public Property Documents() As List(Of DocumentObject)
            Get
                Return _documents
            End Get
            Set(ByVal value As List(Of DocumentObject))
                _documents = value
            End Set
        End Property

        Public Property Notes() As String
            Get
                Return _Notes
            End Get
            Set(ByVal value As String)
                _Notes = value
            End Set
        End Property
        Public Property State() As String
            Get
                Return _State
            End Get
            Set(ByVal value As String)
                _State = value
            End Set
        End Property

        Public Property Zip() As String
            Get
                Return _Zip
            End Get
            Set(ByVal value As String)
                _Zip = value
            End Set
        End Property

#End Region 'Properties

#Region "Methods"

        Public Shared Function GetContacts(ByVal buyerid As Integer) As List(Of ContactObject)
            GetContacts = New List(Of ContactObject)
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("buyerid", buyerid))
            Using dt As DataTable = SqlHelper.GetDataTable("stp_buyer_getcontacts", CommandType.StoredProcedure, params.ToArray)
                For Each dr As DataRow In dt.Rows
                    Dim c As New ContactObject
                    c.ParentID = buyerid
                    c.ContactID = dr("ContactID").ToString
                    c.FullName = dr("FullName").ToString
                    c.Email = dr("Email").ToString
                    c.Phone = dr("Phone").ToString
                    c.Notes = dr("Notes").ToString
                    c.Billing = dr("Billing").ToString
                    GetContacts.Add(c)
                Next
            End Using
        End Function

        Public Shared Function GetDocuments(ByVal buyerid As Integer) As List(Of DocumentObject)
            GetDocuments = New List(Of DocumentObject)
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("buyerid", buyerid))
            Using dt As DataTable = SqlHelper.GetDataTable("stp_buyer_getdocuments", CommandType.StoredProcedure, params.ToArray)
                For Each dr As DataRow In dt.Rows
                    Dim d As New DocumentObject
                    d.DocumentID = dr("fileid").ToString
                    d.Filename = dr("file").ToString
                    d.FilePath = dr("FilePath").ToString
                    d.DateAdded = dr("DateAdded").ToString
                    d.Portal = dr("Portal").ToString
                    d.Type = dr("Type").ToString

                    GetDocuments.Add(d)
                Next
            End Using
        End Function

#End Region 'Methods

    End Class

    Public Class ContactObjactComparer
        Implements IComparer(Of ContactObject)

#Region "Fields"

        Private ReadOnly _sortField As String
        Private ReadOnly _sortOrder As String

#End Region 'Fields

#Region "Constructors"

        Public Sub New(ByVal propertyName As String, ByVal order As String)
            _sortField = propertyName
            _sortOrder = If((String.IsNullOrEmpty(order) OrElse (Not order.Equals("ASC") AndAlso Not order.Equals("DESC"))), "ASC", order)
        End Sub

#End Region 'Constructors

#Region "Methods"

        Public Function Compare(ByVal x As ContactObject, ByVal y As ContactObject) As Integer Implements System.Collections.Generic.IComparer(Of ContactObject).Compare
            Dim [property] As PropertyInfo = x.[GetType]().GetProperty(_sortField)
            If IsNothing([property]) Then
                Throw New ApplicationException("Invalid property " + _sortField)
            End If
            If _sortOrder.Equals("ASC") Then
                Return Comparer.DefaultInvariant.Compare([property].GetValue(x, Nothing), [property].GetValue(y, Nothing))
            Else
                Return Comparer.DefaultInvariant.Compare([property].GetValue(y, Nothing), [property].GetValue(x, Nothing))
            End If
        End Function

#End Region 'Methods

    End Class

    Public Class ContactObject

#Region "Fields"

        Private _BuyerID As Integer
        Private _ContactID As Integer
        Private _Email As String
        Private _FullName As String
        Private _Phone As String
        Private _Notes As String
        Private _Billing As Boolean
#End Region 'Fields

#Region "Properties"

        Public Property Billing() As Boolean
            Get
                Return _Billing
            End Get
            Set(ByVal value As Boolean)
                _Billing = value
            End Set
        End Property
        Public Property ParentID() As Integer
            Get
                Return _BuyerID
            End Get
            Set(ByVal value As Integer)
                _BuyerID = value
            End Set
        End Property

        Public Property ContactID() As Integer
            Get
                Return _ContactID
            End Get
            Set(ByVal value As Integer)
                _ContactID = value
            End Set
        End Property

        Public Property Email() As String
            Get
                Return _Email
            End Get
            Set(ByVal value As String)
                _Email = value
            End Set
        End Property

        Public Property FullName() As String
            Get
                Return _FullName
            End Get
            Set(ByVal value As String)
                _FullName = value
            End Set
        End Property

        Public Property Phone() As String
            Get
                Return _Phone
            End Get
            Set(ByVal value As String)
                _Phone = value
            End Set
        End Property

        Public Property Notes() As String
            Get
                Return _Notes
            End Get
            Set(ByVal value As String)
                _Notes = value
            End Set
        End Property
#End Region 'Properties

    End Class

    <DataObject(True)> _
    Public Class DocumentObject

#Region "Fields"

        Private _dateAdded As String
        Private _documentid As Integer
        Private _filePath As String
        Private _filename As String
        Private _portal As String
        Private _type As String

#End Region 'Fields

#Region "Properties"

        Public Property DateAdded() As String
            Get
                Return _dateAdded
            End Get
            Set(ByVal value As String)
                _dateAdded = value
            End Set
        End Property

        Public Property DocumentID() As Integer
            Get
                Return _documentid
            End Get
            Set(ByVal value As Integer)
                _documentid = value
            End Set
        End Property

        Public Property FilePath() As String
            Get
                Return _filePath
            End Get
            Set(ByVal value As String)
                _filePath = value
            End Set
        End Property

        Public Property Filename() As String
            Get
                Return _filename
            End Get
            Set(ByVal value As String)
                _filename = value
            End Set
        End Property

        Public Property Portal() As String
            Get
                Return _portal
            End Get
            Set(ByVal value As String)
                _portal = value
            End Set
        End Property

        Public Property Type() As String
            Get
                Return _type
            End Get
            Set(ByVal value As String)
                _type = value
            End Set
        End Property

#End Region 'Properties

    End Class

    Public Class DocumentObjectComparer
        Implements IComparer(Of DocumentObject)

#Region "Fields"

        Private ReadOnly _sortField As String
        Private ReadOnly _sortOrder As String

#End Region 'Fields

#Region "Constructors"

        Public Sub New(ByVal propertyName As String, ByVal order As String)
            _sortField = propertyName
            _sortOrder = If((String.IsNullOrEmpty(order) OrElse (Not order.Equals("ASC") AndAlso Not order.Equals("DESC"))), "ASC", order)
        End Sub

#End Region 'Constructors

#Region "Methods"

        Public Function Compare(ByVal x As DocumentObject, ByVal y As DocumentObject) As Integer Implements System.Collections.Generic.IComparer(Of DocumentObject).Compare
            Dim [property] As PropertyInfo = x.[GetType]().GetProperty(_sortField)
            If IsNothing([property]) Then
                Throw New ApplicationException("Invalid property " + _sortField)
            End If
            If _sortOrder.Equals("ASC") Then
                Return Comparer.DefaultInvariant.Compare([property].GetValue(x, Nothing), [property].GetValue(y, Nothing))
            Else
                Return Comparer.DefaultInvariant.Compare([property].GetValue(y, Nothing), [property].GetValue(x, Nothing))
            End If
        End Function

#End Region 'Methods

    End Class

#End Region 'Nested Types

End Class
