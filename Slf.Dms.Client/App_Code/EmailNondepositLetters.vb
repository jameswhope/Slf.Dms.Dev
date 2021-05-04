Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Data

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class EmailNondepositLetters
     Inherits System.Web.Services.WebService

    <WebMethod()> _
    Public Function EmailNonDepositLetters(ByVal UserId As Integer) As String
        Return NonDepositHelper.EmailNonDepositLetters(UserId).ToString
    End Function

End Class
