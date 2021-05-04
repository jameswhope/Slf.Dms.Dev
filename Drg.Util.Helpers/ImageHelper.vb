Option Explicit On 

Imports System.Drawing

Public Class ImageHelper

    Public Shared Sub ReplaceColor(ByVal Img As Bitmap, ByVal Source As Color, ByVal Target As Color)

        For i As Integer = 0 To Img.Size.Width - 1

            For j As Integer = 0 To Img.Size.Height - 1

                If Img.GetPixel(i, j).ToArgb = Source.ToArgb Then
                    Img.SetPixel(i, j, Target)
                End If

            Next

        Next

    End Sub

End Class
