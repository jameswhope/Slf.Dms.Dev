Imports System.IO
Imports System.Net
Imports System.Xml

Imports Microsoft.VisualBasic

Namespace Lexxiom.USPSHelper

    #Region "Enumerations"

    Public Enum enumServerType
        Testing = 0
        Production = 1
    End Enum

    Public Enum enumWebToolAddressAction
        Verify = 0
        CityStateLookup = 1
        ZipCodeLookup = 2
    End Enum

    #End Region 'Enumerations

    Public Class AddressInfo

        #Region "Fields"

        Private _Address1 As String
        Private _Address2 As String
        Private _AddressID As Integer
        Private _City As String
        Private _FirmName As String
        Private _State As String
        Private _Zip4 As String
        Private _Zip5 As String

        #End Region 'Fields

        #Region "Properties"

        Public Property Address1() As String
            Get
                Return _Address1
            End Get
            Set(ByVal value As String)
                _Address1 = value
            End Set
        End Property

        Public Property Address2() As String
            Get
                Return _Address2
            End Get
            Set(ByVal value As String)
                _Address2 = value
            End Set
        End Property

        Public Property AddressID() As Integer
            Get
                Return _AddressID
            End Get
            Set(ByVal value As Integer)
                _AddressID = value
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

        Public Property FirmName() As String
            Get
                Return _FirmName
            End Get
            Set(ByVal value As String)
                _FirmName = value
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

        Public Property Zip4() As String
            Get
                Return _Zip4
            End Get
            Set(ByVal value As String)
                _Zip4 = value
            End Set
        End Property

        Public Property Zip5() As String
            Get
                Return _Zip5
            End Get
            Set(ByVal value As String)
                _Zip5 = value
            End Set
        End Property

        #End Region 'Properties

        #Region "Methods"

        Public Overrides Function ToString() As String
            Dim s As New StringBuilder
            For Each p As System.Reflection.PropertyInfo In MyBase.GetType().GetProperties()
                If p.CanRead Then
                    s.AppendFormat("{0}:{1}<br>", p.Name.ToString, p.GetValue(Me, Nothing))
                End If
            Next
            Return s.ToString()
        End Function

        #End Region 'Methods

    End Class

    Public Class ErrorInfo

        #Region "Fields"

        Private _Description As String
        Private _Number As String
        Private _Source As String

        #End Region 'Fields

        #Region "Properties"

        Public Property Description() As String
            Get
                Return _Description
            End Get
            Set(ByVal value As String)
                _Description = value
            End Set
        End Property

        Public Property Number() As String
            Get
                Return _Number
            End Get
            Set(ByVal value As String)
                _Number = value
            End Set
        End Property

        Public Property Source() As String
            Get
                Return _Source
            End Get
            Set(ByVal value As String)
                _Source = value
            End Set
        End Property

        #End Region 'Properties

        #Region "Methods"

        Public Overrides Function ToString() As String
            Dim s As New StringBuilder
            For Each p As System.Reflection.PropertyInfo In MyBase.GetType().GetProperties()
                If p.CanRead Then
                    s.AppendFormat("{0}:{1}<br>", p.Name.ToString, p.GetValue(Me, Nothing))
                End If
            Next
            Return s.ToString()
        End Function

        #End Region 'Methods

    End Class

    Public Class USPSWebTools

        #Region "Fields"

        Private _ServerString As String
        Private _TypeOfRequest As enumServerType
        Private _USPS_UserName As String

        #End Region 'Fields

        #Region "Constructors"

        Sub New(ByVal USPSUserName As String, Optional ByVal typeOfRequest As enumServerType = enumServerType.Testing)
            _USPS_UserName = USPSUserName
            Select Case typeOfRequest
                Case enumServerType.Testing
                    _ServerString = "testing.shippingapis.com"
                Case enumServerType.Production
                    _ServerString = ""
            End Select
        End Sub

        #End Region 'Constructors

        #Region "Properties"

        Public Property USPS_UserName() As String
            Get
                Return _USPS_UserName
            End Get
            Set(ByVal value As String)
                _USPS_UserName = value
            End Set
        End Property

        #End Region 'Properties

        #Region "Methods"
        ''' <summary>
        ''' 
        ''' </summary>
        ''' <param name="webtoolAction"></param>
        ''' <param name="a">adressinfo object</param>
        ''' <returns>addressinfo if successful, errInfo on fail</returns>
        ''' <remarks>not all items in address info need data, 
        ''' for instance zipcode lookup only needs a city state</remarks>
        Public Function DoWebToolAddressAction(ByVal webtoolAction As enumWebToolAddressAction, ByVal a As AddressInfo) As Object
            Dim aWithZip As New AddressInfo
            Dim errInfo As New ErrorInfo

            Dim addrString As New StringBuilder
            addrString.AppendFormat("http://{0}/ShippingAPITest.dll?", _ServerString)

            Select Case webtoolAction
                Case enumWebToolAddressAction.Verify
                    addrString.Append("API=Verify&XML=")
                    addrString.AppendFormat("<AddressValidateRequest USERID=""{0}"">", _USPS_UserName)
                    addrString.AppendFormat("<Address ID=""{0}"">", a.AddressID)
                    addrString.AppendFormat("<Address1>{0}</Address1>", a.Address1)
                    addrString.AppendFormat("<Address2>{0}</Address2>", a.Address2)
                    addrString.AppendFormat("<City>{0}</City>", a.City)
                    addrString.AppendFormat("<State>{0}</State>", a.State)
                    addrString.AppendFormat("<Zip5>{0}</Zip5>", a.Zip5)
                    addrString.AppendFormat("<Zip4>{0}</Zip4>", a.Zip5)
                    addrString.Append("</Address>")
                    addrString.AppendFormat("</AddressValidateRequest>")
                Case enumWebToolAddressAction.CityStateLookup
                    addrString.Append("API=CityStateLookup&XML=")
                    addrString.AppendFormat("<CityStateLookupRequest USERID=""{0}"">", _USPS_UserName)
                    addrString.AppendFormat("<ZipCode ID=""{0}"">", a.AddressID)
                    addrString.AppendFormat("<Zip5>{0}</Zip5>", a.Zip5)
                    addrString.Append("</ZipCode>")
                    addrString.AppendFormat("</CityStateLookupRequest>")
                Case enumWebToolAddressAction.ZipCodeLookup
                    addrString.Append("API=ZipCodeLookup&XML=")
                    addrString.AppendFormat("<ZipCodeLookupRequest USERID=""{0}"">", _USPS_UserName)
                    addrString.AppendFormat("<Address ID=""{0}"">", a.AddressID)
                    addrString.AppendFormat("<Address1>{0}</Address1>", a.Address1)
                    addrString.AppendFormat("<Address2>{0}</Address2>", a.Address2)
                    addrString.AppendFormat("<City>{0}</City>", a.City)
                    addrString.AppendFormat("<State>{0}</State>", a.State)
                    addrString.Append("</Address>")
                    addrString.AppendFormat("</ZipCodeLookupRequest>")
            End Select

            Dim xdoc As XmlDocument = SendWebRequest(addrString.ToString)
            Dim errList As XmlNodeList = xdoc.GetElementsByTagName("Error")
            Dim oNode As XmlNode = xdoc.DocumentElement
            If errList.Count > 0 Then
                errInfo = GetErrInfo(oNode)
                Return errInfo
            Else
                aWithZip = New AddressInfo
                For Each cn As XmlNode In oNode.ChildNodes
                    For Each cn2 As XmlNode In cn.ChildNodes
                        For Each p As System.Reflection.PropertyInfo In aWithZip.GetType().GetProperties()
                            If p.CanRead Then
                                'p.Name, p.GetValue(bi, Nothing)
                                If p.Name.ToLower = cn2.Name.ToLower Then
                                    p.SetValue(aWithZip, cn2.InnerXml, Nothing)
                                End If
                            End If
                        Next
                    Next
                Next
                Return aWithZip
            End If
        End Function
        Public Function DoWebToolAddressAction(ByVal webtoolAction As enumWebToolAddressAction, _
                                        ByVal Address1 As String, ByVal Address2 As String, _
                                        ByVal City As String, ByVal State As String, ByVal Zip As String) As Object
            Dim aWithZip As New AddressInfo
            Dim errInfo As New ErrorInfo

            Dim addrString As New StringBuilder
            addrString.AppendFormat("http://{0}/ShippingAPITest.dll?", _ServerString)
            Dim addressID As Integer = 0

            Select Case webtoolAction
                Case enumWebToolAddressAction.Verify
                    addrString.Append("API=Verify&XML=")
                    addrString.AppendFormat("<AddressValidateRequest USERID=""{0}"">", _USPS_UserName)
                    addrString.AppendFormat("<Address ID=""{0}"">", addressID)
                    addrString.AppendFormat("<Address1>{0}</Address1>", Address1)
                    addrString.AppendFormat("<Address2>{0}</Address2>", Address2)
                    addrString.AppendFormat("<City>{0}</City>", City)
                    addrString.AppendFormat("<State>{0}</State>", State)
                    addrString.AppendFormat("<Zip5>{0}</Zip5>", Zip)
                    addrString.AppendFormat("<Zip4>{0}</Zip4>", "")
                    addrString.Append("</Address>")
                    addrString.AppendFormat("</AddressValidateRequest>")
                Case enumWebToolAddressAction.CityStateLookup
                    addrString.Append("API=CityStateLookup&XML=")
                    addrString.AppendFormat("<CityStateLookupRequest USERID=""{0}"">", _USPS_UserName)
                    addrString.AppendFormat("<ZipCode ID=""{0}"">", addressID)
                    addrString.AppendFormat("<Zip5>{0}</Zip5>", Zip)
                    addrString.Append("</ZipCode>")
                    addrString.AppendFormat("</CityStateLookupRequest>")
                Case enumWebToolAddressAction.ZipCodeLookup
                    addrString.Append("API=ZipCodeLookup&XML=")
                    addrString.AppendFormat("<ZipCodeLookupRequest USERID=""{0}"">", _USPS_UserName)
                    addrString.AppendFormat("<Address ID=""{0}"">", addressID)
                    addrString.AppendFormat("<Address1>{0}</Address1>", Address1)
                    addrString.AppendFormat("<Address2>{0}</Address2>", Address2)
                    addrString.AppendFormat("<City>{0}</City>", City)
                    addrString.AppendFormat("<State>{0}</State>", State)
                    addrString.Append("</Address>")
                    addrString.AppendFormat("</ZipCodeLookupRequest>")
            End Select

            Dim xdoc As XmlDocument = SendWebRequest(addrString.ToString)
            Dim errList As XmlNodeList = xdoc.GetElementsByTagName("Error")
            Dim oNode As XmlNode = xdoc.DocumentElement
            If errList.Count > 0 Then
                errInfo = GetErrInfo(oNode)
                Return errInfo
            Else
                aWithZip = New AddressInfo
                For Each cn As XmlNode In oNode.ChildNodes
                    For Each cn2 As XmlNode In cn.ChildNodes
                        For Each p As System.Reflection.PropertyInfo In aWithZip.GetType().GetProperties()
                            If p.CanRead Then
                                'p.Name, p.GetValue(bi, Nothing)
                                If p.Name.ToLower = cn2.Name.ToLower Then
                                    p.SetValue(aWithZip, cn2.InnerXml, Nothing)
                                End If
                            End If
                        Next
                    Next
                Next
                Return aWithZip
            End If
        End Function
        Private Shared Function GetErrInfo(ByVal oNode As XmlNode) As ErrorInfo
            Dim errInfo As ErrorInfo
            errInfo = New ErrorInfo
            Try
                For Each cn As XmlNode In oNode.ChildNodes
                    For Each errnode As XmlNode In cn.ChildNodes
                        For Each cn2 As XmlNode In errnode.ChildNodes
                            Dim nodename As String = cn2.Name.ToLower
                            Dim nodeval As String = cn2.InnerXml

                            For Each p As System.Reflection.PropertyInfo In errInfo.GetType().GetProperties()
                                If p.CanRead Then
                                    Dim propName As String = p.Name.ToLower
                                    'p.Name, p.GetValue(bi, Nothing)
                                    If propName = nodename Then
                                        p.SetValue(errInfo, nodeval, Nothing)
                                    End If
                                End If
                            Next
                        Next
                    Next

                Next
            Catch ex As Exception
                errInfo.Description = ex.Message
                If Not IsNothing(ex.InnerException) Then
                    errInfo.Description = ex.InnerException.ToString
                End If
            End Try

            Return errInfo
        End Function

        Private Shared Function SendWebRequest(ByVal requestString As String) As Object
            Dim myReq As System.Net.HttpWebRequest = WebRequest.Create(requestString)
            Dim responseFromServer As String
            Dim doc As System.Xml.XmlDocument
            Try
                doc = New System.Xml.XmlDocument()

                Using response As HttpWebResponse = myReq.GetResponse()
                    If Not response.StatusCode = HttpStatusCode.OK Then
                        responseFromServer = String.Format("POST failed. Received HTTP {0}", response.StatusCode)
                        Return responseFromServer
                    Else
                        'Dim d As New XmlTextReader(myReq.GetResponse().GetResponseStream())
                        doc.Load(myReq.GetResponse().GetResponseStream())
                        Return doc
                    End If
                End Using
            Catch ex As Exception
                Dim errMsg As New StringBuilder
                errMsg.AppendFormat("{0}", ex.Message)
                If Not IsNothing(ex.InnerException) Then
                    errMsg.AppendFormat("{0}", ex.InnerException.ToString)
                End If
                Return errMsg.ToString
            End Try
        End Function

        #End Region 'Methods

    End Class

End Namespace

