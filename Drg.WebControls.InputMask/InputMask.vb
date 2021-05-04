Option Explicit On 

Imports System
Imports System.Text
Imports System.Web.UI
Imports System.Drawing
Imports System.Reflection
Imports System.ComponentModel
Imports System.Web.UI.WebControls
Imports Microsoft.VisualBasic.CompilerServices

<Category("Input"), _
DefaultProperty("Mask"), _
Description("An ASP.NET server control that restricts user entry based on a preset mask."), _
ToolboxData("<{0}:InputMask runat=""server""></{0}:InputMask>"), _
ToolboxBitmap(GetType(InputMask), "Drg.WebControls.InputMask.bmp")> _
Public Class InputMask
    Inherits TextBox

#Region "Properties"

    <DefaultValue(MaskForceCase.Default), Description("Determines whether the input value should be forced to upper or lower case."), Category("Input")> _
    Public Property ForceCase() As MaskForceCase
        Get
            If (Not ViewState("ForceCase") Is Nothing) Then
                Return ViewState("ForceCase")
            End If
            Return MaskForceCase.Default
        End Get
        Set(ByVal Value As MaskForceCase)
            ViewState("ForceCase") = Value
        End Set
    End Property

    <Description("The starting position of the cursor when the control gets focus."), Category("Input")> _
    Public Property CursorStartLocation() As MaskStartLocation
        Get
            If (Not Me.ViewState.Item("CursorStartLocation") Is Nothing) Then
                Return ViewState("CursorStartLocation")
            End If
            Return MaskStartLocation.FirstEmpty
        End Get
        Set(ByVal Value As MaskStartLocation)
            ViewState("CursorStartLocation") = Value
        End Set
    End Property

    <Description("The javascript function that handles the OnGotFocus event."), Category("Events")> _
    Public Property ClientSideOnGotFocus() As String
        Get
            If (Not ViewState("ClientSideOnGotFocus") Is Nothing) Then
                Return ViewState("ClientSideOnGotFocus")
            End If
            Return String.Empty
        End Get
        Set(ByVal Value As String)
            ViewState("ClientSideOnGotFocus") = Value
        End Set
    End Property

    <Description("The javascript function that handles the OnLostFocus event."), Category("Events")> _
    Public Property ClientSideOnLostFocus() As String
        Get
            If (Not ViewState("ClientSideOnLostFocus") Is Nothing) Then
                Return ViewState("ClientSideOnLostFocus")
            End If
            Return String.Empty
        End Get
        Set(ByVal Value As String)
            ViewState("ClientSideOnLostFocus") = Value
        End Set
    End Property

    <Description("The javascript function that handles the OnBeforeInsert event."), Category("Events")> _
    Public Property ClientSideOnBeforeInsert() As String
        Get
            If (Not ViewState("ClientSideOnBeforeInsert") Is Nothing) Then
                Return ViewState("ClientSideOnBeforeInsert")
            End If
            Return String.Empty
        End Get
        Set(ByVal Value As String)
            ViewState("ClientSideOnBeforeInsert") = Value
        End Set
    End Property

    <Description("The javascript function that handles the OnAfterInsert event."), Category("Events")> _
    Public Property ClientSideOnAfterInsert() As String
        Get
            If (Not ViewState("ClientSideOnAfterInsert") Is Nothing) Then
                Return ViewState("ClientSideOnAfterInsert")
            End If
            Return String.Empty
        End Get
        Set(ByVal Value As String)
            ViewState("ClientSideOnAfterInsert") = Value
        End Set
    End Property

    <Description("The mask pattern that determines how this control allows or limits inputted characters."), Category("Input")> _
    Public Property Mask() As String
        Get
            If (Not Me.ViewState.Item("Mask") Is Nothing) Then
                Return StringType.FromObject(Me.ViewState.Item("Mask"))
            End If
            Return String.Empty
        End Get
        Set(ByVal Value As String)
            Me.ViewState.Item("Mask") = Value
        End Set
    End Property

    <DefaultValue("a"), Category("Input"), Description("The single character that represents all allowed alphabetic instances within the mask.")> _
    Public Property MaskCharAlpha() As String
        Get
            If (Not Me.ViewState.Item("MaskCharAlpha") Is Nothing) Then
                Return StringType.FromObject(Me.ViewState.Item("MaskCharAlpha"))
            End If
            Return String.Empty
        End Get
        Set(ByVal Value As String)
            If (Value.Length > 0) Then
                Me.ViewState.Item("MaskCharAlpha") = Value.Substring(0, 1)
            Else
                Me.ViewState.Item("MaskCharNumeric") = String.Empty
            End If
        End Set
    End Property

    <DefaultValue("x"), Description("The single character that represents all allowed alphabetic or numeric instances within the mask."), Category("Input")> _
    Public Property MaskCharAlphaNumeric() As String
        Get
            If (Not Me.ViewState.Item("MaskCharAlphaNumeric") Is Nothing) Then
                Return StringType.FromObject(Me.ViewState.Item("MaskCharAlphaNumeric"))
            End If
            Return String.Empty
        End Get
        Set(ByVal Value As String)
            If (Value.Length > 0) Then
                Me.ViewState.Item("MaskCharAlphaNumeric") = Value.Substring(0, 1)
            Else
                Me.ViewState.Item("MaskCharNumeric") = String.Empty
            End If
        End Set
    End Property

    <DefaultValue("_"), Category("Input"), Description("The single character that is displayed as the placeholder for potential, allowed  input characters.")> _
    Public Property MaskCharDisplay() As String
        Get
            If (Not Me.ViewState.Item("MaskCharDisplay") Is Nothing) Then
                Return StringType.FromObject(Me.ViewState.Item("MaskCharDisplay"))
            End If
            Return String.Empty
        End Get
        Set(ByVal Value As String)
            If (Value.Length > 0) Then
                Me.ViewState.Item("MaskCharDisplay") = Value.Substring(0, 1)
            Else
                Me.ViewState.Item("MaskCharNumeric") = String.Empty
            End If
        End Set
    End Property

    <Description("The single character that represents all allowed numeric instances within the mask."), DefaultValue("n"), Category("Input")> _
    Public Property MaskCharNumeric() As String
        Get
            If (Not Me.ViewState.Item("MaskCharNumeric") Is Nothing) Then
                Return StringType.FromObject(Me.ViewState.Item("MaskCharNumeric"))
            End If
            Return String.Empty
        End Get
        Set(ByVal Value As String)
            If (Value.Length > 0) Then
                Me.ViewState.Item("MaskCharNumeric") = Value.Substring(0, 1)
            Else
                Me.ViewState.Item("MaskCharNumeric") = String.Empty
            End If
        End Set
    End Property

    <Browsable(False)> _
    Public ReadOnly Property TextUnMasked() As String
        Get
            Return InputMask.ApplyFilter(Me.Text, Filter.AphaNumericOnly)
        End Get
    End Property

    <Browsable(False)> _
    Public Property LicenseXml() As String
        Get
            If Not String.IsNullOrEmpty(ViewState("LicenseXml")) Then
                Return ViewState("LicenseXml")
            End If
            Return String.Empty
        End Get
        Set(ByVal value As String)
            ViewState("LicenseXml") = value
        End Set
    End Property

#End Region

#Region "Enums"

    Public Enum MaskStartLocation
        SelectAll
        First
        FirstEmpty
        Last
        LastEmpty
    End Enum

    Public Enum MaskForceCase
        [Default]
        Upper
        Lower
    End Enum

    Private Enum Filter
        AphaNumericOnly = 2
        None = 0
        NumericOnly = 1
    End Enum

#End Region

#Region "Constructor"

    Public Sub New()

        Me.MaskCharAlpha = "a"
        Me.MaskCharNumeric = "n"
        Me.MaskCharAlphaNumeric = "x"
        Me.MaskCharDisplay = "_"

    End Sub

#End Region

    Private Shared Function ApplyFilter(ByVal Value As String, ByVal Filter As Filter) As String

        ApplyFilter = String.Empty

        For i As Integer = 0 To Value.Length - 1

            Select Case Filter
                Case Filter.None

                    ApplyFilter += Value.Substring(i, 1)

                Case Filter.NumericOnly

                    If Char.IsDigit(CharType.FromString(Value.Substring(i, 1))) Then
                        ApplyFilter += Value.Substring(i, 1)
                    End If

                Case Filter.AphaNumericOnly

                    If Char.IsLetterOrDigit(CharType.FromString(Value.Substring(i, 1))) Then
                        ApplyFilter += Value.Substring(i, 1)
                    End If

            End Select

        Next

    End Function

    Protected Overrides Sub OnPreRender(ByVal e As EventArgs)
        MyBase.OnPreRender(e)
        RegisterScript()
    End Sub

    Private Function PlaceInMask() As String
        Dim flag1 As Boolean
        Dim text1 As String = String.Empty
        Dim text2 As String = InputMask.ApplyFilter(Me.Text, Filter.AphaNumericOnly)
        If (text2.Length > 0) Then
            Dim num2 As Integer = (Me.Mask.Length - 1)
            Dim num1 As Integer = 0
            Do While (num1 <= num2)
                If (StringType.StrCmp(Me.Mask.Substring(num1, 1), Me.MaskCharAlpha, False) = 0) Then
                    Do While ((text2.Length > 0) AndAlso Not Char.IsLetter(CharType.FromString(text2.Substring(0, 1))))
                        text2 = text2.Remove(0, 1)
                    Loop
                    If (text2.Length > 0) Then
                        text1 = (text1 & text2.Substring(0, 1))
                        text2 = text2.Remove(0, 1)
                        flag1 = True
                    Else
                        text1 = (text1 & Me.MaskCharDisplay)
                    End If
                Else
                    If (StringType.StrCmp(Me.Mask.Substring(num1, 1), Me.MaskCharNumeric, False) = 0) Then
                        Do While ((text2.Length > 0) AndAlso Not Char.IsNumber(CharType.FromString(text2.Substring(0, 1))))
                            text2 = text2.Remove(0, 1)
                        Loop
                        If (text2.Length > 0) Then
                            text1 = (text1 & text2.Substring(0, 1))
                            text2 = text2.Remove(0, 1)
                            flag1 = True
                        Else
                            text1 = (text1 & Me.MaskCharDisplay)
                        End If
                    Else
                        If (StringType.StrCmp(Me.Mask.Substring(num1, 1), Me.MaskCharAlphaNumeric, False) = 0) Then
                            If (text2.Length > 0) Then
                                text1 = (text1 & text2.Substring(0, 1))
                                text2 = text2.Remove(0, 1)
                                flag1 = True
                            Else
                                text1 = (text1 & Me.MaskCharDisplay)
                            End If
                        Else
                            If text2.Length > 0 AndAlso Mask.Substring(num1, 1) = text2.Substring(0, 1) Then
                                text1 = (text1 & text2.Substring(0, 1))
                                text2 = text2.Remove(0, 1)
                                flag1 = True
                            Else
                                text1 = (text1 & Me.Mask.Substring(num1, 1))
                            End If
                        End If
                    End If
                End If
                num1 += 1
            Loop
        End If
        If Not flag1 Then
            text1 = String.Empty
        End If
        Return text1
    End Function
    Private Sub RegisterScript()

        Page.ClientScript.RegisterArrayDeclaration("DRG_InputMask_Objects", """" & ClientID & """")

        Dim cs As ClientScriptManager = Page.ClientScript
        Dim t As Type = Me.GetType()

        cs.RegisterClientScriptInclude("Drg.WebControls.InputMask", cs.GetWebResourceUrl(t, _
            "Drg.WebControls.InputMask.js"))

    End Sub
    Protected Overrides Sub Render(ByVal output As HtmlTextWriter)

        If Not String.IsNullOrEmpty(Mask) Then

            Me.Text = Me.PlaceInMask
            Me.Attributes.Item("mask") = Me.Mask
            Me.Attributes.Item("maskAlpha") = Me.MaskCharAlpha
            Me.Attributes.Item("maskNumeric") = Me.MaskCharNumeric
            Me.Attributes.Item("maskAlphaNumeric") = Me.MaskCharAlphaNumeric
            Me.Attributes.Item("maskDisplay") = Me.MaskCharDisplay
            Me.Attributes.Item("OnKeyDown") = "javascript:DRG_InputMask_KeyDown(event, this);"
            Me.Attributes.Item("OnKeyPress") = "javascript:DRG_InputMask_KeyPress(event, this);"
            Me.Attributes.Item("OnClick") = "javascript:DRG_InputMask_OnClick(event, this);"
            Me.Attributes.Item("OnFocus") = "javascript:DRG_InputMask_GotFocus(this);"
            Me.Attributes.Item("OnBlur") = "javascript:DRG_InputMask_LostFocus(this);"
            Me.Attributes.Item("OnCut") = "javascript:DRG_InputMask_OnCut(this);"
            Me.Attributes.Item("OnPaste") = "javascript:DRG_InputMask_OnPaste(this);"
            Me.Attributes.Item("OnInput") = "javascript:DRG_InputMask_OnInput(event, this);"
            Me.Attributes.Item("OnSelectStart") = "return true;"

            Select Case CursorStartLocation
                Case MaskStartLocation.SelectAll
                    Attributes("CursorStartLocation") = "selectall"
                Case MaskStartLocation.First
                    Attributes("CursorStartLocation") = "first"
                Case MaskStartLocation.FirstEmpty
                    Attributes("CursorStartLocation") = "firstempty"
                Case MaskStartLocation.Last
                    Attributes("CursorStartLocation") = "last"
                Case MaskStartLocation.LastEmpty
                    Attributes("CursorStartLocation") = "lastempty"
            End Select

            If Not String.IsNullOrEmpty(ClientSideOnGotFocus) Then
                Attributes("ClientSideOnGotFocus") = ClientSideOnGotFocus
            End If

            If Not String.IsNullOrEmpty(ClientSideOnLostFocus) Then
                Attributes("ClientSideOnLostFocus") = ClientSideOnLostFocus
            End If

            If Not String.IsNullOrEmpty(ClientSideOnAfterInsert) Then
                Attributes("ClientSideOnAfterInsert") = ClientSideOnAfterInsert
            End If

            If Not String.IsNullOrEmpty(ClientSideOnBeforeInsert) Then
                Attributes("ClientSideOnBeforeInsert") = ClientSideOnBeforeInsert
            End If

            If ForceCase = MaskForceCase.Lower Then
                Attributes("ForceCase") = "lower"
            ElseIf ForceCase = MaskForceCase.Upper Then
                Attributes("ForceCase") = "upper"
            End If

        End If

        MyBase.Render(output)

    End Sub

End Class