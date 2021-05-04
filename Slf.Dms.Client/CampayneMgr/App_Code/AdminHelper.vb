Imports System.ComponentModel
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Reflection

Imports Microsoft.VisualBasic

Public Class AdminHelper
    Public Enum toastMesageType
        enumSuccess = 0
        enumWarning = 1
        enumNotice = 2
        enumError = 3
    End Enum
#Region "Methods"

    Public Shared Sub ShowToastMsg(msgtext As String, Optional msgType As toastMesageType = toastMesageType.enumWarning, Optional bSticky As Boolean = False)
        Dim pg As Page = TryCast(HttpContext.Current.CurrentHandler, Page)
        Dim mtype As String = msgType.ToString.ToLower.Replace("enum", "")

        pg.ClientScript.RegisterStartupScript(pg.GetType, "loadmsg", String.Format("showToast('{0}','{1}',{2});", msgtext, mtype, bSticky.ToString.ToLower), True)
    End Sub
    Public Shared Function ControlToHTML(ByVal ctl As Control) As String
        Dim SB As New StringBuilder()
        Dim SW As New StringWriter(SB)
        Dim htmlTW As New HtmlTextWriter(SW)
        ctl.RenderControl(htmlTW)
        Return SB.ToString()
    End Function

    Public Shared Function ConvertTextToBoolean(ByVal textBoolean As String) As String
        Select Case textBoolean.ToLower
            Case "check", "checked", "true", "True"
                ConvertTextToBoolean = "True"
            Case Else
                ConvertTextToBoolean = "False"
        End Select
    End Function

    Public Shared Function FormatPhone(ByVal strPhone As String) As String
        Dim nStringLength As Int16 = Len(Trim(strPhone))
        Select Case nStringLength
            Case 7
                FormatPhone = Left(strPhone, 3) & "-" & Right(strPhone, 4)
            Case 10
                FormatPhone = "(" & Left(strPhone, 3) & ") " & Mid(strPhone, 3, 3) & "-" & Right(strPhone, 4)
            Case Else
                FormatPhone = strPhone
        End Select
    End Function

    Public Shared Function GetImgUrl(ByVal booleanObjectState As Boolean) As String
        Dim imgUrl As String = "~/images/16-circle-"
        If Not booleanObjectState Then
            imgUrl += "red.png"
        Else
            imgUrl += "green.png"
        End If
        Return imgUrl
    End Function

    Public Shared Function parseHTML(ByVal stringToParse As String) As String
        Dim newString As String = stringToParse
        Dim ds As String() = stringToParse.Split("<DIV")
        Dim sList As New List(Of String)

        For Each d As String In ds
            If Not String.IsNullOrEmpty(d) Then
                Dim idx As Integer = d.IndexOf(">")
                Dim objToAdd As String = d.Substring(idx + 1)
                If Not String.IsNullOrEmpty(objToAdd.Trim) And Not objToAdd.Contains("Drop") Then
                    objToAdd = objToAdd.Replace("<img", "").Replace("<ul", "").Replace("ul", "").Replace("img", "")
                    sList.Add(objToAdd)
                End If
            End If

        Next

        newString = Join(sList.ToArray, ",")

        Return newString
    End Function

#End Region 'Methods

#Region "Nested Types"

    <DataObject(True)> _
    Public Class AdvertiserObject

#Region "Fields"

        Private _AccountManager As String
        Private _AccountManagerID As Integer
        Private _Active As Boolean
        Private _AdvertiserID As String
        Private _BillingCycle As String
        Private _City As String
        Private _Country As String
        Private _Created As String
        Private _CreatedBy As String
        Private _CreatedByName As String
        Private _Name As String
        Private _Notes As String
        Private _State As String
        Private _Street As String
        Private _Website As String
        Private _Zip As String

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

        Public Property AccountManagerID() As Integer
            Get
                Return _AccountManagerID
            End Get
            Set(ByVal value As Integer)
                _AccountManagerID = value
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

        Public Property AdvertiserID() As String
            Get
                Return _AdvertiserID
            End Get
            Set(ByVal value As String)
                _AdvertiserID = value
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

        Public Property City() As String
            Get
                Return _City
            End Get
            Set(ByVal value As String)
                _City = value
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

        Public Property CreatedBy() As String
            Get
                Return _CreatedBy
            End Get
            Set(ByVal value As String)
                _CreatedBy = value
            End Set
        End Property

        Public Property CreatedByName() As String
            Get
                Return _CreatedByName
            End Get
            Set(ByVal value As String)
                _CreatedByName = value
            End Set
        End Property

        Public Property Name() As String
            Get
                Return _Name
            End Get
            Set(ByVal value As String)
                _Name = value
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

        Public Property Street() As String
            Get
                Return _Street
            End Get
            Set(ByVal value As String)
                _Street = value
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

        Public Shared Function GetContacts(ByVal advertiserid As Integer) As List(Of BuyerHelper.ContactObject)
            GetContacts = New List(Of BuyerHelper.ContactObject)
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("advertiserid", advertiserid))
            Using dt As DataTable = SqlHelper.GetDataTable("stp_advertisers_getcontacts", CommandType.StoredProcedure, params.ToArray)
                For Each dr As DataRow In dt.Rows
                    Dim c As New BuyerHelper.ContactObject
                    c.ParentID = advertiserid
                    c.ContactID = dr("ContactID").ToString
                    c.FullName = dr("FullName").ToString
                    c.Email = dr("Email").ToString
                    c.Phone = dr("Phone").ToString
                    c.Notes = dr("Notes").ToString
                    GetContacts.Add(c)
                Next
            End Using
        End Function

        Public Shared Function GetDocuments(ByVal advertiserid As Integer) As List(Of BuyerHelper.DocumentObject)
            GetDocuments = New List(Of BuyerHelper.DocumentObject)
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("advertiserid", advertiserid))
            Using dt As DataTable = SqlHelper.GetDataTable("stp_advertisers_getdocuments", CommandType.StoredProcedure, params.ToArray)
                For Each dr As DataRow In dt.Rows
                    Dim d As New BuyerHelper.DocumentObject
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

        Public Shared Function getAdvertiserOffers(Optional ByVal advertiserID As Integer = 0) As List(Of OfferObject)
            getAdvertiserOffers = New List(Of OfferObject)
            Dim ssql As String = String.Format("stp_advertisers_getOffers {0}", advertiserID)

            Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)
                For Each dr As DataRow In dt.Rows
                    Dim no As New OfferObject
                    With no
                        .OfferID = dr("offerid").ToString
                        .Offer = dr("Offer").ToString
                        .Active = dr("Active").ToString
                        .TransferData = dr("TransferData").ToString
                        .LastModified = IIf(IsDBNull(dr("LastModified")), Nothing, dr("LastModified").ToString)
                        .LastModifiedBy = IIf(IsDBNull(dr("LastModifiedBy")), Nothing, dr("LastModifiedBy").ToString)
                        .CallCenter = dr("CallCenter").ToString
                        .AdvertiserID = dr("AdvertiserID").ToString
                        .AdvertiserName = dr("AdvertiserName").ToString
                        .Created = IIf(IsDBNull(dr("Created")), Nothing, dr("Created").ToString)
                        .CreatedBy = IIf(IsDBNull(dr("CreatedBy")), Nothing, dr("CreatedBy").ToString)
                        .CreatedByName = dr("CreatedByName").ToString
                        .OfferLink = dr("OfferLink").ToString
                        .VerticalID = dr("VerticalID").ToString
                        .VerticalName = dr("VerticalName").ToString
                    End With
                    getAdvertiserOffers.Add(no)
                Next

            End Using
        End Function

        Public Shared Function getAdvertisers(ByVal sortField As String, ByVal sortOrder As String, Optional ByVal advertiserID As Integer = -1) As List(Of AdvertiserObject)
            getAdvertisers = New List(Of AdvertiserObject)
            Dim ssql As String = String.Format("stp_advertisers_select {0}", advertiserID)

            Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)
                For Each dr As DataRow In dt.Rows
                    Dim ao As New AdvertiserObject
                    With ao
                        .AdvertiserID = IIf(IsDBNull(dr("AdvertiserID")), -1, dr("AdvertiserID").ToString)
                        .Name = IIf(IsDBNull(dr("name")), Nothing, dr("name").ToString)
                        .AccountManager = IIf(IsDBNull(dr("AccountManager")), Nothing, dr("AccountManager").ToString)
                        .AccountManagerID = IIf(IsDBNull(dr("AccountManagerID")), Nothing, dr("AccountManagerID").ToString)
                        .Website = IIf(IsDBNull(dr("Website")), Nothing, dr("Website").ToString)
                        .BillingCycle = IIf(IsDBNull(dr("BillingCycle")), Nothing, dr("BillingCycle").ToString)
                        .Street = IIf(IsDBNull(dr("Street")), Nothing, dr("Street").ToString)
                        .City = IIf(IsDBNull(dr("City")), Nothing, dr("City").ToString)
                        .State = IIf(IsDBNull(dr("State")), Nothing, dr("State").ToString)
                        .Zip = IIf(IsDBNull(dr("Zip")), Nothing, dr("Zip").ToString)
                        .Country = IIf(IsDBNull(dr("Country")), Nothing, dr("Country").ToString)
                        .Notes = IIf(IsDBNull(dr("Notes")), Nothing, dr("Notes").ToString)
                        .Active = IIf(IsDBNull(dr("Active")), False, dr("Active").ToString)
                        .Created = IIf(IsDBNull(dr("Created")), Nothing, dr("Created").ToString)
                        .CreatedBy = IIf(IsDBNull(dr("CreatedBy")), Nothing, dr("CreatedBy").ToString)
                        .CreatedByName = IIf(IsDBNull(dr("CreatedByName")), Nothing, dr("CreatedByName").ToString)

                    End With
                    getAdvertisers.Add(ao)
                Next
            End Using

            If Not IsNothing(sortField) Then
                getAdvertisers.Sort(New AdvertiserObjectComparer(sortField, sortOrder))
            End If
        End Function

#End Region 'Methods

    End Class

    Public Class AdvertiserObjectComparer
        Implements IComparer(Of AdvertiserObject)

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

        Public Function Compare(ByVal x As AdvertiserObject, ByVal y As AdvertiserObject) As Integer Implements System.Collections.Generic.IComparer(Of AdvertiserObject).Compare
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
    Public Class AffiliateObject

#Region "Fields"

        Private _AccountManager As String
        Private _AccountManagerID As Integer
        Private _Active As Boolean
        Private _AffiliateID As Integer
        Private _BillingCycle As String
        Private _City As String
        Private _Country As String
        Private _Created As Date
        Private _CreatedBy As String
        Private _LastModified As Date
        Private _LastModifiedBy As String
        Private _Name As String
        Private _Notes As String
        Private _State As String
        Private _Street As String
        Private _Website As String
        Private _Zip As String

#End Region 'Fields

#Region "Properties"

        Public Property AccountManager() As String
            Get
                Return _AccountManager
            End Get
            Set(ByVal Value As String)
                _AccountManager = Value
            End Set
        End Property

        Public Property AccountManagerID() As Integer
            Get
                Return _AccountManagerID
            End Get
            Set(ByVal value As Integer)
                _AccountManagerID = value
            End Set
        End Property

        Public Property Active() As Boolean
            Get
                Return _Active
            End Get
            Set(ByVal Value As Boolean)
                _Active = Value
            End Set
        End Property

        Public Property AffiliateID() As Integer
            Get
                Return _AffiliateID
            End Get
            Set(ByVal Value As Integer)
                _AffiliateID = Value
            End Set
        End Property

        Public Property BillingCycle() As String
            Get
                Return _BillingCycle
            End Get
            Set(ByVal Value As String)
                _BillingCycle = Value
            End Set
        End Property

        Public Property City() As String
            Get
                Return _City
            End Get
            Set(ByVal Value As String)
                _City = Value
            End Set
        End Property

        Public Property Country() As String
            Get
                Return _Country
            End Get
            Set(ByVal Value As String)
                _Country = Value
            End Set
        End Property

        Public Property Created() As Date
            Get
                Return _Created
            End Get
            Set(ByVal Value As Date)
                _Created = Value
            End Set
        End Property

        Public Property CreatedBy() As String
            Get
                Return _CreatedBy
            End Get
            Set(ByVal Value As String)
                _CreatedBy = Value
            End Set
        End Property

        Public Property LastModified() As Date
            Get
                Return _LastModified
            End Get
            Set(ByVal Value As Date)
                _LastModified = Value
            End Set
        End Property

        Public Property LastModifiedBy() As String
            Get
                Return _LastModifiedBy
            End Get
            Set(ByVal Value As String)
                _LastModifiedBy = Value
            End Set
        End Property

        Public Property Name() As String
            Get
                Return _Name
            End Get
            Set(ByVal Value As String)
                _Name = Value
            End Set
        End Property

        Public Property Notes() As String
            Get
                Return _Notes
            End Get
            Set(ByVal Value As String)
                _Notes = Value
            End Set
        End Property

        Public Property State() As String
            Get
                Return _State
            End Get
            Set(ByVal Value As String)
                _State = Value
            End Set
        End Property

        Public Property Street() As String
            Get
                Return _Street
            End Get
            Set(ByVal Value As String)
                _Street = Value
            End Set
        End Property

        Public Property Website() As String
            Get
                Return _Website
            End Get
            Set(ByVal Value As String)
                _Website = Value
            End Set
        End Property

        Public Property Zip() As String
            Get
                Return _Zip
            End Get
            Set(ByVal Value As String)
                _Zip = Value
            End Set
        End Property

#End Region 'Properties

#Region "Methods"

        Public Shared Function GetContacts(ByVal affiliateid As Integer) As List(Of BuyerHelper.ContactObject)
            GetContacts = New List(Of BuyerHelper.ContactObject)
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("affiliateid", affiliateid))
            Using dt As DataTable = SqlHelper.GetDataTable("stp_affiliate_getcontacts", CommandType.StoredProcedure, params.ToArray)
                For Each dr As DataRow In dt.Rows
                    Dim c As New BuyerHelper.ContactObject
                    c.ParentID = affiliateid
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

        Public Shared Function GetDocuments(ByVal affiliateid As Integer) As List(Of BuyerHelper.DocumentObject)
            GetDocuments = New List(Of BuyerHelper.DocumentObject)
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("affiliateid", affiliateid))
            Using dt As DataTable = SqlHelper.GetDataTable("stp_affiliate_getdocuments", CommandType.StoredProcedure, params.ToArray)
                For Each dr As DataRow In dt.Rows
                    Dim d As New BuyerHelper.DocumentObject
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

        Public Shared Function getAffiliates(ByVal sortField As String, ByVal sortOrder As String, Optional ByVal affiliateID As Integer = -1) As List(Of AffiliateObject)
            getAffiliates = New List(Of AffiliateObject)
            Dim ssql As String = String.Format("stp_affiliate_select {0}", affiliateID)

            Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)
                For Each dr As DataRow In dt.Rows
                    Dim ao As New AffiliateObject
                    With ao
                        .AffiliateID = IIf(IsDBNull(dr("AffiliateID")), -1, dr("AffiliateID").ToString)
                        .Name = IIf(IsDBNull(dr("name")), Nothing, dr("name").ToString)
                        .AccountManagerID = IIf(IsDBNull(dr("AccountManagerID")), Nothing, dr("AccountManagerID").ToString)
                        .AccountManager = IIf(IsDBNull(dr("AccountManager")), Nothing, dr("AccountManager").ToString)
                        .Website = IIf(IsDBNull(dr("Website")), Nothing, dr("Website").ToString)
                        .BillingCycle = IIf(IsDBNull(dr("BillingCycle")), Nothing, dr("BillingCycle").ToString)
                        .Street = IIf(IsDBNull(dr("Street")), Nothing, dr("Street").ToString)
                        .City = IIf(IsDBNull(dr("City")), Nothing, dr("City").ToString)
                        .State = IIf(IsDBNull(dr("State")), Nothing, dr("State").ToString)
                        .Zip = IIf(IsDBNull(dr("Zip")), Nothing, dr("Zip").ToString)
                        .Country = IIf(IsDBNull(dr("Country")), Nothing, dr("Country").ToString)
                        .Notes = IIf(IsDBNull(dr("Notes")), Nothing, dr("Notes").ToString)
                        .Active = IIf(IsDBNull(dr("Active")), False, dr("Active").ToString)
                        .Created = IIf(IsDBNull(dr("Created")), Nothing, dr("Created").ToString)
                        .CreatedBy = IIf(IsDBNull(dr("CreatedBy")), Nothing, dr("CreatedBy").ToString)
                        .LastModified = IIf(IsDBNull(dr("LastModified")), Nothing, dr("LastModified").ToString)
                        .LastModifiedBy = IIf(IsDBNull(dr("LastModifiedBy")), Nothing, dr("LastModifiedBy").ToString)

                    End With
                    getAffiliates.Add(ao)
                Next
            End Using

            If Not IsNothing(sortField) Then
                getAffiliates.Sort(New AffiliateObjectComparer(sortField, sortOrder))
            End If
        End Function

        Public Shared Function getCampaignsByAffiliateID(ByVal affiliateID As Integer) As List(Of CampaignObject)
            getCampaignsByAffiliateID = New List(Of CampaignObject)
            Dim ssql As String = String.Format("select * from tblcampaigns where affiliateid = {0}", affiliateID)

            Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)
                For Each dr As DataRow In dt.Rows
                    Dim co As New CampaignObject
                    With co
                        .CampaignID = dr("CampaignID").ToString
                        .Campaign = dr("Campaign").ToString
                        .Priority = dr("Priority").ToString
                        .AffiliateID = dr("AffiliateID").ToString
                        .OfferID = dr("offerid").ToString
                        .MediaTypeID = dr("MediaTypeID").ToString
                        .Price = dr("Price").ToString
                        .AffiliatePixel = dr("AffiliatePixel").ToString
                        .Active = dr("Active").ToString
                        .LastModified = IIf(IsDBNull(dr("LastModified")), Nothing, dr("LastModified").ToString)
                        .LastModifiedBy = IIf(IsDBNull(dr("LastModifiedBy")), Nothing, dr("LastModifiedBy").ToString)
                        .Created = IIf(IsDBNull(dr("Created")), Nothing, dr("Created").ToString)
                        .CreatedBy = IIf(IsDBNull(dr("CreatedBy")), Nothing, dr("CreatedBy").ToString)

                    End With
                    getCampaignsByAffiliateID.Add(co)
                Next

            End Using
        End Function

#End Region 'Methods

    End Class

    Public Class AffiliateObjectComparer
        Implements IComparer(Of AffiliateObject)

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

        Public Function Compare(ByVal x As AffiliateObject, ByVal y As AffiliateObject) As Integer Implements System.Collections.Generic.IComparer(Of AffiliateObject).Compare
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

    <DataObject()> _
    Public Class CampaignObject

#Region "Fields"

        Private _Active As String
        Private _Affiliate As String
        Private _AffiliateID As String
        Private _AffiliatePixel As String
        Private _Campaign As String
        Private _CampaignID As Integer
        Private _Created As String
        Private _CreatedBy As String
        Private _CreatedByName As String
        Private _IsDefault As Boolean
        Private _LastModified As String
        Private _LastModifiedBy As String
        Private _LastModifiedByName As String
        Private _MediaType As String
        Private _MediaTypeID As String
        Private _Offer As String
        Private _OfferID As String
        Private _Pickle As String
        Private _Price As String
        Private _Priority As String
        Private _SubId As String
        Private _TrafficTypeID As String
        Private _UserID As String

#End Region 'Fields

#Region "Properties"

        Public Property Active() As String
            Get
                Return _Active
            End Get
            Set(ByVal value As String)
                _Active = value
            End Set
        End Property

        Public Property Affiliate() As String
            Get
                Return _Affiliate
            End Get
            Set(ByVal value As String)
                _Affiliate = value
            End Set
        End Property

        Public Property AffiliateID() As String
            Get
                Return _AffiliateID
            End Get
            Set(ByVal value As String)
                _AffiliateID = value
            End Set
        End Property

        Public Property AffiliatePixel() As String
            Get
                Return _AffiliatePixel
            End Get
            Set(ByVal value As String)
                _AffiliatePixel = value
            End Set
        End Property

        Public Property Campaign() As String
            Get
                Return _Campaign
            End Get
            Set(ByVal value As String)
                _Campaign = value
            End Set
        End Property

        Public Property CampaignID() As Integer
            Get
                Return _CampaignID
            End Get
            Set(ByVal value As Integer)
                _CampaignID = value
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

        Public Property CreatedBy() As String
            Get
                Return _CreatedBy
            End Get
            Set(ByVal value As String)
                _CreatedBy = value
            End Set
        End Property

        Public Property CreatedByName() As String
            Get
                Return _CreatedByName
            End Get
            Set(ByVal value As String)
                _CreatedByName = value
            End Set
        End Property

        Public Property IsDefault() As Boolean
            Get
                Return _IsDefault
            End Get
            Set(value As Boolean)
                _IsDefault = value
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

        Public Property LastModifiedByName() As String
            Get
                Return _LastModifiedByName
            End Get
            Set(ByVal value As String)
                _LastModifiedByName = value
            End Set
        End Property

        Public Property MediaType() As String
            Get
                Return _MediaType
            End Get
            Set(ByVal value As String)
                _MediaType = value
            End Set
        End Property

        Public Property MediaTypeID() As String
            Get
                Return _MediaTypeID
            End Get
            Set(ByVal value As String)
                _MediaTypeID = value
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

        Public Property OfferID() As String
            Get
                Return _OfferID
            End Get
            Set(ByVal value As String)
                _OfferID = value
            End Set
        End Property

        Public Property Pickle() As String
            Get
                Return _Pickle
            End Get
            Set(ByVal value As String)
                _Pickle = value
            End Set
        End Property

        Public Property Price() As String
            Get
                Return _Price
            End Get
            Set(ByVal value As String)
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

        Public Property SubId() As String
            Get
                Return _SubId
            End Get
            Set(ByVal value As String)
                _SubId = value
            End Set
        End Property

        Public Property TrafficTypeID() As String
            Get
                Return _TrafficTypeID
            End Get
            Set(ByVal value As String)
                _TrafficTypeID = value
            End Set
        End Property

        Public Property UserID() As Integer
            Get
                Return _UserID
            End Get
            Set(ByVal value As Integer)
                _UserID = value
            End Set
        End Property

#End Region 'Properties

#Region "Methods"

        Public Shared Function getCampaigns(ByVal sortField As String, ByVal sortOrder As String, Optional ByVal affiliateid As Integer = 0, Optional ByVal offerid As Integer = 0, Optional ByVal active As Integer = -1, Optional ByVal mediaTypeID As Integer = -1) As List(Of CampaignObject)
            getCampaigns = New List(Of CampaignObject)

            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("affiliateid", affiliateid))
            params.Add(New SqlParameter("offerid", offerid))
            If active <> -1 Then params.Add(New SqlParameter("active", active))
            If mediaTypeID > 0 Then params.Add(New SqlParameter("mediaTypeID", mediaTypeID))

            Using dt As DataTable = SqlHelper.GetDataTable("stp_campaigns_select", CommandType.StoredProcedure, params.ToArray)
                For Each dr As DataRow In dt.Rows
                    Dim no As New CampaignObject
                    With no
                        .CampaignID = dr("CampaignID").ToString
                        .Campaign = dr("Campaign").ToString
                        .Priority = dr("Priority").ToString
                        .AffiliateID = IIf(IsDBNull(dr("AffiliateID")), Nothing, dr("AffiliateID").ToString)
                        .Affiliate = IIf(IsDBNull(dr("Affiliate")), Nothing, dr("Affiliate").ToString)
                        .OfferID = IIf(IsDBNull(dr("OfferID")), Nothing, dr("OfferID").ToString)
                        .Offer = IIf(IsDBNull(dr("Offer")), Nothing, dr("Offer").ToString)

                        .MediaType = IIf(IsDBNull(dr("MediaType")), Nothing, dr("MediaType").ToString)
                        .MediaTypeID = IIf(IsDBNull(dr("MediaTypeID")), Nothing, dr("MediaTypeID").ToString)
                        .TrafficTypeID = CStr(dr("TrafficTypeID"))

                        .Price = dr("Price").ToString
                        .AffiliatePixel = IIf(IsDBNull(dr("AffiliatePixel")), Nothing, dr("AffiliatePixel").ToString)
                        .Active = dr("Active").ToString
                        .LastModified = IIf(IsDBNull(dr("LastModified")), Nothing, dr("LastModified").ToString)
                        .LastModifiedBy = IIf(IsDBNull(dr("LastModifiedBy")), Nothing, dr("LastModifiedBy").ToString)
                        .LastModifiedByName = dr("LastModifiedByName").ToString
                        .Created = IIf(IsDBNull(dr("Created")), Nothing, dr("Created").ToString)
                        .CreatedBy = IIf(IsDBNull(dr("CreatedBy")), Nothing, dr("CreatedBy").ToString)
                        .CreatedByName = dr("CreatedByName").ToString

                        .Pickle = IIf(IsDBNull(dr("Pickle")), "0", dr("Pickle").ToString)
                    End With
                    getCampaigns.Add(no)
                Next
            End Using

            If Not IsNothing(sortField) Then
                getCampaigns.Sort(New CampaignObjectComparer(sortField, sortOrder))
            End If
        End Function

#End Region 'Methods

    End Class

    Public Class CampaignObjectComparer
        Implements IComparer(Of CampaignObject)

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

        Public Function Compare(ByVal x As CampaignObject, ByVal y As CampaignObject) As Integer Implements System.Collections.Generic.IComparer(Of CampaignObject).Compare
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
    Public Class OfferObject

#Region "Fields"

        Private _Active As Boolean
        Private _AdvertiserID As String
        Private _AdvertiserName As String
        Private _CallCenter As String
        Private _Category As String
        Private _Created As String
        Private _CreatedBy As String
        Private _CreatedByName As String
        Private _LastModified As String
        Private _LastModifiedBy As String
        Private _Offer As String
        Private _OfferID As String
        Private _OfferLink As String
        Private _Received As Double
        Private _Tag As String
        Private _TransferData As String
        Private _VerticalID As String
        Private _VerticalName As String

#End Region 'Fields

#Region "Properties"

        Public Property Active() As Boolean
            Get
                Return _Active
            End Get
            Set(ByVal value As Boolean)
                _Active = value
            End Set
        End Property

        Public Property AdvertiserID() As String
            Get
                Return _AdvertiserID
            End Get
            Set(ByVal value As String)
                _AdvertiserID = value
            End Set
        End Property

        Public Property AdvertiserName() As String
            Get
                Return _AdvertiserName
            End Get
            Set(ByVal value As String)
                _AdvertiserName = value
            End Set
        End Property

        Public Property CallCenter() As String
            Get
                Return _CallCenter
            End Get
            Set(ByVal value As String)
                _CallCenter = value
            End Set
        End Property

        Public Property Category() As String
            Get
                Return _Category
            End Get
            Set(ByVal value As String)
                _Category = value
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

        Public Property CreatedBy() As String
            Get
                Return _CreatedBy
            End Get
            Set(ByVal value As String)
                _CreatedBy = value
            End Set
        End Property

        Public Property CreatedByName() As String
            Get
                Return _CreatedByName
            End Get
            Set(ByVal value As String)
                _CreatedByName = value
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

        Public Property Offer() As String
            Get
                Return _Offer
            End Get
            Set(ByVal value As String)
                _Offer = value
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

        Public Property OfferLink() As String
            Get
                Return _OfferLink
            End Get
            Set(ByVal value As String)
                _OfferLink = value
            End Set
        End Property

        Public Property Received() As Double
            Get
                Return _Received
            End Get
            Set(ByVal value As Double)
                _Received = value
            End Set
        End Property

        Public Property Tag() As String
            Get
                Return _Tag
            End Get
            Set(ByVal value As String)
                _Tag = value
            End Set
        End Property

        Public Property TransferData() As String
            Get
                Return _TransferData
            End Get
            Set(ByVal value As String)
                _TransferData = value
            End Set
        End Property

        Public Property VerticalID() As String
            Get
                Return _VerticalID
            End Get
            Set(ByVal value As String)
                _VerticalID = value
            End Set
        End Property

        Public Property VerticalName() As String
            Get
                Return _VerticalName
            End Get
            Set(ByVal value As String)
                _VerticalName = value
            End Set
        End Property

#End Region 'Properties

#Region "Methods"

        Public Shared Function getOffers(ByVal sortField As String, ByVal sortOrder As String, Optional ByVal offerID As Integer = -1, Optional ByVal VerticalID As Integer = -1, Optional ByVal AdvertiserID As Integer = -1, Optional ByVal Tag As String = "", Optional ByVal Active As Integer = -1) As List(Of OfferObject)
            getOffers = New List(Of OfferObject)

            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("offerID", offerID))
            If VerticalID > 0 Then params.Add(New SqlParameter("verticalID", VerticalID))
            If AdvertiserID > 0 Then params.Add(New SqlParameter("advertiserID", AdvertiserID))
            If Tag <> "" Then params.Add(New SqlParameter("tag", Tag))
            If Active <> -1 Then params.Add(New SqlParameter("active", Active))

            Using dt As DataTable = SqlHelper.GetDataTable("stp_offer_select", CommandType.StoredProcedure, params.ToArray)
                For Each dr As DataRow In dt.Rows
                    Dim no As New OfferObject
                    With no
                        .OfferID = dr("offerid").ToString
                        .Offer = dr("Offer").ToString
                        .Active = dr("Active").ToString
                        .TransferData = dr("TransferData").ToString
                        .LastModified = IIf(IsDBNull(dr("LastModified")), Nothing, dr("LastModified").ToString)
                        .LastModifiedBy = IIf(IsDBNull(dr("LastModifiedBy")), Nothing, dr("LastModifiedBy").ToString)
                        .CallCenter = dr("CallCenter").ToString
                        .AdvertiserID = dr("AdvertiserID").ToString
                        .AdvertiserName = dr("AdvertiserName").ToString
                        .Created = IIf(IsDBNull(dr("Created")), Nothing, Format(CDate(dr("Created")), "M/d/yyyy"))
                        .CreatedBy = IIf(IsDBNull(dr("CreatedBy")), Nothing, dr("CreatedBy").ToString)
                        .CreatedByName = dr("CreatedByName").ToString
                        .OfferLink = dr("OfferLink").ToString
                        .VerticalID = dr("VerticalID").ToString
                        .VerticalName = dr("VerticalName").ToString
                        .Category = dr("Category").ToString
                        .Received = Val(dr("Received"))
                        .Tag = IIf(IsDBNull(dr("Tag")), "", dr("Tag").ToString)
                    End With
                    getOffers.Add(no)
                Next
            End Using

            If Not IsNothing(sortField) Then
                getOffers.Sort(New OfferObjectComparer(sortField, sortOrder))
            End If
        End Function

#End Region 'Methods

    End Class

    Public Class OfferObjectComparer
        Implements IComparer(Of OfferObject)

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

        Public Function Compare(ByVal x As OfferObject, ByVal y As OfferObject) As Integer Implements System.Collections.Generic.IComparer(Of OfferObject).Compare
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

    Public Class websiteObject

#Region "Fields"

        Private _Code As String
        Private _DefaultSurveyID As Integer
        Private _Description As String
        Private _DisclosureText As String
        Private _Name As String
        Private _SurveyName As String
        Private _Type As Integer
        Private _URL As String
        Private _WebsiteID As Integer

#End Region 'Fields

#Region "Properties"

        Public Property Code() As String
            Get
                Return _Code
            End Get
            Set(ByVal value As String)
                _Code = value
            End Set
        End Property

        Public Property DefaultSurveyID() As Integer
            Get
                Return _DefaultSurveyID
            End Get
            Set(ByVal value As Integer)
                _DefaultSurveyID = value
            End Set
        End Property

        Public Property Description() As String
            Get
                Return _Description
            End Get
            Set(ByVal value As String)
                _Description = value
            End Set
        End Property

        Public Property DisclosureText() As String
            Get
                Return _DisclosureText
            End Get
            Set(ByVal value As String)
                _DisclosureText = value
            End Set
        End Property

        Public Property Name() As String
            Get
                Return _Name
            End Get
            Set(ByVal value As String)
                _Name = value
            End Set
        End Property

        Public Property WebSiteTypeID() As Integer
            Get
                Return _Type
            End Get
            Set(ByVal value As Integer)
                _Type = value
            End Set
        End Property

        Public Property URL() As String
            Get
                Return _URL
            End Get
            Set(ByVal value As String)
                _URL = value
            End Set
        End Property

        Public Property WebsiteID() As String
            Get
                Return _WebsiteID
            End Get
            Set(ByVal value As String)
                _WebsiteID = value
            End Set
        End Property



#End Region 'Properties

    End Class

#End Region 'Nested Types

End Class