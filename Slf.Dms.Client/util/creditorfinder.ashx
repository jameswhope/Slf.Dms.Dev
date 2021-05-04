<%@ WebHandler Language="VB" Class="creditorfinder" %>

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System
Imports System.Xml
Imports System.Web
Imports System.Data

Public Class creditorfinder : Implements IHttpHandler
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        Dim name As String = String.Empty
        Dim street As String = String.Empty
        Dim street2 As String = String.Empty
        Dim city As String = String.Empty
        Dim stateid As Integer = 0
        Dim zipcode As String = String.Empty

        Dim doc As XmlDocument = New XmlDocument
        Dim root As XmlElement = doc.CreateElement("creditors")

        If Not context.Request.QueryString("name") Is Nothing Then
            name = context.Request.QueryString("name").Trim
        End If

        If Not context.Request.QueryString("street") Is Nothing Then
            street = context.Request.QueryString("street").Trim
        End If

        If Not context.Request.QueryString("street2") Is Nothing Then
            street2 = context.Request.QueryString("street2").Trim
        End If

        If Not context.Request.QueryString("city") Is Nothing Then
            city = context.Request.QueryString("city").Trim
        End If

        If Not context.Request.QueryString("stateid") Is Nothing Then
            stateid = DataHelper.Nz_int(context.Request.QueryString("stateid").Trim)
        End If

        If Not context.Request.QueryString("zipcode") Is Nothing Then
            zipcode = context.Request.QueryString("zipcode").Trim
        End If

        'build criteria
        Dim where As String = String.Empty

        If name.Length > 0 Then
            If where.Length > 0 Then
                where += " AND tblcreditor.Name LIKE '" & name.Replace("'", "''") & "%'"
            Else
                where = "tblcreditor.Name LIKE '" & name.Replace("'", "''") & "%'"
            End If
        End If

        If street.Length > 0 Then
            If where.Length > 0 Then
                where += " AND Street LIKE '" & street.Replace("'", "''") & "%'"
            Else
                where = "Street LIKE '" & street.Replace("'", "''") & "%'"
            End If
        End If

        If street2.Length > 0 Then
            If where.Length > 0 Then
                where += " AND Street2 LIKE '" & street2.Replace("'", "''") & "%'"
            Else
                where = "Street2 LIKE '" & street2.Replace("'", "''") & "%'"
            End If
        End If

        If city.Length > 0 Then
            If where.Length > 0 Then
                where += " AND City LIKE '" & city.Replace("'", "''") & "%'"
            Else
                where = "City LIKE '" & city.Replace("'", "''") & "%'"
            End If
        End If

        If stateid > 0 Then
            If where.Length > 0 Then
                where += " AND tblcreditor.StateID = " & stateid
            Else
                where = "tblcreditor.StateID = " & stateid
            End If
        End If

        If zipcode.Length > 0 Then
            If where.Length > 0 Then
                where += " AND ZipCode LIKE '" & zipcode.Replace("'", "''") & "%'"
            Else
                where = "ZipCode LIKE '" & zipcode.Replace("'", "''") & "%'"
            End If
        End If

        If where.Length > 0 Then

            Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetCreditors")

                DatabaseHelper.AddParameter(cmd, "Return", "25")
                DatabaseHelper.AddParameter(cmd, "Where", "WHERE " & where)
                DatabaseHelper.AddParameter(cmd, "OrderBy", "ORDER BY validated desc, tblcreditor.Name, StateName, City")

                Using cmd.Connection

                    cmd.Connection.Open()

                    Using rd As IDataReader = cmd.ExecuteReader()

                        While rd.Read()

                            Dim el As XmlElement = doc.CreateElement("creditor")

                            el.SetAttribute("creditorid", DatabaseHelper.Peel_int(rd, "CreditorID"))
                            el.SetAttribute("name", PadEmpty(DatabaseHelper.Peel_string(rd, "Name")))
                            el.SetAttribute("street", PadEmpty(DatabaseHelper.Peel_string(rd, "Street")))
                            el.SetAttribute("street2", PadEmpty(DatabaseHelper.Peel_string(rd, "Street2")))
                            el.SetAttribute("city", PadEmpty(DatabaseHelper.Peel_string(rd, "City")))
                            el.SetAttribute("stateid", DatabaseHelper.Peel_int(rd, "StateID"))
                            el.SetAttribute("statename", PadEmpty(DatabaseHelper.Peel_string(rd, "StateName")))
                            el.SetAttribute("stateabbreviation", PadEmpty(DatabaseHelper.Peel_string(rd, "StateAbbreviation")))
                            el.SetAttribute("zipcode", PadEmpty(DatabaseHelper.Peel_string(rd, "ZipCode")))
                            el.SetAttribute("validated", PadEmpty(DatabaseHelper.Peel_bool(rd, "validated")))

                            root.AppendChild(el)

                        End While
                    End Using
                End Using
            End Using
        End If

        doc.AppendChild(root)

        context.Response.ClearContent()
        context.Response.ClearHeaders()
        context.Response.ContentType = "text/xml"

        context.Response.Write("<?xml version=""1.0""?>")
        doc.Save(context.Response.OutputStream)
        context.Response.End()

    End Sub
    
    Private Function PadEmpty(ByVal Value As String) As String
        
        If Value Is Nothing OrElse Value.Length = 0 Then
            Return "&nbsp;"
        Else
            Return Value
        End If
        
    End Function
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class