Imports System.IO
Imports System.Data
Imports System.Text
Imports System.Management
Imports System.Data.SqlClient
Imports System.Drawing.Imaging
Imports System.Drawing.Printing
Imports System.Collections.Generic
Imports Drg.Util.Helpers
Imports Drg.Util.DataHelpers

Public Class ValidationHelper

   Private objValidationHelper As ValidationHelper

   Public Sub New()
      'objValidationHelper = New ValidationHelper
   End Sub

   Public Function ValidateEmail(ByVal EmailAddress As String) As Boolean
      'Validate it's a valid email address
      Dim regEx As RegularExpressions.Regex = New RegularExpressions.Regex("^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$")
      Return regEx.IsMatch(EmailAddress)
   End Function
End Class
