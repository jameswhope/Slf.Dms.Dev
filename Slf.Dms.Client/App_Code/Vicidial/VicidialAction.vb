Imports Microsoft.VisualBasic
Imports System.Web.Script.Serialization
Imports System.Reflection

Public MustInherit Class VicidialAction

    Public MustOverride Function Execute(ByVal json As String) As String

    Public Shared Function Create(ByVal action As String) As VicidialAction
        Dim classname As String = String.Format("Vicidial{0}Action", action.Trim)
        Return Activator.CreateInstance(CType(System.Web.Compilation.BuildManager.CodeAssemblies(0), System.Reflection.Assembly).GetType(classname))
    End Function

    Protected Function readJson(ByVal json As String, ByVal objType As Type) As Object
        Dim ser As New JavaScriptSerializer()
        Return ser.GetType().GetMethod("Deserialize").MakeGenericMethod(objType).Invoke(ser, New Object(0) {json})
    End Function

    Protected Function writeJson(ByVal obj As Object) As String
        Dim javaScriptSerializer As New JavaScriptSerializer()
        Dim jsondata As String = javaScriptSerializer.Serialize(obj)
        Return jsondata
    End Function

End Class
