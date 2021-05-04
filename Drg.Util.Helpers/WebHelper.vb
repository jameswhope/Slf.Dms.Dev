Option Explicit On 

Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Drawing
Imports System.Text

Public Class WebHelper
    Public Shared Sub RegisterPopup(ByVal p As Page, ByVal url As String, ByVal queryString As String, _
        ByVal functionName As String, ByVal width As Integer, ByVal height As Integer, ByVal left As Integer, _
        ByVal top As Integer, ByVal toolbar As String, ByVal location As String, ByVal directories As String, _
        ByVal status As String, ByVal menubar As String, ByVal scrollbars As String, ByVal resizable As String)
        Dim script As StringBuilder = New StringBuilder

        script.Append("<script type=""text/javascript"">")
        script.Append("    function ")
        script.Append(functionName)
        script.Append("() {")
        script.Append("        window.open('")
        script.Append(url)
        script.Append(queryString)
        script.Append("','")
        script.Append(functionName)
        script.Append("', 'width=" & width & ",height=" & height & ",left=" & left & ",top=" & top & ",")
        script.Append("toolbar=" & toolbar & ",location=" & location & ",directories=" & directories & ",")
        script.Append("status=" & status & ",menubar=" & menubar & ",scrollbars=" & scrollbars & ",resizable=" & resizable & "') }</script>")

        p.RegisterClientScriptBlock(functionName, script.ToString())
    End Sub
    Public Shared Function DrillFor(ByVal controls As ControlCollection, ByVal t As Type) As ICollection
        Dim newControls As ArrayList = New ArrayList
        DrillFor(controls, t, newControls)
        Return newControls
    End Function
    Private Shared Sub DrillFor(ByVal controls As ControlCollection, ByVal t As Type, ByVal foundList As IList)
        Dim ctl As Web.UI.Control

        For Each ctl In controls
            If ctl.GetType() Is t Then
                foundList.Add(ctl)
            End If

            DrillFor(ctl.Controls, t, foundList)
        Next ctl
    End Sub

    Public Shared Function BuildUri(ByVal path As String, ByVal newQueryString As String) As Uri
        Return BuildUri(New Uri(path), newQueryString)
    End Function

    Public Shared Function BuildUri(ByVal uriBase As Uri, ByVal newQueryString As String) As Uri
        Dim newUri As UriBuilder = New UriBuilder(uriBase.GetLeftPart(UriPartial.Path))
        newUri.Query = newQueryString
        Return newUri.Uri
    End Function

    Public Shared Sub SetControlsEnabledState(ByVal ctrls As ICollection, ByVal state As Boolean)
        Dim ctl As Object

        For Each ctl In ctrls
            If TypeOf ctl Is TextBox Then
                CType(ctl, TextBox).Enabled = state
            ElseIf TypeOf ctl Is ListControl Then
                CType(ctl, ListControl).Enabled = state
            ElseIf TypeOf ctl Is CheckBox Then
                'TODO: Allow users to scroll in multiline textboxes, even if they can't edit them
                CType(ctl, CheckBox).Enabled = state
            ElseIf TypeOf ctl Is BaseValidator Then
                CType(ctl, BaseValidator).Enabled = state
            ElseIf TypeOf ctl Is Label Then
                CType(ctl, Label).Enabled = state
            End If
        Next ctl
    End Sub
    Public Shared Sub SetControlsEnabledState_New(ByVal ctrls As ICollection, ByVal state As Boolean)
        Dim ctl As Object
        For Each ctl In ctrls
            If TypeOf ctl Is TextBox Then
                CType(ctl, TextBox).Enabled = state
                If state = False Then
                    CType(ctl, TextBox).BorderWidth = System.Web.UI.WebControls.Unit.Pixel(0)
                Else
                    CType(ctl, TextBox).BorderWidth = System.Web.UI.WebControls.Unit.Pixel(1)
                End If
            ElseIf TypeOf ctl Is ListControl Then
                CType(ctl, ListControl).Enabled = state
                If state = False Then
                    CType(ctl, ListControl).BorderWidth = System.Web.UI.WebControls.Unit.Pixel(0)
                Else
                    CType(ctl, ListControl).BorderWidth = System.Web.UI.WebControls.Unit.Pixel(1)
                End If
            ElseIf TypeOf ctl Is Label Then
                CType(ctl, Label).ForeColor = System.Drawing.Color.Gray
            ElseIf TypeOf ctl Is CheckBox Then
                CType(ctl, CheckBox).Enabled = state
                If state = False Then
                    CType(ctl, CheckBox).BorderWidth = System.Web.UI.WebControls.Unit.Pixel(0)
                Else
                    CType(ctl, CheckBox).BorderWidth = System.Web.UI.WebControls.Unit.Pixel(0)
                End If
            ElseIf TypeOf ctl Is BaseValidator Then
                CType(ctl, BaseValidator).Enabled = state
            End If
        Next ctl
    End Sub
End Class
