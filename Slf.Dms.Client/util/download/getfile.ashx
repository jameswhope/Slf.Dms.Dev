<%@ WebHandler Language="VB" Class="getfile" %>

Imports Drg.Util.DataAccess

Imports AssistedSolutions.SlickUpload.Streams
Imports AssistedSolutions.SlickUpload.Configuration

Imports System.Web
Imports System.Data
Imports System.Configuration

Public Class getfile : Implements IHttpHandler
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        Dim FileID As Integer = DataHelper.Nz_int(context.Request.QueryString("id"), 0)

        Dim Size As Integer = -1
        Dim FileName As String = String.Empty

        Dim rd As IDataReader = Nothing

        'use the file repository database, which has a different connection string
        Dim cmd As IDbCommand = ConnectionFactory.Create(ConfigurationManager.AppSettings("connectionstringrepository")).CreateCommand()

        cmd.CommandText = "SELECT [Name], DATALENGTH([Content]) AS [Size] FROM tblFile WHERE FileID = " & FileID

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                Size = DatabaseHelper.Peel_double(rd, "Size")
                FileName = DatabaseHelper.Peel_string(rd, "Name")

            End If

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        context.Response.ContentType = "application/octet-stream"

        If Not FileName Is Nothing Then
            context.Response.AddHeader("Content-Disposition", "attachment; filename=" & FileName)
        End If

        context.Response.AddHeader("Content-Transfer-Encoding", "binary")

        If Not Size = -1 Then
            context.Response.AddHeader("Content-Length", Size.ToString())
        End If

        context.Response.BufferOutput = False

        Dim stream As SqlClientOutputStream = Nothing

        Try

            stream = New SqlClientOutputStream(ConfigurationManager.AppSettings("connectionstringrepository"), "tblFile", "Content", "FileID = " & FileID)

            Dim buffer() As Byte = New Byte(8191) {}

            Dim read As Integer

            Do

                read = stream.Read(buffer, 0, 8192)

                If read > 0 Then
                    context.Response.OutputStream.Write(buffer, 0, read)
                Else
                    Exit Do
                End If

            Loop

        Finally

            If Not stream Is Nothing Then
                stream.Close()
            End If

        End Try

    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class