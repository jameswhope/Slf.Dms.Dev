<%@ WebHandler Language="VB" Class="viciTransfer" %>

Imports System
Imports System.Web
Imports System.IO
Imports System.Data

Public Class viciTransfer : Implements IHttpHandler
    
    Protected Enum ResultCode As Integer
        [ERROR] = 0
        GOOD = 1
        DUPLICATE = 2
        FAILSTATE = 3
    End Enum
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        
        Dim Phone As String = "123456789"
        Dim AreaCode As String = ""
        
        If IsNothing(context.Request.QueryString("number")) Then
            SqlHelper.ExecuteNonQuery(String.Format("insert tblRGRData (status,xmlstring,vendorcode,productid,affiliateid,lead_id,home_phone) values ('NOQUERY','{0}','{1}',{2},{3},'{4}','{5}')", context.Request.Url.PathAndQuery, "", 0, 0, "", ""), CommandType.Text)
        Else
            Phone = context.Request.QueryString("number")
            AreaCode = Left(Phone, 3)
            Phone = Mid(Phone, 4, 7)
            
            Dim query As String = String.Format("select case when count(*) > 0 then 1 else 0 end from tblClient c join tblPerson p on p.PersonId = c.PrimaryPersonId join tblPersonPhone pp on pp.PersonId = p.PersonId join tblPhone ph on ph.PhoneId = pp.PhoneId where c.AgencyId = 867 and ph.AreaCode = '{0}' and ph.Number = '{1}'", AreaCode, Phone)
            
            Dim result As Integer = -1
            
            Try
                result = CInt(SqlHelper.ExecuteScalar(query, CommandType.Text))
                SqlHelper.ExecuteNonQuery(String.Format("insert tblRGRData (status,xmlstring,vendorcode,productid,affiliateid,lead_id,home_phone) values ('GOOD','{0}','{1}',{2},{3},'{4}','{5}')", context.Request.Url.PathAndQuery, "", 0, result, AreaCode, Phone), CommandType.Text)
            Catch ex As Exception
                SqlHelper.ExecuteNonQuery(String.Format("insert tblRGRData (status,xmlstring,vendorcode,productid,affiliateid,lead_id,home_phone) values ('ERROR','{0}','{1}',{2},{3},'{4}','{5}')", query + " " + ex.Message, "", 0, result, AreaCode, Phone), CommandType.Text)
            End Try
                        
            context.Response.Write(result)
        End If
        
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class