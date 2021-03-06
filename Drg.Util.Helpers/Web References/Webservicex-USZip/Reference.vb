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
Namespace Webservicex_USZip
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.7.3056.0"),  _
     System.Diagnostics.DebuggerStepThroughAttribute(),  _
     System.ComponentModel.DesignerCategoryAttribute("code"),  _
     System.Web.Services.WebServiceBindingAttribute(Name:="USZipSoap", [Namespace]:="http://www.webserviceX.NET")>  _
    Partial Public Class USZip
        Inherits System.Web.Services.Protocols.SoapHttpClientProtocol
        
        Private GetInfoByZIPOperationCompleted As System.Threading.SendOrPostCallback
        
        Private GetInfoByCityOperationCompleted As System.Threading.SendOrPostCallback
        
        Private GetInfoByStateOperationCompleted As System.Threading.SendOrPostCallback
        
        Private GetInfoByAreaCodeOperationCompleted As System.Threading.SendOrPostCallback
        
        Private useDefaultCredentialsSetExplicitly As Boolean
        
        '''<remarks/>
        Public Sub New()
            MyBase.New
            Me.Url = Global.Drg.Util.Helpers.My.MySettings.Default.Drg_Util_Helpers_www_webservicex_net_uszip_USZip
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
        Public Event GetInfoByZIPCompleted As GetInfoByZIPCompletedEventHandler
        
        '''<remarks/>
        Public Event GetInfoByCityCompleted As GetInfoByCityCompletedEventHandler
        
        '''<remarks/>
        Public Event GetInfoByStateCompleted As GetInfoByStateCompletedEventHandler
        
        '''<remarks/>
        Public Event GetInfoByAreaCodeCompleted As GetInfoByAreaCodeCompletedEventHandler
        
        '''<remarks/>
        <System.Web.Services.Protocols.SoapDocumentMethodAttribute("http://www.webserviceX.NET/GetInfoByZIP", RequestNamespace:="http://www.webserviceX.NET", ResponseNamespace:="http://www.webserviceX.NET", Use:=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle:=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)>  _
        Public Function GetInfoByZIP(ByVal USZip As String) As System.Xml.XmlNode
            Dim results() As Object = Me.Invoke("GetInfoByZIP", New Object() {USZip})
            Return CType(results(0),System.Xml.XmlNode)
        End Function
        
        '''<remarks/>
        Public Overloads Sub GetInfoByZIPAsync(ByVal USZip As String)
            Me.GetInfoByZIPAsync(USZip, Nothing)
        End Sub
        
        '''<remarks/>
        Public Overloads Sub GetInfoByZIPAsync(ByVal USZip As String, ByVal userState As Object)
            If (Me.GetInfoByZIPOperationCompleted Is Nothing) Then
                Me.GetInfoByZIPOperationCompleted = AddressOf Me.OnGetInfoByZIPOperationCompleted
            End If
            Me.InvokeAsync("GetInfoByZIP", New Object() {USZip}, Me.GetInfoByZIPOperationCompleted, userState)
        End Sub
        
        Private Sub OnGetInfoByZIPOperationCompleted(ByVal arg As Object)
            If (Not (Me.GetInfoByZIPCompletedEvent) Is Nothing) Then
                Dim invokeArgs As System.Web.Services.Protocols.InvokeCompletedEventArgs = CType(arg,System.Web.Services.Protocols.InvokeCompletedEventArgs)
                RaiseEvent GetInfoByZIPCompleted(Me, New GetInfoByZIPCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState))
            End If
        End Sub
        
        '''<remarks/>
        <System.Web.Services.Protocols.SoapDocumentMethodAttribute("http://www.webserviceX.NET/GetInfoByCity", RequestNamespace:="http://www.webserviceX.NET", ResponseNamespace:="http://www.webserviceX.NET", Use:=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle:=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)>  _
        Public Function GetInfoByCity(ByVal USCity As String) As System.Xml.XmlNode
            Dim results() As Object = Me.Invoke("GetInfoByCity", New Object() {USCity})
            Return CType(results(0),System.Xml.XmlNode)
        End Function
        
        '''<remarks/>
        Public Overloads Sub GetInfoByCityAsync(ByVal USCity As String)
            Me.GetInfoByCityAsync(USCity, Nothing)
        End Sub
        
        '''<remarks/>
        Public Overloads Sub GetInfoByCityAsync(ByVal USCity As String, ByVal userState As Object)
            If (Me.GetInfoByCityOperationCompleted Is Nothing) Then
                Me.GetInfoByCityOperationCompleted = AddressOf Me.OnGetInfoByCityOperationCompleted
            End If
            Me.InvokeAsync("GetInfoByCity", New Object() {USCity}, Me.GetInfoByCityOperationCompleted, userState)
        End Sub
        
        Private Sub OnGetInfoByCityOperationCompleted(ByVal arg As Object)
            If (Not (Me.GetInfoByCityCompletedEvent) Is Nothing) Then
                Dim invokeArgs As System.Web.Services.Protocols.InvokeCompletedEventArgs = CType(arg,System.Web.Services.Protocols.InvokeCompletedEventArgs)
                RaiseEvent GetInfoByCityCompleted(Me, New GetInfoByCityCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState))
            End If
        End Sub
        
        '''<remarks/>
        <System.Web.Services.Protocols.SoapDocumentMethodAttribute("http://www.webserviceX.NET/GetInfoByState", RequestNamespace:="http://www.webserviceX.NET", ResponseNamespace:="http://www.webserviceX.NET", Use:=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle:=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)>  _
        Public Function GetInfoByState(ByVal USState As String) As System.Xml.XmlNode
            Dim results() As Object = Me.Invoke("GetInfoByState", New Object() {USState})
            Return CType(results(0),System.Xml.XmlNode)
        End Function
        
        '''<remarks/>
        Public Overloads Sub GetInfoByStateAsync(ByVal USState As String)
            Me.GetInfoByStateAsync(USState, Nothing)
        End Sub
        
        '''<remarks/>
        Public Overloads Sub GetInfoByStateAsync(ByVal USState As String, ByVal userState As Object)
            If (Me.GetInfoByStateOperationCompleted Is Nothing) Then
                Me.GetInfoByStateOperationCompleted = AddressOf Me.OnGetInfoByStateOperationCompleted
            End If
            Me.InvokeAsync("GetInfoByState", New Object() {USState}, Me.GetInfoByStateOperationCompleted, userState)
        End Sub
        
        Private Sub OnGetInfoByStateOperationCompleted(ByVal arg As Object)
            If (Not (Me.GetInfoByStateCompletedEvent) Is Nothing) Then
                Dim invokeArgs As System.Web.Services.Protocols.InvokeCompletedEventArgs = CType(arg,System.Web.Services.Protocols.InvokeCompletedEventArgs)
                RaiseEvent GetInfoByStateCompleted(Me, New GetInfoByStateCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState))
            End If
        End Sub
        
        '''<remarks/>
        <System.Web.Services.Protocols.SoapDocumentMethodAttribute("http://www.webserviceX.NET/GetInfoByAreaCode", RequestNamespace:="http://www.webserviceX.NET", ResponseNamespace:="http://www.webserviceX.NET", Use:=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle:=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)>  _
        Public Function GetInfoByAreaCode(ByVal USAreaCode As String) As System.Xml.XmlNode
            Dim results() As Object = Me.Invoke("GetInfoByAreaCode", New Object() {USAreaCode})
            Return CType(results(0),System.Xml.XmlNode)
        End Function
        
        '''<remarks/>
        Public Overloads Sub GetInfoByAreaCodeAsync(ByVal USAreaCode As String)
            Me.GetInfoByAreaCodeAsync(USAreaCode, Nothing)
        End Sub
        
        '''<remarks/>
        Public Overloads Sub GetInfoByAreaCodeAsync(ByVal USAreaCode As String, ByVal userState As Object)
            If (Me.GetInfoByAreaCodeOperationCompleted Is Nothing) Then
                Me.GetInfoByAreaCodeOperationCompleted = AddressOf Me.OnGetInfoByAreaCodeOperationCompleted
            End If
            Me.InvokeAsync("GetInfoByAreaCode", New Object() {USAreaCode}, Me.GetInfoByAreaCodeOperationCompleted, userState)
        End Sub
        
        Private Sub OnGetInfoByAreaCodeOperationCompleted(ByVal arg As Object)
            If (Not (Me.GetInfoByAreaCodeCompletedEvent) Is Nothing) Then
                Dim invokeArgs As System.Web.Services.Protocols.InvokeCompletedEventArgs = CType(arg,System.Web.Services.Protocols.InvokeCompletedEventArgs)
                RaiseEvent GetInfoByAreaCodeCompleted(Me, New GetInfoByAreaCodeCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState))
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
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.7.3056.0")>  _
    Public Delegate Sub GetInfoByZIPCompletedEventHandler(ByVal sender As Object, ByVal e As GetInfoByZIPCompletedEventArgs)
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.7.3056.0"),  _
     System.Diagnostics.DebuggerStepThroughAttribute(),  _
     System.ComponentModel.DesignerCategoryAttribute("code")>  _
    Partial Public Class GetInfoByZIPCompletedEventArgs
        Inherits System.ComponentModel.AsyncCompletedEventArgs
        
        Private results() As Object
        
        Friend Sub New(ByVal results() As Object, ByVal exception As System.Exception, ByVal cancelled As Boolean, ByVal userState As Object)
            MyBase.New(exception, cancelled, userState)
            Me.results = results
        End Sub
        
        '''<remarks/>
        Public ReadOnly Property Result() As System.Xml.XmlNode
            Get
                Me.RaiseExceptionIfNecessary
                Return CType(Me.results(0),System.Xml.XmlNode)
            End Get
        End Property
    End Class
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.7.3056.0")>  _
    Public Delegate Sub GetInfoByCityCompletedEventHandler(ByVal sender As Object, ByVal e As GetInfoByCityCompletedEventArgs)
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.7.3056.0"),  _
     System.Diagnostics.DebuggerStepThroughAttribute(),  _
     System.ComponentModel.DesignerCategoryAttribute("code")>  _
    Partial Public Class GetInfoByCityCompletedEventArgs
        Inherits System.ComponentModel.AsyncCompletedEventArgs
        
        Private results() As Object
        
        Friend Sub New(ByVal results() As Object, ByVal exception As System.Exception, ByVal cancelled As Boolean, ByVal userState As Object)
            MyBase.New(exception, cancelled, userState)
            Me.results = results
        End Sub
        
        '''<remarks/>
        Public ReadOnly Property Result() As System.Xml.XmlNode
            Get
                Me.RaiseExceptionIfNecessary
                Return CType(Me.results(0),System.Xml.XmlNode)
            End Get
        End Property
    End Class
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.7.3056.0")>  _
    Public Delegate Sub GetInfoByStateCompletedEventHandler(ByVal sender As Object, ByVal e As GetInfoByStateCompletedEventArgs)
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.7.3056.0"),  _
     System.Diagnostics.DebuggerStepThroughAttribute(),  _
     System.ComponentModel.DesignerCategoryAttribute("code")>  _
    Partial Public Class GetInfoByStateCompletedEventArgs
        Inherits System.ComponentModel.AsyncCompletedEventArgs
        
        Private results() As Object
        
        Friend Sub New(ByVal results() As Object, ByVal exception As System.Exception, ByVal cancelled As Boolean, ByVal userState As Object)
            MyBase.New(exception, cancelled, userState)
            Me.results = results
        End Sub
        
        '''<remarks/>
        Public ReadOnly Property Result() As System.Xml.XmlNode
            Get
                Me.RaiseExceptionIfNecessary
                Return CType(Me.results(0),System.Xml.XmlNode)
            End Get
        End Property
    End Class
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.7.3056.0")>  _
    Public Delegate Sub GetInfoByAreaCodeCompletedEventHandler(ByVal sender As Object, ByVal e As GetInfoByAreaCodeCompletedEventArgs)
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.7.3056.0"),  _
     System.Diagnostics.DebuggerStepThroughAttribute(),  _
     System.ComponentModel.DesignerCategoryAttribute("code")>  _
    Partial Public Class GetInfoByAreaCodeCompletedEventArgs
        Inherits System.ComponentModel.AsyncCompletedEventArgs
        
        Private results() As Object
        
        Friend Sub New(ByVal results() As Object, ByVal exception As System.Exception, ByVal cancelled As Boolean, ByVal userState As Object)
            MyBase.New(exception, cancelled, userState)
            Me.results = results
        End Sub
        
        '''<remarks/>
        Public ReadOnly Property Result() As System.Xml.XmlNode
            Get
                Me.RaiseExceptionIfNecessary
                Return CType(Me.results(0),System.Xml.XmlNode)
            End Get
        End Property
    End Class
End Namespace
