Imports System
Imports System.Diagnostics
Imports System.Windows.Forms

Namespace Slf.Dms.Service.BankImport.Drg.Util
    Public Class TextBoxTraceListener
        Inherits TraceListener
        ' Methods
        Public Sub New(ByVal output As TextBox)
            Me._output = output
        End Sub

        Public Overrides Sub Write(ByVal message As String)
            If Not String.IsNullOrEmpty(message) Then
                Me._output.AppendText(message)
                Me._output.SelectionStart = Me._output.Text.Length
                Me._output.ScrollToCaret
            End If
        End Sub

        Public Overrides Sub WriteLine(ByVal message As String)
            Me.WriteIndent
            Me.Write((message & Environment.NewLine))
        End Sub


        ' Fields
        Private _output As TextBox
    End Class
End Namespace

