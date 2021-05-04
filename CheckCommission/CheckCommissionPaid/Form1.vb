Imports CheckCommPaidLib
Imports System.Configuration

Public Class Form1

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        CheckCommPaidLib.JobStep.Execute()
    End Sub

    
End Class
