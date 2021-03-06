'------------------------------------------------------------------------------
' <auto-generated>
'     This code was generated by a tool.
'     Runtime Version:4.0.30319.42000
'
'     Changes to this file may cause incorrect behavior and will be lost if
'     the code is regenerated.
' </auto-generated>
'------------------------------------------------------------------------------

Option Strict Off
Option Explicit On

Imports System
Imports System.ComponentModel
Imports System.Diagnostics
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Xml.Serialization

'
'This source code was auto-generated by Microsoft.VSDesigner, Version 4.0.30319.42000.
'
Namespace Webservicex_ACH
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.7.3056.0"),  _
     System.Diagnostics.DebuggerStepThroughAttribute(),  _
     System.ComponentModel.DesignerCategoryAttribute("code"),  _
     System.Web.Services.WebServiceBindingAttribute(Name:="FedACHSoap", [Namespace]:="http://www.webservicex.net/")>  _
    Partial Public Class FedACH
        Inherits System.Web.Services.Protocols.SoapHttpClientProtocol
        
        Private getACHByNameOperationCompleted As System.Threading.SendOrPostCallback
        
        Private getACHByLocationOperationCompleted As System.Threading.SendOrPostCallback
        
        Private getACHByZipCodeOperationCompleted As System.Threading.SendOrPostCallback
        
        Private getACHByFRBNumberOperationCompleted As System.Threading.SendOrPostCallback
        
        Private getACHByRoutingNumberOperationCompleted As System.Threading.SendOrPostCallback
        
        Private useDefaultCredentialsSetExplicitly As Boolean
        
        '''<remarks/>
        Public Sub New()
            MyBase.New
            Me.Url = Global.Drg.Util.Helpers.My.MySettings.Default.Drg_Util_Helpers_Webservicex_ACH_FedACH
            If (Me.IsLocalFileSystemWebService(Me.Url) = true) Then
                Me.UseDefaultCredentials = true
                Me.useDefaultCredentialsSetExplicitly = false
            Else
                Me.useDefaultCredentialsSetExplicitly = true
            End If
        End Sub
        
        Public Shadows Property Url() As String
            Get
                Return MyBase.Url
            End Get
            Set
                If (((Me.IsLocalFileSystemWebService(MyBase.Url) = true)  _
                            AndAlso (Me.useDefaultCredentialsSetExplicitly = false))  _
                            AndAlso (Me.IsLocalFileSystemWebService(value) = false)) Then
                    MyBase.UseDefaultCredentials = false
                End If
                MyBase.Url = value
            End Set
        End Property
        
        Public Shadows Property UseDefaultCredentials() As Boolean
            Get
                Return MyBase.UseDefaultCredentials
            End Get
            Set
                MyBase.UseDefaultCredentials = value
                Me.useDefaultCredentialsSetExplicitly = true
            End Set
        End Property
        
        '''<remarks/>
        Public Event getACHByNameCompleted As getACHByNameCompletedEventHandler
        
        '''<remarks/>
        Public Event getACHByLocationCompleted As getACHByLocationCompletedEventHandler
        
        '''<remarks/>
        Public Event getACHByZipCodeCompleted As getACHByZipCodeCompletedEventHandler
        
        '''<remarks/>
        Public Event getACHByFRBNumberCompleted As getACHByFRBNumberCompletedEventHandler
        
        '''<remarks/>
        Public Event getACHByRoutingNumberCompleted As getACHByRoutingNumberCompletedEventHandler
        
        '''<remarks/>
        <System.Web.Services.Protocols.SoapDocumentMethodAttribute("http://www.webservicex.net/getACHByName", RequestNamespace:="http://www.webservicex.net/", ResponseNamespace:="http://www.webservicex.net/", Use:=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle:=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)>  _
        Public Function getACHByName(ByVal Name As String, ByRef FedACHLists As FedACHList) As Boolean
            Dim results() As Object = Me.Invoke("getACHByName", New Object() {Name})
            FedACHLists = CType(results(1),FedACHList)
            Return CType(results(0),Boolean)
        End Function
        
        '''<remarks/>
        Public Overloads Sub getACHByNameAsync(ByVal Name As String)
            Me.getACHByNameAsync(Name, Nothing)
        End Sub
        
        '''<remarks/>
        Public Overloads Sub getACHByNameAsync(ByVal Name As String, ByVal userState As Object)
            If (Me.getACHByNameOperationCompleted Is Nothing) Then
                Me.getACHByNameOperationCompleted = AddressOf Me.OngetACHByNameOperationCompleted
            End If
            Me.InvokeAsync("getACHByName", New Object() {Name}, Me.getACHByNameOperationCompleted, userState)
        End Sub
        
        Private Sub OngetACHByNameOperationCompleted(ByVal arg As Object)
            If (Not (Me.getACHByNameCompletedEvent) Is Nothing) Then
                Dim invokeArgs As System.Web.Services.Protocols.InvokeCompletedEventArgs = CType(arg,System.Web.Services.Protocols.InvokeCompletedEventArgs)
                RaiseEvent getACHByNameCompleted(Me, New getACHByNameCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState))
            End If
        End Sub
        
        '''<remarks/>
        <System.Web.Services.Protocols.SoapDocumentMethodAttribute("http://www.webservicex.net/getACHByLocation", RequestNamespace:="http://www.webservicex.net/", ResponseNamespace:="http://www.webservicex.net/", Use:=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle:=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)>  _
        Public Function getACHByLocation(ByVal Address As String, ByVal StateCode As String, ByVal City As String, ByRef FedACHLists As FedACHList) As Boolean
            Dim results() As Object = Me.Invoke("getACHByLocation", New Object() {Address, StateCode, City})
            FedACHLists = CType(results(1),FedACHList)
            Return CType(results(0),Boolean)
        End Function
        
        '''<remarks/>
        Public Overloads Sub getACHByLocationAsync(ByVal Address As String, ByVal StateCode As String, ByVal City As String)
            Me.getACHByLocationAsync(Address, StateCode, City, Nothing)
        End Sub
        
        '''<remarks/>
        Public Overloads Sub getACHByLocationAsync(ByVal Address As String, ByVal StateCode As String, ByVal City As String, ByVal userState As Object)
            If (Me.getACHByLocationOperationCompleted Is Nothing) Then
                Me.getACHByLocationOperationCompleted = AddressOf Me.OngetACHByLocationOperationCompleted
            End If
            Me.InvokeAsync("getACHByLocation", New Object() {Address, StateCode, City}, Me.getACHByLocationOperationCompleted, userState)
        End Sub
        
        Private Sub OngetACHByLocationOperationCompleted(ByVal arg As Object)
            If (Not (Me.getACHByLocationCompletedEvent) Is Nothing) Then
                Dim invokeArgs As System.Web.Services.Protocols.InvokeCompletedEventArgs = CType(arg,System.Web.Services.Protocols.InvokeCompletedEventArgs)
                RaiseEvent getACHByLocationCompleted(Me, New getACHByLocationCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState))
            End If
        End Sub
        
        '''<remarks/>
        <System.Web.Services.Protocols.SoapDocumentMethodAttribute("http://www.webservicex.net/getACHByZipCode", RequestNamespace:="http://www.webservicex.net/", ResponseNamespace:="http://www.webservicex.net/", Use:=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle:=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)>  _
        Public Function getACHByZipCode(ByVal ZipCode As String, ByRef FedACHLists As FedACHList) As Boolean
            Dim results() As Object = Me.Invoke("getACHByZipCode", New Object() {ZipCode})
            FedACHLists = CType(results(1),FedACHList)
            Return CType(results(0),Boolean)
        End Function
        
        '''<remarks/>
        Public Overloads Sub getACHByZipCodeAsync(ByVal ZipCode As String)
            Me.getACHByZipCodeAsync(ZipCode, Nothing)
        End Sub
        
        '''<remarks/>
        Public Overloads Sub getACHByZipCodeAsync(ByVal ZipCode As String, ByVal userState As Object)
            If (Me.getACHByZipCodeOperationCompleted Is Nothing) Then
                Me.getACHByZipCodeOperationCompleted = AddressOf Me.OngetACHByZipCodeOperationCompleted
            End If
            Me.InvokeAsync("getACHByZipCode", New Object() {ZipCode}, Me.getACHByZipCodeOperationCompleted, userState)
        End Sub
        
        Private Sub OngetACHByZipCodeOperationCompleted(ByVal arg As Object)
            If (Not (Me.getACHByZipCodeCompletedEvent) Is Nothing) Then
                Dim invokeArgs As System.Web.Services.Protocols.InvokeCompletedEventArgs = CType(arg,System.Web.Services.Protocols.InvokeCompletedEventArgs)
                RaiseEvent getACHByZipCodeCompleted(Me, New getACHByZipCodeCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState))
            End If
        End Sub
        
        '''<remarks/>
        <System.Web.Services.Protocols.SoapDocumentMethodAttribute("http://www.webservicex.net/getACHByFRBNumber", RequestNamespace:="http://www.webservicex.net/", ResponseNamespace:="http://www.webservicex.net/", Use:=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle:=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)>  _
        Public Function getACHByFRBNumber(ByVal FRBNumber As String, ByRef FedACHLists As FedACHList) As Boolean
            Dim results() As Object = Me.Invoke("getACHByFRBNumber", New Object() {FRBNumber})
            FedACHLists = CType(results(1),FedACHList)
            Return CType(results(0),Boolean)
        End Function
        
        '''<remarks/>
        Public Overloads Sub getACHByFRBNumberAsync(ByVal FRBNumber As String)
            Me.getACHByFRBNumberAsync(FRBNumber, Nothing)
        End Sub
        
        '''<remarks/>
        Public Overloads Sub getACHByFRBNumberAsync(ByVal FRBNumber As String, ByVal userState As Object)
            If (Me.getACHByFRBNumberOperationCompleted Is Nothing) Then
                Me.getACHByFRBNumberOperationCompleted = AddressOf Me.OngetACHByFRBNumberOperationCompleted
            End If
            Me.InvokeAsync("getACHByFRBNumber", New Object() {FRBNumber}, Me.getACHByFRBNumberOperationCompleted, userState)
        End Sub
        
        Private Sub OngetACHByFRBNumberOperationCompleted(ByVal arg As Object)
            If (Not (Me.getACHByFRBNumberCompletedEvent) Is Nothing) Then
                Dim invokeArgs As System.Web.Services.Protocols.InvokeCompletedEventArgs = CType(arg,System.Web.Services.Protocols.InvokeCompletedEventArgs)
                RaiseEvent getACHByFRBNumberCompleted(Me, New getACHByFRBNumberCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState))
            End If
        End Sub
        
        '''<remarks/>
        <System.Web.Services.Protocols.SoapDocumentMethodAttribute("http://www.webservicex.net/getACHByRoutingNumber", RequestNamespace:="http://www.webservicex.net/", ResponseNamespace:="http://www.webservicex.net/", Use:=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle:=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)>  _
        Public Function getACHByRoutingNumber(ByVal RoutingNumber As String, ByRef FedACHLists As FedACHList) As Boolean
            Dim results() As Object = Me.Invoke("getACHByRoutingNumber", New Object() {RoutingNumber})
            FedACHLists = CType(results(1),FedACHList)
            Return CType(results(0),Boolean)
        End Function
        
        '''<remarks/>
        Public Overloads Sub getACHByRoutingNumberAsync(ByVal RoutingNumber As String)
            Me.getACHByRoutingNumberAsync(RoutingNumber, Nothing)
        End Sub
        
        '''<remarks/>
        Public Overloads Sub getACHByRoutingNumberAsync(ByVal RoutingNumber As String, ByVal userState As Object)
            If (Me.getACHByRoutingNumberOperationCompleted Is Nothing) Then
                Me.getACHByRoutingNumberOperationCompleted = AddressOf Me.OngetACHByRoutingNumberOperationCompleted
            End If
            Me.InvokeAsync("getACHByRoutingNumber", New Object() {RoutingNumber}, Me.getACHByRoutingNumberOperationCompleted, userState)
        End Sub
        
        Private Sub OngetACHByRoutingNumberOperationCompleted(ByVal arg As Object)
            If (Not (Me.getACHByRoutingNumberCompletedEvent) Is Nothing) Then
                Dim invokeArgs As System.Web.Services.Protocols.InvokeCompletedEventArgs = CType(arg,System.Web.Services.Protocols.InvokeCompletedEventArgs)
                RaiseEvent getACHByRoutingNumberCompleted(Me, New getACHByRoutingNumberCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState))
            End If
        End Sub
        
        '''<remarks/>
        Public Shadows Sub CancelAsync(ByVal userState As Object)
            MyBase.CancelAsync(userState)
        End Sub
        
        Private Function IsLocalFileSystemWebService(ByVal url As String) As Boolean
            If ((url Is Nothing)  _
                        OrElse (url Is String.Empty)) Then
                Return false
            End If
            Dim wsUri As System.Uri = New System.Uri(url)
            If ((wsUri.Port >= 1024)  _
                        AndAlso (String.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) = 0)) Then
                Return true
            End If
            Return false
        End Function
    End Class
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.7.3056.0"),  _
     System.SerializableAttribute(),  _
     System.Diagnostics.DebuggerStepThroughAttribute(),  _
     System.ComponentModel.DesignerCategoryAttribute("code"),  _
     System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://www.webservicex.net/")>  _
    Partial Public Class FedACHList
        
        Private fedACHsField() As FedACHData
        
        Private totalRecordsField As Integer
        
        '''<remarks/>
        <System.Xml.Serialization.XmlArrayItemAttribute(IsNullable:=false)>  _
        Public Property FedACHs() As FedACHData()
            Get
                Return Me.fedACHsField
            End Get
            Set
                Me.fedACHsField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property TotalRecords() As Integer
            Get
                Return Me.totalRecordsField
            End Get
            Set
                Me.totalRecordsField = value
            End Set
        End Property
    End Class
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.7.3056.0"),  _
     System.SerializableAttribute(),  _
     System.Diagnostics.DebuggerStepThroughAttribute(),  _
     System.ComponentModel.DesignerCategoryAttribute("code"),  _
     System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://www.webservicex.net/")>  _
    Partial Public Class FedACHData
        
        Private routingNumberField As String
        
        Private officeCodeField As String
        
        Private servicingFRBNumberField As String
        
        Private recordTypeCodeField As String
        
        Private changeDateField As String
        
        Private newRoutingNumberField As String
        
        Private customerNameField As String
        
        Private addressField As String
        
        Private cityField As String
        
        Private stateCodeField As String
        
        Private zipcodeField As String
        
        Private zipcodeExtensionField As String
        
        Private telephoneAreaCodeField As String
        
        Private telephonePrefixNumberField As String
        
        Private telephoneSuffixNumberField As String
        
        Private institutionStatusCodeField As String
        
        '''<remarks/>
        Public Property RoutingNumber() As String
            Get
                Return Me.routingNumberField
            End Get
            Set
                Me.routingNumberField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property OfficeCode() As String
            Get
                Return Me.officeCodeField
            End Get
            Set
                Me.officeCodeField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property ServicingFRBNumber() As String
            Get
                Return Me.servicingFRBNumberField
            End Get
            Set
                Me.servicingFRBNumberField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property RecordTypeCode() As String
            Get
                Return Me.recordTypeCodeField
            End Get
            Set
                Me.recordTypeCodeField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property ChangeDate() As String
            Get
                Return Me.changeDateField
            End Get
            Set
                Me.changeDateField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property NewRoutingNumber() As String
            Get
                Return Me.newRoutingNumberField
            End Get
            Set
                Me.newRoutingNumberField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property CustomerName() As String
            Get
                Return Me.customerNameField
            End Get
            Set
                Me.customerNameField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property Address() As String
            Get
                Return Me.addressField
            End Get
            Set
                Me.addressField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property City() As String
            Get
                Return Me.cityField
            End Get
            Set
                Me.cityField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property StateCode() As String
            Get
                Return Me.stateCodeField
            End Get
            Set
                Me.stateCodeField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property Zipcode() As String
            Get
                Return Me.zipcodeField
            End Get
            Set
                Me.zipcodeField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property ZipcodeExtension() As String
            Get
                Return Me.zipcodeExtensionField
            End Get
            Set
                Me.zipcodeExtensionField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property TelephoneAreaCode() As String
            Get
                Return Me.telephoneAreaCodeField
            End Get
            Set
                Me.telephoneAreaCodeField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property TelephonePrefixNumber() As String
            Get
                Return Me.telephonePrefixNumberField
            End Get
            Set
                Me.telephonePrefixNumberField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property TelephoneSuffixNumber() As String
            Get
                Return Me.telephoneSuffixNumberField
            End Get
            Set
                Me.telephoneSuffixNumberField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property InstitutionStatusCode() As String
            Get
                Return Me.institutionStatusCodeField
            End Get
            Set
                Me.institutionStatusCodeField = value
            End Set
        End Property
    End Class
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.7.3056.0")>  _
    Public Delegate Sub getACHByNameCompletedEventHandler(ByVal sender As Object, ByVal e As getACHByNameCompletedEventArgs)
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.7.3056.0"),  _
     System.Diagnostics.DebuggerStepThroughAttribute(),  _
     System.ComponentModel.DesignerCategoryAttribute("code")>  _
    Partial Public Class getACHByNameCompletedEventArgs
        Inherits System.ComponentModel.AsyncCompletedEventArgs
        
        Private results() As Object
        
        Friend Sub New(ByVal results() As Object, ByVal exception As System.Exception, ByVal cancelled As Boolean, ByVal userState As Object)
            MyBase.New(exception, cancelled, userState)
            Me.results = results
        End Sub
        
        '''<remarks/>
        Public ReadOnly Property Result() As Boolean
            Get
                Me.RaiseExceptionIfNecessary
                Return CType(Me.results(0),Boolean)
            End Get
        End Property
        
        '''<remarks/>
        Public ReadOnly Property FedACHLists() As FedACHList
            Get
                Me.RaiseExceptionIfNecessary
                Return CType(Me.results(1),FedACHList)
            End Get
        End Property
    End Class
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.7.3056.0")>  _
    Public Delegate Sub getACHByLocationCompletedEventHandler(ByVal sender As Object, ByVal e As getACHByLocationCompletedEventArgs)
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.7.3056.0"),  _
     System.Diagnostics.DebuggerStepThroughAttribute(),  _
     System.ComponentModel.DesignerCategoryAttribute("code")>  _
    Partial Public Class getACHByLocationCompletedEventArgs
        Inherits System.ComponentModel.AsyncCompletedEventArgs
        
        Private results() As Object
        
        Friend Sub New(ByVal results() As Object, ByVal exception As System.Exception, ByVal cancelled As Boolean, ByVal userState As Object)
            MyBase.New(exception, cancelled, userState)
            Me.results = results
        End Sub
        
        '''<remarks/>
        Public ReadOnly Property Result() As Boolean
            Get
                Me.RaiseExceptionIfNecessary
                Return CType(Me.results(0),Boolean)
            End Get
        End Property
        
        '''<remarks/>
        Public ReadOnly Property FedACHLists() As FedACHList
            Get
                Me.RaiseExceptionIfNecessary
                Return CType(Me.results(1),FedACHList)
            End Get
        End Property
    End Class
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.7.3056.0")>  _
    Public Delegate Sub getACHByZipCodeCompletedEventHandler(ByVal sender As Object, ByVal e As getACHByZipCodeCompletedEventArgs)
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.7.3056.0"),  _
     System.Diagnostics.DebuggerStepThroughAttribute(),  _
     System.ComponentModel.DesignerCategoryAttribute("code")>  _
    Partial Public Class getACHByZipCodeCompletedEventArgs
        Inherits System.ComponentModel.AsyncCompletedEventArgs
        
        Private results() As Object
        
        Friend Sub New(ByVal results() As Object, ByVal exception As System.Exception, ByVal cancelled As Boolean, ByVal userState As Object)
            MyBase.New(exception, cancelled, userState)
            Me.results = results
        End Sub
        
        '''<remarks/>
        Public ReadOnly Property Result() As Boolean
            Get
                Me.RaiseExceptionIfNecessary
                Return CType(Me.results(0),Boolean)
            End Get
        End Property
        
        '''<remarks/>
        Public ReadOnly Property FedACHLists() As FedACHList
            Get
                Me.RaiseExceptionIfNecessary
                Return CType(Me.results(1),FedACHList)
            End Get
        End Property
    End Class
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.7.3056.0")>  _
    Public Delegate Sub getACHByFRBNumberCompletedEventHandler(ByVal sender As Object, ByVal e As getACHByFRBNumberCompletedEventArgs)
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.7.3056.0"),  _
     System.Diagnostics.DebuggerStepThroughAttribute(),  _
     System.ComponentModel.DesignerCategoryAttribute("code")>  _
    Partial Public Class getACHByFRBNumberCompletedEventArgs
        Inherits System.ComponentModel.AsyncCompletedEventArgs
        
        Private results() As Object
        
        Friend Sub New(ByVal results() As Object, ByVal exception As System.Exception, ByVal cancelled As Boolean, ByVal userState As Object)
            MyBase.New(exception, cancelled, userState)
            Me.results = results
        End Sub
        
        '''<remarks/>
        Public ReadOnly Property Result() As Boolean
            Get
                Me.RaiseExceptionIfNecessary
                Return CType(Me.results(0),Boolean)
            End Get
        End Property
        
        '''<remarks/>
        Public ReadOnly Property FedACHLists() As FedACHList
            Get
                Me.RaiseExceptionIfNecessary
                Return CType(Me.results(1),FedACHList)
            End Get
        End Property
    End Class
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.7.3056.0")>  _
    Public Delegate Sub getACHByRoutingNumberCompletedEventHandler(ByVal sender As Object, ByVal e As getACHByRoutingNumberCompletedEventArgs)
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.7.3056.0"),  _
     System.Diagnostics.DebuggerStepThroughAttribute(),  _
     System.ComponentModel.DesignerCategoryAttribute("code")>  _
    Partial Public Class getACHByRoutingNumberCompletedEventArgs
        Inherits System.ComponentModel.AsyncCompletedEventArgs
        
        Private results() As Object
        
        Friend Sub New(ByVal results() As Object, ByVal exception As System.Exception, ByVal cancelled As Boolean, ByVal userState As Object)
            MyBase.New(exception, cancelled, userState)
            Me.results = results
        End Sub
        
        '''<remarks/>
        Public ReadOnly Property Result() As Boolean
            Get
                Me.RaiseExceptionIfNecessary
                Return CType(Me.results(0),Boolean)
            End Get
        End Property
        
        '''<remarks/>
        Public ReadOnly Property FedACHLists() As FedACHList
            Get
                Me.RaiseExceptionIfNecessary
                Return CType(Me.results(1),FedACHList)
            End Get
        End Property
    End Class
End Namespace
