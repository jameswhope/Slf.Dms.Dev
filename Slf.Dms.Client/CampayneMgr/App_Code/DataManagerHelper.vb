Imports System.ComponentModel
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Net
Imports System.Reflection
Imports System.Runtime.Serialization

Imports Microsoft.VisualBasic
Imports System.Xml

Public Class DataManagerHelper

#Region "Methods"

    Public Shared Function GetStoredProcParams(ByVal spName As String) As List(Of String)
        Dim params As New List(Of String)

        ' build the SQL query

        Dim sql As String = String.Format("select parameter_name from information_schema.parameters where specific_name = '{0}'", spName)
        Try
            Using reader = SqlHelper.GetDataTable(sql, CommandType.Text)
                For Each dr As DataRow In reader.Rows
                    params.Add(dr(0))
                Next
            End Using

        Catch ex As Exception
            Return Nothing
        End Try

        Return params
    End Function

    Public Shared Function PostTestData(ByVal LeadID As Integer, ByVal postData As String, ByVal requestUri As String, ByVal throttle As Boolean, Optional ByRef fatalError As Boolean = False) As String
        Dim results As String = ""
        Dim rand As New Random

        If throttle Then
            Dim ms As Integer = rand.Next(100, 500) '.1-.5 sec
            System.Threading.Thread.Sleep(ms)
        End If

        Try
            Dim req As HttpWebRequest = WebRequest.Create(requestUri)
            req.Method = "POST"
            If postData.Contains("?xml") Then
                req.ContentType = "text/xml"
            Else
                req.ContentType = "application/x-www-form-urlencoded"
            End If
            req.ContentLength = postData.Length

            Dim encoding As New System.Text.ASCIIEncoding
            Dim data() As Byte = encoding.GetBytes(postData)
            Dim stream As IO.Stream = req.GetRequestStream
            stream.Write(data, 0, data.Length) 'send the data
            stream.Close()

            Dim resp As HttpWebResponse = req.GetResponse
            Dim sr As New StreamReader(resp.GetResponseStream)
            results = sr.ReadToEnd
            sr.Close()
            resp.Close()
        Catch ex As Exception
            Select Case ex.Message
                Case "Unable to connect to the remote server"
                    fatalError = True
            End Select
            results = ex.Message
        End Try

        Return results
    End Function

#End Region 'Methods

#Region "Nested Types"

    Public Class DataPostObject

#Region "Fields"

        Private _Address As String
        Private _BestTimeToCall As String
        Private _CakeLeadId As String
        Private _CallAgainAfter As String
        Private _CampaignID As String
        Private _City As String
        Private _Created As String
        Private _DOB As String
        Private _DialerCount As String
        Private _Dups As String
        Private _Email As String
        Private _FirstName As String
        Private _FullName As String
        Private _LastDup As String
        Private _LastModified As String
        Private _LastModifiedBy As String
        Private _LastName As String
        Private _LeadID As String
        Private _MiddleName As String
        Private _MyGUID As String
        Private _Phone As String
        Private _ProductID As String
        Private _ProductCode As String
        Private _RemoteAddr As String
        Private _SSN As String
        Private _Spanish As String
        Private _StateCode As String
        Private _SubID As String
        Private _Throttle As String
        Private _Unsubscribe As String
        Private _VisitID As String
        Private _Website As String
        Private _WorkPhone As String
        Private _ZipCode As String
        Private _dailycap As String
        Private _leadstatusid As String
        Private _offerid As String
        Private _program As String
        Private _sold As String
        Private _programcode As String
        Private _SchoolType As String
        Private _GradYear As Integer
        Private _Goal As String
        Private _CareerInterest As String

#End Region 'Fields

#Region "Properties"

        Public Property Address() As String
            Get
                Return _Address
            End Get
            Set(ByVal value As String)
                _Address = value
            End Set
        End Property

        Public Property BestTimeToCall() As String
            Get
                Return _BestTimeToCall
            End Get
            Set(ByVal value As String)
                _BestTimeToCall = value
            End Set
        End Property

        Public Property CakeLeadId() As String
            Get
                Return _CakeLeadId
            End Get
            Set(ByVal value As String)
                _CakeLeadId = value
            End Set
        End Property

        Public Property CallAgainAfter() As String
            Get
                Return _CallAgainAfter
            End Get
            Set(ByVal value As String)
                _CallAgainAfter = value
            End Set
        End Property

        Public Property CampaignID() As String
            Get
                Return _CampaignID
            End Get
            Set(ByVal value As String)
                _CampaignID = value
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

        Public Property Created() As String
            Get
                Return _Created
            End Get
            Set(ByVal value As String)
                _Created = value
            End Set
        End Property

        Public Property DOB() As String
            Get
                Return _DOB
            End Get
            Set(ByVal value As String)
                _DOB = value
            End Set
        End Property

        Public Property DialerCount() As String
            Get
                Return _DialerCount
            End Get
            Set(ByVal value As String)
                _DialerCount = value
            End Set
        End Property

        Public Property Dups() As String
            Get
                Return _Dups
            End Get
            Set(ByVal value As String)
                _Dups = value
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

        Public Property FirstName() As String
            Get
                Return _FirstName
            End Get
            Set(ByVal value As String)
                _FirstName = value
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

        Public Property Goal() As String
            Get
                Return _Goal
            End Get
            Set(ByVal value As String)
                _Goal = value
            End Set
        End Property
        Public Property GradYear() As Integer
            Get
                Return _GradYear
            End Get
            Set(ByVal value As Integer)
                _GradYear = value
            End Set
        End Property
        Public Property LastDup() As String
            Get
                Return _LastDup
            End Get
            Set(ByVal value As String)
                _LastDup = value
            End Set
        End Property

        Public Property LastModified() As String
            Get
                Return _LastModified
            End Get
            Set(ByVal value As String)
                _LastModified = value
            End Set
        End Property

        Public Property LastModifiedBy() As String
            Get
                Return _LastModifiedBy
            End Get
            Set(ByVal value As String)
                _LastModifiedBy = value
            End Set
        End Property

        Public Property LastName() As String
            Get
                Return _LastName
            End Get
            Set(ByVal value As String)
                _LastName = value
            End Set
        End Property

        Public Property LeadID() As String
            Get
                Return _LeadID
            End Get
            Set(ByVal value As String)
                _LeadID = value
            End Set
        End Property

        Public Property MiddleName() As String
            Get
                Return _MiddleName
            End Get
            Set(ByVal value As String)
                _MiddleName = value
            End Set
        End Property

        Public Property MyGUID() As String
            Get
                Return _MyGUID
            End Get
            Set(ByVal value As String)
                _MyGUID = value
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

        Public Property ProductCode() As String
            Get
                Return _ProductCode
            End Get
            Set(ByVal value As String)
                _ProductCode = value
            End Set
        End Property
        Public Property ProductID() As String
            Get
                Return _ProductID
            End Get
            Set(ByVal value As String)
                _ProductID = value
            End Set
        End Property

        Public Property Programcode() As String
            Get
                Return _programcode
            End Get
            Set(ByVal value As String)
                _programcode = value
            End Set
        End Property
        Public Property RemoteAddr() As String
            Get
                Return _RemoteAddr
            End Get
            Set(ByVal value As String)
                _RemoteAddr = value
            End Set
        End Property

        Public Property SchoolType() As String
            Get
                Return _SchoolType
            End Get
            Set(ByVal value As String)
                _SchoolType = value
            End Set
        End Property
        Public Property SSN() As String
            Get
                Return _SSN
            End Get
            Set(ByVal value As String)
                _SSN = value
            End Set
        End Property

        Public Property Spanish() As String
            Get
                Return _Spanish
            End Get
            Set(ByVal value As String)
                _Spanish = value
            End Set
        End Property

        Public Property StateCode() As String
            Get
                Return _StateCode
            End Get
            Set(ByVal value As String)
                _StateCode = value
            End Set
        End Property

        Public Property SubID() As String
            Get
                Return _SubID
            End Get
            Set(ByVal value As String)
                _SubID = value
            End Set
        End Property

        Public Property Throttle() As String
            Get
                Return _Throttle
            End Get
            Set(ByVal value As String)
                _Throttle = value
            End Set
        End Property

        Public Property Unsubscribe() As String
            Get
                Return _Unsubscribe
            End Get
            Set(ByVal value As String)
                _Unsubscribe = value
            End Set
        End Property

        Public Property VisitID() As String
            Get
                Return _VisitID
            End Get
            Set(ByVal value As String)
                _VisitID = value
            End Set
        End Property

        Public Property Website() As String
            Get
                Return _Website
            End Get
            Set(ByVal value As String)
                _Website = value
            End Set
        End Property

        Public Property WorkPhone() As String
            Get
                Return _WorkPhone
            End Get
            Set(ByVal value As String)
                _WorkPhone = value
            End Set
        End Property

        Public Property ZipCode() As String
            Get
                Return _ZipCode
            End Get
            Set(ByVal value As String)
                _ZipCode = value
            End Set
        End Property

        Public Property dailycap() As String
            Get
                Return _dailycap
            End Get
            Set(ByVal value As String)
                _dailycap = value
            End Set
        End Property

        Public Property leadstatusid() As String
            Get
                Return _leadstatusid
            End Get
            Set(ByVal value As String)
                _leadstatusid = value
            End Set
        End Property

        Public Property offerid() As String
            Get
                Return _offerid
            End Get
            Set(ByVal value As String)
                _offerid = value
            End Set
        End Property

        Public Property program() As String
            Get
                Return _program
            End Get
            Set(ByVal value As String)
                _program = value
            End Set
        End Property

        Public Property sold() As String
            Get
                Return _sold
            End Get
            Set(ByVal value As String)
                _sold = value
            End Set
        End Property

        Public Property CareerInterest As String
            Get
                Return _CareerInterest
            End Get
            Set(ByVal value As String)
                _CareerInterest = value
            End Set
        End Property

#End Region 'Properties

#Region "Methods"

        'Public Shared Function GetTestData(ByVal dmo As DeliveryMethodObject) As DataPostObject
        '    'get data
        '    'Dim sParams As List(Of String) = GetStoredProcParams(dmo.DataProcedureName)
        '    Dim params As New List(Of SqlParameter)
        '    params.Add(New SqlParameter("buyerid", dmo.Buyerid))

        '    'For i As Integer = 0 To sParams.Count - 1
        '    '    If sParams(i).ToLower = "@Buyerid".ToLower Then
        '    '        params.Add(New SqlParameter("buyerid", dmo.Buyerid))
        '    '    End If
        '    'Next

        '    Using dtData As DataTable = SqlHelper.GetDataTable("stp_datamgr_TestLead", CommandType.StoredProcedure, params.ToArray)
        '        Dim postList As New List(Of DataPostObject)
        '        GetTestData = New DataPostObject
        '        For Each pr As DataRow In dtData.Rows
        '            GetTestData.LeadID = pr("LeadID").ToString
        '            GetTestData.FirstName = pr("FirstName").ToString
        '            GetTestData.LastName = pr("LastName").ToString
        '            GetTestData.Phone = pr("Phone").ToString
        '            GetTestData.Email = pr("Email").ToString
        '            GetTestData.StateCode = pr("StateCode").ToString
        '            GetTestData.ZipCode = pr("ZipCode").ToString
        '            GetTestData.Created = pr("Created").ToString
        '            GetTestData.WorkPhone = pr("WorkPhone").ToString
        '            GetTestData.Address = pr("Address").ToString
        '            GetTestData.City = pr("City").ToString
        '            GetTestData.Programcode = pr("ProgramCode").ToString
        '            GetTestData.program = pr("Program").ToString
        '            GetTestData.RemoteAddr = pr("RemoteAddr").ToString
        '            GetTestData.Website = pr("Website").ToString
        '            GetTestData.CareerInterest = pr("CareerInterest").ToString
        '            GetTestData.GradYear = pr("GradYear")
        '            GetTestData.Goal = pr("Goal").ToString
        '            GetTestData.SchoolType = pr("SchoolType").ToString
        '            Exit For
        '        Next
        '    End Using

        '    Return GetTestData
        'End Function

#End Region 'Methods

    End Class

    Public Class DeliveryMethodObject
        Implements IDisposable

#Region "Fields"

        Private _AgedMinutes As Integer
        Private _BuyerName As String
        Private _BuyerOfferXrefID As Integer
        Private _CakeCampaignId As Integer
        Private _CakePostKey As String
        Private _ContractTypeDesc As String
        Private _ContractTypeID As Integer
        Private _DailyCap As Integer
        Private _DataProcedureName As String
        Private _DeliveryMethodID As Integer
        Private _Offer As String
        Private _OfferId As Integer
        Private _OfferPriority As Integer
        Private _postFields As New List(Of PostFieldObject)
        Private _PostData As New List(Of DataPostObject)
        Private _PostToCake As Boolean
        Private _PostUrl As String
        Private _Price As Double
        Private _Priority As Integer
        Private _RealTimeMinutes As Integer
        Private _ResponseResultCode_XML As String
        Private _ResponseResultError_XML As String
        Private _ResponseResultID_XML As String
        Private _ResponseSuccessText As String
        Private _Throttle As Boolean
        Private _Trickle As Integer
        Private _buyerID As Integer
        Private _contractName As String
        Private _dataSortDirection As String
        Private _dataSortFieldName As String
        Private _deliverySchedule As New List(Of DeliveryScheduleObject)
        Private _exclusive As Boolean
        Private _postDataFields As New List(Of PostDataFieldObject)
        Private _resultType As String
        Private _weight As Double
        Private _NoScrub As Boolean
        Private _ExcludeDNC As Boolean
        Private _WirelessOnly As Boolean
        Private _LandlineOnly As Boolean
        Private _Method As String
        Private _NoPacing As Boolean

        Private disposedValue As Boolean = False 'To detect redundant calls

#End Region 'Fields

#Region "Properties"

        Public Property NoPacing As Boolean
            Get
                Return _NoPacing
            End Get
            Set(value As Boolean)
                _NoPacing = value
            End Set
        End Property

        Public Property Method As String
            Get
                Return _Method
            End Get
            Set(value As String)
                _Method = value
            End Set
        End Property

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

        Public Property BuyerID() As Integer
            Get
                Return _buyerID
            End Get
            Set(ByVal value As Integer)
                _buyerID = value
            End Set
        End Property

        Public Property BuyerName() As String
            Get
                Return _BuyerName
            End Get
            Set(ByVal value As String)
                _BuyerName = value
            End Set
        End Property

        Public Property BuyerOfferXrefID() As Integer
            Get
                Return _BuyerOfferXrefID
            End Get
            Set(ByVal Value As Integer)
                _BuyerOfferXrefID = Value
            End Set
        End Property

        Public Property CakeCampaignId() As Integer
            Get
                Return _CakeCampaignId
            End Get
            Set(ByVal Value As Integer)
                _CakeCampaignId = Value
            End Set
        End Property

        Public Property CakePostKey() As String
            Get
                Return _CakePostKey
            End Get
            Set(ByVal Value As String)
                _CakePostKey = Value
            End Set
        End Property

        Public Property ContractName() As String
            Get
                Return _contractName
            End Get
            Set(ByVal value As String)
                _contractName = value
            End Set
        End Property

        Public Property ContractTypeDesc() As String
            Get
                Return _ContractTypeDesc
            End Get
            Set(ByVal value As String)
                _ContractTypeDesc = value
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

        Public Property DailyCap() As Integer
            Get
                Return _DailyCap
            End Get
            Set(ByVal value As Integer)
                _DailyCap = value
            End Set
        End Property

        Public Property DataProcedureName() As String
            Get
                Return _DataProcedureName
            End Get
            Set(ByVal value As String)
                _DataProcedureName = value
            End Set
        End Property

        Public Property DataSortDirection() As String
            Get
                Return _dataSortDirection
            End Get
            Set(ByVal value As String)
                _dataSortDirection = value
            End Set
        End Property

        Public Property DataSortFieldName() As String
            Get
                Return _dataSortFieldName
            End Get
            Set(ByVal value As String)
                _dataSortFieldName = value
            End Set
        End Property

        Public Property DeliveryMethodID() As Integer
            Get
                Return _DeliveryMethodID
            End Get
            Set(ByVal Value As Integer)
                _DeliveryMethodID = Value
            End Set
        End Property

        Public Property DeliverySchedule() As List(Of DeliveryScheduleObject)
            Get
                Return _deliverySchedule
            End Get
            Set(ByVal value As List(Of DeliveryScheduleObject))
                _deliverySchedule = value
            End Set
        End Property

        Public Property Exclusive() As Boolean
            Get
                Return _exclusive
            End Get
            Set(ByVal value As Boolean)
                _exclusive = value
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

        Public Property OfferId() As Integer
            Get
                Return _OfferId
            End Get
            Set(ByVal value As Integer)
                _OfferId = value
            End Set
        End Property

        Public Property OfferPriority() As Integer
            Get
                Return _OfferPriority
            End Get
            Set(ByVal value As Integer)
                _OfferPriority = value
            End Set
        End Property

        Public Property PostData() As List(Of DataPostObject)
            Get
                Return _PostData
            End Get
            Set(ByVal value As List(Of DataPostObject))
                _PostData = value
            End Set
        End Property

        Public Property PostFields() As List(Of PostFieldObject)
            Get
                Return _postFields
            End Get
            Set(ByVal value As List(Of PostFieldObject))
                _postFields = value
            End Set
        End Property

        Public Property PostDataFields() As List(Of PostDataFieldObject)
            Get
                Return _postDataFields
            End Get
            Set(ByVal value As List(Of PostDataFieldObject))
                _postDataFields = value
            End Set
        End Property

        Public Property PostToCake() As Boolean
            Get
                Return _PostToCake
            End Get
            Set(ByVal value As Boolean)
                _PostToCake = value
            End Set
        End Property

        Public Property PostUrl() As String
            Get
                Return _PostUrl
            End Get
            Set(ByVal Value As String)
                _PostUrl = Value
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

        Public Property Priority() As Integer
            Get
                Return _Priority
            End Get
            Set(ByVal value As Integer)
                _Priority = value
            End Set
        End Property

        Public Property ResponseResultCode_XML() As String
            Get
                Return _ResponseResultCode_XML
            End Get
            Set(ByVal value As String)
                _ResponseResultCode_XML = value
            End Set
        End Property

        Public Property ResponseResultError_XML() As String
            Get
                Return _ResponseResultError_XML
            End Get
            Set(ByVal value As String)
                _ResponseResultError_XML = value
            End Set
        End Property

        Public Property ResponseResultID_XML() As String
            Get
                Return _ResponseResultID_XML
            End Get
            Set(ByVal value As String)
                _ResponseResultID_XML = value
            End Set
        End Property

        Public Property ResponseSuccessText() As String
            Get
                Return _ResponseSuccessText
            End Get
            Set(ByVal value As String)
                _ResponseSuccessText = value
            End Set
        End Property

        Public Property ResultType() As String
            Get
                Return _resultType
            End Get
            Set(ByVal value As String)
                _resultType = value
            End Set
        End Property

        Public Property Throttle() As Boolean
            Get
                Return _Throttle
            End Get
            Set(ByVal value As Boolean)
                _Throttle = value
            End Set
        End Property

        Public Property Weight() As Integer
            Get
                Return _weight
            End Get
            Set(ByVal value As Integer)
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

        Public Property AgedMinutes() As Integer
            Get
                Return _AgedMinutes
            End Get
            Set(value As Integer)
                _AgedMinutes = value
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

        Public Property Trickle() As Integer
            Get
                Return _Trickle
            End Get
            Set(value As Integer)
                _Trickle = value
            End Set
        End Property

#End Region 'Properties

#Region "Methods"

        Public Shared Function GetAllByID(ByVal BuyerOfferXrefIDs As String()) As List(Of DeliveryMethodObject)
            GetAllByID = New List(Of DeliveryMethodObject)
            Dim ssql As String = "SELECT BuyerOfferXrefID from tblBuyerOfferXref "
            ssql += String.Format("WHERE BuyerOfferXrefID in ({0})", Join(BuyerOfferXrefIDs, ","))
            ssql += " ORDER BY Priority"
            Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)
                For Each dr As DataRow In dt.Rows
                    GetAllByID.Add(DeliveryMethodObject.GetDeliveryMethod(dr(0).ToString, False))
                Next
            End Using
        End Function

        Public Shared Function GetDeliveryMethod(ByVal buyerOfferXrefID As Integer, Optional ByVal bWithData As Boolean = True) As DeliveryMethodObject
            GetDeliveryMethod = New DeliveryMethodObject
            Using dt As DataTable = SqlHelper.GetDataTable(String.Format("stp_datamgr_getDeliveryMethod {0}", buyerOfferXrefID), CommandType.Text)
                For Each dr As DataRow In dt.Rows
                    With GetDeliveryMethod
                        .BuyerName = dr("Buyer").ToString
                        .BuyerID = dr("BuyerID").ToString
                        .DeliveryMethodID = dr("DeliveryMethodID").ToString
                        .BuyerOfferXrefID = dr("BuyerOfferXrefID").ToString
                        .PostUrl = dr("PostUrl").ToString
                        .CakeCampaignId = IIf(IsDBNull(dr("CakeCampaignId")), Nothing, dr("CakeCampaignId").ToString)
                        .CakePostKey = IIf(IsDBNull(dr("CakePostKey")), "", dr("CakePostKey").ToString)
                        .DataProcedureName = dr("DataProcedureName").ToString
                        .DataSortFieldName = IIf(IsDBNull(dr("DataSortFieldName")), "Created", dr("DataSortFieldName").ToString)
                        .DataSortDirection = IIf(IsDBNull(dr("DataSortDirection")), "ASC", dr("DataSortDirection").ToString)
                        .ResultType = dr("ResultType").ToString
                        .Throttle = dr("Throttle").ToString
                        .PostToCake = dr("DoCakePost").ToString
                        .ResponseSuccessText = IIf(IsDBNull(dr("responsesuccesstext")), "", dr("responsesuccesstext").ToString)
                        .ResponseResultID_XML = IIf(IsDBNull(dr("ResponseResultID_XML")), "", dr("ResponseResultID_XML").ToString)
                        .ResponseResultCode_XML = IIf(IsDBNull(dr("ResponseResultCode_XML")), "", dr("ResponseResultCode_XML").ToString)
                        .ResponseResultError_XML = IIf(IsDBNull(dr("ResponseResultError_XML")), "", dr("ResponseResultError_XML").ToString)
                        .Exclusive = dr("Exclusive").ToString
                        .Weight = IIf(String.IsNullOrEmpty(dr("Weight").ToString), 100, dr("Weight").ToString)
                        .ContractName = dr("ContractName").ToString
                        .Price = IIf(String.IsNullOrEmpty(dr("Price").ToString), 0.0, dr("Price").ToString)
                        .DailyCap = IIf(String.IsNullOrEmpty(dr("DailyCap").ToString), 999, dr("DailyCap").ToString)
                        .OfferId = dr("OfferId").ToString
                        .Offer = dr("Offer").ToString
                        .OfferPriority = dr("OfferPriority").ToString
                        .ContractTypeID = dr("ContractTypeID").ToString
                        .ContractTypeDesc = dr("ContractType").ToString
                        .Priority = CInt(dr("Priority"))
                        .NoScrub = dr("NoScrub")
                        .ExcludeDNC = dr("ExcludeDNC")
                        .WirelessOnly = dr("WirelessOnly")
                        .LandlineOnly = dr("LandlineOnly")
                        .Method = dr("Method").ToString
                        .NoPacing = dr("NoPacing")
                        .RealTimeMinutes = dr("RealTimeMinutes").ToString
                        .AgedMinutes = dr("AgedMinutes").ToString
                        .Trickle = dr("Trickle").ToString

                        'get post fields
                        Using dtFlds As DataTable = SqlHelper.GetDataTable(String.Format("SELECT * from tblDeliveryPostFields where deliverymethodid = {0}", .DeliveryMethodID), CommandType.Text)
                            For Each pf As DataRow In dtFlds.Rows
                                Dim f As New PostDataFieldObject
                                f.PostFieldID = pf("PostFieldID").ToString
                                f.DeliveryMethodID = pf("DeliveryMethodID").ToString
                                f.Parameter = pf("Parameter").ToString
                                f.Field = pf("Field").ToString
                                f.Query = pf("Query").ToString
                                .PostDataFields.Add(f)
                                'Added
                                .PostFields.Add(New PostFieldObject() With {.Postfieldid = pf("Postfieldid").ToString, _
                                                                            .Parameter = pf("Parameter").ToString, _
                                                                            .FieldID = CInt(pf("FieldID")), _
                                                                            .Field = pf("Field").ToString, _
                                                                            .Query = pf("Query").ToString})
                            Next
                        End Using

                        'get schedule
                        Using dtSched As DataTable = SqlHelper.GetDataTable(String.Format("SELECT Weekday,fromhour,ToHour from tblBuyerHours where BuyerOfferXrefID = {0}", .BuyerOfferXrefID), CommandType.Text)
                            For Each sc As DataRow In dtSched.Rows
                                Dim dms As New DeliveryScheduleObject
                                dms.BuyerID = .BuyerID
                                dms.BuyerOfferXrefID = .BuyerOfferXrefID
                                dms.Weekday = sc("weekday").ToString
                                dms.FromHour = sc("FromHour").ToString
                                dms.ToHour = sc("ToHour").ToString
                                If dms.TotalSellableHours > 0 Then
                                    dms.LeadsPerHour = .DailyCap / dms.TotalSellableHours
                                End If
                                dms.PerHourPriceEstimate = dms.LeadsPerHour * .Price
                                dms.Priority = .Priority
                                .DeliverySchedule.Add(dms)
                            Next
                        End Using
                    End With
                    Exit For
                Next
            End Using
        End Function

        ' This code added by Visual Basic to correctly implement the disposable pattern.
        Public Sub Dispose() Implements IDisposable.Dispose
            ' Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
            Dispose(True)
            GC.SuppressFinalize(Me)
        End Sub

        ' IDisposable
        Protected Overridable Sub Dispose(ByVal disposing As Boolean)
            If Not Me.disposedValue Then
                If disposing Then
                    ' TODO: free other state (managed objects).
                End If
                _PostData = Nothing
                _postDataFields = Nothing
                ' TODO: free your own state (unmanaged objects).
                ' TODO: set large fields to null.
            End If
            Me.disposedValue = True
        End Sub

#End Region 'Methods

    End Class

    <DataObject(True)> _
    Public Class DeliveryScheduleObject

#Region "Fields"

        Private _BuyerID As String
        Private _BuyerOfferXrefID As String
        Private _DailyCap As String
        Private _Exclusive As String
        Private _FromHour As String
        Private _Price As Double
        Private _Priority As String
        Private _ToHour As String
        Private _Weekday As String
        Private _LeadsPerHour As Double
        Private _PerHourPriceEstimate As Double

#End Region 'Fields

#Region "Properties"

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

        Public Property DailyCap() As String
            Get
                Return _DailyCap
            End Get
            Set(ByVal value As String)
                _DailyCap = value
            End Set
        End Property

        Public Property Exclusive() As String
            Get
                Return _Exclusive
            End Get
            Set(ByVal value As String)
                _Exclusive = value
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

        Public Property FromHour() As String
            Get
                Return _FromHour
            End Get
            Set(ByVal Value As String)
                _FromHour = Value
            End Set
        End Property

        Public Property LeadsPerHour() As Double
            Get
                Return _LeadsPerHour
            End Get
            Set(ByVal value As Double)
                _LeadsPerHour = value
            End Set
        End Property

        Public Property PerHourPriceEstimate() As Double
            Get
                Return _PerHourPriceEstimate
            End Get
            Set(ByVal value As Double)
                _PerHourPriceEstimate = value
            End Set
        End Property

        Public Property ToHour() As String
            Get
                Return _ToHour
            End Get
            Set(ByVal Value As String)
                _ToHour = Value
            End Set
        End Property

        Public ReadOnly Property TotalSellableHours() As Double
            Get
                If IsNothing(_FromHour) Then
                    _FromHour = "12:00 AM"
                End If
                If IsNothing(_ToHour) Then
                    _FromHour = "12:00 AM"
                End If

                If IsNothing(_FromHour) AndAlso IsNothing(_ToHour) Then
                    Return 24
                End If

                Dim dHours As Double = Math.Abs(DateDiff(DateInterval.Hour, CDate(_ToHour), CDate(_FromHour)))
                Return dHours

            End Get
        End Property

        Public Property Weekday() As String
            Get
                Return _Weekday
            End Get
            Set(ByVal Value As String)
                _Weekday = Value
            End Set
        End Property

        Public Property Priority() As Integer
            Get
                Return _Priority
            End Get
            Set(ByVal Value As Integer)
                _Priority = Value
            End Set
        End Property

#End Region 'Properties

    End Class

    <DataObject(True)> _
    Public Class FilterObject

#Region "Fields"

        Private _FilterDescription As String
        Private _FilterValue As String

#End Region 'Fields

#Region "Properties"

        Public Property FilterDescription() As String
            Get
                Return _FilterDescription
            End Get
            Set(ByVal value As String)
                _FilterDescription = value
            End Set
        End Property

        Public Property FilterValue() As String
            Get
                Return _FilterValue
            End Get
            Set(ByVal value As String)
                _FilterValue = value
            End Set
        End Property

#End Region 'Properties

    End Class

    <DataObject(True)> _
    Public Class PostFieldObject

#Region "Fields"

        Private _field As String
        Private _fieldID As Integer
        Private _parameter As String
        Private _postfieldid As Integer
        Private _query As Boolean

#End Region 'Fields

#Region "Properties"

        Public Property Field() As String
            Get
                Return _field
            End Get
            Set(ByVal value As String)
                _field = value
            End Set
        End Property

        Public Property FieldID As Integer
            Get
                Return _fieldID
            End Get
            Set(value As Integer)
                _fieldID = value
            End Set
        End Property

        Public Property Parameter() As String
            Get
                Return _parameter
            End Get
            Set(ByVal value As String)
                _parameter = value
            End Set
        End Property

        Public Property Postfieldid() As Integer
            Get
                Return _postfieldid
            End Get
            Set(ByVal value As Integer)
                _postfieldid = value
            End Set
        End Property

        Public Property Query() As Boolean
            Get
                Return _query
            End Get
            Set(ByVal value As Boolean)
                _query = value
            End Set
        End Property

#End Region 'Properties

    End Class

    Public Class TemplateObject

#Region "Fields"

        Private _TemplateID As Integer
        Private _templateName As String

#End Region 'Fields

#Region "Properties"

        Public Property TemplateID() As Integer
            Get
                Return _TemplateID
            End Get
            Set(ByVal value As Integer)
                _TemplateID = value
            End Set
        End Property

        Public Property TemplateName() As String
            Get
                Return _templateName
            End Get
            Set(ByVal value As String)
                _templateName = value
            End Set
        End Property

#End Region 'Properties

    End Class

    Public Class chartParameter

#Region "Fields"

        Private _chartDataProcParams As String
        Private _chartDataProcedureName As String
        Private _groupByFieldName As String
        Private _xAxisFieldName As String
        Private _yAxisFieldName As String

#End Region 'Fields

#Region "Properties"

        Public Property ChartDataProcParams() As String
            Get
                Return _chartDataProcParams
            End Get
            Set(ByVal value As String)
                _chartDataProcParams = value
            End Set
        End Property

        Public Property ChartDataProcedureName() As String
            Get
                Return _chartDataProcedureName
            End Get
            Set(ByVal value As String)
                _chartDataProcedureName = value
            End Set
        End Property

        Public Property GroupByFieldName() As String
            Get
                Return _groupByFieldName
            End Get
            Set(ByVal value As String)
                _groupByFieldName = value
            End Set
        End Property

        Public Property XAxisFieldName() As String
            Get
                Return _xAxisFieldName
            End Get
            Set(ByVal value As String)
                _xAxisFieldName = value
            End Set
        End Property

        Public Property YAxisFieldName() As String
            Get
                Return _yAxisFieldName
            End Get
            Set(ByVal value As String)
                _yAxisFieldName = value
            End Set
        End Property

#End Region 'Properties

    End Class

    Public Class chartSeriesData

#Region "Fields"

        Private _SeriesData As String
        Private _SeriesName As String

#End Region 'Fields

#Region "Properties"

        Public Property SeriesData() As String
            Get
                Return _SeriesData
            End Get
            Set(ByVal value As String)
                _SeriesData = value
            End Set
        End Property

        Public Property SeriesName() As String
            Get
                Return _SeriesName
            End Get
            Set(ByVal value As String)
                _SeriesName = value
            End Set
        End Property

#End Region 'Properties

    End Class

    Public Class PostDataFieldObject

#Region "Fields"

        Private _DeliveryMethodID As String
        Private _Field As String
        Private _Parameter As String
        Private _PostFieldID As String
        Private _Query As String

#End Region 'Fields

#Region "Properties"

        Public Property DeliveryMethodID() As String
            Get
                Return _DeliveryMethodID
            End Get
            Set(ByVal value As String)
                _DeliveryMethodID = value
            End Set
        End Property

        Public Property Field() As String
            Get
                Return _Field
            End Get
            Set(ByVal value As String)
                _Field = value
            End Set
        End Property

        Public Property Parameter() As String
            Get
                Return _Parameter
            End Get
            Set(ByVal value As String)
                _Parameter = value
            End Set
        End Property

        Public Property PostFieldID() As String
            Get
                Return _PostFieldID
            End Get
            Set(ByVal value As String)
                _PostFieldID = value
            End Set
        End Property

        Public Property Query() As String
            Get
                Return _Query
            End Get
            Set(ByVal value As String)
                _Query = value
            End Set
        End Property

#End Region 'Properties

    End Class

#End Region 'Nested Types

End Class
